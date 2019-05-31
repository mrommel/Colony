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
    var monster: Monster
    var ship: Ship

    // MARK: map

    let mapDisplay = HexMapDisplay()
    let map: HexagonTileMap

    init(with size: CGSize) {

        //self.map = HexagonTileMap(with: size)
        //self.map.set(terrain: .grass, at: HexPoint(x: 1, y: 1))

        let options = MapGeneratorOptions(withSize: .standard, zone: .earth, waterPercentage: 0.30, rivers: 4)

        let generator = MapGenerator(width: Int(size.width), height: Int(size.height))
        self.map = generator.generate(with: options)!

        self.terrainLayer = TerrainLayer(with: size, and: mapDisplay)
        self.terrainLayer.populate(with: self.map)

        self.featureLayer = FeatureLayer(with: size, and: mapDisplay)
        self.featureLayer.populate(with: self.map)

        self.boardLayer = BoardLayer(with: size, and: mapDisplay)
        self.boardLayer.populate(with: self.map)
        
        self.riverLayer = RiverLayer(with: size, and: mapDisplay)
        self.riverLayer.populate(with: self.map)
        
        self.monster = Monster(with: "monster", at: HexPoint(x: 1, y: 1), mapDisplay: self.mapDisplay)
        self.ship = Ship(with: "ship", at: HexPoint(x: 4, y: 3), mapDisplay: self.mapDisplay)

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
            let path = [HexPoint(x: 1, y: 2), HexPoint(x: 2, y: 2), HexPoint(x: 2, y: 3), HexPoint(x: 1, y: 3), HexPoint(x: 0, y: 2), HexPoint(x: 1, y: 1)]
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
        
        if self.map.valid(point: to) {
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource = map.oceanPathfinderDataSource
            return pathFinder.shortestPath(fromTileCoord: from, toTileCoord: to)
        } else {
            return nil
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
