//
//  UnitObject.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

struct Queue<T> {
     var list = [T]()

    mutating func enqueue(_ element: T) {
          list.append(element)
    }

    mutating func dequeue() -> T? {
         if !list.isEmpty {
           return list.removeFirst()
         } else {
           return nil
         }
    }

    func peek() -> T? {
         if !list.isEmpty {
              return list[0]
         } else {
           return nil
         }
    }

    var isEmpty: Bool {
         return list.isEmpty
    }
}

class UnitObject {

    static let idleActionKey: String = "idleActionKey"
    static let fortifiedActionKey: String = "fortifiedActionKey"
    static let alphaVisible: CGFloat = 1.0
    static let alphaInvisible: CGFloat = 0.0

    static var atlasEmbarkedIdle: ObjectTextureAtlas {
        ObjectTextureAtlas(template: "embarked-idle-", range: 0..<3)
    }
    static var atlasEmbarkedWest: ObjectTextureAtlas {
        ObjectTextureAtlas(template: "embarked-west-", range: 0..<3)
    }
    static var atlasEmbarkedEast: ObjectTextureAtlas {
        ObjectTextureAtlas(template: "embarked-east-", range: 0..<3)
    }
    static var atlasEmbarkedNorth: ObjectTextureAtlas {
        ObjectTextureAtlas(template: "embarked-north-", range: 0..<3)
    }
    static var atlasEmbarkedSouth: ObjectTextureAtlas {
        ObjectTextureAtlas(template: "embarked-south-", range: 0..<3)
    }

    weak var unit: AbstractUnit?
    weak var gameModel: GameModel?

    let identifier: String

    var atlasIdle: ObjectTextureAtlas?
    var atlasFortified: ObjectTextureAtlas?
    var atlasSouth: ObjectTextureAtlas?
    var atlasNorth: ObjectTextureAtlas?
    var atlasEast: ObjectTextureAtlas?
    var atlasWest: ObjectTextureAtlas?

    var lastTime: CFTimeInterval = 0
    var animationSpeed = 4.0

    var animationQueue: Queue<UnitAnimationType> = Queue<UnitAnimationType>()
    var currentAnimation: UnitAnimationType

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

        self.currentAnimation = .idle(location: unit.location)

        let unitTexture = SKTexture(imageNamed: unit.type.spriteName)
        self.sprite = SKSpriteNode(texture: unitTexture, color: .black, size: BaseLayer.kTextureSize)
        self.sprite.position = HexPoint.toScreen(hex: unit.location)
        self.sprite.zPosition = Globals.ZLevels.unit
        self.sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        let unitTypeBackgroundImage = ImageCache.shared.image(for: "unit-type-background")
        let unitTypeBackgroundTexture = SKTexture(image: unitTypeBackgroundImage)
        self.typeBackgroundSprite = SKSpriteNode(texture: unitTypeBackgroundTexture, color: .black, size: CGSize(width: 10, height: 10))
        self.typeBackgroundSprite.position = CGPoint(x: 8, y: 36)
        self.typeBackgroundSprite.zPosition = Globals.ZLevels.unit + 0.05
        self.typeBackgroundSprite.color = civilization.main
        self.typeBackgroundSprite.colorBlendFactor = 1.0
        self.sprite.addChild(self.typeBackgroundSprite)

        let unitTypeIconImage = ImageCache.shared.image(for: unit.type.typeTemplateTexture())
        let unitTypeIconTexture = SKTexture(image: unitTypeIconImage)
        self.typeIconSprite = SKSpriteNode(texture: unitTypeIconTexture, color: .black, size: CGSize(width: 10, height: 10))
        self.typeIconSprite.position = CGPoint(x: 8, y: 36)
        self.typeIconSprite.zPosition = Globals.ZLevels.unit + 0.06
        self.typeIconSprite.color = civilization.accent
        self.typeIconSprite.colorBlendFactor = 1.0
        self.sprite.addChild(self.typeIconSprite)

        self.strengthIndicatorNode = UnitStrengthIndicator(strength: 100)
        self.strengthIndicatorNode.position = CGPoint(x: 42, y: 16)
        self.strengthIndicatorNode.zPosition = Globals.ZLevels.unit + 0.06
        self.sprite.addChild(self.strengthIndicatorNode)

        // setup atlases
        self.atlasIdle = unit.type.idleAtlas
        self.atlasSouth = unit.type.walkSouthAtlas
        self.atlasNorth = unit.type.walkNorthAtlas
        self.atlasWest = unit.type.walkWestAtlas
        self.atlasEast = unit.type.walkEastAtlas
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

