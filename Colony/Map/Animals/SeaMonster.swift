//
//  SeaMonster.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class SeaMonster: Animal {

    // MARK: constructors
    
    init(position: HexPoint) {
        super.init(position: position, animalType: .monster)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func createGameObject() -> GameObject? {

        let gameObject = SeaMonsterObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
    
    // MARK: AI handling
    
    override func handleBeganState(in game: Game?) {
        assert(self.state.transitioning == .began, "method can only handle .begin")
        
        switch self.state.state {
            
        case .idle:
            self.handleIdle(in: game)
            
        case .wanderAround:
            self.handleWanderAround(in: game)
            
        case .following:
            self.handleFollowing(in: game)
            
        case .battling:
            self.handleBattling(in: game)
            
        case .ambushed:
            self.handleAmbushed(in: game)
            
        case .fleeing:
            fatalError("[Monster] handle began fleeing")
        
        case .traveling:
            fatalError("[Monster] handle began traveling")
        }
    }
    
    override func handleEndedState(in game: Game?) {
        
        assert(self.state.transitioning == .ended, "method can only handle .ended")
        
        switch self.state.state {
            
        case .idle:
            self.state.transitioning = .began // re-start with same state
            
        case .wanderAround:
            self.state = AIUnitState.idleState()
            
        case .following:
            self.state.transitioning = .began // re-start with same state
            
        case .battling:
            fatalError("[Monster] handle ended battling")
            
        case .ambushed:
            self.state = AIUnitState.idleState()
            
        case .fleeing:
            fatalError("[Monster] handle ended fleeing")
            
        case .traveling:
            fatalError("[Monster] handle ended traveling")
        }
    }
    
    // worker
    
    func handleIdle(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        // find tile that is towards a ship in sight
        let tilesInSight = self.tilesInSight()
        var possibleTargets = game.navalUnits(in: tilesInSight)
        
        if possibleTargets.isEmpty {
            
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
            
        } else {
            let target = possibleTargets.randomItem()
            self.state = AIUnitState.followingState(target: target.position)
        }
    }
    
    func handleWanderAround(in _: Game?) {
        
        if let path = self.state.path {
            self.gameObject?.showWalk(on: path, completion: {})
        }
    }
    
    func handleFollowing(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let target = self.state.target else {
            fatalError("target not set")
        }
        
        let units = game.getUnits(at: target)
        if let unitRef = units.first, let unit = unitRef {
            
            if unit.position == self.position {
                // battle
                self.state = AIUnitState.battlingState(with: unit.position)
            } else if unit.position.distance(to: self.position) > 1 /*self.sight*/ {
                // lost sight (out of reach)
                self.state = AIUnitState.idleState()
            } else {
                // move towards - keep state
                self.stepOnWater(towards: unit.position, in: game)
            }
        } else {
            // lost target - target does not exist anymore (moved or killed)
            self.state = AIUnitState.idleState()
        }
    }
    
    func handleBattling(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let target = self.state.target else {
            fatalError("target position not set")
        }
        
        let units = game.getUnits(at: target)
        if let unitRef = units.first, let unit = unitRef {
            
            // ambush unit
            unit.state = AIUnitState.ambushedState(by: self.position)
            
            // animals can cause no battles between units and animals
            // self.gameObject?.delegate?.battle(between: self, and: unit)
        }
    }
    
    /// sea monster is attacked by someone
    func handleAmbushed(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let attacker = self.state.target else {
            fatalError("attacker position not set")
        }
        
        let units = game.getUnits(at: attacker)
        if let attackerRef = units.first, let attacker = attackerRef {
            
            fatalError("not implemented")
            //self.gameObject?.delegate?.ambushed(self, by: attacker)
        }
    }
}
