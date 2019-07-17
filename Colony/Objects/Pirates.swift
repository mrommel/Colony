//
//  Pirates.swift
//  Colony
//
//  Created by Michael Rommel on 07.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Pirates: GameObject {
    
    init(with identifier: String, at point: HexPoint) {
        super.init(with: identifier, type: .pirates, at: point, spriteName: "pirate003", anchorPoint: CGPoint(x: 0.0, y: 0.0), tribe: .enemy, sight: 2)
        
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
            
            // find neighbor water tile
            let waterNeighbors = self.position.neighbors().filter({ map.tile(at: $0)?.isWater ?? false })
            
            // FIXME: find tile that is towards the ship
            var bestWaterNeighbor = waterNeighbors.first!
            var bestDistance: Int = Int.max
            guard let enemyPosition = game?.level?.gameObjectManager.selected?.position else {
                return
            }
            
            for waterNeighbor in waterNeighbors {
                let neighborDistance = waterNeighbor.distance(to: enemyPosition) + Int.random(number: 2)
                if neighborDistance < bestDistance {
                    bestWaterNeighbor = waterNeighbor
                    bestDistance = neighborDistance
                }
            }

            let pathFinder = AStarPathfinder()
            pathFinder.dataSource =  map.pathfinderDataSource(with: gameObjectManager, movementType: self.movementType, ignoreSight: true)
            
            if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
                self.walk(on: path)
            }
        }
    }
}
