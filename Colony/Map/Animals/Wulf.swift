//
//  Wulf.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Wulf: Animal {
    
    // MARK: constructors
    
    init(position: HexPoint) {
        super.init(position: position, animalType: .wulf)
    }
        
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func createGameObject() -> GameObject? {

        let gameObject = WulfObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
    
    // MARK: AI handling
    
    /*override func handleBeganState(in game: Game?) {
        
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
            self.gameObject?.showIdle()
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
        pathFinder.dataSource = game.pathfinderDataSource(for: self.animalType.movementType, ignoreSight: true)
        
        if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestLandNeighbor) {
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
