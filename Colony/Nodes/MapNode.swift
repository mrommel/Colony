//
//  MapNode.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MapNode: SKNode {

    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer

    // MARK: objects
    //var monster: Monster
    //var ship: Ship
    //var village: Village

    // MARK: map

    private var map: HexagonTileMap?
    var gameObjectManager: GameObjectManager

    /*init(with map: HexagonTileMap?) {

        self.map = map

        let startPositionFinder = StartPositionFinder(map: self.map)
        let startPositions = startPositionFinder.identifyStartPositions()

        self.gameObjectManager = GameObjectManager(on: self.map)

        let monster = Monster(with: "monster", at: startPositions.monsterPosition, tribe: .enemy)
        self.gameObjectManager.add(object: monster)
        let ship = Ship(with: "ship", at: startPositions.playerPosition, tribe: .player)
        self.gameObjectManager.add(object: ship)
        let village = Village(with: "village", at: startPositions.villagePosition, tribe: .player)
        self.gameObjectManager.add(object: village)

        self.terrainLayer = TerrainLayer()
        self.terrainLayer.populate(with: self.map)

        self.featureLayer = FeatureLayer()
        self.featureLayer.populate(with: self.map)

        self.boardLayer = BoardLayer()
        self.boardLayer.populate(with: self.map)

        self.riverLayer = RiverLayer()
        self.riverLayer.populate(with: self.map)

        super.init()

        //self.gameObjectManager.add(conditionCheck: MonsterCheck())

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)

        self.addChild(monster.sprite)
        monster.idle()

        self.addChild(ship.sprite)
        ship.idle()

        self.addChild(village.sprite)
        village.idle()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // Change `2.0` to the desired number of seconds.
            let path = startPositionFinder.findPatrolPath(from: startPositions.monsterPosition)
            monster.walk(on: path)
        }
    }*/

    init(with level: Level) {

        self.map = level.map
        self.gameObjectManager = level.gameObjectManager
        self.gameObjectManager.map = self.map

        // TODO: make objects generic

        self.terrainLayer = TerrainLayer()
        self.terrainLayer.populate(with: self.map)

        self.featureLayer = FeatureLayer()
        self.featureLayer.populate(with: self.map)

        self.boardLayer = BoardLayer()
        self.boardLayer.populate(with: self.map)

        self.riverLayer = RiverLayer()
        self.riverLayer.populate(with: self.map)

        super.init()

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)

        for unit in self.gameObjectManager.objects {
            if let unit = unit {
                self.addChild(unit.sprite)
                unit.idle()
            }
        }

        level.gameObjectManager.gameObjectUnitDelegates.addDelegate(self)

        /*DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // Change `2.0` to the desired number of seconds.
            let path = startPositionFinder.findPatrolPath(from: startPositions.monsterPosition)
            self.monster.walk(on: path)
        }*/
    }

    func moveShip(to hex: HexPoint) {

        // find ship AKA current unit
        if let ship = self.gameObjectManager.unitBy(identifier: "ship") {

            if let path = self.findPathFrom(from: ship.position, to: hex) {
                ship.walk(on: path)
                return
            }
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

extension MapNode: GameObjectUnitDelegate {
    
    func selectedGameObjectChanged(to gameObject: GameObject?) {
        // NOOP
    }
    
    func removed(gameObject: GameObject?) {
        gameObject?.sprite.removeFromParent()
        //self.rem.addChild(unit.sprite)
    }
}