            let move = SKAction.move(to: HexPoint.toScreen(hex: hex), duration: walk.duration)

            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, completion: {
                block()
            })
        } else {
            self.sprite.position = HexPoint.toScreen(hex: hex)
            block()
        }
    }

    private func walk(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {

        guard let unit = self.unit else {
            fatalError("unit not given")
        }

        if from == to {
            return
        }

        let direction = HexPoint.screenDirection(from: from, towards: to)
        let showEmbarked = unit.isEmbarked() && gameModel?.tile(at: to)?.isWater() ?? false

        switch direction {

        case .north:
            if showEmbarked {
                self.animate(to: to, on: UnitObject.atlasEmbarkedNorth, completion: block)
            } else {
                self.animate(to: to, on: self.atlasNorth, completion: block)
            }
        case .northeast, .southeast:
            if showEmbarked {
                self.animate(to: to, on: UnitObject.atlasEmbarkedEast, completion: block)
            } else {
                self.animate(to: to, on: self.atlasEast, completion: block)
            }
        case .south:
            if showEmbarked {
                self.animate(to: to, on: UnitObject.atlasEmbarkedSouth, completion: block)
            } else {
                self.animate(to: to, on: self.atlasSouth, completion: block)
            }
        case .southwest, .northwest:
            if showEmbarked {
                self.animate(to: to, on: UnitObject.atlasEmbarkedWest, completion: block)
            } else {
                self.animate(to: to, on: self.atlasWest, completion: block)
            }
        }
    }

    func showTexture(named spriteName: String) {

        let newTexture = SKTexture(imageNamed: spriteName)

        self.sprite.texture = newTexture
    }

    func update() {

        guard let unit = self.unit else {
            fatalError("unit not given")
        }

        let strength = unit.healthPoints()

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

        /*if let currentAnimation = self.currentAnimation {
            print("## Animation: \(unit.name()) currently = \(currentAnimation) ##")
        }*/

        if case .idle(location: let location) = self.currentAnimation {

            if !self.animationQueue.isEmpty {

                // print("animationQueue: \(animationQueue)")
                if let firstAnimation = self.animationQueue.dequeue() {

                    self.currentAnimation = firstAnimation

                    switch firstAnimation {

                    case .move(from: let from, to: let to):
                        // print("## Animation: \(unit.name()) walk begin ##")
                        self.walk(from: from, to: to) {
                            // print("## Animation: \(unit.name()) walk ended ##")
                            self.currentAnimation = .idle(location: to)
                        }
                    case .show:
                        // print("## Animation: \(unit.name()) show ##")
                        // self.show
                        self.currentAnimation = .idle(location: unit.location)
                    case .hide:
                        // print("## Animation: \(unit.name()) hide ##")
                        // self.show
                        self.currentAnimation = .idle(location: unit.location)
                    case .fortify:
                        // print("## Animation: \(unit.name()) fortify ##")
                        self.showFortified()
                        self.currentAnimation = .idle(location: unit.location)
                    case .unfortify:
                        // print("## Animation: \(unit.name()) unfortify ##")
                        // noop
                        self.currentAnimation = .idle(location: unit.location)

                    case .idle(location: let location):
                        // noop
                        print("does not happen: idle at \(location)")
                    }
                }
            } else {
                // print("## Animation: \(unit.name()) idle ##")
                self.showIdle(at: location)
            }
        }
    }

    func move(on path: HexPath) {

        var lastPoint: HexPoint = HexPoint.invalid
        for (index, point) in path.enumerated() {

            if index == 0 {
                lastPoint = point
            } else {
                self.animationQueue.enqueue(.move(from: lastPoint, to: point))
                lastPoint = point
            }
        }
    }

    func fortify() {

        // enqueue animation
        self.animationQueue.enqueue(.fortify)
    }

    private func showIdle(at location: HexPoint) {

        guard let unit = self.unit else {
            fatalError("unit not given")
        }

        self.sprite.removeAction(forKey: UnitObject.fortifiedActionKey)

        // just to be sure
        self.sprite.position = HexPoint.toScreen(hex: unit.location)

        var idleAtlas: ObjectTextureAtlas
        if unit.isEmbarked() {
            idleAtlas = UnitObject.atlasEmbarkedIdle
        } else {
            guard let atlas = self.atlasIdle else {
                fatalError("cant get idle atlas")
            }

            idleAtlas = atlas
        }

        let idleFrames = idleAtlas.textures.map { SKTexture(image: $0) }
        let combinedIdleFrames = [idleFrames, idleFrames, idleFrames].flatMap { $0 }
        let idleAnimation = SKAction.repeatForever(
            SKAction.animate(
                with: combinedIdleFrames,
                timePerFrame: idleAtlas.speed
            )
        )

        self.sprite.run(idleAnimation, withKey: UnitObject.idleActionKey, completion: { })
    }

    private func showFortified() {

        guard let unit = self.unit else {
            fatalError("unit not given")
        }

        self.sprite.removeAction(forKey: UnitObject.idleActionKey)

        // just to be sure
        self.sprite.position = HexPoint.toScreen(hex: unit.location)

        if let atlas = self.atlasFortified {
            let fortifiedFrames = atlas.textures.map { SKTexture(image: $0) }
            let combinedFortifiedFrames = [fortifiedFrames, fortifiedFrames, fortifiedFrames].flatMap { $0 }
            let idleAnimation = SKAction.repeatForever(
                SKAction.animate(
                    with: combinedFortifiedFrames,
                    timePerFrame: atlas.speed
                )
            )

            self.sprite.run(idleAnimation, withKey: UnitObject.fortifiedActionKey, completion: { })
        }
    }

    private func showWalk(on path: HexPath, completion block: @escaping () -> Swift.Void) {

        guard path.count >= 2 else {
            block()
            return
        }

        print("showWalk: \(path)")

        self.sprite.removeAction(forKey: UnitObject.idleActionKey)
        self.sprite.removeAction(forKey: UnitObject.fortifiedActionKey)

        if let (fromPoint, _) = path.first, let (toPoint, _) = path.second {

            let pathWithoutFirst = path.pathWithoutFirst()

            self.walk(from: fromPoint, to: toPoint, completion: {
                self.showWalk(on: pathWithoutFirst, completion: block)
            })
        }
    }
}
