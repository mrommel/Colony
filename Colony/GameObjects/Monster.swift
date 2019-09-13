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
        super.init(with: identifier, type: .monster, at: point, spriteName: "tile004", anchorPoint: CGPoint(x: 0.0, y: 0.2), civilization: nil, sight: 1)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "monster", textures: ["tile004", "tile005", "tile006", "tile007"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "monster", textures: ["tile000", "tile001", "tile002", "tile003"])
        self.atlasUp = GameObjectAtlas(atlasName: "monster", textures: ["tile012", "tile013", "tile014", "tile015"])
        self.atlasLeft = GameObjectAtlas(atlasName: "monster", textures: ["tile004", "tile005", "tile006", "tile007"])
        self.atlasRight = GameObjectAtlas(atlasName: "monster", textures: ["tile008", "tile009", "tile010", "tile011"])
        
        self.canMoveByUserInput = false
        self.movementType = .swimOcean
        
        self.showUnitStrengthIndicator()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    // game AI
    
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
        possibleTargets = possibleTargets.filter({ $0.identifier != self.identifier }) // remove self from target list
        
        if possibleTargets.isEmpty {
            
            // no real target - find neighboring water tile
            let waterNeighbors = game.neighborsInWater(of: self.position)
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
            
            // ambush unit
            unit.state = AIUnitState.ambushedState(by: self.identifier)
            
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
}
