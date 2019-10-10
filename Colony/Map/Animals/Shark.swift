//
//  Shark.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Shark: Animal {
    
    // MARK: constructors
    
    init(position: HexPoint) {
        super.init(position: position, animalType: .shark)
    }
        
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    // MARK: AI handling
    
    override func createGameObject() -> GameObject? {

        let gameObject = SharkObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
    
    /*override func handleBeganState(in game: Game?) {
        
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
            self.gameObject?.showIdle()
            self.state = AIUnitState.idleState()
            
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
        
        if waterNeighbors.isEmpty {
            // fallback
            self.state = AIUnitState.idleState()
            return
        }
        
        let bestWaterNeighbor = waterNeighbors.randomItem()
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = game.pathfinderDataSource(for: self.animalType.movementType, ignoreSight: true)
        
        if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
            self.state = AIUnitState.wanderAroundState(on: path)
        } else {
            // fallback
            self.state = AIUnitState.idleState()
        }
    }
    
    func handleWanderAround(in _: Game?) {
        
        self.state.transitioning = .running
        
        if let path = self.state.path {
            self.gameObject?.showWalk(on: path, completion: {
                self.state.transitioning = .ended
            })
        }
    }*/
}
