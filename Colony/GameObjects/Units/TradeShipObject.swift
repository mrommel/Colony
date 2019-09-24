//
//  TradeShip.swift
//  Colony
//
//  Created by Michael Rommel on 18.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class TradeShipObject: GameObject {

    init(for unit: Unit?) {
           
        let identifier = UUID()
        let identifierString = "trader-\(identifier.uuidString)"

        super.init(with: identifierString, unit: unit, spriteName: "pirate003", anchorPoint: CGPoint(x: 0.0, y: 0.0))

        self.atlasIdle = GameObjectAtlas(atlasName: "pirates", textures: ["pirate003", "pirate004", "pirate005"])

        self.atlasDown = GameObjectAtlas(atlasName: "pirates", textures: ["pirate000", "pirate001", "pirate002"])
        self.atlasUp = GameObjectAtlas(atlasName: "pirates", textures: ["pirate009", "pirate010", "pirate011"])
        self.atlasLeft = GameObjectAtlas(atlasName: "pirates", textures: ["pirate003", "pirate004", "pirate005"])
        self.atlasRight = GameObjectAtlas(atlasName: "pirates", textures: ["pirate006", "pirate007", "pirate008"])

        self.canMoveByUserInput = false

        self.showUnitTypeIndicator()
        self.showUnitStrengthIndicator()
    }
    
    /*override func handleBeganState(in game: Game?) {
        
        assert(self.state.transitioning == .began, "method can only handle .begin")
        
        switch self.state.state {
            
        case .idle:
            self.handleIdle(in: game)
            
        case .wanderAround:
            self.handleWanderAround(in: game)
            
        case .following:
            fatalError("[TradeShip] handle began following")
            
        case .battling:
            fatalError("[TradeShip] handle began battling")
            
        case .ambushed:
            self.handleAmbushed(in: game)
            
        case .fleeing:
            fatalError("[TradeShip] handle began fleeing")
            
        case .traveling:
            self.handleTraveling(in: game)
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
            fatalError("[TradeShip] handle ended following")
            
        case .battling:
            fatalError("[TradeShip] handle ended battling")
            
        case .ambushed:
            self.state = AIUnitState.idleState()
            
        case .fleeing:
            fatalError("[TradeShip] handle ended fleeing")
            
        case .traveling:
            self.state = AIUnitState.idleState()
            // FIXME: do trade with city 
        }
    }
    
    // worker
    
    func handleIdle(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let ocean = game.ocean(at: self.position) else {
            fatalError("trade ship not at an ocean")
        }
        
        let listOfPossibleDestinations = game.getCoastalCities(at: ocean)
        
        if listOfPossibleDestinations.count >= 2 {
            let newCityDestination = listOfPossibleDestinations.randomItem()
            let newCityObject = game.getCityObject(at: newCityDestination.position)
            //let newDestination = game.neighborsInWater(of: newCityDestination.position).randomItem()
        
            self.state = AIUnitState.travelingState(to: newCityObject?.identifier)
        } else {
            // wander randomly
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
        }
    }
    
    func handleWanderAround(in _: Game?) {
        
        guard let path = self.state.path else {
            fatalError("path not set")
        }
        
        self.walk(on: path)
    }
    
    func handleTraveling(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let cityIdentifier = self.state.targetIdentifier else {
            fatalError("target identifier not set")
        }
        
        guard let cityObject = game.getCityObject(identifier: cityIdentifier) else {
            fatalError("target identifier not a city")
        }
        
        let waterNeighbors = game.neighborsInWater(of: cityObject.position)
        
        if waterNeighbors.isEmpty {
            // fallback
            self.state = AIUnitState.idleState()
            return
        }
        
        let bestWaterNeighbor = waterNeighbors.randomItem()
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = game.pathfinderDataSource(for: self.movementType, ignoreSight: true)
        
        guard let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) else {
            fatalError("no path found")
        }

        self.walk(on: path)
    }
    
    func handleAmbushed(in game: Game?) {
        
        guard let game = game else {
            return
        }
        
        guard let attackerIdentifier = self.state.targetIdentifier else {
            fatalError("attacker identifier not set")
        }
        
        guard let attacker = game.getUnitBy(identifier: attackerIdentifier) else {
            //fatalError("Can't get attacker unit")
            print("[TradeShip] Can't get attacker unit => maybe dead?")
            return
        }
        
        guard attacker.civilization != self.civilization else {
            fatalError("Can't have a fight between units of same civilization")
        }
        
        // automatic battle?
        guard let currentUser = userUsecase?.currentUser() else {
            fatalError("Can't get current user")
        }
        
        if attacker.civilization == self.civilization {
            fatalError("attacker can't attack tradeship of same civ")
        }
        
        if currentUser.civilization == attacker.civilization  {
            //let battleResult = GameObject.battle(between: attacker, and: self, attackType: .active, real: false, in: game)
            // FIXME: battle - user attacks trade ship
            //self.delegate?.
            print("[TradeShip] uah - I'm beeing attacked")
        } else {
            self.delegate?.ambushed(self, by: attacker) //
        }
    }*/
}
