//
//  DestroyBarbarianCampOperation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 19.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvAIOperationDestroyBarbarianCamp
//!  \brief        Send out a squad of units to take out a barbarian camp
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class DestroyBarbarianCampOperation: EnemyTerritoryOperation {

    var civilianRescue: Bool
    var unitToRescue: AbstractUnit?

    init() {

        self.civilianRescue = false
        self.unitToRescue = nil

        super.init(type: .destroyBarbarianCamp)
    }

    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override func formation(in gameModel: GameModel?) -> UnitFormationType {

        return .antiBarbarianTeam // MUFORMATION_ANTI_BARBARIAN_TEAM
    }

    /// How close to target do we end up?
    override func deployRange() -> Int {

        return 2 /* AI_OPERATIONAL_BARBARIAN_CAMP_DEPLOY_RANGE */
    }

    /// Same as default version except if just gathered forces, check to see if a better target has presented itself
    override func armyInPosition(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel,
              let army = self.army else {
            fatalError("cant get basics")
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
                self.state = .aborted(reason: .lostTarget)
            } else if possibleBetterTarget! != self.targetPosition {
                // If target changed, reset to this new one
                // If we're traveling on a single continent, set our destination to be a few plots shy of the final target
                if self.army?.area == gameModel.area(of: possibleBetterTarget!) {

                    // Reset our destination to be a few plots shy of the final target
                    let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
                        for: .walk,
                           for: self.player,
                           unitMapType: .combat,
                           canEmbark: player!.canEmbark(),
                           canEnterOcean: false
                    )
                    let pathFinder = AStarPathfinder(with: pathFinderDataSource)

                    if let path = pathFinder.shortestPath(fromTileCoord: self.army!.position, toTileCoord: possibleBetterTarget!),
                        let reducedPath = path.path(without: 2 /* AI_OPERATIONAL_BARBARIAN_CAMP_DEPLOY_RANGE */),
                        let deployPoint = reducedPath.last {

                        self.army?.goal = deployPoint.0
                        self.targetPosition = deployPoint.0
                    }
                } else {
                    // Coming in from the sea. Just head to the camp
                    self.army?.goal = possibleBetterTarget!
                    self.targetPosition = possibleBetterTarget!
                }
            }

        // See if reached our target, if so give control of these units to the tactical AI
        case .movingToTarget:

            if army.position.distance(to: army.goal) <= 1 {

                // Notify tactical AI to focus on this area
                let zone = TemporaryZone(location: self.targetPosition!, lastTurn: gameModel.currentTurn + 5 /* AI_TACTICAL_MAP_TEMP_ZONE_TURNS */, targetType: .barbarianCamp, navalMission: false)

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

    /// Returns true when we should abort the operation totally (besides when we have lost all units in it)
    override func shouldAbort(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel,
              let player = self.player,
              let army = self.army else {
            fatalError("cant get basics")
        }

        guard let targetPosition = self.targetPosition,
              let targetPlot = gameModel.tile(at: targetPosition) else {

            return true
        }

        // If parent says we're done, don't even check anything else
        let rtnValue = super.shouldAbort(in: gameModel)

        if !rtnValue {

            // See if our target camp is still there
            if !self.civilianRescue && targetPlot.improvement() != .barbarianCamp {
                // Success!  The camp is gone
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                    print("Barbarian camp at \(targetPosition) no longer exists. Aborting")
                }

                return true
            } else if self.civilianRescue {

                // is the unit rescued?
                if self.unitToRescue == nil || self.unitToRescue!.isDelayedDeath() {

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        print("Civilian can no longer be rescued from barbarians. Aborting")
                    }
                    return true
                } else {

                    guard let unitToRescue = self.unitToRescue else {
                        fatalError("cant get unitToRescue")
                    }

                    if unitToRescue.originalLeader != player.leader || (unitToRescue.task() != .settle && unitToRescue.task() != .work) {
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                            print("Civilian can no longer be rescued from barbarians. Aborting")
                        }
                        return true
                    }
                }
            } else if self.state != .recruitingUnits {

                // If down below strength of camp, abort
                let campDefender = gameModel.unit(at: targetPosition, of: .combat)

                if campDefender != nil && army.totalPower() < campDefender!.power() {
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        print("Barbarian camp stronger (campDefender!.power()) than our units army.totalPower(). Aborting")
                    }
                    return true
                }
            }
        }

        return rtnValue
    }

    /// Find the barbarian camp we want to eliminate
    override func findBestTarget(in gameModel: GameModel?) -> HexPoint? {

        guard let gameModel = gameModel,
              let barbarianPlayer = gameModel.barbarianPlayer(),
              let player = self.player else {

            fatalError("cant get basics")
        }

        self.civilianRescue = false

        var bestDistance: Int = Int.max
        var bestPlot: HexPoint?

        if let startCity = self.operationStartCity(in: gameModel) {

            // look for good captured civilians of ours (settlers and workers, not missionaries)
            // these will be even more important than just a camp
            // btw - the AI will cheat here - as a human I would use a combination of memory and intuition to find these, since our current AI has neither of these...
            let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
                for: .walk,
                for: self.player,
                unitMapType: .combat,
                canEmbark: self.player!.canEmbark(),
                canEnterOcean: false
            )
            let pathFinder = AStarPathfinder(with: pathFinderDataSource)

            for loopUnitRef in gameModel.units(of: barbarianPlayer) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if loopUnit.originalLeader == player.leader && (loopUnit.task() == .settle || loopUnit.task() == .work/* || loopUnit.task: .archaeologist)*/) {

                    let distance: Int = pathFinder.shortestPath(fromTileCoord: loopUnit.location, toTileCoord: startCity.location)?.count ?? Int.max

                    if distance < bestDistance {

                        bestDistance = distance
                        bestPlot = loopUnit.location
                        self.civilianRescue = true
                        self.unitToRescue = loopUnitRef
                    }
                }
            }

            // no unit to capture - check for camps
            if bestPlot == nil {

                let mapSize = gameModel.mapSize()

                // Look at map for Barbarian camps
                for x in 0..<mapSize.width() {
                    for y in 0..<mapSize.height() {

                        if let tile = gameModel.tile(x: x, y: y) {

                            if tile.isDiscovered(by: player) {
                                if tile.has(improvement: .barbarianCamp) {

                                    let distance: Int = pathFinder.shortestPath(fromTileCoord: tile.point, toTileCoord: startCity.location)?.count ?? Int.max

                                    if distance < bestDistance {

                                        bestDistance = distance
                                        bestPlot = tile.point
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
}
