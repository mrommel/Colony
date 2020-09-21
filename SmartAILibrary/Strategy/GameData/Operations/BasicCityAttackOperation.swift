//
//  BasicCityAttackOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class BasicCityAttackOperation: EnemyTerritoryOperation {

    init() {

        super.init(type: .basicCityAttack)
    }
    
    override init(type: UnitOperationType) {

        super.init(type: type)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        super.initialize(for: player, enemy: enemy, area: area, in: gameModel)
 
        self.moveType = .enemyTerritory
        self.startPosition = muster?.location

        // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
        self.army = Army(of: player, for: self, with: self.formation(in: gameModel))
        self.army?.state = .waitingForUnitsToReinforce

        if let target = target {
            
            self.targetPosition = target.location
            self.army?.goal = target.location
            self.musterPosition = muster?.location
     
            self.army?.position = muster!.location
            self.area = gameModel.area(of: muster!.location)

            // Reset our destination to be a few plots shy of the final target
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: self.player)
            
            if let path = pathFinder.shortestPath(fromTileCoord: self.musterPosition!, toTileCoord: self.targetPosition!),
                let reducedPath = path.path(without: self.deployRange()),
                let deployPoint = reducedPath.last {
                    
                self.army?.goal = deployPoint.0

                // Find the list of units we need to build before starting this operation in earnest
                self.buildListOfUnitsWeStillNeedToBuild()

                // try to get as many units as possible from existing units that are waiting around
                if self.grabUnitsFromTheReserves(at: self.musterPosition, for: self.targetPosition, in: gameModel) {
                    self.army?.state = .waitingForUnitsToCatchUp
                    self.state = .gatheringForces
                } else {
                    self.state = .recruitingUnits
                }

                //LogOperationStart();
            } else {
                self.state = .aborted(reason: .lostPath)
            }
        } else {
            // Lost our target, abort
            self.state = .aborted(reason: .lostTarget)
        }
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let handicap = gameModel.handicap
        
        return handicap > .prince ? .biggerCityAttackForce : .basicCityAttackForce // MUFORMATION_BIGGER_CITY_ATTACK_FORCE : MUFORMATION_BASIC_CITY_ATTACK_FORCE;
    }

    /// Same as default version except if just gathered forces, check to see if a better target has presented itself
    @discardableResult
    override func armyInPosition(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel,
              let enemy = self.enemy else {
            
            fatalError("cant get gameModel")
        }
        
        var stateChanged = false

        switch self.state {
        
            // If we were gathering forces, let's make sure a better target hasn't presented itself
        case .gatheringForces:
        
            // First do base case processing
            stateChanged = super.armyInPosition(in: gameModel)

            // Is target still under enemy control?
            if let targetPosition = self.targetPosition,
               let targetTile = gameModel.tile(at: targetPosition) {
                
                if !enemy.isEqual(to: targetTile.owner()) {
                    self.state = .aborted(reason: .targetAlreadyCaptured)
                }
            }

        // See if reached our target, if so give control of these units to the tactical AI
        case .movingToTarget:
        
            // Are we within tactical range of our target?
            if let centerOfMass = self.army?.centerOfMass(in: gameModel) {
                
                if centerOfMass.distance(to: self.targetPosition ?? HexPoint.invalid) <= 4 { // AI_OPERATIONAL_CITY_ATTACK_DEPLOY_RANGE
                    
                    // Notify Diplo AI we're in place for attack
                    self.player?.diplomacyAI?.updateMusteringForAttack(against: self.enemy, to: true)

                    // Notify tactical AI to focus on this area
                    let zone = TacticalAI.TemporaryZone(location: self.targetPosition!, lastTurn: gameModel.currentTurn + 5 /* AI_TACTICAL_MAP_TEMP_ZONE_TURNS */, targetType: .city)
                    self.player?.tacticalAI?.add(temporaryZone: zone)

                    self.state = .successful
                }
            }

        // In all other cases use base class version
        case .aborted(reason: _), .recruitingUnits, .atTarget:
            return super.armyInPosition(in: gameModel)
            
        default:
            // NOOP
            break
        };

        return stateChanged
    }

    /// Returns true when we should abort the operation totally (besides when we have lost all units in it)
    override func shouldAbort(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel,
              let targetPosition = self.targetPosition,
              let enemy = self.enemy else {
            fatalError("cant get gameModel")
        }
        
        // If parent says we're done, don't even check anything else
        let rtnValue = super.shouldAbort(in: gameModel)

        if !rtnValue {
            
            guard let targetTile = gameModel.tile(at: targetPosition) else {
                fatalError("cant get targetTile")
            }
            
            // See if our target city is still owned by our enemy
            if gameModel.city(at: targetPosition) == nil || !enemy.isEqual(to: targetTile.owner()) {
                // Success!  The city has been captured/destroyed
                return true
            }
        }

        return rtnValue
    }

    /// Find the city we want to attack
    override func findBestTarget(in gameModel: GameModel?) -> HexPoint? {
        
        fatalError("Obsolete function called CvAIOperationBasicCityAttack::findBestTarget()")
    }
}
