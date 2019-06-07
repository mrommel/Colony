//
//  MapNode.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MapNode: SKNode {

    //
    
    var fogManager: FogManager? = nil
    
    // MARK: layer

    var terrainLayer: TerrainLayer
    var featureLayer: FeatureLayer
    var boardLayer: BoardLayer
    var riverLayer: RiverLayer
    
    // MARK: objects
    var monster: Monster
    var ship: Ship

    // MARK: map

    let mapDisplay = HexMapDisplay()
    private var map: HexagonTileMap?

    init(with size: CGSize, map: HexagonTileMap?) {

        self.map = map
        self.fogManager = FogManager(map: self.map)
        
        let startPositionFinder = StartPositionFinder(map: self.map)
        let startPositions = startPositionFinder.identifyStartPositions()
        
        self.monster = Monster(with: "monster", at: startPositions.monsterPosition, mapDisplay: self.mapDisplay)
        self.monster.fogManager = self.fogManager
        
        self.ship = Ship(with: "ship", at: startPositions.playerPosition, mapDisplay: self.mapDisplay)
        self.ship.fogManager = self.fogManager
        
        //self.fogManager?.addSight(at: HexPoint(x: 4, y: 3), with: 2)
        
        self.terrainLayer = TerrainLayer(with: size, and: mapDisplay, fogManager: self.fogManager)
        self.terrainLayer.populate(with: self.map)

        self.featureLayer = FeatureLayer(with: size, and: mapDisplay, fogManager: self.fogManager)
        self.featureLayer.populate(with: self.map)

        self.boardLayer = BoardLayer(with: size, and: mapDisplay, fogManager: self.fogManager)
        self.boardLayer.populate(with: self.map)
        
        self.riverLayer = RiverLayer(with: size, and: mapDisplay, fogManager: self.fogManager)
        self.riverLayer.populate(with: self.map)

        super.init()

        self.addChild(self.terrainLayer)
        self.addChild(self.featureLayer)
        self.addChild(self.boardLayer)
        self.addChild(self.riverLayer)
        
        self.addChild(self.monster.sprite)
        self.monster.idle()
        
        self.addChild(self.ship.sprite)
        self.ship.idle()
        
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
