//
//  Pirates.swift
//  Colony
//
//  Created by Michael Rommel on 07.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

/*class Pirates: GameObject {

    init(with identifier: String, at point: HexPoint) {
        
        super.init(with: identifier, type: .pirates, at: point, spriteName: "pirate003", anchorPoint: CGPoint(x: 0.0, y: 0.0), civilization: .pirates, sight: 2)

        self.atlasIdle = GameObjectAtlas(atlasName: "pirates", textures: ["pirate003", "pirate004", "pirate005"])

        self.atlasDown = GameObjectAtlas(atlasName: "pirates", textures: ["pirate000", "pirate001", "pirate002"])
        self.atlasUp = GameObjectAtlas(atlasName: "pirates", textures: ["pirate009", "pirate010", "pirate011"])
        self.atlasLeft = GameObjectAtlas(atlasName: "pirates", textures: ["pirate003", "pirate004", "pirate005"])
        self.atlasRight = GameObjectAtlas(atlasName: "pirates", textures: ["pirate006", "pirate007", "pirate008"])

        self.canMoveByUserInput = false
        self.movementType = .swimOcean

        self.showUnitTypeIndicator()
        self.showUnitStrengthIndicator()
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
            self.handleFollowing(in: game)
            
        case .battling:
            self.handleBattling(in: game)
            
        case .ambushed:
            self.handleAmbushed(in: game)
            
        case .fleeing:
            fatalError("[Pirates] handle began fleeing")
            
        case .traveling:
            fatalError("[Pirates] handle began traveling")
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
            fatalError("[Pirates] handle ended battling")
            
        case .ambushed:
            self.state = AIUnitState.idleState()
            
        case .fleeing:
            fatalError("[Pirates] handle ended fleeing")
            
        case .traveling:
            fatalError("[Pirates] handle ended traveling")
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
        possibleTargets = possibleTargets.filter({ $0.identifier != self.identifier })
        
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
            pathFinder.dataSource = game.pathfinderDataSource(for: self.movementType, ignoreSight: true)
            
            if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
                self.state = AIUnitState.wanderAroundState(on: path)
            } else {
                // fallback
                self.state = AIUnitState.idleState()
            }
            
        } else {
            let target = possibleTargets.randomItem()
            self.state = AIUnitState.followingState(targetIdentifier: target.identifier)
        }
    }
    
    func handleWanderAround(in _: Game?) {
        
        if let path = self.state.path {
            self.walk(on: path)
        }
    }
    
    func handleFollowing(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let targetIdentifier = self.state.targetIdentifier else {
            fatalError("target identifier not set")
        }
        
        if let unit = game.getUnitBy(identifier: targetIdentifier) {
            
            if unit.position == self.position {
                // battle
                self.state = AIUnitState.battlingState(with: unit.identifier)
            } else if unit.position.distance(to: self.position) > self.sight {
                // lost sight (out of reach)
                 self.state = AIUnitState.idleState()
            } else {
                // move towards - keep state
                self.stepOnWater(towards: unit.position, in: game)
            }
        } else {
            // lost target - target does not exist any more (killed)
            self.state = AIUnitState.idleState()
        }
    }
    
    func handleBattling(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let targetIdentifier = self.state.targetIdentifier else {
            fatalError("target identifier not set")
        }
        
        if let unit = game.getUnitBy(identifier: targetIdentifier) {
        
            self.delegate?.battle(between: self, and: unit)
        } 
    }
    
    func handleAmbushed(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let attackerIdentifier = self.state.targetIdentifier else {
            fatalError("attacker identifier not set")
        }
        
        if let attacker = game.getUnitBy(identifier: attackerIdentifier) {
            
            self.delegate?.ambushed(self, by: attacker)
        }
    }
}*/
