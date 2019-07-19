//
//  TradeShip.swift
//  Colony
//
//  Created by Michael Rommel on 18.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class TradeShip: GameObject {
    
    init(with identifier: String, at point: HexPoint) {
        super.init(with: identifier, type: .tradeShip, at: point, spriteName: "pirate003", anchorPoint: CGPoint(x: 0.0, y: 0.0), tribe: .neutral, sight: 2)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "pirates", textures: ["pirate003", "pirate004", "pirate005"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "pirates", textures: ["pirate000", "pirate001", "pirate002"])
        self.atlasUp = GameObjectAtlas(atlasName: "pirates", textures: ["pirate009", "pirate010", "pirate011"])
        self.atlasLeft = GameObjectAtlas(atlasName: "pirates", textures: ["pirate003", "pirate004", "pirate005"])
        self.atlasRight = GameObjectAtlas(atlasName: "pirates", textures: ["pirate006", "pirate007", "pirate008"])
        
        self.canMoveByUserInput = false
        self.movementType = .swimOcean
        
        self.showUnitIndicator()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func update(in game: Game?) {
        
        if self.state == .idle {
            
            guard let map = game?.level?.map else {
                return
            }
            
            guard let gameObjectManager = game?.level?.gameObjectManager else {
                return
            }
            
            guard let ocean = map.ocean(at: self.position) else {
                fatalError("ship not at ocean")
            }
            
            let listOfPossibleDestinations = map.getCoastalCities(at: ocean)
            let newCityDestination = listOfPossibleDestinations.randomItem()
            let newDestination = newCityDestination.position.neighbors().filter({ map.isWater(at: $0) }).randomItem()
            
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource =  map.pathfinderDataSource(with: gameObjectManager, movementType: self.movementType, ignoreSight: true)
            
            if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: newDestination) {
                self.walk(on: path)
            } else {
                fatalError("can't find path from \(self.position) to \(newDestination)")
            }
        }
    }
}
