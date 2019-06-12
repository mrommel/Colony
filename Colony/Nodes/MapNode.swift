//
//  MapNode.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

// TOOD move
enum MonsterGameConditionType: GameConditionType {

    case villageReached
    case monsterCaughtShip
}

class MonsterCheck: GameConditionCheck {

    public var gameObjectManager: GameObjectManager?
    var map: HexagonTileMap?

    init(on map: HexagonTileMap?) {
        self.map = map
    }

    func isWon() -> GameConditionType? {

        guard let playerUnits = self.gameObjectManager?.unitsOf(tribe: .player) else {
            fatalError("no player units")
        }

        guard playerUnits.count == 2 else {
            return nil
        }

        if let position0 = playerUnits[0]?.position, let position1 = playerUnits[1]?.position {

            if position0.distance(to: position1) == 1 {
                return MonsterGameConditionType.villageReached
            }
        }

        return nil
    }

    func isLost() -> GameConditionType? {

        guard let enemyUnits = self.gameObjectManager?.unitsOf(tribe: .enemy) else {
            fatalError("no enemy units")
        }

        guard let playerUnits = self.gameObjectManager?.unitsOf(tribe: .player) else {
            fatalError("no player units")
        }

        for enemyUnit in enemyUnits {
            for playerUnit in playerUnits {
                if enemyUnit?.position == playerUnit?.position {
                    return MonsterGameConditionType.monsterCaughtShip
                }
            }
        }

        return nil
    }
}

class MapNode: SKNode {

    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer

    // MARK: objects
    var monster: Monster
    var ship: Ship
    var village: Village

    // MARK: map

    let mapDisplay = HexMapDisplay()
    private var map: HexagonTileMap?
    var gameObjectManager: GameObjectManager

    init(with size: CGSize, map: HexagonTileMap?) {

        self.map = map

        let startPositionFinder = StartPositionFinder(map: self.map)
        let startPositions = startPositionFinder.identifyStartPositions()

        self.gameObjectManager = GameObjectManager(on: self.map)
        self.monster = Monster(with: "monster", at: startPositions.monsterPosition, mapDisplay: self.mapDisplay, tribe: .enemy)
        self.gameObjectManager.add(object: self.monster)
        self.ship = Ship(with: "ship", at: startPositions.playerPosition, mapDisplay: self.mapDisplay, tribe: .player)
        self.gameObjectManager.add(object: self.ship)
        self.village = Village(with: "village", at: startPositions.villagePosition, mapDisplay: self.mapDisplay, tribe: .player)
        self.gameObjectManager.add(object: self.village)

        self.terrainLayer = TerrainLayer(with: size, and: mapDisplay)
        self.terrainLayer.populate(with: self.map)

        self.featureLayer = FeatureLayer(with: size, and: mapDisplay)
        self.featureLayer.populate(with: self.map)

        self.boardLayer = BoardLayer(with: size, and: mapDisplay)
        self.boardLayer.populate(with: self.map)

        self.riverLayer = RiverLayer(with: size, and: mapDisplay)
        self.riverLayer.populate(with: self.map)

        super.init()

        self.gameObjectManager.conditionCheck = MonsterCheck(on: self.map)
        /*if let scene = self.scene as? GameScene {
            self.gameObjectManager.conditionDelegate = scene
        }*/

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)

        self.addChild(self.monster.sprite)
        self.monster.idle()

        self.addChild(self.ship.sprite)
        self.ship.idle()

        self.addChild(self.village.sprite)
        self.village.idle()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // Change `2.0` to the desired number of seconds.
            let path = startPositionFinder.findPatrolPath(from: startPositions.monsterPosition)
            self.monster.walk(on: path)
        }
    }

    func moveShip(to hex: HexPoint) {
        if let path = self.findPathFrom(from: self.ship.position, to: hex) {
            self.ship.walk(on: path)
            return
        }
    }

    func findPathFrom(from: HexPoint, to: HexPoint) -> [HexPoint]? {

        if self.map?.valid(point: to) ?? false {
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource = map?.oceanPathfinderDataSource
            return pathFinder.shortestPath(fromTileCoord: from, toTileCoord: to)
        } else {
            return nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
