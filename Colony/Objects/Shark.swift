//
//  Shark.swift
//  Colony
//
//  Created by Michael Rommel on 10.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Shark: GameObject {
    
    init(at point: HexPoint) {
        
        let identifier = UUID()
        let identifierString = "shark-\(identifier.uuidString)"
        
        super.init(with: identifierString, type: .animal, at: point, spriteName: "shark-down-0", anchorPoint: CGPoint(x: 0.0, y: 0.0), tribe: .decoration, sight: 1)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "shark", textures: ["shark-left-0", "shark-left-1", "shark-left-2", "shark-left-3", "shark-left-4", "shark-left-5", "shark-left-6", "shark-left-7", "shark-left-8", "shark-left-9"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "shark", textures: ["shark-down-0", "shark-down-1", "shark-down-2", "shark-down-3", "shark-down-4", "shark-down-5", "shark-down-6", "shark-down-7", "shark-down-8", "shark-down-9"])
        self.atlasUp = GameObjectAtlas(atlasName: "shark", textures: ["shark-up-0", "shark-up-1", "shark-up-2", "shark-up-3", "shark-up-4", "shark-up-5", "shark-up-6", "shark-up-7", "shark-up-8", "shark-up-9"])
        self.atlasLeft = GameObjectAtlas(atlasName: "shark", textures: ["shark-left-0", "shark-left-1", "shark-left-2", "shark-left-3", "shark-left-4", "shark-left-5", "shark-left-6", "shark-left-7", "shark-left-8", "shark-left-9"])
        self.atlasRight = GameObjectAtlas(atlasName: "shark", textures: ["shark-right-0", "shark-right-1", "shark-right-2", "shark-right-3", "shark-right-4", "shark-right-5", "shark-right-6", "shark-right-7", "shark-right-8", "shark-right-9"])

        self.set(zPosition: GameScene.Constants.ZLevels.underwater)
        self.animationSpeed = 3.5
        
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
            let waterNeighbors = self.position.neighbors().filter({ map.tile(at: $0)?.isWater ?? false })
            let bestWaterNeighbor = waterNeighbors.randomItem()
            
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource =  map.pathfinderDataSource(with: self.movementType, ignoreSight: true)
            
            if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
                self.walk(on: path)
            }
        }
    }
}
