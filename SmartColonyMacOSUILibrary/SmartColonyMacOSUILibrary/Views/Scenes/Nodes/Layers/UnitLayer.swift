//
//  UnitLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class UnitLayer: SKNode {

    static let kTextureWidth: Int = 48
    static let kTextureSize: CGSize = CGSize(width: kTextureWidth, height: kTextureWidth)
    static let focusActionKey: String = "focusActionKey"
    static let focusAttackActionKey: String = "focusAttackActionKey"

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    private var unitObjects: [UnitObject]

    // focus
    private var focusNode: SKSpriteNode?
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

        // already shown, no need to add
        if let unitObject = self.unitObject(of: unit) {

            unitObject.show(at: location)
            unitObject.update()

        } else {

            let unitObject = UnitObject(unit: unit, in: self.gameModel)

            // add to canvas
            unitObject.addTo(node: self)
            unitObject.delegate = self

            // make idle
            // unitObject.showIdle()
            unitObject.show(at: location)
            unitObject.update()

            // keep reference
            self.unitObjects.append(unitObject)
        }
    }

    func hide(unit: AbstractUnit?, at location: HexPoint) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        if let unitObject = self.unitObject(of: unit) {
            unitObject.hide(at: location)
        }
    }

    func enterCity(unit: AbstractUnit?, at location: HexPoint) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        if let unitObject = self.unitObject(of: unit) {
            unitObject.enterCity(at: location)
        }
    }

    func leaveCity(unit: AbstractUnit?, at location: HexPoint) {

        self.show(unit: unit, at: location)
    }

    func fortify(unit: AbstractUnit?) {

        if let unitObject = self.unitObject(of: unit) {

            unitObject.fortify()
            // unitObject.showFortified()
        }
    }

    func attack(unit: AbstractUnit?, from source: HexPoint, towards location: HexPoint) {

        if let unitObject = self.unitObject(of: unit) {

            unitObject.attack(from: source, towards: location)
        }
    }

    func rangeAttack(unit: AbstractUnit?, from source: HexPoint, towards location: HexPoint) {

        if let unitObject = self.unitObject(of: unit) {

            unitObject.rangeAttack(from: source, towards: location)
        }
    }

    private func unitObject(at location: HexPoint) -> UnitObject? {

        for object in self.unitObjects where object.unit?.location == location {
            return object
        }

        return nil
    }

    private func unitObject(of unit: AbstractUnit?) -> UnitObject? {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        for object in self.unitObjects {
            if unit.isEqual(to: object.unit) {
                return object
            }
        }

        return nil
    }

    func showFocus(for unit: AbstractUnit?) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        if self.focusNode != nil {
            self.focusNode?.removeAction(forKey: UnitLayer.focusActionKey)
            self.focusNode?.removeFromParent()
            self.focusNode = nil
        }

        let focusImage = ImageCache.shared.image(for: "focus1")
        self.focusNode = SKSpriteNode(texture: SKTexture(image: focusImage), size: UnitLayer.kTextureSize)
        self.focusNode?.position = HexPoint.toScreen(hex: unit.location)
        self.focusNode?.zPosition = Globals.ZLevels.focus
        self.focusNode?.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let atlas = self.atlasFocus {

            let focusFrames = atlas.textures.map { SKTexture(image: $0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: atlas.timePerFrame))

            self.focusNode?.run(focusAnimation, withKey: UnitLayer.focusActionKey, completion: { })
        }

        if let focusNode = self.focusNode {
            self.addChild(focusNode)
        }
    }

    func hideAttackFocus() {

        for attackFocusNode in self.attackFocusNodes {
            attackFocusNode?.removeFromParent()
        }

        self.attackFocusNodes.removeAll()
    }

    func showAttackFocus(at point: HexPoint) {

        let focusImage = ImageCache.shared.image(for: "focus-attack1")
        let attackFocusNode = SKSpriteNode(texture: SKTexture(image: focusImage), size: UnitLayer.kTextureSize)
        attackFocusNode.position = HexPoint.toScreen(hex: point)
        attackFocusNode.zPosition = Globals.ZLevels.focus
        attackFocusNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let atlas = self.atlasAttackFocus {

            let focusFrames = atlas.textures.map { SKTexture(image: $0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: atlas.timePerFrame))

            attackFocusNode.run(focusAnimation, withKey: UnitLayer.focusAttackActionKey, completion: { })
        }

        self.attackFocusNodes.append(attackFocusNode)
        self.addChild(attackFocusNode)
    }

    func hideFocus() {

        if self.focusNode != nil {
            self.focusNode?.removeAction(forKey: UnitLayer.focusActionKey)
            self.focusNode?.removeFromParent()
            self.focusNode = nil
        }
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

            // if !isReallyMovementLeft {
            //     textureName += "-out"
            // }

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

    func move(unit: AbstractUnit?, to hex: HexPoint) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        if let selectedUnit = unit {

            if self.unitObject(of: selectedUnit) == nil {
                self.show(unit: selectedUnit, at: selectedUnit.location)
                print("show")
            }

            if let unitObject = self.unitObject(at: selectedUnit.location) {

                if gameModel.valid(point: hex) {

                    let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
                        for: selectedUnit.movementType(),
                        for: selectedUnit.player,
                        ignoreOwner: false,
                        unitMapType: selectedUnit.unitMapType(),
                        canEmbark: selectedUnit.canEverEmbark(),
                        canEnterOcean: selectedUnit.player!.canEnterOcean()
                    )
                    let pathFinder = AStarPathfinder(with: pathFinderDataSource)

                    if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.location, toTileCoord: hex) {

                        unitObject.move(on: path)
                        return
                    }
                }
            }
        }
    }

    func move(unit: AbstractUnit?, on path: HexPath) {

        if let selectedUnit = unit {

            if let unitObject = self.unitObject(of: selectedUnit) {

                unitObject.move(on: path)
            } else {

                // most likely foreign unit
                self.show(unit: selectedUnit, at: selectedUnit.location)

                if let unitObject = self.unitObject(of: selectedUnit) {

                    unitObject.move(on: path)
                }
            }
        }
    }

    func update(unit: AbstractUnit?) {

        if let unitObject = unitObject(of: unit) {

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
