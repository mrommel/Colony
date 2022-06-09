//
//  UnitLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

// swiftlint:disable type_body_length
class UnitLayer: SKNode {

    static let kTextureWidth: Int = 48
    static let kTextureSize: CGSize = CGSize(width: kTextureWidth, height: kTextureWidth)
    static let focusActionOriginalKey: String = "focusActionKey"
    static let focusActionAlternateKey: String = "focusActionAlternateKey"
    static let focusAttackActionKey: String = "focusAttackActionKey"

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    var wrapOverlap: Int = 0

    private var unitObjects: [UnitObject]

    // focus
    private var focusNodeOriginal: SKSpriteNode?
    private var focusNodeAlternate: SKSpriteNode?
    private var atlasFocus: ObjectTextureAtlas?
    private var attackFocusNodes: [SKSpriteNode?] = []
    private var atlasAttackFocus: ObjectTextureAtlas?

    // path
    private var pathSpriteBuffer: [SKSpriteNode] = []

    init(player: AbstractPlayer?) {

        self.player = player
        self.unitObjects = []

        let focusTextureNames: [String] = [
            "focus1", "focus2", "focus3", "focus4", "focus5", "focus6",
            "focus6", "focus5", "focus4", "focus3", "focus2", "focus1"
        ]
        self.atlasFocus = ObjectTextureAtlas(textures: focusTextureNames)

        let attackTextureNames: [String] = [
            "focus-attack1", "focus-attack2", "focus-attack3",
            "focus-attack3", "focus-attack2", "focus-attack1"
        ]
        self.atlasAttackFocus = ObjectTextureAtlas(textures: attackTextureNames)

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with gameModel: GameModel?) {

        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        self.textureUtils = TextureUtils(with: gameModel)

        let mapSize = gameModel.mapSize()

        self.wrapOverlap = mapSize.width() / 2

        for player in gameModel.players {

            for unitRef in gameModel.units(of: player) {

                self.show(unit: unitRef, at: unitRef?.location ?? HexPoint.invalid)
            }
        }

        print("inited with: \(self.unitObjects.count) visible units")
    }

    /// has any unit animations running - means at last one units not in idle state
    /// used to disabled the turn button
    ///
    /// - Returns: `true`if all animations are finished
    func animationsAreRunning(for leader: LeaderType) -> Bool {

        var animationsAreRunning: Bool = false

        for unitObject in self.unitObjects where unitObject.unit?.leader == leader {

            if !unitObject.animationQueueEmpty() {
                animationsAreRunning = true
            }

            if case .idle(location: _) = unitObject.currentAnimation {
                // NOOP
            } else {
                animationsAreRunning = true
            }
        }

        return animationsAreRunning
    }

    func show(unit: AbstractUnit?, at location: HexPoint) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        if let tile = gameModel.tile(at: unit.location) {

            if !tile.isVisible(to: self.player) {

                return
            }
        }

        // original: already shown, no need to add
        if let unitObject = self.originalUnitObject(of: unit) {

            unitObject.show(at: location)
            unitObject.update()

        } else {

            let unitObject = UnitObject(unit: unit, mode: .original, at: location, in: self.gameModel)

            // add to canvas
            unitObject.addTo(node: self)
            unitObject.delegate = self

            // make idle
            unitObject.show(at: location)
            unitObject.update()

            // keep reference
            self.unitObjects.append(unitObject)
        }

