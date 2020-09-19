//
//  PillageEnemyOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 18.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationPillageEnemy
//!  \brief        Create a fast strike team to harass the enemy
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class PillageEnemyOperation: EnemyTerritoryOperation {
    
    init() {

        super.init(type: .pillageEnemy)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {
        
        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)
    }
    
    /// How close to target do we end up?
    override func deployRange() -> Int {

        return 4 // AI_OPERATIONAL_PILLAGE_ENEMY_DEPLOY_RANGE
    }
    
    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        return .fastPillagers // MUFORMATION_FAST_PILLAGERS
    }
    
    /// Every time the army moves on its way to the destination lets double-check that we don't have a better target
    override func armyMoved(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let stateChanged = false

        switch self.state {
        
        case .movingToTarget:
        
            // Find best pillage target
            if let betterTarget = self.findBestTarget(in: gameModel),
               let targetPlot = self.targetPosition {
                
                if betterTarget != targetPlot {
                    // If this is a new target, switch to it
                    self.targetPosition = betterTarget
                    self.army?.goal = betterTarget

                    // Reset our destination to be a few plots shy of the final target
                    let pathFinder = AStarPathfinder()
                    pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: self.player)
                    
                    if let path = pathFinder.shortestPath(fromTileCoord: self.army!.position, toTileCoord: betterTarget),
                        let reducedPath = path.path(without: 4 /* AI_OPERATIONAL_PILLAGE_ENEMY_DEPLOY_RANGE */),
                        let deployPoint = reducedPath.last {
                        
                        self.army?.goal = deployPoint.0
                    }
                }
            } else {
                // No targets at all!  Abort
                self.state = .aborted(reason: .noTarget)
            }

        // In all other cases use base class version
        case .atTarget, .recruitingUnits, .gatheringForces, .aborted(reason: _):
            return super.armyMoved(in: gameModel)
            
        default:
            // NOOP
            break
        }

        return stateChanged
    }

    /// If at target, pillage improvements
    override func armyInPosition(in gameModel: GameModel?) -> Bool {
        
        guard let army = self.army else {
            fatalError("cant get army")
        }
        
        var stateChanged = false

        switch self.state {
        
            // See if reached our target, if so give control of these units to the tactical AI
        case .movingToTarget:
        
            if army.position == army.goal {
                self.state = .successful
            }

        // In all other cases use base class version
        case .gatheringForces, .aborted(reason: _), .recruitingUnits, .atTarget:
            stateChanged = super.armyInPosition(in: gameModel)
            
        default:
            // NOOP
            break
        }

        return stateChanged
    }

    /// Find the city that we want to pillage
    override func findBestTarget(in gameModel: GameModel?) -> HexPoint? {

        guard let gameModel = gameModel,
              let enemy = self.enemy else {
            
            fatalError("cant get gameModel, enemy")
        }

        if !enemy.isAlive() {
            return nil
        }

        var bestValue = 0
        var bestTargetCity: AbstractCity? = nil
        
        if let startCity = self.operationStartCity(in: gameModel) {
            
            for loopCityRef in gameModel.cities(of: enemy) {
                
                guard let loopCity = loopCityRef else {
                    continue
                }
                
                // Make sure city is in the same area as our start city
                if gameModel.area(of: loopCity.location) == gameModel.area(of: startCity.location) {
                    
                    // Initial value of target is the number of improved plots
                    var value = loopCity.countNumImprovedPlots(in: gameModel)

                    // Adjust value based on proximity to our start location
                    let distance = loopCity.location.distance(to: startCity.location)
                    
                    if distance > 0 {
                        value = value * 100 / distance
                    }

                    if value > bestValue {
                        bestValue = value
                        bestTargetCity = loopCityRef
                    }
                }
            }
        }

        if let bestTargetCity = bestTargetCity {
            return bestTargetCity.location
        } else {
            return nil
        }
    }
}
