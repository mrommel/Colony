//
//  NavalBombardmentOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationNavalBombardment
//!  \brief        Send out a squadron of naval units to bomb enemy forces on the coast
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class NavalBombardmentOperation: NavalOperation {
    
    init() {
        
        super.init(type: .navalBombard)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /// Kick off this operation
    override func initialize(for player: AbstractPlayer?, enemy: AbstractPlayer?, area: HexArea?, target: AbstractCity? = nil, muster: AbstractCity? = nil, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)

        self.moveType = .enemyTerritory

        
        if self.operationStartCity(in: gameModel) != nil {
            
            // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
            self.army = Army(of: self.player, for: self, with: self.formation(in: gameModel))
            self.army?.state = .waitingForUnitsToReinforce
            
            // Figure out the initial rally point
            if let target = self.findBestTarget(in: gameModel) {
                
                self.targetPosition = target
                self.army?.goal = target

                if self.selectInitialMusterPoint(in: gameModel) != nil {
                    
                    self.army?.position = self.musterPosition!
                    self.area = gameModel.area(of: self.musterPosition!)

                    // Find the list of units we need to build before starting this operation in earnest
                    self.buildListOfUnitsWeStillNeedToBuild()

                    // try to get as many units as possible from existing units that are waiting around
                    if self.grabUnitsFromTheReserves(at: self.musterPosition, for: self.musterPosition, in: gameModel) {
                        self.army?.state = .waitingForUnitsToCatchUp
                        self.state = .gatheringForces
                    } else {
                        self.state = .recruitingUnits
                    }

                    // LogOperationStart();
                } else {
                    // No muster point, abort
                    self.state = .aborted(reason: .noMuster)
                }
            } else {
                // Lost our target, abort
                self.state = .aborted(reason: .lostTarget)
            }
        }
    }

    /// Same as default version except if just gathered forces, check to see if a better target has presented itself
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var stateChanged = false

        switch self.state {
            // If we were gathering forces, let's make sure a better target hasn't presented itself
        case .gatheringForces:
        
            // First do base case processing
            stateChanged = super.armyInPosition(in: gameModel)

            // Now revisit target
            let possibleBetterTarget = self.findBestTarget(in: gameModel)

            // If no target left, abort
            if possibleBetterTarget == nil {
                
                self.state = .aborted(reason: .noTarget)
            } else if possibleBetterTarget! != self.targetPosition! {
                // If target changed, reset to this new one
                // Reset our destination to be a few plots shy of the final target
                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: self.player, unitMapType: .combat, canEmbark: true)
                
                // Reset our destination to be a few plots shy of the final target
                if let path = pathFinder.shortestPath(fromTileCoord: self.army!.position, toTileCoord: possibleBetterTarget!),
                    let reducedPath = path.path(without: self.deployRange()),
                    let deployPoint = reducedPath.last {
                    
                    self.army?.goal = deployPoint.0
                    self.targetPosition = deployPoint.0
                }
            }

        // See if reached our target, if so give control of these units to the tactical AI
        case .movingToTarget:
        
            if self.army?.position == self.army?.goal {
                
                // Notify tactical AI to focus on this area
                let zone = TemporaryZone(location: self.targetPosition!, lastTurn: gameModel.currentTurn + 1 /* AI_TACTICAL_MAP_BOMBARDMENT_ZONE_TURNS */, targetType: .bombardmentZone)
                self.player?.tacticalAI?.add(temporaryZone: zone)
                
                self.state = .successful
            }


        // In all other cases use base class version
        case .aborted(reason: _), .recruitingUnits, .atTarget:
            return super.armyInPosition(in: gameModel)
            
        default:
            // NOOP
        break
        }

        return stateChanged
    }

    /// Find the barbarian camp we want to eliminate
    override func findBestTarget(in gameModel: GameModel?) -> HexPoint? {
 
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var bestPlot: HexPoint? = nil
        var bestTurns: Int = Int.max

        var initialUnit: AbstractUnit? = nil

        if let army = self.army {
            if let firstArmyUnit = army.unit(at: 0) {
                initialUnit = firstArmyUnit
            } else {
                initialUnit = self.findInitialUnit(in: gameModel)
            }
        } else {
            initialUnit = self.findInitialUnit(in: gameModel)
        }
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: self.player, unitMapType: .combat, canEmbark: self.player!.canEmbark())

        if let initialUnit = initialUnit {
            
            // Look at map for enemy units on the coast
            for plotLoop in gameModel.points() {
                
                guard let plot = gameModel.tile(at: plotLoop) else {
                    continue
                }

                if plot.isDiscovered(by: self.player) {
                    
                    if gameModel.isCoastal(at: plotLoop) {
                        
                        // Enemy defender here? (for now let's not add cities; they fire back!)
                        if gameModel.visibleEnemy(at: plotLoop, for: self.player) != nil {
                            
                            // Find an adjacent coastal water tile
                            for adjacentPoint in plotLoop.neighbors() {
                                
                                guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                                    continue
                                }
                                
                                if adjacentPlot.terrain() == .shore {
                                    
                                    let turns = pathFinder.turnsToReachTarget(for: initialUnit, to: adjacentPlot.point)
                                    
                                    if turns < Int.max && turns < bestTurns {
                                        
                                        bestTurns = turns
                                        bestPlot = adjacentPoint
                                    }

                                }
                            }
                        }
                    }
                }
            }
        }

        return bestPlot
    }
    
    override func formation(in gameModel: GameModel?) -> UnitFormationType {
        
        return .navalBombardment // AI_OPERATION_NAVAL_BOMBARDMENT
    }
}
