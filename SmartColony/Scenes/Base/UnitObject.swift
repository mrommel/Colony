//
//  UnitObject.swift
//  SmartColony
//
//  Created by Michael Rommel on 06.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class UnitObject {
    
    static let idleActionKey: String = "idleActionKey"
    static let focusActionKey: String = "focusActionKey"
    static let alphaVisible: CGFloat = 1.0
    static let alphaInvisible: CGFloat = 0.0
    
    weak var unit: AbstractUnit?
    weak var gameModel: GameModel?
    
    //let identifier: String
    var spriteName: String

    var atlasIdle: GameObjectAtlas?
    var atlasDown: GameObjectAtlas?
    var atlasUp: GameObjectAtlas?
    var atlasRight: GameObjectAtlas?
    var atlasLeft: GameObjectAtlas?

    var lastTime: CFTimeInterval = 0
    var animationSpeed = 4.0
    
    // internal UI elements
    private var sprite: SKSpriteNode
    private var pathSpriteBuffer: [SKSpriteNode] = []
    
    init(unit: AbstractUnit?, in gameModel: GameModel?) {
     
        self.unit = unit
        self.gameModel = gameModel
        
        guard let unit = self.unit else {
            fatalError("cant get unit")
        }

        self.spriteName = unit.type.spriteName
        self.sprite = SKSpriteNode(imageNamed: self.spriteName)
        self.sprite.position = HexPoint.toScreen(hex: unit.location)
        self.sprite.zPosition = Globals.ZLevels.sprite
        self.sprite.anchorPoint = unit.type.anchorPoint

        // setup atlases
        self.atlasIdle = unit.type.idleAtlas
    }
    
    func addTo(node parent: SKNode) {

        parent.addChild(self.sprite)
    }
    
    private func animate(to hex: HexPoint, on atlas: GameObjectAtlas?, completion block: @escaping () -> Swift.Void) {

        if let atlas = atlas {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let walkFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: animationSpeed / Double(walkFrames.count * 3))

            let move = SKAction.move(to: HexPoint.toScreen(hex: hex), duration: walk.duration)

            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, completion: {
                self.updatePosition(to: hex)
                block()
            })
        }
    }

    private func walk(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {

        let direction = HexPoint.screenDirection(from: from, towards: to)

        switch direction {
        case .north:
            self.animate(to: to, on: self.atlasUp, completion: block)
        case .northeast, .southeast:
            self.animate(to: to, on: self.atlasRight, completion: block)
        case .south:
            self.animate(to: to, on: self.atlasDown, completion: block)
        case .southwest, .northwest:
            self.animate(to: to, on: self.atlasLeft, completion: block)
        }
    }
    
    private func updatePosition(to position: HexPoint) {

        self.unit?.doMove(on: position, in: self.gameModel)
    }

    func clearPathSpriteBuffer() {

        for sprite in self.pathSpriteBuffer {
            sprite.removeFromParent()
        }
    }

    func show(path: HexPath) {

        var costSum: Double = 0.0
        let movementInCurrentTurn = Double(self.unit?.movesLeft() ?? 0)
        self.clearPathSpriteBuffer()

        guard path.count > 1 else {
            return
        }

        let (firstPoint, _) = path[0]
        let (secondPoint, secondCost) = path[1]
        
        let isMovementLeft = movementInCurrentTurn >= secondCost

        if let dir = firstPoint.direction(towards: secondPoint) {
            var textureName = "path-start-\(dir.short())"
            
            if !isMovementLeft {
                textureName = textureName + "-out"
            }

            let pathSprite = SKSpriteNode(imageNamed: textureName)
            pathSprite.position = HexPoint.toScreen(hex: firstPoint)
            pathSprite.zPosition = Globals.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.sprite.parent?.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)
        }

        for i in 1..<path.count - 1 {
            let (previousPoint, _) = path[i - 1]
            let (currentPoint, currentCost) = path[i]
            let (nextPoint, _) = path[i + 1]

            costSum = costSum + currentCost
            let isMovementLeft = movementInCurrentTurn > costSum
            
            if let dir = currentPoint.direction(towards: previousPoint),
                let dir2 = currentPoint.direction(towards: nextPoint) {

                var textureName = "path-\(dir.short())-\(dir2.short())"
                if dir.rawValue > dir2.rawValue {
                    textureName = "path-\(dir2.short())-\(dir.short())"
                }
                
                if !isMovementLeft {
                    textureName = textureName + "-out"
                }

                let pathSprite = SKSpriteNode(imageNamed: textureName)
                pathSprite.position = HexPoint.toScreen(hex: currentPoint)
                pathSprite.zPosition = Globals.ZLevels.path
                pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                self.sprite.parent?.addChild(pathSprite)

                self.pathSpriteBuffer.append(pathSprite)
            }
        }

        let (secondlastItem, _) = path[path.count - 2]
        let (lastPoint, lastCost) = path[path.count - 1]
        
        costSum = costSum + lastCost
        let isMovementLeftLast = movementInCurrentTurn > costSum

        if let dir = lastPoint.direction(towards: secondlastItem) {
            var textureName = "path-start-\(dir.short())"
            
            if !isMovementLeftLast {
                textureName = textureName + "-out"
            }

            let pathSprite = SKSpriteNode(imageNamed: textureName)
            pathSprite.position = HexPoint.toScreen(hex: lastPoint)
            pathSprite.zPosition = Globals.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.sprite.parent?.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)
        }
    }

    func showTexture(named spriteName: String) {

        self.spriteName = spriteName
        let newTexture = SKTexture(imageNamed: self.spriteName)

        self.sprite.texture = newTexture
    }

    func showIdle() {

        self.clearPathSpriteBuffer()

        if let atlas = self.atlasIdle {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let idleFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: (animationSpeed / 4.0) / Double(idleFrames.count)))

            self.sprite.run(idleAnimation, withKey: UnitObject.idleActionKey, completion: { })
        }
    }

    func showWalk(on path: HexPath, completion block: @escaping () -> Swift.Void) {

        guard !path.isEmpty else {
            self.clearPathSpriteBuffer()
            block()
            return
        }
        
        guard let unit = self.unit else {
            fatalError("unit not given")
        }

        if let (_, cost) = path.first {
            if Double(unit.movesLeft()) < cost {
                print("movement limited")
                self.clearPathSpriteBuffer()
                return
            }
        }
        
        self.sprite.removeAction(forKey: UnitObject.idleActionKey)

        /*guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        if let civilization = self.connectedUnit()?.civilization {
            if civilization == currentUserCivilization {
                self.show(path: HexPath(point: self.position, cost: 0.0, path: path))
            }
        }*/

        if let (point, _) = path.first {
            let pathWithoutFirst = path.pathWithoutFirst()

            // reduce the movementInCurrentTurn
            self.unit?.doMove(on: point, in: self.gameModel)
            
            self.walk(from: unit.location, to: point, completion: {
                self.showWalk(on: pathWithoutFirst, completion: block)
            })
        }
    }
}
