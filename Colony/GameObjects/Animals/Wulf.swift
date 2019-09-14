//
//  Wulf.swift
//  Colony
//
//  Created by Michael Rommel on 30.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Wulf: GameObject {
    
    init(at point: HexPoint) {
        
        let identifier = UUID()
        let identifierString = "wulf-\(identifier.uuidString)"
        
        super.init(with: identifierString, type: .animal, at: point, spriteName: "wulf-left-0", anchorPoint: CGPoint(x: 0.0, y: 0.0), civilization: nil, sight: 1)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-left-0"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-down-0", "wulf-down-1", "wulf-down-2", "wulf-down-3", "wulf-down-4", "wulf-down-5", "wulf-down-6", "wulf-down-7", "wulf-down-8", "wulf-down-9"])
        self.atlasUp = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-up-0", "wulf-up-1", "wulf-up-2", "wulf-up-3", "wulf-up-4", "wulf-up-5", "wulf-up-6", "wulf-up-7", "wulf-up-8", "wulf-up-9"])
        self.atlasLeft = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-left-0", "wulf-left-1", "wulf-left-2", "wulf-left-3", "wulf-left-4", "wulf-left-5", "wulf-left-6", "wulf-left-7", "wulf-left-8", "wulf-left-9"])
        self.atlasRight = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-right-0", "wulf-right-1", "wulf-right-2", "wulf-right-3", "wulf-right-4", "wulf-right-5", "wulf-right-6", "wulf-right-7", "wulf-right-8", "wulf-right-9"])
        
        self.set(zPosition: GameScene.Constants.ZLevels.featureUpper)
        self.animationSpeed = 2.5
        
        self.canMoveByUserInput = false
        self.movementType = .walk
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
            fatalError("[Wulf] handle began following")
            
        case .battling:
            fatalError("[Wulf] handle began battling")
            
        case .ambushed:
            fatalError("[Wulf] handle began ambushed")
            
        case .fleeing:
            fatalError("[Wulf] handle began fleeing")
            
        case .traveling:
            fatalError("[Wulf] handle began traveling")
        }
    }
    
    override func handleEndedState(in game: Game?) {
        
        assert(self.state.transitioning == .ended, "method can only handle .ended")
        
        switch self.state.state {
            
        case .idle:
            self.state.transitioning = .began // re-start with same state
            
        case .wanderAround:
            self.idle()
            self.state = AIUnitState.idleState()
            
        case .following:
            fatalError("[Wulf] handle ended following")
            
        case .battling:
            fatalError("[Wulf] handle ended battling")
            
        case .ambushed:
            fatalError("[Wulf] handle ended ambushed")
            
        case .fleeing:
            fatalError("[Wulf] handle ended fleeing")
            
        case .traveling:
            fatalError("[Wulf] handle ended traveling")
        }
    }
    
    // worker
    
    func handleIdle(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        // no real target - find neighboring water tile
        let landNeighbors = game.neighborsOnLand(of: self.position)
        
        if landNeighbors.isEmpty {
            // fallback
            self.state = AIUnitState.idleState()
            return
        }
        
        let bestLandNeighbor = landNeighbors.randomItem()
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = game.pathfinderDataSource(for: self.movementType, ignoreSight: true)
        
        if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestLandNeighbor) {
            self.state = AIUnitState.wanderAroundState(on: path)
        } else {
            // fallback
            self.state = AIUnitState.idleState()
        }
    }
    
    func handleWanderAround(in _: Game?) {
        
        if let path = self.state.path {
            self.walk(on: path)
        }
    }
}
