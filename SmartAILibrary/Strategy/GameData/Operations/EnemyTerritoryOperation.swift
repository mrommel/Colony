//
//  EnemyTerritoryOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class EnemyTerritoryOperation: Operation {

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

        super.initialize(for: player, enemy: enemy, area: area, target: target, muster: muster, in: gameModel)

        self.moveType = .enemyTerritory

        // create the armies that are needed and set the state to ARMYAISTATE_WAITING_FOR_UNITS_TO_REINFORCE
        self.army = Army(of: player, for: self, with: self.formation(in: gameModel))
        self.army?.state = .waitingForUnitsToReinforce

        // Figure out the initial rally point
        if let targetPlot = self.findBestTarget(in: gameModel) {

            self.targetPosition = targetPlot
            self.army?.goal = targetPlot

            if let newMusterPlot = self.selectInitialMusterPoint(in: gameModel) {

                self.musterPosition = newMusterPlot.point
                self.army?.position = newMusterPlot.point
                self.area = gameModel.area(of: newMusterPlot.point)

                if self.area != gameModel.area(of: targetPlot) {
                    self.army?.goal = targetPlot
                } else {

                    let pathFinder = AStarPathfinder()
                    pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(
                        for: .walk,
                        for: self.player,
                        unitMapType: .combat,
                        canEmbark: self.player!.canEmbark(),
                        canEnterOcean: self.player!.canEnterOcean()
                    )

                    if let path = pathFinder.shortestPath(fromTileCoord: self.musterPosition!, toTileCoord: self.targetPosition!),
                        let reducedPath = path.path(without: self.deployRange()),
                        let deployPoint = reducedPath.last {

                        self.army?.goal = deployPoint.0
                    } else {
                        // No path, abort
                        self.state = .aborted(reason: .lostPath)
                    }
                }

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
                // No muster point, abort
                self.state = .aborted(reason: .noMuster)
            }
        } else {
            // Lost our target, abort
            self.state = .aborted(reason: .lostTarget)
        }
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        return .none
    }

    /// How close to target do we end up?
    func deployRange() -> Int {

        return 4 // AI_OPERATIONAL_CITY_ATTACK_DEPLOY_RANGE
    }

    /// How long will we wait for a recruit to show up?
    func maximumRecruitTurns() -> Int {

        return 10 // AI_OPERATIONAL_MAX_RECRUIT_TURNS_ENEMY_TERRITORY
    }

    /// Figure out the initial rally point
    func selectInitialMusterPoint(in gameModel: GameModel?) -> AbstractTile? {

        guard let gameModel = gameModel,
              let player = self.player,
              let dangerPlotsAI = self.player?.dangerPlotsAI else {

            fatalError("cant get gameModel")
        }

        var deployPlot: HexPoint?
        var musterPlot: HexPoint?

        if let startCity = self.operationStartCity(in: gameModel) {

            if let startCityPlot = gameModel.tile(at: startCity.location) {

                // Different areas?  If so, just muster at start city
                if startCityPlot.area != gameModel.area(of: self.army!.goal) {

                    self.musterPosition = startCityPlot.point
                    return startCityPlot
                }

                // Generate path
                let pathFinder = AStarPathfinder()
                pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(
                    for: .walk,
                    for: self.player,
                    unitMapType: .combat,
                    canEmbark: player.canEmbark(),
                    canEnterOcean: player.canEnterOcean()
                )

                if let path = pathFinder.shortestPath(fromTileCoord: startCity.location, toTileCoord: self.army!.goal) {

                    var spacesFromTarget = 0
                    var dangerousPlots = 0

                    // Starting at the end, loop until we find a plot from this owner
                    for pathItem in path.points().reversed() {

                        guard let pathPlot = gameModel.tile(at: pathItem) else {
                            fatalError("path element outside of the map")
                        }

                        // Is this the deploy point?
                        if spacesFromTarget == self.deployRange() {
                            deployPlot = pathItem
                        }

                        // Check and see if this plot has the right owner

                        if player.isEqual(to: pathPlot.owner()) {
                            musterPlot = pathItem
                            break
                        } else {
                            // Is this a dangerous plot?
                            if dangerPlotsAI.danger(at: pathItem) > 0 {
                                dangerousPlots += 1
                            }
                        }

                        // Move to the previous plot on the path
                        spacesFromTarget += 1
                    }

                    // Is the path safe?  If so, let's just muster at the deploy point
                    if spacesFromTarget > 0 && (dangerousPlots * 100 / spacesFromTarget) < 20 /* AI_OPERATIONAL_PERCENT_DANGER_FOR_FORWARD_MUSTER*/ {

                        if let deployPlot = deployPlot {
                            musterPlot = deployPlot
                        }
                    }
                }
            }
        }

        if let musterPlot = musterPlot {
            self.musterPosition = musterPlot
            return gameModel.tile(at: musterPlot)
        } else {
            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                print("No muster point found, Operation aborting, Target was, \(self.army!.goal)")
            }
        }

        return nil
    }

    func findBestTarget(in gameModel: GameModel?) -> HexPoint? {

        fatalError("function called CvEnemyTerritoryOperation::findBestTarget() - should be overriden")
    }
}
