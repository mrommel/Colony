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
    
    let identifier: String
    var spriteName: String

    var atlasIdle: GameObjectAtlas?
    var atlasDown: GameObjectAtlas?
    var atlasUp: GameObjectAtlas?
    var atlasRight: GameObjectAtlas?
    var atlasLeft: GameObjectAtlas?

    var lastTime: CFTimeInterval = 0
    var animationSpeed = 4.0
    
    // internal UI elements
    var sprite: SKSpriteNode
    var typeBackgroundSprite: SKSpriteNode
    var typeIconSprite: SKSpriteNode
    var strengthIndicatorNode: UnitStrengthIndicator
    
    init(unit: AbstractUnit?, in gameModel: GameModel?) {
     
        self.identifier = UUID.init().uuidString
        self.unit = unit
        self.gameModel = gameModel
        
        guard let unit = self.unit else {
            fatalError("cant get unit")
        }
        
        guard let civilization = unit.player?.leader.civilization() else {
            fatalError("cant get civilization")
        }

        self.spriteName = unit.type.spriteName
        self.sprite = SKSpriteNode(imageNamed: self.spriteName)
        self.sprite.position = HexPoint.toScreen(hex: unit.location)
        self.sprite.zPosition = Globals.ZLevels.unit
        self.sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        let unitTypeBackgroundTexture = SKTexture(imageNamed: "unit_type_background")
        self.typeBackgroundSprite = SKSpriteNode(texture: unitTypeBackgroundTexture, color: .black, size: CGSize(width: 10, height: 10))
        self.typeBackgroundSprite.position = CGPoint(x: 8, y: 36)
        self.typeBackgroundSprite.zPosition = Globals.ZLevels.unit + 0.05
        self.typeBackgroundSprite.color = civilization.backgroundColor()
        self.typeBackgroundSprite.colorBlendFactor = 1.0
        self.sprite.addChild(self.typeBackgroundSprite)
        
        let unitTypeIconTexture = SKTexture(imageNamed: unit.type.typeTexture())
        self.typeIconSprite = SKSpriteNode(texture: unitTypeIconTexture, color: .black, size: CGSize(width: 10, height: 10))
        self.typeIconSprite.position = CGPoint(x: 8, y: 36)
        self.typeIconSprite.zPosition = Globals.ZLevels.unit + 0.06
        self.typeIconSprite.color = civilization.iconColor()
        self.typeIconSprite.colorBlendFactor = 1.0
        self.sprite.addChild(self.typeIconSprite)
        
        self.strengthIndicatorNode = UnitStrengthIndicator(strength: 100)
        self.strengthIndicatorNode.position = CGPoint(x: 42, y: 16)
        self.strengthIndicatorNode.zPosition = Globals.ZLevels.unit + 0.06
        // dont add
        self.sprite.addChild(self.strengthIndicatorNode)

        // setup atlases
        self.atlasIdle = unit.type.idleAtlas
        self.atlasDown = unit.type.walkDownAtlas
        self.atlasUp = unit.type.walkUpAtlas
        self.atlasLeft = unit.type.walkLeftAtlas
        self.atlasRight = unit.type.walkRightAtlas
    }
    
    func addTo(node parent: SKNode) {

        parent.addChild(self.sprite)
    }
    
    private func animate(to hex: HexPoint, on atlas: GameObjectAtlas?, completion block: @escaping () -> Swift.Void) {

        if let atlas = atlas {
            let walkFrames = atlas.textures
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: atlas.speed)

            let move = SKAction.move(to: HexPoint.toScreen(hex: hex), duration: walk.duration)

            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, completion: {
                block()
            })
        } else {
            // if no atlas
            // print("missing atlas")
            self.sprite.position = HexPoint.toScreen(hex: hex)
            block()
        }
    }

    private func walk(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {

        if from == to {
            return
        }
        
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
    
    func update(strength: Int) {
        
        if strength >= 100 {
            if self.strengthIndicatorNode.parent != nil {
                self.strengthIndicatorNode.removeFromParent()
            }
        } else {
            if self.strengthIndicatorNode.parent == nil {
                self.sprite.addChild(self.strengthIndicatorNode)
            }
            self.strengthIndicatorNode.set(strength: strength)
        }
        //self.strengthIndicatorNode.set(strength: strength)
    }

    func showIdle() {
        
        guard let unit = self.unit else {
            fatalError("unit not given")
        }
        
        // just to be sure
        self.sprite.position = HexPoint.toScreen(hex: unit.location)

        if let atlas = self.atlasIdle {
            let idleFrames = atlas.textures
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: atlas.speed))

            self.sprite.run(idleAnimation, withKey: UnitObject.idleActionKey, completion: { })
        }
    }

    func showWalk(on path: HexPath, completion block: @escaping () -> Swift.Void) {

        guard path.count >= 2 else {
            block()
            return
        }
        
        self.sprite.removeAction(forKey: UnitObject.idleActionKey)

        if let (fromPoint, _) = path.first, let (toPoint, _) = path.second {
        
            // print("=== walk from \(fromPoint) to \(toPoint) ---")
            let pathWithoutFirst = path.pathWithoutFirst()

            self.walk(from: fromPoint, to: toPoint, completion: {
                // print("=== ready walking from \(fromPoint) to \(toPoint) ---")
                self.showWalk(on: pathWithoutFirst, completion: block)
            })
        }
    }
}
