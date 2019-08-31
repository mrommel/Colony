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
        
        super.init(with: identifierString, type: .animal, at: point, spriteName: "shark-down-0", anchorPoint: CGPoint(x: 0.0, y: 0.0), civilization: nil, sight: 1)
        
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
    
    override func handleBeganState(in game: Game?) {
        
        assert(self.state.transitioning == .began, "method can only handle .begin")
        
        switch self.state.state {
            
        case .idle:
            self.handleIdle(in: game)
            
        case .wanderAround:
            self.handleWanderAround(in: game)
            
        case .following:
            fatalError("[Shark] handle began following")
            
        case .battling:
            fatalError("[Shark] handle began battling")
            
        case .ambushed:
            fatalError("[Shark] handle began ambushed")
            
        case .fleeing:
            fatalError("[Shark] handle began fleeing")
            
        case .traveling:
            fatalError("[Shark] handle began traveling")
        }
    }
    
    override func handleEndedState(in game: Game?) {
        
        assert(self.state.transitioning == .ended, "method can only handle .ended")
        
        switch self.state.state {
            
        case .idle:
            self.state.transitioning = .began // re-start with same state
            
        case .wanderAround:
            self.idle()
            self.state = GameObjectAIState.idleState()
            
        case .following:
            fatalError("[Shark] handle ended following")
            
        case .battling:
            fatalError("[Shark] handle ended battling")
            
        case .ambushed:
            fatalError("[Shark] handle ended ambushed")
            
        case .fleeing:
            fatalError("[Shark] handle ended fleeing")
            
        case .traveling:
            fatalError("[Shark] handle ended traveling")
        }
    }
    
    // worker
    
    func handleIdle(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        // no real target - find neighboring water tile
        let waterNeighbors = game.neighborsInWater(of: self.position)
        let bestWaterNeighbor = waterNeighbors.randomItem()
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = game.pathfinderDataSource(for: self.movementType, ignoreSight: true)
        
        if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
            self.state = GameObjectAIState.wanderAroundState(on: path)
        } else {
            // fallback
            self.state = GameObjectAIState.idleState()
        }
    }
    
    func handleWanderAround(in _: Game?) {
        
        if let path = self.state.path {
            self.walk(on: path)
        }
    }
}
