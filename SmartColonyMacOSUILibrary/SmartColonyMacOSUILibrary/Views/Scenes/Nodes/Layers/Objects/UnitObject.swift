//
//  UnitObject.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

protocol UnitObjectDelegate: AnyObject {

    func clearFocus()
}

class UnitObject {

    static let idleActionKey: String = "idleActionKey"
    static let walkActionKey: String = "walkActionKey"
    static let fortifiedActionKey: String = "fortifiedActionKey"
    static let attackActionKey: String = "attackActionKey"
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

    // walk atlases
    var atlasWalkSouth: ObjectTextureAtlas?
    var atlasWalkNorth: ObjectTextureAtlas?
    var atlasWalkEast: ObjectTextureAtlas?
    var atlasWalkWest: ObjectTextureAtlas?

    // attack atlases
    var atlasAttackSouth: ObjectTextureAtlas?
    var atlasAttackNorth: ObjectTextureAtlas?
    var atlasAttackEast: ObjectTextureAtlas?
    var atlasAttackWest: ObjectTextureAtlas?

    var lastTime: CFTimeInterval = 0
    var animationSpeed = 4.0

    var animationQueue: Queue<UnitAnimationType> = Queue<UnitAnimationType>()
    var currentAnimation: UnitAnimationType

    // internal UI elements
    var sprite: SKSpriteNode
    var typeBackgroundSprite: SKSpriteNode
    var typeIconSprite: SKSpriteNode
    var strengthIndicatorNode: UnitStrengthIndicator

    var shouldRemove: Bool = false

    weak var delegate: UnitObjectDelegate?

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

        let unitImage = ImageCache.shared.image(for: unit.type.spriteName)
        let unitTexture = SKTexture(image: unitImage)
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

        self.atlasWalkSouth = unit.type.walkSouthAtlas
        self.atlasWalkNorth = unit.type.walkNorthAtlas
        self.atlasWalkWest = unit.type.walkWestAtlas
        self.atlasWalkEast = unit.type.walkEastAtlas

