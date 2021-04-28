//
//  UnitObject.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class UnitObject {
    
    static let idleActionKey: String = "idleActionKey"
    static let fortifiedActionKey: String = "fortifiedActionKey"
    static let alphaVisible: CGFloat = 1.0
    static let alphaInvisible: CGFloat = 0.0
    
    weak var unit: AbstractUnit?
    weak var gameModel: GameModel?
    
    let identifier: String
    //var spriteName: String

    var atlasIdle: ObjectTextureAtlas?
    var atlasFortified: ObjectTextureAtlas?
    var atlasDown: ObjectTextureAtlas?
    var atlasUp: ObjectTextureAtlas?
    var atlasRight: ObjectTextureAtlas?
    var atlasLeft: ObjectTextureAtlas?

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

        let unitTexture = SKTexture(imageNamed: unit.type.spriteName)
        self.sprite = SKSpriteNode(texture: unitTexture, color: .black, size: CGSize(width: 144, height: 144))
        self.sprite.position = HexPoint.toScreen(hex: unit.location) * 3.0
        self.sprite.zPosition = Globals.ZLevels.unit
        self.sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        let unitTypeBackgroundImage = ImageCache.shared.image(for: "unit-type-background")
        let unitTypeBackgroundTexture = SKTexture(image: unitTypeBackgroundImage)
        self.typeBackgroundSprite = SKSpriteNode(texture: unitTypeBackgroundTexture, color: .black, size: CGSize(width: 30, height: 30))
        self.typeBackgroundSprite.position = CGPoint(x: 24, y: 36 * 3)
        self.typeBackgroundSprite.zPosition = Globals.ZLevels.unit + 0.05
        self.typeBackgroundSprite.color = civilization.main
        self.typeBackgroundSprite.colorBlendFactor = 1.0
        self.sprite.addChild(self.typeBackgroundSprite)
        
        let unitTypeIconImage = ImageCache.shared.image(for: unit.type.typeTexture())
        let unitTypeIconTexture = SKTexture(image: unitTypeIconImage)
        self.typeIconSprite = SKSpriteNode(texture: unitTypeIconTexture, color: .black, size: CGSize(width: 30, height: 30))
        self.typeIconSprite.position = CGPoint(x: 24, y: 36 * 3)
        self.typeIconSprite.zPosition = Globals.ZLevels.unit + 0.06
        self.typeIconSprite.color = civilization.accent
        self.typeIconSprite.colorBlendFactor = 1.0
        self.sprite.addChild(self.typeIconSprite)
        
        self.strengthIndicatorNode = UnitStrengthIndicator(strength: 100)
        self.strengthIndicatorNode.position = CGPoint(x: 42 * 3, y: 16 * 3)
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
    
    private func animate(to hex: HexPoint, on atlas: ObjectTextureAtlas?, completion block: @escaping () -> Swift.Void) {

        self.sprite.removeAction(forKey: UnitObject.idleActionKey)
        self.sprite.removeAction(forKey: UnitObject.fortifiedActionKey)
        
        if let atlas = atlas {
            let walkFrames = atlas.textures.map { SKTexture(image: $0) }
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: atlas.speed)

            let move = SKAction.move(to: HexPoint.toScreen(hex: hex) * 3.0, duration: walk.duration)

            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, completion: {
                block()
            })
        } else {
            // if no atlas
            // print("missing atlas")
            self.sprite.position = HexPoint.toScreen(hex: hex) * 3.0
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

        let newTexture = SKTexture(imageNamed: spriteName)

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
        
        self.sprite.removeAction(forKey: UnitObject.fortifiedActionKey)
        
        // just to be sure
        self.sprite.position = HexPoint.toScreen(hex: unit.location) * 3.0

        if let atlas = self.atlasIdle {
            let idleFrames = atlas.textures.map { SKTexture(image: $0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: [idleFrames, idleFrames, idleFrames].flatMap { $0 }, timePerFrame: atlas.speed))

            self.sprite.run(idleAnimation, withKey: UnitObject.idleActionKey, completion: { })
        }
    }
    
    func showFortified() {
        
        guard let unit = self.unit else {
            fatalError("unit not given")
        }
        
        self.sprite.removeAction(forKey: UnitObject.idleActionKey)
        
        // just to be sure
        self.sprite.position = HexPoint.toScreen(hex: unit.location) * 3.0
        
        if let atlas = self.atlasFortified {
            let fortifiedFrames = atlas.textures.map { SKTexture(image: $0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: [fortifiedFrames, fortifiedFrames, fortifiedFrames].flatMap { $0 }, timePerFrame: atlas.speed))

            self.sprite.run(idleAnimation, withKey: UnitObject.fortifiedActionKey, completion: { })
        }
    }

    func showWalk(on path: HexPath, completion block: @escaping () -> Swift.Void) {

        guard path.count >= 2 else {
            block()
            return
        }
        
        self.sprite.removeAction(forKey: UnitObject.idleActionKey)
        self.sprite.removeAction(forKey: UnitObject.fortifiedActionKey)

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