        // alternate: already shown, no need to add
        let alternateLocation = self.alternatePoint(for: location)
        if let unitObject = self.alternateUnitObject(of: unit) {

            unitObject.show(at: alternateLocation)
            unitObject.update()

        } else {

            let unitObject = UnitObject(unit: unit, mode: .alternate, at: alternateLocation, in: self.gameModel)

            // add to canvas
            unitObject.addTo(node: self)
            unitObject.delegate = self

            // make idle
            unitObject.show(at: alternateLocation)
            unitObject.update()

            // keep reference
            self.unitObjects.append(unitObject)
        }
    }

    func hide(unit: AbstractUnit?, at location: HexPoint) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        if let unitObject = self.originalUnitObject(of: unit) {
            unitObject.hide(at: location)
        }

        if let unitObject = self.alternateUnitObject(of: unit) {
            let alternateLocation = self.alternatePoint(for: location)
            unitObject.hide(at: alternateLocation)
        }
    }

    func enterCity(unit: AbstractUnit?, at location: HexPoint) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        if let unitObject = self.originalUnitObject(of: unit) {
            unitObject.enterCity(at: location)
        }

        if let unitObject = self.alternateUnitObject(of: unit) {
            let alternateLocation = self.alternatePoint(for: location)
            unitObject.enterCity(at: alternateLocation)
        }
    }

    func leaveCity(unit: AbstractUnit?, at location: HexPoint) {

        self.show(unit: unit, at: location)
    }

    func fortify(unit: AbstractUnit?) {

        if let unitObject = self.originalUnitObject(of: unit) {

            unitObject.fortify()
        }

        if let unitObject = self.alternateUnitObject(of: unit) {

            unitObject.fortify()
        }
    }

    func attack(unit: AbstractUnit?, from source: HexPoint, towards location: HexPoint) {

        if let unitObject = self.originalUnitObject(of: unit) {

            unitObject.attack(from: source, towards: location)
        }

        if let unitObject = self.alternateUnitObject(of: unit) {

            let alternateSource = self.alternatePoint(for: source)
            let alternateLocation = self.alternatePoint(for: location)
            unitObject.attack(from: alternateSource, towards: alternateLocation)
        }
    }

    func rangeAttack(unit: AbstractUnit?, from source: HexPoint, towards location: HexPoint) {

        if let unitObject = self.originalUnitObject(of: unit) {

            unitObject.rangeAttack(from: source, towards: location)
        }

        if let unitObject = self.alternateUnitObject(of: unit) {

            let alternateSource = self.alternatePoint(for: source)
            let alternateLocation = self.alternatePoint(for: location)
            unitObject.rangeAttack(from: alternateSource, towards: alternateLocation)
        }
    }

    private func originalUnitObject(at location: HexPoint) -> UnitObject? {

        for unitObject in self.unitObjects where unitObject.mode == .original && unitObject.unit?.location == location {

            return unitObject
        }

        return nil
    }

    private func originalUnitObject(of unit: AbstractUnit?) -> UnitObject? {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        for unitObject in self.unitObjects where unitObject.mode == .original && unit.isEqual(to: unitObject.unit) {

            return unitObject
        }

        return nil
    }

    private func alternateUnitObject(at location: HexPoint) -> UnitObject? {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }

        let originalLocation = location
        let wrappedLocation = gameModel.wrap(point: location)

        for unitObject in self.unitObjects where
            unitObject.mode == .alternate &&
            (unitObject.unit?.location == originalLocation || unitObject.unit?.location == wrappedLocation) {

            return unitObject
        }

        return nil
    }

    private func alternateUnitObject(of unit: AbstractUnit?) -> UnitObject? {

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        let originalLocation = unit.location
        let wrappedLocation = gameModel.wrap(point: unit.location)

        for unitObject in self.unitObjects where
            unitObject.mode == .alternate &&
            unitObject.unit?.type == unit.type &&
            (unitObject.unit?.location == originalLocation || unitObject.unit?.location == wrappedLocation) {

            return unitObject
        }

        return nil
    }

    func alternatePoint(for point: HexPoint) -> HexPoint {

        if point.x >= self.wrapOverlap {
            return HexPoint(x: point.x - 2 * self.wrapOverlap, y: point.y)
        }

        if point.x < self.wrapOverlap {
            return HexPoint(x: point.x + 2 * self.wrapOverlap, y: point.y)
        }

        return point
    }

    func showFocus(for unit: AbstractUnit?) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        self.hideFocus()

        let focusImage = ImageCache.shared.image(for: "focus1")

        // original point
        let originalPoint = unit.location
        self.focusNodeOriginal = SKSpriteNode(texture: SKTexture(image: focusImage), size: UnitLayer.kTextureSize)
        self.focusNodeOriginal?.position = HexPoint.toScreen(hex: originalPoint)
        self.focusNodeOriginal?.zPosition = Globals.ZLevels.focus
        self.focusNodeOriginal?.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let atlas = self.atlasFocus {

            let focusFrames = atlas.textures.map { SKTexture(image: $0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: atlas.timePerFrame))

            self.focusNodeOriginal?.run(focusAnimation, withKey: UnitLayer.focusActionOriginalKey, completion: { })
        }

        if let focusNodeOriginal = self.focusNodeOriginal {
            self.addChild(focusNodeOriginal)
        }

        // alternate point
        let alternatePoint = self.alternatePoint(for: unit.location)
        self.focusNodeAlternate = SKSpriteNode(texture: SKTexture(image: focusImage), size: UnitLayer.kTextureSize)
        self.focusNodeAlternate?.position = HexPoint.toScreen(hex: alternatePoint)
        self.focusNodeAlternate?.zPosition = Globals.ZLevels.focus
        self.focusNodeAlternate?.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let atlas = self.atlasFocus {

            let focusFrames = atlas.textures.map { SKTexture(image: $0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: atlas.timePerFrame))

            self.focusNodeAlternate?.run(focusAnimation, withKey: UnitLayer.focusActionAlternateKey, completion: { })
        }

        if let focusNodeAlternate = self.focusNodeAlternate {
            self.addChild(focusNodeAlternate)
        }
    }

    func hideFocus() {

        if self.focusNodeOriginal != nil {
            self.focusNodeOriginal?.removeAction(forKey: UnitLayer.focusActionOriginalKey)
            self.focusNodeOriginal?.removeFromParent()
            self.focusNodeOriginal = nil
        }

        if self.focusNodeAlternate != nil {
            self.focusNodeAlternate?.removeAction(forKey: UnitLayer.focusActionAlternateKey)
            self.focusNodeAlternate?.removeFromParent()
            self.focusNodeAlternate = nil
        }
    }

    func showAttackFocus(at point: HexPoint) {

        let focusImage = ImageCache.shared.image(for: "focus-attack1")

        // original attack focus
        let originalPoint = point
        let originalAttackFocusNode = SKSpriteNode(texture: SKTexture(image: focusImage), size: UnitLayer.kTextureSize)
        originalAttackFocusNode.position = HexPoint.toScreen(hex: originalPoint)
        originalAttackFocusNode.zPosition = Globals.ZLevels.focus
        originalAttackFocusNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let atlas = self.atlasAttackFocus {

            let focusFrames = atlas.textures.map { SKTexture(image: $0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: atlas.timePerFrame))

            originalAttackFocusNode.run(focusAnimation, withKey: UnitLayer.focusAttackActionKey, completion: { })
        }

        self.attackFocusNodes.append(originalAttackFocusNode)
        self.addChild(originalAttackFocusNode)

        // alternate attack focus
        let alternatePoint = self.alternatePoint(for: point)
        let alternateAttackFocusNode = SKSpriteNode(texture: SKTexture(image: focusImage), size: UnitLayer.kTextureSize)
        alternateAttackFocusNode.position = HexPoint.toScreen(hex: alternatePoint)
        alternateAttackFocusNode.zPosition = Globals.ZLevels.focus
        alternateAttackFocusNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let atlas = self.atlasAttackFocus {

            let focusFrames = atlas.textures.map { SKTexture(image: $0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: atlas.timePerFrame))

            alternateAttackFocusNode.run(focusAnimation, withKey: UnitLayer.focusAttackActionKey, completion: { })
        }

        self.attackFocusNodes.append(alternateAttackFocusNode)
        self.addChild(alternateAttackFocusNode)
    }

    func hideAttackFocus() {

        for attackFocusNode in self.attackFocusNodes {
            attackFocusNode?.removeFromParent()
        }

        self.attackFocusNodes.removeAll()
    }

    func clearPathSpriteBuffer() {

        for sprite in self.pathSpriteBuffer {
            sprite.removeFromParent()
        }
    }

    func show(path: HexPath, for unit: AbstractUnit?) {

        var costSum: Double = 0.0
        let movementInCurrentTurn = Double(unit?.movesLeft() ?? 0)
        self.clearPathSpriteBuffer()

        guard path.count > 1 else {
            return
        }

        var isReallyMovementLeft: Bool = true

        let (firstPoint, _) = path[0]
        let (secondPoint, secondCost) = path[1]

        let isMovementLeft = movementInCurrentTurn > secondCost

        if let dir = firstPoint.direction(towards: secondPoint) {
            let textureName = "path-start-\(dir.short())"

            let pathImage = ImageCache.shared.image(for: textureName)

            let pathSprite = SKSpriteNode(texture: SKTexture(image: pathImage), size: UnitLayer.kTextureSize)
            pathSprite.position = HexPoint.toScreen(hex: firstPoint)
            pathSprite.zPosition = Globals.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)

            if !isMovementLeft {
                isReallyMovementLeft = false
            }
        }

        for index in 1..<path.count - 1 {
            let (previousPoint, _) = path[index - 1]
            let (currentPoint, currentCost) = path[index]
            let (nextPoint, _) = path[index + 1]

            costSum += currentCost
            let isMovementLeft = movementInCurrentTurn > costSum

            if let dir = currentPoint.direction(towards: previousPoint),
                let dir2 = currentPoint.direction(towards: nextPoint) {

                var textureName = "path-\(dir.short())-\(dir2.short())"
                if dir.rawValue > dir2.rawValue {
                    textureName = "path-\(dir2.short())-\(dir.short())"
                }

                if !isReallyMovementLeft {
                    textureName += "-out"
                }

                guard ImageCache.shared.exists(key: textureName) else {
                    continue
                }

                let pathImage = ImageCache.shared.image(for: textureName)

                let pathSprite = SKSpriteNode(texture: SKTexture(image: pathImage), size: UnitLayer.kTextureSize)
                pathSprite.position = HexPoint.toScreen(hex: currentPoint)
                pathSprite.zPosition = Globals.ZLevels.path
                pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                self.addChild(pathSprite)

                self.pathSpriteBuffer.append(pathSprite)
            }

            if !isMovementLeft {
                isReallyMovementLeft = false
            }
        }

        let (secondlastItem, _) = path[path.count - 2]
        let (lastPoint, lastCost) = path[path.count - 1]

        costSum += lastCost

        if let dir = lastPoint.direction(towards: secondlastItem) {
            var textureName = "path-start-\(dir.short())"

            if !isReallyMovementLeft {
                textureName += "-out"
            }

            if !ImageCache.shared.exists(key: textureName) {
                return
            }

            let pathImage = ImageCache.shared.image(for: textureName)

            let pathSprite = SKSpriteNode(texture: SKTexture(image: pathImage), size: UnitLayer.kTextureSize)
            pathSprite.position = HexPoint.toScreen(hex: lastPoint)
            pathSprite.zPosition = Globals.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)
        }
    }

    func move(unit: AbstractUnit?, on path: HexPath) {

        if let selectedUnit = unit {

            // original
            if let unitObject = self.originalUnitObject(of: selectedUnit) {

                unitObject.move(on: path)
            } else {

                // most likely foreign unit
                self.show(unit: selectedUnit, at: selectedUnit.location)

                if let unitObject = self.originalUnitObject(of: selectedUnit) {

                    unitObject.move(on: path)
                }
            }

            // alternate
            let alternatePath = HexPath(points: path.points().map { self.alternatePoint(for: $0) }, costs: path.costs)
            let alternatePoint = self.alternatePoint(for: selectedUnit.location)
            if let unitObject = self.alternateUnitObject(of: selectedUnit) {

                unitObject.move(on: alternatePath)
            } else {

                // most likely foreign unit
                self.show(unit: selectedUnit, at: alternatePoint)

                if let unitObject = self.alternateUnitObject(of: selectedUnit) {

                    unitObject.move(on: alternatePath)
                }
            }
        }
    }

    func update(unit: AbstractUnit?) {

        if let unitObject = self.originalUnitObject(of: unit) {

            if unit?.isDelayedDeath() ?? false {
                unitObject.hide(at: unit?.location ?? .invalid)
            }

            unitObject.update()
        }

        if let unitObject = self.alternateUnitObject(of: unit) {

            if unit?.isDelayedDeath() ?? false {
                unitObject.hide(at: unit?.location ?? .invalid)
            }

            unitObject.update()
        }
    }

    func checkDelayedDeath() {

        for unitObject in self.unitObjects where unitObject.unit?.isDelayedDeath() ?? false {
            self.hide(unit: unitObject.unit, at: unitObject.unit?.location ?? HexPoint.invalid)
        }

        for unitObject in self.unitObjects {

            if case .hide(location: _) = unitObject.animationQueue.peek() {
                unitObject.sprite.removeFromParent()
                self.unitObjects.removeAll(where: { $0.identifier == unitObject.identifier })
            }
        }

        for unitObject in self.unitObjects {

            if unitObject.unit?.healthPoints() ?? 0 <= 0 {
                unitObject.unit?.startDelayedDeath()
            }

            if unitObject.shouldBeRemoved() || unitObject.unit?.isDelayedDeath() ?? false {
                unitObject.sprite.removeFromParent()
                self.unitObjects.removeAll(where: { $0.identifier == unitObject.identifier })
            }
        }
    }
}

extension UnitLayer: UnitObjectDelegate {

    func clearFocus() {

        self.hideFocus()
        self.hideAttackFocus()
    }
}
