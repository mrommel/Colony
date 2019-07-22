//
//  Pirates.swift
//  Colony
//
//  Created by Michael Rommel on 07.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Pirates: GameObject {
    
    var target: GameObject? = nil
    
    init(with identifier: String, at point: HexPoint) {
        super.init(with: identifier, type: .pirates, at: point, spriteName: "pirate003", anchorPoint: CGPoint(x: 0.0, y: 0.0), civilization: .pirates, sight: 2)
        
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
            
            guard let game = game else {
                return
            }

            // find tile that is towards a ship in sight
            let tilesInSight = self.tilesInSight()
            var possibleTargets = game.navalUnits(in: tilesInSight)
            possibleTargets = possibleTargets.filter({ $0.identifier != self.identifier})
            
            if possibleTargets.isEmpty {
                // find neighbor water tile
                let waterNeighbors = game.neighborsInWater(of: self.position)
                let target = waterNeighbors.randomItem()
                
                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = game.pathfinderDataSource(for: self.movementType, ignoreSight: true)
                
                if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: target) {
                    self.walk(on: path)
                }
            } else {
                let target = possibleTargets.randomItem()
                self.follow(unit: target, in: game)
            }
        }
        
        if self.state == .following {
            
            if let targetPosition = self.target?.position {
                
                // is target still in sight
                if self.position.distance(to: targetPosition) <= self.sight {
                    self.idle()
                    return
                }
                
                self.step(towards: targetPosition, in: game)
            }
        }
    }
    
    func follow(unit: GameObject?, in game: Game?) {
        
        self.target = unit
        self.state = .following
        
        if let targetPosition = self.target?.position {
            self.step(towards: targetPosition, in: game)
        }
    }
    
    func step(towards point: HexPoint, in game: Game?) {
        
        guard let waterNeighbors = game?.neighborsInWater(of: point) else {
            return
        }
        
        var bestWaterNeighbor = waterNeighbors.first!
        var bestDistance: Int = Int.max

        for waterNeighbor in waterNeighbors {
            let neighborDistance = waterNeighbor.distance(to: point) + Int.random(number: 2)
            if neighborDistance < bestDistance {
                bestWaterNeighbor = waterNeighbor
                bestDistance = neighborDistance
            }
        }

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = game?.pathfinderDataSource(for: self.movementType, ignoreSight: true)
        
        if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
            self.followUnit(on: path)
        }
    }
}
