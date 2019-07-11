//
//  Monster.swift
//  Colony
//
//  Created by Michael Rommel on 30.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Monster: GameObject {
    
    init(with identifier: String, at point: HexPoint) {
        super.init(with: identifier, type: .monster, at: point, spriteName: "tile004", tribe: .enemy, sight: 1)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "monster", textures: ["tile004", "tile005", "tile006", "tile007"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "monster", textures: ["tile000", "tile001", "tile002", "tile003"])
        self.atlasUp = GameObjectAtlas(atlasName: "monster", textures: ["tile012", "tile013", "tile014", "tile015"])
        self.atlasLeft = GameObjectAtlas(atlasName: "monster", textures: ["tile004", "tile005", "tile006", "tile007"])
        self.atlasRight = GameObjectAtlas(atlasName: "monster", textures: ["tile008", "tile009", "tile010", "tile011"])
        
        self.sprite.anchorPoint = CGPoint(x: 0.0, y: 0.2)
        
        self.canMoveByUserInput = false
        self.movementType = .swimOcean
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func update(in game: Game?) {
        
        if self.state == .idle {
            
            guard let map = game?.level?.map else {
                return
            }
            
            // find neighbor water tile
            let waterNeighbors = self.position.neighbors().filter({ map.tile(at: $0)?.water ?? false })
            
            // FIXME: find tile that is towards the ship
            var bestWaterNeighbor = waterNeighbors.first!
            var bestDistance: Int = Int.max
            guard let enemyPosition = game?.level?.gameObjectManager.selected?.position else {
                return
            }
            
            for waterNeighbor in waterNeighbors {
                
                // monsters avoid to go near the coast, so we add a penalty for shore tiles
                let shorePenalty = game?.level?.map.terrain(at: waterNeighbor) == .shore ? 2 : 0
                
                // make it a bit unforeseen
                let randomPenalty = Int.random(number: 2) // 0..1
                
                let neighborDistance = waterNeighbor.distance(to: enemyPosition) + shorePenalty + randomPenalty
                
                if neighborDistance < bestDistance {
                    bestWaterNeighbor = waterNeighbor
                    bestDistance = neighborDistance
                }
            }
            //let waterNeighbor = waterNeighbors.randomItem()
            
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource =  map.pathfinderDataSource(with: self.movementType, ignoreSight: true)
            
            if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
                self.walk(on: path)
            }
        }
    }
}
