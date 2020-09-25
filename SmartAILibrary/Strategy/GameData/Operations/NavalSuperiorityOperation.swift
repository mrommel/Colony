//
//  NavalSuperiorityOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class WeightedPoints: WeightedList<HexPoint> {
    
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationNavalSuperiority
//!  \brief        Send out a squadron of naval units to rule the seas
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class NavalSuperiorityOperation: NavalOperation {

    init() {
        
        super.init(type: .navalSuperiority)
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
        
        self.moveType = .freeformNaval

        if self.operationStartCity(in: gameModel) != nil {
            
            // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
            self.army = Army(of: self.player, for: self, with: self.formation(in: gameModel))
            self.army?.state = .waitingForUnitsToReinforce

            // Figure out the initial rally point
            if let targetPlot = self.findBestTarget(in: gameModel) {
                
                self.targetPosition = targetPlot
                self.army?.goal = targetPlot

                if self.selectInitialMusterPoint(in: gameModel) != nil {
                    
                    self.army?.position = self.musterPosition!
                    self.area = gameModel.area(of: self.musterPosition!)

                    // Find the list of units we need to build before starting this operation in earnest
                    self.buildListOfUnitsWeStillNeedToBuild()

                    // try to get as many units as possible from existing units that are waiting around
                    if self.grabUnitsFromTheReserves(at: self.musterPosition!, for: self.musterPosition!, in: gameModel) {
                        self.army?.state = .waitingForUnitsToCatchUp
                        self.state = .movingToTarget
                    } else {
                        self.state = .recruitingUnits
                    }

                    //LogOperationStart();
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

    /// Same as default version except if just gathered forces and this operation never reaches a final target (just keeps attacking until dead or the operation is ended)
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var stateChanged = false

        switch self.state {
        
            // If we were gathering forces, let's make sure a better target hasn't presented itself
        case .gatheringForces, .movingToTarget:

            // First do base case processing
            stateChanged = super.armyInPosition(in: gameModel)

            // Now revisit target
            let possibleBetterTarget = self.findBestTarget(in: gameModel)

            if possibleBetterTarget == nil {
                // If no target left, abort
                self.state = .aborted(reason: .noTarget)
            }

            // If target changed, reset to this new one
            else if possibleBetterTarget != self.targetPosition {
                
                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: self.player)
                
                // Reset our destination to be a few plots shy of the final target
                if let path = pathFinder.shortestPath(fromTileCoord: self.army!.position, toTileCoord: possibleBetterTarget!),
                    let reducedPath = path.path(without: self.deployRange()),
                    let deployPoint = reducedPath.last {
                    
                    self.army?.goal = deployPoint.0
                    self.targetPosition = deployPoint.0
                }
            }

            // In all other cases use base class version
        case .aborted(reason: _), .recruitingUnits, .atTarget:
            return super.armyInPosition(in: gameModel)

        default:
            // NOOP
        break
        }

        return stateChanged;
    }

    //    ---------------------------------------------------------------------------
    //    Return the first reachable plot in the weighted plot list.
    //    It is assumed that the list has yet to be sorted and will do so.
    private func reachablePlot(for unit: AbstractUnit?, plots: WeightedPoints, turns: inout Int, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var bestPointRef: HexPoint? = nil
        var bestWeight = 0.0
        var bestTurns = 0
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .swim, for: self.player)
        
        if plots.count > 0 {
            
            plots.sort() // FIXME or reversed

            // This will check all the plots that have the same weight.  It will mean a few more path-finds, but it will
            // be more accurate.
            for index in 0..<plots.count {
                
                let plot = plots.items[index].itemType
                let weight = plots.items[index].weight
                
                if let bestPoint = bestPointRef {
                    
                    // Already found one of a lower weight
                    if weight > bestWeight {
                        break
                    }
                    
                    let turnsCalculated = pathFinder.turnsToReachTarget(for: unit, to: plot)
                    
                    if turnsCalculated != Int.max {
                        
                        if turnsCalculated < bestTurns {
                            
                            bestWeight = weight
                            bestPointRef = plot
                            bestTurns = turnsCalculated
                            
                            if bestTurns == 1 {
                                // Not getting better than this
                                break
                            }
                        }
                    }
                } else {
                    
                    let turnsCalculated = pathFinder.turnsToReachTarget(for: unit, to: plot)
                    
                    if turnsCalculated != Int.max {
                        
                        bestWeight = weight
                        bestPointRef = plot
                        bestTurns = turnsCalculated
                        
                        if bestTurns == 1 {
                            // Not getting better than this
                            break
                        }
                    }
                }
            }
        }

        if let bestPoint = bestPointRef {
            
            turns = bestTurns
            
            return bestPoint
        }

        return nil
    }

    /// Find the nearest enemy naval unit to eliminate
    override func findBestTarget(in gameModel: GameModel?) -> HexPoint? {
 
        guard let gameModel = gameModel,
              let player = self.player else {
            fatalError("cant get gameModel")
        }
        
        var bestPlot: HexPoint? = nil
        
        var closestEnemyDistance: Int = Int.max
        var enemyCoastalCity: AbstractCity? = nil
        
        var closestCampDistance: Int = Int.max
        var coastalBarbarianCamp: AbstractTile? = nil
        
        let weightedPoints: WeightedPoints = WeightedPoints()
        
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

        if let initialUnit = initialUnit {

            let baseMoves = initialUnit.maxMoves(in: gameModel)

            // Look at map for enemy naval units
            for plotLoop in gameModel.points() {
                
                guard let plot = gameModel.tile(at: plotLoop) else {
                    continue
                }

                if plot.isDiscovered(by: self.player) {
                    
                    if plot.isWater() {
                        
                        // FIXME: handle multiple units at one plot
                        if let loopUnit: AbstractUnit = gameModel.unit(at: plot.point) {
                            
                            if loopUnit.isEnemy(of: player) == true {
                                
                                let plotDistance = initialUnit.location.distance(to: plot.point)
                                var score = baseMoves * plotDistance
                                
                                if loopUnit.isTrading() {
                                    // we want to plunder trade routes of possible
                                    score /= 3
                                }
                                
                                if loopUnit.isEmbarked() {
                                    // we want to take out embarked units more than ships
                                    score = (score * 2) / 3
                                }

                                weightedPoints.add(weight: score, for: plot.point)
                            }
                        }
                    } else if gameModel.city(at: plot.point) != nil && gameModel.isCoastal(at: plot.point) {
                        
                        // Backup plan is a coastal enemy city
                        if let city = gameModel.city(at: plot.point) {
                            if player.isAtWar(with: city.player) {
                                
                                let distance = initialUnit.location.distance(to: city.location)
                                
                                if distance < closestEnemyDistance {
                                    closestEnemyDistance = distance
                                    enemyCoastalCity = city
                                }
                            }
                        }
                    } else if gameModel.isCoastal(at: plot.point) && plot.has(improvement: .barbarianCamp) {
                        
                        let distance = initialUnit.location.distance(to: plot.point)
                        
                        if distance < closestCampDistance {
                            closestCampDistance = distance
                            coastalBarbarianCamp = plot
                        }
                    }
                }
            }

            var bestTurns: Int = -1
            bestPlot = self.reachablePlot(for: initialUnit, plots: weightedPoints, turns: &bestTurns, in: gameModel)

            // None found, patrol over near closest enemy coastal city, or if not that a water tile adjacent to a camp
            if bestPlot == nil {
                
                if let enemyCoastalCity = enemyCoastalCity {
                    
                    // Find a coastal water tile adjacent to enemy city
                    for adjacentPoint in enemyCoastalCity.location.neighbors() {
                        
                        guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                            continue
                        }
                        
                        if adjacentPlot.terrain() == .shore {
                            
                            if initialUnit.path(towards: adjacentPoint, in: gameModel) != nil {
                                bestPlot = adjacentPoint
                            }
                        }
                    }
                } else {
                    if let coastalBarbarianCamp = coastalBarbarianCamp {
                        
                        // Find a coastal water tile adjacent to camp
                        for adjacentPoint in coastalBarbarianCamp.point.neighbors() {
                            
                            guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                                continue
                            }
                            
                            if adjacentPlot.terrain() == .shore {
                                
                                if initialUnit.path(towards: adjacentPoint, in: gameModel) != nil {
                                    bestPlot = adjacentPoint
                                }
                            }
                        }
                    }
                }
            }
        }

        return bestPlot
    }
    
    func canTacticalAIInterruptOperation() -> Bool {
        
        return true
    }
}
