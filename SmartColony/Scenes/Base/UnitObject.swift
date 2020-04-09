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

        print("\(unit!.location) => \(hex)")
        
        if let atlas = atlas {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let walkFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: animationSpeed / Double(walkFrames.count * 3))

            let move = SKAction.move(to: HexPoint.toScreen(hex: hex), duration: walk.duration)

            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, completion: {
                self.unit?.doMove(on: hex, in: self.gameModel)
                block()
            })
        } else {
            // if no atlas
            print("missing atlas")
            self.sprite.position = HexPoint.toScreen(hex: hex)
            self.unit?.doMove(on: hex, in: self.gameModel)
            block()
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

    func showTexture(named spriteName: String) {

        self.spriteName = spriteName
        let newTexture = SKTexture(imageNamed: self.spriteName)

        self.sprite.texture = newTexture
    }

    func showIdle() {

        //self.clearPathSpriteBuffer()

        if let atlas = self.atlasIdle {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let idleFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: (animationSpeed / 4.0) / Double(idleFrames.count)))

            self.sprite.run(idleAnimation, withKey: UnitObject.idleActionKey, completion: { })
        }
    }

    func showWalk(on path: HexPath, completion block: @escaping () -> Swift.Void) {

        //print("---> path: \(path.count)")
        
        guard !path.isEmpty else {
            //self.clearPathSpriteBuffer()
            print("path empty")
            block()
            return
        }
        
        guard let unit = self.unit else {
            fatalError("unit not given")
        }

        if let (_, cost) = path.first {
            if Double(unit.movesLeft()) < cost {
                //self.clearPathSpriteBuffer()
                print("movement limited")
                block()
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

            self.walk(from: unit.location, to: point, completion: {
                self.showWalk(on: pathWithoutFirst, completion: block)
            })
        }
    }
}