        self.atlasAttackSouth = unit.type.attackSouthAtlas
        self.atlasAttackNorth = unit.type.attackNorthAtlas
        self.atlasAttackWest = unit.type.attackWestAtlas
        self.atlasAttackEast = unit.type.attackEastAtlas
    }

    func addTo(node parent: SKNode) {

        parent.addChild(self.sprite)
    }

    private func animateWalk(to hex: HexPoint, on atlas: ObjectTextureAtlas?, completion block: @escaping () -> Swift.Void) {

        self.sprite.removeAction(forKey: UnitObject.idleActionKey)
        self.sprite.removeAction(forKey: UnitObject.fortifiedActionKey)

        if let atlas = atlas {
            let walkFrames = atlas.textures.map { SKTexture(image: $0) }
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: atlas.timePerFrame)

            let move = SKAction.move(to: HexPoint.toScreen(hex: hex), duration: walk.duration)

            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, withKey: UnitObject.walkActionKey, completion: {
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
                self.animateWalk(to: to, on: UnitObject.atlasEmbarkedNorth, completion: block)
            } else {
                self.animateWalk(to: to, on: self.atlasWalkNorth, completion: block)
            }
        case .northeast, .southeast:
            if showEmbarked {
                self.animateWalk(to: to, on: UnitObject.atlasEmbarkedEast, completion: block)
            } else {
                self.animateWalk(to: to, on: self.atlasWalkEast, completion: block)
            }
        case .south:
            if showEmbarked {
                self.animateWalk(to: to, on: UnitObject.atlasEmbarkedSouth, completion: block)
            } else {
                self.animateWalk(to: to, on: self.atlasWalkSouth, completion: block)
            }
        case .southwest, .northwest:
            if showEmbarked {
                self.animateWalk(to: to, on: UnitObject.atlasEmbarkedWest, completion: block)
            } else {
                self.animateWalk(to: to, on: self.atlasWalkWest, completion: block)
            }
        }
    }

    private func animateAttack(from: HexPoint, to hex: HexPoint, on atlas: ObjectTextureAtlas?, completion block: @escaping () -> Swift.Void) {

        self.sprite.removeAction(forKey: UnitObject.idleActionKey)
        self.sprite.removeAction(forKey: UnitObject.fortifiedActionKey)

        if let atlas = atlas {
            let attackFrames = atlas.textures.map { SKTexture(image: $0) }
            let attack = SKAction.animate(with: [attackFrames, attackFrames, attackFrames].flatMap { $0 }, timePerFrame: atlas.timePerFrame)

            /*let moveForward = SKAction.move(to: HexPoint.toScreen(hex: hex), duration: attack.duration / 3.0)
            let wait = SKAction.wait(forDuration: attack.duration / 3.0)
            let moveBack = SKAction.move(to: HexPoint.toScreen(hex: from), duration: attack.duration / 3.0)
            let move = SKAction.sequence([moveForward, wait, moveBack])

            let animate = SKAction.group([attack, move])*/
            let animate = attack
            self.sprite.run(animate, withKey: UnitObject.attackActionKey, completion: {
                block()
            })
        } else {
            // self.sprite.position = HexPoint.toScreen(hex: hex)
            block()
        }
    }

    private func attack(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {

        if from == to {
            return
        }

        let direction = HexPoint.screenDirection(from: from, towards: to)

        switch direction {

        case .north:
            self.animateAttack(from: from, to: to, on: self.atlasAttackNorth, completion: block)
        case .northeast, .southeast:
            self.animateAttack(from: from, to: to, on: self.atlasAttackEast, completion: block)
        case .south:
            self.animateAttack(from: from, to: to, on: self.atlasAttackSouth, completion: block)
        case .southwest, .northwest:
            self.animateAttack(from: from, to: to, on: self.atlasAttackWest, completion: block)
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

        // if let currentAnimation = self.currentAnimation {
        //    print("## Animation: \(unit.name()) currently = \(self.currentAnimation) ##")
        // }

        if case .idle(location: let location) = self.currentAnimation {

            if !self.animationQueue.isEmpty {

                // print("animationQueue of \(unit.name()): \(self.animationQueue)")
                if let firstAnimation = self.animationQueue.dequeue() {

                    self.currentAnimation = firstAnimation
                    // print("## Animation: \(unit.name()) currently = \(self.currentAnimation) ##")

                    switch firstAnimation {

                    case .move(from: let from, to: let to):
                        // print("## Animation: \(unit.name()) walk started ##")
                        self.walk(from: from, to: to) {
                            self.currentAnimation = .idle(location: to)
                            // print("## Animation: \(unit.name()) walk ended ##")
                            self.delegate?.clearFocus()
                        }

                    case .show(location: let location):
                        // print("## handle show Animation: \(unit.name()) at \(unit.location) / \(location) ##")
                        self.shouldRemove = false
                        self.sprite.alpha = 1.0
                        self.currentAnimation = .idle(location: location)

                    case .hide(location: let location):
                        // print("## handle hide Animation: \(unit.name()) at \(unit.location) / \(location) ##")
                        self.shouldRemove = true
                        self.currentAnimation = .idle(location: location)

                    case .enterCity(location: let location):
                        // print("## handle enterCity Animation: \(unit.name()) at \(unit.location) / \(location) ##")
                        self.sprite.alpha = 0.0
                        self.currentAnimation = .idle(location: location)

                    case .fortify:
                        // print("## handle fortify Animation: \(unit.name()) ##")
                        self.showFortified()
                        self.currentAnimation = .idle(location: location)

                    case .unfortify:
                        // print("## Animation: \(unit.name()) unfortify ##")
                        // noop
                        self.currentAnimation = .idle(location: unit.location)

                    case .attack(from: let from, to: let to):
                        // print("## Animation: \(unit.name()) attack started ##")
                        self.attack(from: from, to: to) {
                            self.currentAnimation = .idle(location: to)
                            // print("## Animation: \(unit.name()) attack ended ##")
                        }

                    case .rangeAttack(from: let from, to: let to):
                        // print("## Animation: \(unit.name()) range attack started ##")
                        self.attack(from: from, to: to) {
                            self.currentAnimation = .idle(location: to)
                            // print("## Animation: \(unit.name()) range attack ended ##")
                        }

                    case .idle(location: _):
                        // noop
                        // print("does not happen: idle at \(location)")
                        break
                    }
                }
            } else {
                // print("## Animation: \(unit.name()) idle ##")
                self.showIdle(at: location)
            }
        }
    }

    func show(at point: HexPoint) {

        self.animationQueue.enqueue(.show(location: point))
    }

    func hide(at point: HexPoint) {

        self.animationQueue.enqueue(.hide(location: point))
    }

    func enterCity(at point: HexPoint) {

        self.animationQueue.enqueue(.enterCity(location: point))
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

    func attack(from source: HexPoint, towards point: HexPoint) {

        self.animationQueue.enqueue(.attack(from: source, to: point))
    }

    func rangeAttack(from source: HexPoint, towards point: HexPoint) {

        self.animationQueue.enqueue(.rangeAttack(from: source, to: point))
    }

    func fortify() {

        // enqueue animation
        self.animationQueue.enqueue(.fortify)
    }

    private func showIdle(at location: HexPoint) {

        guard let unit = self.unit else {
            fatalError("unit not given")
        }

        if self.sprite.action(forKey: UnitObject.idleActionKey) != nil {
            return
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
                timePerFrame: idleAtlas.timePerFrame
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
                    timePerFrame: atlas.timePerFrame
                )
            )

            self.sprite.run(idleAnimation, withKey: UnitObject.fortifiedActionKey, completion: { })
        }
    }

    func shouldBeRemoved() -> Bool {

        return self.shouldRemove
    }

    func animationQueueEmpty() -> Bool {

        return self.animationQueue.isEmpty
    }
}
