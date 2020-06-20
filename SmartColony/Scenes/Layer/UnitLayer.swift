//
//  UnitLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 06.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class UnitLayer: SKNode {

    static let focusActionKey: String = "focusActionKey"

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    private var unitObjects: [UnitObject]

    // focus
    private var focusNode: SKSpriteNode?
    private var atlasFocus: GameObjectAtlas?

    // path
    private var pathSpriteBuffer: [SKSpriteNode] = []

    init(player: AbstractPlayer?) {

        self.player = player
        self.unitObjects = []

        self.atlasFocus = GameObjectAtlas(atlasName: "focus", textures: ["focus1", "focus2", "focus3", "focus4", "focus5", "focus6", "focus6", "focus5", "focus4", "focus3", "focus2", "focus1"])

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

                self.show(unit: unitRef)
            }
        }
    }

    func show(unit: AbstractUnit?) {

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
        if self.unitObject(of: unit) != nil {
            //print("already shown")
            return
        }
        
        let unitObject = UnitObject(unit: unit, in: self.gameModel)

        // add to canvas
        unitObject.addTo(node: self)

        // make idle
        unitObject.showIdle()

        // keep reference
        self.unitObjects.append(unitObject)
    }

    func hide(unit: AbstractUnit?) {

        if let unitObject = self.unitObject(of: unit) {

            unitObject.sprite.removeFromParent()

            self.unitObjects.removeAll(where: { $0.identifier == unitObject.identifier })
        }
    }

    private func unitObject(at location: HexPoint) -> UnitObject? {

        for object in self.unitObjects {
            if object.unit?.location == location {
                return object
            }
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

        let texture = SKTexture(imageNamed: "focus1")
        self.focusNode = SKSpriteNode(texture: texture)
        self.focusNode?.position = HexPoint.toScreen(hex: unit.location)
        self.focusNode?.zPosition = Globals.ZLevels.focus
        self.focusNode?.anchorPoint = CGPoint(x: 0.0, y: 0.0)

        if let atlas = self.atlasFocus {

            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let focusFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: 2.0 / Double(focusFrames.count)))

            self.focusNode?.run(focusAnimation, withKey: UnitLayer.focusActionKey, completion: { })
        }

        if let focusNode = self.focusNode {
            self.addChild(focusNode)
        }
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
            var textureName = "path-start-\(dir.short())"

            if !isReallyMovementLeft {
                textureName = textureName + "-out"
            }

            let pathSprite = SKSpriteNode(imageNamed: textureName)
            pathSprite.position = HexPoint.toScreen(hex: firstPoint)
            pathSprite.zPosition = Globals.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)

            if !isMovementLeft {
                isReallyMovementLeft = false
            }
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

                if !isReallyMovementLeft {
                    textureName = textureName + "-out"
                }

                let pathSprite = SKSpriteNode(imageNamed: textureName)
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

        costSum = costSum + lastCost

        if let dir = lastPoint.direction(towards: secondlastItem) {
            var textureName = "path-start-\(dir.short())"

            if !isReallyMovementLeft {
                textureName = textureName + "-out"
            }

            let pathSprite = SKSpriteNode(imageNamed: textureName)
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

            // unit should show (is in city?)
            /*if let existingUnit = unitObject(of: selectedUnit) {
                print("existing")
            }*/
            
            if unitObject(of: selectedUnit) == nil {
                self.show(unit: selectedUnit)
                print("show")
            }
            
            if let unitObject = self.unitObject(at: selectedUnit.location) {

                if gameModel.valid(point: hex) {

                    let pathFinder = AStarPathfinder()

                    pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: selectedUnit.movementType(), for: selectedUnit.player)

                    if let path = pathFinder.shortestPath(fromTileCoord: selectedUnit.location, toTileCoord: hex) {

                        unitObject.showWalk(on: path, completion: {
                            unitObject.showIdle()
                        })

                        return
                    }
                }
            }
        }
    }

    func move(unit: AbstractUnit?, on path: HexPath) {

        if let selectedUnit = unit {

            guard let unitObject = self.unitObject(of: selectedUnit) else {
                //fatalError("cant get unitObject")
                // most likely foreign unit
                self.show(unit: selectedUnit)
                print("show")
                return
            }

            unitObject.showWalk(on: path, completion: {
                unitObject.showIdle()
            })
        }
    }
}
