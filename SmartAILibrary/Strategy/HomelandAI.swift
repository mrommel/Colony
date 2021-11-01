//
//  HomelandAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvHomelandAI
//!  \brief        A player's AI to control units that are in reserve protecting their lands
//
//!  Key Attributes:
//!  - Handles moves for all military units not recruited by the tactical or operational AI
//!  - Also handles moves for workers and explorers (and settlers on the first turn)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// swiftlint:disable type_body_length
public class HomelandAI {

    var player: Player?
    var currentTurnUnits: [AbstractUnit?]
    var currentMoveUnits: [HomelandUnit?]
    var currentMoveHighPriorityUnits: [HomelandUnit?]

    var movePriorityList: [HomelandMove]
    var movePriorityTurn: Int = 0

    var currentBestMoveUnit: AbstractUnit?
    var currentBestMoveUnitTurns: Int = Int.max
    var currentBestMoveHighPriorityUnit: AbstractUnit?
    var currentBestMoveHighPriorityUnitTurns: Int = Int.max

    static let flavorDampening = 0.3 // AI_TACTICAL_FLAVOR_DAMPENING_FOR_MOVE_PRIORITIZATION
    static let defensiveMoveTurns = 4 // AI_HOMELAND_MAX_DEFENSIVE_MOVE_TURNS
    static let maxDangerLevel = 100000.0 // MAX_DANGER_VALUE

    var targetedCities: [HomelandTarget]
    var targetedSentryPoints: [HomelandTarget]
    var targetedForts: [HomelandTarget]
    var targetedNavalResources: [HomelandTarget]
    var targetedHomelandRoads: [HomelandTarget]
    var targetedAncientRuins: [HomelandTarget]

    // MARK: internal structs / enums

    enum HomelandMoveType: Int, Codable {

        case none // AI_HOMELAND_MOVE_NONE = -1,
        case unassigned // AI_HOMELAND_MOVE_UNASSIGNED,
        case explore // AI_HOMELAND_MOVE_EXPLORE,
        case exploreSea // AI_HOMELAND_MOVE_EXPLORE_SEA,
        case settle // AI_HOMELAND_MOVE_SETTLE,
        case garrison // AI_HOMELAND_MOVE_GARRISON,
        case heal // AI_HOMELAND_MOVE_HEAL,
        case toSafety // AI_HOMELAND_MOVE_TO_SAFETY,
        case mobileReserve // AI_HOMELAND_MOVE_MOBILE_RESERVE,
        case sentry // AI_HOMELAND_MOVE_SENTRY,
        case worker // AI_HOMELAND_MOVE_WORKER,
        case workerSea // AI_HOMELAND_MOVE_WORKER_SEA,
        case patrol // AI_HOMELAND_MOVE_PATROL,
        case upgrade // AI_HOMELAND_MOVE_UPGRADE,
        case ancientRuins // AI_HOMELAND_MOVE_ANCIENT_RUINS,
        // case garrisonCityState // AI_HOMELAND_MOVE_GARRISON_CITY_STATE,
        // case writer // AI_HOMELAND_MOVE_WRITER,
        // case artistGoldenAge // AI_HOMELAND_MOVE_ARTIST_GOLDEN_AGE,
        // case musician // AI_HOMELAND_MOVE_MUSICIAN,
        // case scientiestFreeTech // AI_HOMELAND_MOVE_SCIENTIST_FREE_TECH,
        // case none // AI_HOMELAND_MOVE_MERCHANT_TRADE,
        // case none // AI_HOMELAND_MOVE_ENGINEER_HURRY,
        // case none // AI_HOMELAND_MOVE_GENERAL_GARRISON,
        // case none // AI_HOMELAND_MOVE_ADMIRAL_GARRISON,
        // case none // AI_HOMELAND_MOVE_SPACESHIP_PART,
        case aircraftToTheFront // AI_HOMELAND_MOVE_AIRCRAFT_TO_THE_FRONT,
        //case none // AI_HOMELAND_MOVE_PROPHET_RELIGION,
        //case missionary // AI_HOMELAND_MOVE_MISSIONARY,
        // case inquisitor // AI_HOMELAND_MOVE_INQUISITOR,
        case tradeUnit // AI_HOMELAND_MOVE_TRADE_UNIT,
        //case archaeologist // AI_HOMELAND_MOVE_ARCHAEOLOGIST,
        //case addSpaceshipPart // AI_HOMELAND_MOVE_ADD_SPACESHIP_PART,
        //case airlift // AI_HOMELAND_MOVE_AIRLIFT

        static var all: [HomelandMoveType] {

            return [
                .explore, .exploreSea, .settle, .garrison, .heal, .toSafety, .mobileReserve, .sentry, .worker, .workerSea, .patrol, .upgrade, ancientRuins, .aircraftToTheFront, .tradeUnit
            ]
        }

        func priority() -> Int {

            return self.data().priority
        }

        // MARK: internal data structure / functions

        private struct HomelandMoveTypeData {

            let name: String
            let priority: Int
        }

        private func data() -> HomelandMoveTypeData {

            switch self {

            case .none: return HomelandMoveTypeData(name: "", priority: 0)
            case .unassigned: return HomelandMoveTypeData(name: "", priority: 0)

            case .explore: return HomelandMoveTypeData(name: "explore", priority: 35)
            case .exploreSea: return HomelandMoveTypeData(name: "", priority: 35)
            case .settle: return HomelandMoveTypeData(name: "", priority: 50)
            case .garrison: return HomelandMoveTypeData(name: "", priority: 10)
            case .heal: return HomelandMoveTypeData(name: "", priority: 30)
            case .toSafety: return HomelandMoveTypeData(name: "", priority: 30)
            case .mobileReserve: return HomelandMoveTypeData(name: "", priority: 15)
            case .sentry: return HomelandMoveTypeData(name: "", priority: 20)
            case .worker: return HomelandMoveTypeData(name: "", priority: 30)
            case .workerSea: return HomelandMoveTypeData(name: "", priority: 30)
            case .patrol: return HomelandMoveTypeData(name: "", priority: 0)
            case .upgrade: return HomelandMoveTypeData(name: "", priority: 25)
            case .ancientRuins: return HomelandMoveTypeData(name: "", priority: 40)
            case .aircraftToTheFront: return HomelandMoveTypeData(name: "", priority: 50)

            case .tradeUnit: return HomelandMoveTypeData(name: "", priority: 100)
            }
        }
    }

    // Object stored in the list of move priorities (movePriorityList)
    class HomelandMove: Comparable, Codable {

        var type: HomelandMoveType
        var priority: Int

        init(type: HomelandMoveType = .none, priority: Int = 0) {

            self.type = type
            self.priority = priority
        }

        static func < (lhs: HomelandMove, rhs: HomelandMove) -> Bool {

            return lhs.priority > rhs.priority
        }

        static func == (lhs: HomelandMove, rhs: HomelandMove) -> Bool {

            return lhs.priority == rhs.priority && lhs.type == rhs.type
        }
    }

    // Object stored in the list of current move units (m_CurrentMoveUnits)
    class HomelandUnit: Comparable {

        var unit: AbstractUnit?
        var movesToTarget: Int = 0
        var target: HexPoint?

        init(unit: AbstractUnit? = nil) {

            self.unit = unit
        }

        static func < (lhs: HomelandUnit, rhs: HomelandUnit) -> Bool {

            return lhs.movesToTarget < rhs.movesToTarget
        }

        static func == (lhs: HomelandUnit, rhs: HomelandUnit) -> Bool {

            return lhs.movesToTarget == rhs.movesToTarget
        }
    }

    enum HomelandTargetType: Int, Codable {

        case city // AI_HOMELAND_TARGET_CITY
        case sentryPoint // AI_HOMELAND_TARGET_SENTRY_POINT
        case fort // AI_HOMELAND_TARGET_FORT
        case navalResource // AI_HOMELAND_TARGET_NAVAL_RESOURCE
        case homeRoad // AI_HOMELAND_TARGET_HOME_ROAD
        case ancientRuin // AI_HOMELAND_TARGET_ANCIENT_RUIN
    }

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //  CLASS:      CvHomelandTarget
    //!  \brief        A target of opportunity for the Homeland AI this turn
    //
    //!  Key Attributes:
    //!  - Arises during processing of CvHomelandAI::FindHomelandTargets()
    //!  - Targets are reexamined each turn (so shouldn't need to be serialized)
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    class HomelandTarget: Comparable {

        var targetType: HomelandTargetType
        var target: HexPoint?
        var city: AbstractCity?
        var threatValue: Int = 0
        var improvement: ImprovementType = .none

        init(targetType: HomelandTargetType) {

            self.targetType = targetType
        }

        static func < (lhs: HomelandTarget, rhs: HomelandTarget) -> Bool {

            return lhs.threatValue > rhs.threatValue
        }

        static func == (lhs: HomelandTarget, rhs: HomelandTarget) -> Bool {

            return lhs.threatValue == rhs.threatValue
        }
    }

    // MARK: constructors

    init(player: Player?) {

        self.player = player

        self.currentTurnUnits = []
        self.currentMoveUnits = []
        self.currentMoveHighPriorityUnits = []
        self.movePriorityList = []

        // targets
        self.targetedCities = []
        self.targetedSentryPoints = []
        self.targetedForts = []
        self.targetedNavalResources = []
        self.targetedHomelandRoads = []
        self.targetedAncientRuins = []
    }

    /// Mark all the units that will be under tactical AI control this turn
    func recruitUnits(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.currentTurnUnits.removeAll()

        // Loop through our units
        for unitRef in gameModel.units(of: player) {

            if let unit = unitRef {

                // Never want immobile/dead units or ones that have already moved
                if !unit.processedInTurn() && !unit.isDelayedDeath() && unit.task() != .unknown && unit.canMove() {

                    self.currentTurnUnits.append(unit)
                }
            }
        }
    }

    /// Mark all the units that will be under tactical AI control this turn
    func findAutomatedUnits(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.currentTurnUnits.removeAll()

        // Loop through our units
        for loopUnitRef in gameModel.units(of: player) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            if loopUnit.isAutomated() && !loopUnit.processedInTurn() && loopUnit.task() != .unknown && loopUnit.canMove() {
                self.currentTurnUnits.append(loopUnit)
            }
        }
    }

    /// Update the AI for units
    func turn(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("no player given")
        }

        // Make sure we have a unit to handle
        if !self.currentTurnUnits.isEmpty {

            // Make sure the economic plots are up-to-date, it has a caching system in it.
            let economicAI = player.economicAI
            economicAI?.updatePlots(in: gameModel)

            // Start by establishing the priority order for moves this turn
            self.establishHomelandPriorities(in: gameModel)

            // Put together lists of places we may want to move toward
            self.findHomelandTargets(in: gameModel)

            // Loop through each move assigning units when available
            self.assignHomelandMoves(in: gameModel)
        }
    }

    /// Make lists of everything we might want to target with the homeland AI this turn
    func findHomelandTargets(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("no diplomacyAI given")
        }

        /*int iI;
        CvPlot *pLoopPlot;
        CvHomelandTarget newTarget;*/

        // Clear out target lists since we rebuild them each turn
        self.targetedCities.removeAll()
        self.targetedSentryPoints.removeAll()
        self.targetedForts.removeAll()
        self.targetedNavalResources.removeAll()
        self.targetedHomelandRoads.removeAll()
        self.targetedAncientRuins.removeAll()

        // Look at every tile on map
        //CvMap& theMap = GC.getMap();
        let mapSize = gameModel.mapSize()
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let point = HexPoint(x: x, y: y)
                guard let tile = gameModel.tile(at: point) else {
                    continue
                }

                if tile.isVisible(to: player) {

                    // Have a ...
                    // ... friendly city?
                    if let city = gameModel.city(at: point) {

                        if city.player?.leader == player.leader {

                            // Don't send another unit, if the tactical AI already sent a garrison here
                            var addTarget = false
                            if let unit = gameModel.unit(at: point, of: .combat) {

                                if unit.isUnderTacticalControl() {
                                    addTarget = true
                                }
                            } else {
                                addTarget = true
                            }

                            if addTarget {

                                let newTarget = HomelandTarget(targetType: .city)
                                newTarget.target = point
                                newTarget.city = city
                                newTarget.threatValue = city.threatValue()
                                self.targetedCities.append(newTarget)
                            }
                        }
                    } else if tile.terrain().isWater() && tile.has(improvement: .none) {
                        // ... naval resource?
                        if tile.hasAnyResource(for: player) {

                            if let workingCity = tile.workingCity(), workingCity.player?.leader == player.leader {

                                // Find proper improvement
                                if let improvement = tile.possibleImprovements().first {

                                    let newTarget = HomelandTarget(targetType: .navalResource)
                                    newTarget.target = point
                                    newTarget.improvement = improvement
                                    self.targetedNavalResources.append(newTarget)
                                }
                            }
                        }
                    } else if tile.has(improvement: .goodyHut) {

                        // ... unpopped goody hut?
                        let newTarget = HomelandTarget(targetType: .ancientRuin)
                        newTarget.target = point
                        self.targetedAncientRuins.append(newTarget)

                    } else if let targetUnit = gameModel.unit(at: point, of: .civilian) {

                        // ... enemy civilian (or embarked) unit?
                        if diplomacyAI.isAtWar(with: targetUnit.player) && !targetUnit.canDefend() {

                            let newTarget = HomelandTarget(targetType: .ancientRuin)
                            newTarget.target = point
                            self.targetedAncientRuins.append(newTarget)
                        }
                    } else if tile.terrain().isLand() && gameModel.unit(at: point, of: .combat) == nil {

                        // ... possible sentry point? (must be empty or only have friendly units)

                        // Must be at least adjacent to our land
                        if tile.owner()?.leader == player.leader || tile.owner() == nil {

                            // FIXME

                            // See how many outside plots are nearby to monitor
                            /*int iOutsidePlots = pLoopPlot->GetNumAdjacentDifferentTeam(eTeam, true /*bIgnoreWater*/);

                            if (iOutsidePlots > 0)
                            {
                                newTarget.SetTargetType(AI_HOMELAND_TARGET_SENTRY_POINT);
                                newTarget.SetTargetX(pLoopPlot->getX());
                                newTarget.SetTargetY(pLoopPlot->getY());
                                newTarget.SetAuxData(pLoopPlot);

                                // Get weight for this sentry point
                                int iWeight = iOutsidePlots * 100;
                                iWeight += pLoopPlot->defenseModifier(eTeam, true);
                                iWeight += m_pPlayer->GetPlotDanger(*pLoopPlot);

                                CvCity *pFriendlyCity = m_pPlayer->GetClosestFriendlyCity(*pLoopPlot, 5 /*i SearchRadius */);
                                if (pFriendlyCity && pFriendlyCity->getOwner() == m_pPlayer->GetID())
                                {
                                    iWeight += pFriendlyCity->getThreatValue() * pFriendlyCity->getPopulation() / 50;
                                    if (pFriendlyCity->isCapital())
                                    {
                                        iWeight = (iWeight * GC.getAI_MILITARY_CITY_THREAT_WEIGHT_CAPITAL()) / 100;
                                    }
                                }

                                if (pLoopPlot->isHills())
                                {
                                    iWeight *= 2;
                                }
                                if (pLoopPlot->isCoastalLand())
                                {
                                    iWeight /= 2;
                                }

                                newTarget.SetAuxIntData(iWeight);
                                m_TargetedSentryPoints.push_back(newTarget);
                            }*/
                        }
                    } else if tile.owner()?.leader == player.leader && tile.hasAnyRoute() {

                        // ... road segment in friendly territory?

                        let newTarget = HomelandTarget(targetType: .homeRoad)
                        newTarget.target = point
                        self.targetedHomelandRoads.append(newTarget)
                    }
                }
            }
        }

        // Post-processing on targets
        // FIXME self.eliminateAdjacentSentryPoints();
        // FIXME self.eliminateAdjacentHomelandRoads();
        self.targetedCities.sort()
    }

    /// Choose which moves to emphasize this turn
    private func establishHomelandPriorities(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        let flavorDefense = Int(Double(player.valueOfPersonalityFlavor(of: .defense)) * HomelandAI.flavorDampening)
        //let flavorOffense = Int(Double(player.valueOfPersonalityFlavor(of: .offense)) * self.flavorDampening)
        let flavorExpand = player.valueOfPersonalityFlavor(of: .expansion)
        let flavorImprove = 0
        let flavorNavalImprove = 0
        let flavorExplore = Int(Double(player.valueOfPersonalityFlavor(of: .recon)) * HomelandAI.flavorDampening)
        let flavorGold = player.valueOfPersonalityFlavor(of: .gold)
        //let flavorScience = player.valueOfPersonalityFlavor(of: .science)
        //let flavorWonder = player.valueOfPersonalityFlavor(of: .wonder)
        let flavorMilitaryTraining = player.valueOfPersonalityFlavor(of: .militaryTraining)

        self.movePriorityList.removeAll()
        self.movePriorityTurn = gameModel.currentTurn

        // Loop through each possible homeland move (other than "none" or "unassigned")
        for homelandMoveType in HomelandMoveType.all {

            var priority = homelandMoveType.priority()

            // Garrisons must beat out sentries if policies encourage garrisoning
            if homelandMoveType == .garrison {
                // FIXME ??
            }

            // Make sure base priority is not negative
            if priority >= 0 {

                // Defensive moves
                if [.garrison, .heal, .toSafety, .mobileReserve, .sentry, .aircraftToTheFront].contains(homelandMoveType) {
                    priority += flavorDefense
                }

                // Other miscellaneous types
                if [.explore, .exploreSea].contains(homelandMoveType) {
                    priority += flavorExplore
                }

                if homelandMoveType == .settle {
                    priority += flavorExpand
                }

                if homelandMoveType == .worker {
                    priority += flavorImprove
                }

                if homelandMoveType == .workerSea {
                    priority += flavorNavalImprove
                }

                if homelandMoveType == .upgrade {
                    priority += flavorMilitaryTraining
                }

                if homelandMoveType == .ancientRuins {
                    priority += flavorExplore
                }

                if homelandMoveType == .tradeUnit {
                    priority += flavorGold
                }

                // Store off this move and priority
                self.movePriorityList.append(HomelandMove(type: homelandMoveType, priority: priority))
            }
        }

        // Now sort the moves in priority order
        self.movePriorityList.sort()
    }

    private func clearCurrentMoveUnits() {

        self.currentMoveUnits.removeAll()
        self.currentBestMoveUnit = nil
        self.currentBestMoveUnitTurns = Int.max
    }

    /// Get our first city built
    private func plotFirstTurnSettlerMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.clearCurrentMoveUnits()

        // Loop through all recruited units
        for currentTurnUnitRef in self.currentTurnUnits {

            var goingToSettle = false
            if let currentTurnUnit = currentTurnUnitRef, let currentTurnUnitPlayer = currentTurnUnit.player {

                if !currentTurnUnitPlayer.isHuman() {
                    if gameModel.cities(of: player).isEmpty && self.currentMoveUnits.isEmpty {
                        if currentTurnUnit.canFound(at: currentTurnUnit.location, in: gameModel) {

                            let homelandUnit = HomelandUnit(unit: currentTurnUnit)
                            self.currentMoveUnits.append(homelandUnit)
                            goingToSettle = true
                        }
                    }
                }

                // If we find a settler that isn't in an operation, let's keep him in place
                if !goingToSettle && currentTurnUnit.isFound() && currentTurnUnit.army() == nil {

                    currentTurnUnit.push(mission: UnitMission(type: .skip), in: gameModel)
                    currentTurnUnit.finishMoves()
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {
            self.executeFirstTurnSettlerMoves(in: gameModel)
        }
    }

    /// Find something for all workers to do
    private func plotWorkerMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        self.clearCurrentMoveUnits()

        // Loop through all recruited units
        for currentTurnUnitRef in self.currentTurnUnits {

            if let currentTurnUnit = currentTurnUnitRef {

                if currentTurnUnit.task() == .work || (currentTurnUnit.isAutomated() && currentTurnUnit.domain() == .land && currentTurnUnit.automateType() == .build) {

                    let homelandUnit = HomelandUnit(unit: currentTurnUnit)
                    self.currentMoveUnits.append(homelandUnit)
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {
            self.executeWorkerMoves(in: gameModel)
        }
    }

    /// When nothing better to do, have units patrol to an adjacent tiles
    func plotPatrolMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        self.clearCurrentMoveUnits()

        // Loop through all remaining units
        for currentTurnUnit in self.currentTurnUnits {

            guard let unit = currentTurnUnit else {
                continue
            }

            if !unit.isHuman() && unit.domain() != .air && !unit.isTrading() {

                if let target = self.findPatrolTarget(for: unit, in: gameModel) {

                    let homelandUnit = HomelandUnit(unit: unit)
                    homelandUnit.target = target
                    self.currentMoveUnits.append(homelandUnit)

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                        print("\(unit.name()) patrolling to, \(target), Current \(unit.location)")
                        // LogHomelandMessage(strLogString);
                    }
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {
            self.executePatrolMoves(in: gameModel)
        }
    }

    /// Patrol with chosen units
    func executePatrolMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for currentMoveUnit in self.currentMoveUnits {

            if let unit = currentMoveUnit?.unit, let target = currentMoveUnit?.target {

                unit.push(mission: UnitMission(type: .moveTo, at: target), in: gameModel)
                unit.finishMoves()

                self.unitProcessed(unit: unit)
            }
        }
    }

    /// See if there is an adjacent plot we can wander to
    func findPatrolTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {

        guard let gameModel = gameModel, let unit = unit, let unitPlayer = unit.player else {
            fatalError("cant get gameModel")
        }

        var bestValue = 0
        var bestPlot: HexPoint?

        for adjacentPoint in unit.location.neighbors() {

            guard gameModel.tile(at: adjacentPoint) != nil else {
                continue
            }

            if unit.canMove(into: adjacentPoint, options: .none, in: gameModel) {

                if !gameModel.isEnemyVisible(at: adjacentPoint, for: self.player) {

                    if unit.path(towards: adjacentPoint, options: .none, in: gameModel) != nil {

                        var value = (1 + Int.random(number: 10000))

                        // Prefer wandering in our own territory
                        if unitPlayer.isEqual(to: unit.player) {
                            value += 10000
                        }

                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                            print("Adjacent Patrol Plot Score, \(value), \(adjacentPoint)")
                            // LogPatrolMessage(strLogString, pUnit);
                        }

                        if value > bestValue {
                            bestValue = value
                            bestPlot = adjacentPoint
                        }
                    } else {
                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                            print("Adjacent Patrol Plot !GeneratePath(), \(adjacentPoint)")
                            // LogPatrolMessage(strLogString, pUnit);
                        }
                    }
                } else {
                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                        print("Adjacent Patrol Plot !isVisibleEnemyUnit(), , \(adjacentPoint)")
                        //LogPatrolMessage(strLogString, pUnit);
                    }
                }
            } else {
                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                    print("Adjacent Patrol Plot not valid, \(adjacentPoint)")
                    //LogPatrolMessage(strLogString, pUnit);
                }
            }
        }

        if let bestPlot = bestPlot {

            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                print("Patrol Target FOUND, \(bestValue), \(bestPlot)")
                // LogPatrolMessage(strLogString, pUnit);
            }

            //CvAssert(!pUnit->atPlot(*pBestPlot));
            return bestPlot
        } else {
            if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                print("Patrol Target NOT FOUND")
                // LogPatrolMessage(strLogString, pUnit);
            }
        }

        return nil
    }

    /// Choose which moves to run and assign units to it
    func assignHomelandMoves(in gameModel: GameModel?) {

        // Proceed in priority order
        for movePriorityItem in self.movePriorityList {

            switch movePriorityItem.type {

            case .explore:
                // AI_HOMELAND_MOVE_EXPLORE
                self.plotExplorerMoves(in: gameModel)
            case .exploreSea:
                // AI_HOMELAND_MOVE_EXPLORE_SEA:
                self.plotExplorerSeaMoves(in: gameModel)
            case .settle:
                // AI_HOMELAND_MOVE_SETTLE:
                self.plotFirstTurnSettlerMoves(in: gameModel)
            case .garrison:
                // AI_HOMELAND_MOVE_GARRISON:
                self.plotGarrisonMoves(in: gameModel)
            case .heal:
                // AI_HOMELAND_MOVE_HEAL:
                self.plotHealMoves(in: gameModel)
            case .toSafety:
                // AI_HOMELAND_MOVE_TO_SAFETY:
                self.plotMovesToSafety(in: gameModel)
            case .mobileReserve:
                // AI_HOMELAND_MOVE_MOBILE_RESERVE:
                self.plotMobileReserveMoves(in: gameModel)
            case .sentry:
                // AI_HOMELAND_MOVE_SENTRY:
                self.plotSentryMoves(in: gameModel)
            case .worker:
                // AI_HOMELAND_MOVE_WORKER:
                self.plotWorkerMoves(in: gameModel)
            case .workerSea:
                // AI_HOMELAND_MOVE_WORKER_SEA:
                // FIXME self.plotWorkerSeaMoves()
                break
            case .patrol:
                // AI_HOMELAND_MOVE_PATROL:
                self.plotPatrolMoves(in: gameModel)
            case .upgrade:
                // AI_HOMELAND_MOVE_UPGRADE:
                // self.plotUpgradeMoves(in: gameModel)
                break
            case .ancientRuins:
                // AI_HOMELAND_MOVE_ANCIENT_RUINS:
                self.plotAncientRuinMoves(in: gameModel)
            case .aircraftToTheFront:
                // AI_HOMELAND_MOVE_AIRCRAFT_TO_THE_FRONT:
                // FIXME self.plotAircraftMoves()
                break
            case .tradeUnit:
                // AI_HOMELAND_MOVE_TRADE_UNIT:
                //self.plotTradeUnitMoves(in: gameModel)
            break
            // TODO
            /*case .writer:
                // AI_HOMELAND_MOVE_WRITER:
                self.plotWriterMoves()*/
            /*case AI_HOMELAND_MOVE_ARTIST_GOLDEN_AGE:
                PlotArtistMoves();
                break;
            case AI_HOMELAND_MOVE_MUSICIAN:
                PlotMusicianMoves();
                break;
            case AI_HOMELAND_MOVE_SCIENTIST_FREE_TECH:
                PlotScientistMoves();
                break;
            case AI_HOMELAND_MOVE_ENGINEER_HURRY:
                PlotEngineerMoves();
                break;
            case AI_HOMELAND_MOVE_MERCHANT_TRADE:
                PlotMerchantMoves();
                break;
            case AI_HOMELAND_MOVE_GENERAL_GARRISON:
                PlotGeneralMoves();
                break;
            case AI_HOMELAND_MOVE_ADMIRAL_GARRISON:
                PlotAdmiralMoves();
                break;
            case AI_HOMELAND_MOVE_PROPHET_RELIGION:
                PlotProphetMoves();
                break;
            case AI_HOMELAND_MOVE_MISSIONARY:
                PlotMissionaryMoves();
                break;
            case AI_HOMELAND_MOVE_INQUISITOR:
                PlotInquisitorMoves();
                break;
            case AI_HOMELAND_MOVE_AIRCRAFT_TO_THE_FRONT:
                PlotAircraftMoves();
                break;
            case AI_HOMELAND_MOVE_ADD_SPACESHIP_PART:
                PlotSSPartAdds();
                break;
            case AI_HOMELAND_MOVE_SPACESHIP_PART:
                PlotSSPartMoves();
                break;*/
            /*case AI_HOMELAND_MOVE_ARCHAEOLOGIST:
                PlotArchaeologistMoves();
                break;
            case AI_HOMELAND_MOVE_AIRLIFT:
                PlotAirliftMoves();
                break;*/

            default:
                print("not implemented: HomelandAI - \(movePriorityItem.type)")
            }
        }

        self.reviewUnassignedUnits(in: gameModel)
    }

    /// Log that we couldn't find assignments for some units
    private func reviewUnassignedUnits(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        // Loop through all remaining units
        for currentTurnUnitRef in self.currentTurnUnits {

            if let currentTurnUnit = currentTurnUnitRef {

                currentTurnUnit.push(mission: UnitMission(type: .skip), in: gameModel)
                currentTurnUnit.set(turnProcessed: true)

                print("<< HomelandAI ### Unassigned \(currentTurnUnit.name()) at \(currentTurnUnit.location) ### >>")
            }
        }
    }

    /// Pop goody huts nearby
    func plotAncientRuinMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Do we have any targets of this type?
        if !self.targetedAncientRuins.isEmpty {
            // Prioritize them (LATER)

            // See how many moves of this type we can execute
            for (index, homelandTarget) in self.targetedAncientRuins.enumerated() {

                guard let targetTile = gameModel.tile(at: homelandTarget.target ?? HexPoint.invalid) else {
                    continue
                }

                self.findUnitsFor(move: .ancientRuins, firstTime: index == 0, in: gameModel)

                if (self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count) > 0 {

                    if self.bestUnitToReachTarget(target: targetTile, maxTurns: HomelandAI.defensiveMoveTurns, in: gameModel) {

                        self.executeMoveToTarget(target: targetTile, garrisonIfPossible: false, in: gameModel)

                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                            print("Moving to goody hut (non-explorer), \(targetTile.point)")
                            // LogHomelandMessage(strLogString);
                        }
                    }
                }
            }
        }
    }

     /// Send units to garrison cities
    func plotGarrisonMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        // Do we have any targets of this type?
        if !self.targetedCities.isEmpty {

            var firstRun = true

            for targetedCity in self.targetedCities {

                guard let targetPoint = targetedCity.target else {
                    continue
                }

                let target = gameModel.tile(at: targetPoint)
                guard let city = gameModel.city(at: targetPoint) else {
                    continue
                }

                if city.lastTurnGarrisonAssigned() < gameModel.currentTurn {

                    // Grab units that make sense for this move type
                    self.findUnitsFor(move: .garrison, firstTime: firstRun, in: gameModel)

                    if (self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count) > 0 {

                        if self.bestUnitToReachTarget(target: target, maxTurns: HomelandAI.defensiveMoveTurns, in: gameModel) {
                            self.executeMoveToTarget(target: target, garrisonIfPossible: true, in: gameModel)

                            city.setLastTurnGarrisonAssigned(turn: gameModel.currentTurn)
                       }
                    }
                }

                firstRun = false
            }
        }
    }

    /// Find out which units would like to heal
    func plotHealMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        self.clearCurrentMoveUnits()

        // Loop through all recruited units
        for currentTurnUnit in self.currentTurnUnits {

            if let unit = currentTurnUnit {

                guard let tile = gameModel.tile(at: unit.location) else {
                    continue
                }

                if !unit.isHuman() {

                    // Am I under 100% health and not at sea or already in a city?
                    if unit.healthPoints() < unit.maxHealthPoints() && !unit.isEmbarked() && gameModel.city(at: unit.location) == nil {

                        // If I'm a naval unit I need to be in friendly territory
                        if unit.domain() != .sea || tile.isFriendlyTerritory(for: self.player, in: gameModel) {

                            if !unit.isUnderEnemyRangedAttack() {

                                self.currentMoveUnits.append(HomelandUnit(unit: unit))

                                if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                                    print("\(unit.type) healing at \(unit.location)")
                                    // LogHomelandMessage(strLogString);
                                }
                            }
                        }
                    }
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {
            self.executeHeals(in: gameModel)
        }
    }

    /// Heal chosen units
    func executeHeals(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        // FStaticVector< CvHomelandUnit, 64, true, c_eCiv5GameplayDLL >::iterator it;
        for currentMoveUnit in self.currentMoveUnits {

            if let unit = currentMoveUnit?.unit {

                if unit.canFortify(at: unit.location, in: gameModel) {
                    unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                    unit.set(fortifiedThisTurn: true, in: gameModel)
                } else {
                    unit.push(mission: UnitMission(type: .skip), in: gameModel)
                }
                self.unitProcessed(unit: unit)
            }
        }
    }

    /// Moved endangered units to safe hexes
    func plotMovesToSafety(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        self.clearCurrentMoveUnits()

        // Loop through all recruited units
        for currentTurnUnit in self.currentTurnUnits {

            if let unit = currentTurnUnit {

                guard let tile = gameModel.tile(at: unit.location) else {
                    continue
                }

                guard let dangerLevel = self.player?.dangerPlotsAI?.danger(at: unit.location) else {
                    continue
                }

                // Danger value of plot must be greater than 0
                if dangerLevel > 0 {

                    var addUnit = false

                    // If civilian (or embarked unit) always ready to flee
                    // slewis - 4.18.2013 - Problem here is that a combat unit that is a boat can get stuck in a city hiding from barbarians on the land
                    if !unit.canDefend() {
                        if unit.isAutomated() && unit.baseCombatStrength(ignoreEmbarked: true) > 0 {
                            // then this is our special case
                        } else {
                            addUnit = true
                        }
                    } else if unit.healthPoints() < unit.maxHealthPoints() {
                        // Also may be true if a damaged combat unit
                        if unit.isBarbarian() {
                            // Barbarian combat units - only naval units flee (but they flee if have taken ANY damage)
                            if unit.domain() == .sea {
                                addUnit = true
                            }
                        } else if unit.isUnderEnemyRangedAttack() || unit.attackStrength(against: nil, or: nil, on: tile, in: gameModel) * 2 <= unit.baseCombatStrength(ignoreEmbarked: false) {
                            // Everyone else flees at less than or equal to 50% combat strength
                            addUnit = true
                        }
                    } else if !unit.isBarbarian() {
                        // Also flee if danger is really high in current plot (but not if we're barbarian)
                        let acceptableDanger = unit.attackStrength(against: nil, or: nil, on: tile, in: gameModel) * 100
                        if Int(dangerLevel) > acceptableDanger {
                            addUnit = true
                        }
                    }

                    if addUnit {
                        // Just one unit involved in this move to execute
                        self.currentMoveUnits.append(HomelandUnit(unit: unit))
                    }
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {
            self.executeMovesToSafestPlot(in: gameModel)
        }
    }

    private func preferenceLevel(x: Double, y: Double) -> Double {

        return (x * HomelandAI.maxDangerLevel) + ((HomelandAI.maxDangerLevel - 1.0) - y)
    }

    /// Moves units to the hex with the lowest danger
    func executeMovesToSafestPlot(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let dangerPlotsAI = self.player?.dangerPlotsAI else {
            fatalError("no dangerPlotsAI given")
        }

        for currentMoveUnit in self.currentMoveUnits {

            //WeightedPlotVector aBestPlotList;
            //aBestPlotList.reserve(100);
            let bestPlotList = WeightedPoints()

            if let unit = currentMoveUnit?.unit {

                var bestPoint: HexPoint?

                let range = unit.maxMoves(in: gameModel)

                // For each plot within movement range of the fleeing unit
                for pt in unit.location.areaWith(radius: range) {

                    guard let plot = gameModel.tile(at: pt) else {
                        continue
                    }

                    //   prefer being in a city with the lowest danger value
                    //   prefer being in a plot with no danger value
                    //   prefer being under a unit with the lowest danger value
                    //   prefer being in your own territory with the lowest danger value
                    //   prefer the lowest danger value

                    let danger = dangerPlotsAI.danger(at: pt)
                    let isZeroDanger = danger <= 0
                    let isInCity = gameModel.city(at: pt) != nil
                    let isInCover = false // FIXME - another combat unit shields civilian
                    let isInTerritory = plot.ownerLeader() == self.player?.leader

                    //#define PREFERENCE_LEVEL(x, y) (x * MAX_DANGER_VALUE) + ((MAX_DANGER_VALUE - 1) - y)

                    assert(danger < HomelandAI.maxDangerLevel)

                    var score: Double = 0.0

                    if isInCity {
                        score = self.preferenceLevel(x: 5.0, y: danger)
                    } else if isZeroDanger {
                        if isInTerritory {
                            score = self.preferenceLevel(x: 4.0, y: danger)
                        } else {
                            score = self.preferenceLevel(x: 3.0, y: danger)
                        }
                    } else if isInCover {
                        score = self.preferenceLevel(x: 2.0, y: danger)
                    } else if isInTerritory {
                        score = self.preferenceLevel(x: 1.0, y: danger)
                    } else {
                        // if we have no good home, head to the lowest danger value
                        score = self.preferenceLevel(x: 0.0, y: danger)
                    }

                    bestPlotList.add(weight: score, for: plot.point)
                }

                // highest score will be first.
                var bestPlotArray: [(HexPoint, Double)] = bestPlotList.items.sortedByValue.reversed()

                // Now loop through the sorted score list and go to the best one we can reach in one turn.
                // #define EXECUTEMOVESTOSAFESTPLOT_FAILURE_LIMIT
                var failureLimit = 10

                //uint uiListSize;
                while !bestPlotArray.isEmpty {

                    bestPoint = bestPlotArray.removeFirst().0

                    if unit.canReach(at: bestPoint!, in: 1, in: gameModel) {
                        break
                    } else {
                        failureLimit -= 1
                    }

                    if failureLimit <= 0 {
                        bestPoint = nil // reset
                        break
                    }
                }

                if let bestPoint = bestPoint {

                    // Move to the lowest danger value found
                    unit.push(mission: UnitMission(type: .moveTo, at: bestPoint), in: gameModel)// MOVE_UNITS_IGNORE_DANGER
                    unit.finishMoves()
                    self.unitProcessed(unit: unit)

                    if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {
                        print("Moving \(unit.type) to safety, \(bestPoint)")
                        // LogHomelandMessage(strLogString);
                    }
                }
            }
        }
    }

    /// Send units to roads for quick movement to face any threat
    func plotMobileReserveMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        // Do we have any targets of this type?
        if !self.targetedHomelandRoads.isEmpty {

            // Prioritize them (LATER)

            // See how many moves of this type we can execute
            for (index, targetedHomelandRoad) in self.targetedHomelandRoads.enumerated() {

                guard let targetTile = gameModel.tile(at: targetedHomelandRoad.target ?? HexPoint.invalid) else {
                    continue
                }

                self.findUnitsFor(move: .mobileReserve, firstTime: (index == 0), in: gameModel)

                if (self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count) > 0 {

                    if self.bestUnitToReachTarget(target: targetTile, maxTurns: Int.max, in: gameModel) {

                        self.executeMoveToTarget(target: targetTile, garrisonIfPossible: false, in: gameModel)

                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                            print("Moving to mobile reserve muster pt, \(targetedHomelandRoad.target ?? HexPoint.invalid)")
                            // LogHomelandMessage(strLogString);
                        }
                    }
                }
            }
        }
    }

    /// Send units to sentry points around borders
    func plotSentryMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        // Do we have any targets of this type?
        if !self.targetedSentryPoints.isEmpty {
            // Prioritize them (LATER)

            // See how many moves of this type we can execute
            for (index, targetedSentryPoint) in self.targetedSentryPoints.enumerated() {

                // AI_PERF_FORMAT("Homeland-perf.csv", ("PlotSentryMoves, Turn %03d, %s", GC.getGame().getElapsedGameTurns(), m_pPlayer->getCivilizationShortDescription()) );

                // CvPlot* pTarget = GC.getMap().plot(m_TargetedSentryPoints[iI].GetTargetX(), m_TargetedSentryPoints[iI].GetTargetY());
                guard let targetTile = gameModel.tile(at: targetedSentryPoint.target ?? HexPoint.invalid) else {
                    continue
                }

                self.findUnitsFor(move: .sentry, firstTime: (index == 0), in: gameModel)

                if (self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count) > 0 {

                    if self.bestUnitToReachTarget(target: targetTile, maxTurns: Int.max, in: gameModel) {

                        self.executeMoveToTarget(target: targetTile, garrisonIfPossible: false, in: gameModel)

                        if gameModel.loggingEnabled() && gameModel.aiLoggingEnabled() {

                            print("Moving to sentry point, \(targetedSentryPoint.target ?? HexPoint.invalid), Priority: \(targetedSentryPoint.threatValue)")
                            // LogHomelandMessage(strLogString);
                        }
                    }
                }
            }
        }
    }

    /// Find one unit to move to target, starting with high priority list
    func executeMoveToTarget(target: AbstractTile?, garrisonIfPossible: Bool, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let target = target else {
            fatalError("cant get target")
        }

        // Do we have a pre-calcuated 'best' unit?
        var bestUnit: AbstractUnit?

        if self.currentBestMoveHighPriorityUnit != nil {

            // Don't move high priority unit if regular priority unit is closer
            if self.currentBestMoveUnit != nil && self.currentBestMoveUnitTurns < self.currentBestMoveHighPriorityUnitTurns {
                bestUnit = self.currentBestMoveUnit
            } else {
                bestUnit = self.currentBestMoveHighPriorityUnit
            }
        } else {
            bestUnit = self.currentBestMoveUnit
        }

        if let bestUnit = bestUnit {

            if bestUnit.location == target.point && bestUnit.canFortify(at: bestUnit.location, in: gameModel) {

                bestUnit.push(mission: UnitMission(type: .fortify), in: gameModel)
                bestUnit.doFortify(in: gameModel)
                self.unitProcessed(unit: bestUnit)
                return

            } else if garrisonIfPossible && bestUnit.location == target.point && bestUnit.canGarrison(at: target.point, in: gameModel) {

                bestUnit.push(mission: UnitMission(type: .garrison), in: gameModel)
                bestUnit.finishMoves()
                self.unitProcessed(unit: bestUnit)
                return

            } else {

                // Best units have already had a full path check to the target, so just add the move
                bestUnit.push(mission: UnitMission(type: .moveTo, at: target.point), in: gameModel)
                bestUnit.finishMoves()
                self.unitProcessed(unit: bestUnit)
                return
            }
        }

        // Start with high priority list
        for currentMoveHighPriorityUnit in self.currentMoveHighPriorityUnits {

            guard let loopUnit = currentMoveHighPriorityUnit?.unit else {
                continue
            }

            // Don't move high priority unit if regular priority unit is closer
            if let firstCurrentMoveUnit = self.currentMoveUnits.first {
                if firstCurrentMoveUnit!.movesToTarget < currentMoveHighPriorityUnit!.movesToTarget {
                    break
                }
            }

            if loopUnit.location == target.point && loopUnit.canFortify(at: loopUnit.location, in: gameModel) {

                loopUnit.push(mission: UnitMission(type: .fortify), in: gameModel)
                loopUnit.doFortify(in: gameModel)
                self.unitProcessed(unit: loopUnit)
                return
            } else if garrisonIfPossible && loopUnit.location == target.point && loopUnit.canGarrison(at: target.point, in: gameModel) {

                loopUnit.push(mission: UnitMission(type: .garrison), in: gameModel)
                loopUnit.finishMoves()
                self.unitProcessed(unit: loopUnit)
                return
            } else if currentMoveHighPriorityUnit!.movesToTarget < 8 /* AI_HOMELAND_ESTIMATE_TURNS_DISTANCE */ || loopUnit.turnsToReach(at: target.point, in: gameModel) != Int.max {

                loopUnit.push(mission: UnitMission(type: .moveTo, at: target.point), in: gameModel)
                loopUnit.finishMoves()
                self.unitProcessed(unit: loopUnit)
                return
            }
        }

        // Then regular priority
        for currentMoveUnit in self.currentMoveUnits {

            guard let loopUnit = currentMoveUnit?.unit else {
                continue
            }

            if loopUnit.location == target.point && loopUnit.canFortify(at: loopUnit.location, in: gameModel) {

                loopUnit.push(mission: UnitMission(type: .fortify), in: gameModel)
                loopUnit.doFortify(in: gameModel)
                self.unitProcessed(unit: loopUnit)
                return
            } else if currentMoveUnit!.movesToTarget  < 8 /* AI_HOMELAND_ESTIMATE_TURNS_DISTANCE */ || loopUnit.turnsToReach(at: target.point, in: gameModel) != Int.max {

                loopUnit.push(mission: UnitMission(type: .moveTo, at: target.point), in: gameModel)
                loopUnit.finishMoves()
                self.unitProcessed(unit: loopUnit)
                return
            }

        }
    }

    /// Compute the best unit to reach a target in the current normal and high priority move list
    func bestUnitToReachTarget(target: AbstractTile?, maxTurns: Int, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let target = target else {
            fatalError("cant get target")
        }

        // Normal priority units
        for currentMoveUnit in self.currentMoveUnits {

            guard let loopUnit = currentMoveUnit?.unit else {
                continue
            }

            // Make sure domain matches
            if loopUnit.domain() == .sea && !target.terrain().isWater() || loopUnit.domain() == .land && target.terrain().isWater() {

                currentMoveUnit?.movesToTarget = Int.max
                continue
            }

            // Make sure we can move into the destination.  The path finder will do a similar check near the beginning, but it is best to get this out of the way before then
            if !loopUnit.canMove(into: target.point, options: MoveOptions.none, in: gameModel) {

                currentMoveUnit?.movesToTarget = Int.max
                continue
            }

            let plotDistance = loopUnit.location.distance(to: target.point)
            currentMoveUnit?.movesToTarget = plotDistance
        }

        // High priority units
        for currentMoveHighPriorityUnit in self.currentMoveHighPriorityUnits {

            guard let loopUnit = currentMoveHighPriorityUnit?.unit else {
                continue
            }

            // Make sure domain matches
            if loopUnit.domain() == .sea && !target.terrain().isWater() || loopUnit.domain() == .land && target.terrain().isWater() {

                currentMoveHighPriorityUnit?.movesToTarget = Int.max
                continue
            }

            // Make sure we can move into the destination.  The path finder will do a similar check near the beginning, but it is best to get this out of the way before then
            if !loopUnit.canMove(into: target.point, options: MoveOptions.none, in: gameModel) {

                currentMoveHighPriorityUnit?.movesToTarget = Int.max
                continue
            }

            let plotDistance = loopUnit.location.distance(to: target.point)
            currentMoveHighPriorityUnit?.movesToTarget = plotDistance
        }

        // Sort by raw distance
        self.currentMoveUnits.sort(by: { $0!.movesToTarget < $1!.movesToTarget })
        self.currentMoveHighPriorityUnits.sort(by: { $0!.movesToTarget < $1!.movesToTarget })

        // Find the one with the best true moves distance
        (self.currentBestMoveUnit, _) = self.getClosestUnitByTurnsToTarget(moveUnits: self.currentMoveUnits, target: target, maxTurns: maxTurns, in: gameModel)
        (self.currentBestMoveHighPriorityUnit, _) = self.getClosestUnitByTurnsToTarget(moveUnits: self.currentMoveHighPriorityUnits, target: target, maxTurns: maxTurns, in: gameModel)

        return self.currentBestMoveHighPriorityUnit != nil || self.currentBestMoveUnit != nil
    }

    /// Get the closest
    func getClosestUnitByTurnsToTarget(moveUnits: [HomelandUnit?], target: AbstractTile?, maxTurns: Int, in gameModel: GameModel?) -> (AbstractUnit?, Int) {

        guard let target = target else {
            fatalError("cant get target")
        }

        var minTurns = Int.max
        var bestUnit: AbstractUnit?
        var failedPaths = 0

        // If we see this many failed pathing attempts, we assume no unit can get to the target
        let kMaxFailedPaths = 2

        // If the last failed pathing attempt was this far (raw distance) from the target, we assume no one can reach the target, even if we have not reached MAX_FAILED_PATHS
        let kEarlyOutFailedPathDistance = 12

        // Now go through and figure out the actual number of turns, and as a result, even if it can get there at all.
        // We will try and do as few as possible by stopping if we find a unit that can make it in one turn.
        for moveUnit in moveUnits {

            guard let loopUnit = moveUnit?.unit else {
                continue
            }

            // Raw distance
            guard let distance = moveUnit?.movesToTarget else {
                continue
            }

            if distance == Int.max {
                continue
            }

            let moves = loopUnit.turnsToReach(at: target.point, in: gameModel)
            moveUnit?.movesToTarget = moves

            // Did we make it at all?
            if moves != Int.max {

                // Reasonably close?
                if distance == 0 || (moves <= distance && moves <= maxTurns && moves < minTurns) {
                    bestUnit = loopUnit
                    minTurns = moves
                    break
                }

                if moves < minTurns {
                    bestUnit = loopUnit
                    minTurns = moves
                }

                // Were we far away?  If so, this is probably the best we are going to do
                if distance >= 8 { /* AI_HOMELAND_ESTIMATE_TURNS_DISTANCE */
                    break
                }
            } else {
                failedPaths += 1
                if failedPaths >= kMaxFailedPaths {
                    break
                }

                if distance >= kEarlyOutFailedPathDistance {
                    break
                }
            }
        }

        return (bestUnit, minTurns)
    }

    /// Finds both high and normal priority units we can use for this homeland move (returns true if at least 1 unit found)
    @discardableResult
    func findUnitsFor(move moveType: HomelandMoveType, firstTime: Bool, in gameModel: GameModel?) -> Bool {

        var rtnValue = false

        if firstTime {

            self.currentMoveUnits.removeAll()
            self.currentMoveHighPriorityUnits.removeAll()

            // Loop through all units available to homeland AI this turn
            for currentTurnUnit in self.currentTurnUnits {

                guard let loopUnit = currentTurnUnit else {
                    continue
                }

                guard let loopUnitPlayer = loopUnit.player else {
                    continue
                }

                guard let economicAI = self.player?.economicAI else {
                    continue
                }

                if !loopUnitPlayer.isHuman() {

                    // Civilians aren't useful for any of these moves
                    if !loopUnit.isCombatUnit() {
                        continue
                    }

                    // Scouts aren't useful unless recon is entirely shut off
                    if loopUnit.task() == .explore && economicAI.reconState() != .enough {
                        continue
                    }

                    var suitableUnit = false
                    var highPriority = false

                    switch moveType {

                    case .garrison:
                        // Want to put ranged units in cities to give them a ranged attack
                        if loopUnit.isRanged() && !loopUnit.has(task: .cityBombard) {

                            suitableUnit = true
                            highPriority = true

                        } else if loopUnit.canAttack() { // Don't use non-combatants

                            // Don't put units with a combat strength boosted from promotions in cities, these boosts are ignored
                            if loopUnit.defenseModifier(against: nil, or: nil, on: nil, ranged: false, in: gameModel) == 0
                                && loopUnit.attackModifier(against: nil, or: nil, on: nil, in: gameModel) == 0 {
                                suitableUnit = true
                            }
                        }

                    case .sentry:
                        // No ranged units as sentries
                        if !loopUnit.isRanged() /* && !loopUnit->noDefensiveBonus()*/ {
                            suitableUnit = true

                            // Units with extra sight are especially valuable
                            if loopUnit.sight() > 2 {
                                highPriority = true
                            }
                        } else if /*loopUnit->noDefensiveBonus() &&*/ loopUnit.sight() > 2 {
                            suitableUnit = true
                            highPriority = true
                        }

                    case .mobileReserve:
                        // Ranged units are excellent in the mobile reserve as are fast movers
                        if loopUnit.isRanged() || loopUnit.has(task: .fastAttack) {
                            suitableUnit = true
                            highPriority = true
                        } else if loopUnit.canAttack() {
                            suitableUnit = true
                        }

                    case .ancientRuins:
                        // Fast movers are top priority
                        if loopUnit.has(task: .fastAttack) {
                            suitableUnit = true
                            highPriority = true
                        } else if loopUnit.canAttack() {
                            suitableUnit = true
                        }
                    default:
                        // NOOP
                        break
                    }

                    // If unit was suitable, add it to the proper list
                    if suitableUnit {

                        let unit = HomelandUnit(unit: loopUnit)
                        if highPriority {
                            self.currentMoveHighPriorityUnits.append(unit)
                        } else {
                            self.currentMoveUnits.append(unit)
                        }
                        rtnValue = true
                    }
                }
            }
        } else {

            // Normal priority units
            var tempList = self.currentMoveUnits /*.copy */
            self.currentMoveUnits.removeAll()

            for iterator in tempList {

                if self.currentTurnUnits.contains(where: { $0?.location == iterator?.unit?.location }) {
                    self.currentMoveUnits.append(iterator)
                    rtnValue = true
                }
            }

            // High priority units
            tempList = self.currentMoveHighPriorityUnits /*.copy */
            self.currentMoveHighPriorityUnits.removeAll()

            for iterator in tempList {

                if self.currentTurnUnits.contains(where: { $0?.location == iterator?.unit?.location }) {
                    self.currentMoveHighPriorityUnits.append(iterator)
                    rtnValue = true
                }
            }
        }

        return rtnValue
    }

    /// Get units with explore AI and plan their moves
    func plotExplorerMoves(in gameModel: GameModel?) {

        self.clearCurrentMoveUnits()

        // Loop through all recruited units
        for currentTurnUnitRef in self.currentTurnUnits {

            if let currentTurnUnit = currentTurnUnitRef {

                if currentTurnUnit.task() == .explore || (currentTurnUnit.isAutomated() && currentTurnUnit.domain() == .land && currentTurnUnit.automateType() == .explore) {

                    let homelandUnit = HomelandUnit(unit: currentTurnUnit)
                    self.currentMoveUnits.append(homelandUnit)
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {

            // Execute twice so explorers who can reach the end of their sight can move again
            self.executeExplorerMoves(in: gameModel)
            self.executeExplorerMoves(in: gameModel)
        }
    }

    /// Get units with explore AI and plan their moves
    func plotExplorerSeaMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.clearCurrentMoveUnits()

        // Loop through all recruited units
        for currentTurnUnit in self.currentTurnUnits {

            if let unit = currentTurnUnit {

                if unit.task() == .exploreSea || (unit.isAutomated() && unit.domain() == .sea && unit.automateType() == .explore) {

                    self.currentMoveUnits.append(HomelandUnit(unit: currentTurnUnit))
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {
            // Execute twice so explorers who can reach the end of their sight can move again
            self.executeExplorerMoves(in: gameModel)
            self.executeExplorerMoves(in: gameModel)
        }
    }

    /// Moves units to explore the map
    private func executeExplorerMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }

        economicAI.updatePlots(in: gameModel)
        var foundNearbyExplorePlot = false

        let pathfinder = AStarPathfinder()
        pathfinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: player, unitMapType: .combat, canEmbark: player.canEmbark())

        for homelandUnit in self.currentMoveUnits {

            if homelandUnit?.unit == nil {
                continue
            }

            if let unit = homelandUnit?.unit {

                if unit.processedInTurn() {
                    continue
                }

                guard let unitPlayer = unit.player else {
                    continue
                }

                if let goodyPlot = economicAI.unitTargetGoodyPlot(for: unit, in: gameModel) {

                    print("Unit \(unit.name()) at \(unit.location) has goody target at \(goodyPlot.point)")

                    if (goodyPlot.has(improvement: .goodyHut) || goodyPlot.has(improvement: .barbarianCamp)) &&
                        gameModel.visibleEnemy(at: goodyPlot.point, for: player) != nil {

                        if let path = pathfinder.shortestPath(fromTileCoord: unit.location, toTileCoord: goodyPlot.point) {

                            let firstStep = path.firstSegment(for: unit.moves())

                            if let (stepPoint, _) = firstStep.last {

                                print("Unit \(unit.name()) Moving to goody hut, from \(unit.location)")

                                unit.push(mission: UnitMission(type: .moveTo, at: stepPoint), in: gameModel)

                                unit.finishMoves()
                                self.unitProcessed(unit: unit)

                            } else {
                                print("Unit \(unit.name()) no end turn plot to goody from \(unit.location)")
                            }

                            continue

                        } else {

                            print("Unit \(unit.name()) can't find path to goody from \(unit.location)")
                        }
                    }
                }

                var bestPlot: AbstractTile?
                var bestPlotScore = 0

                /*TeamTypes eTeam = pUnit->getTeam();*/
                let sightRange = unit.sight()

                let movementRange = unit.movesLeft()// / GC.getMOVE_DENOMINATOR();
                for evalPoint in unit.location.areaWith(radius: movementRange) {

                    guard let evalPlot = gameModel.tile(at: evalPoint) else {
                        continue
                    }

                    if !self.isValidExplorerEndTurnPlot(unit: unit, evalPlot: evalPlot, in: gameModel) {
                        continue
                    }

                    guard let path = pathfinder.shortestPath(fromTileCoord: unit.location, toTileCoord: evalPoint) else {
                        continue
                    }

                    let distance = path.count
                    if distance > 1 {
                        continue
                    }

                    let domain = unit.domain()
                    var score = economicAI.scoreExplore(plot: evalPoint, for: player, range: sightRange, domain: domain, in: gameModel)
                    if score > 0 {
                        if domain == .land && evalPlot.hasHills() {
                            score += 50
                        } else if domain == .sea && gameModel.adjacentToLand(point: evalPoint) {
                            score += 200
                        } /*else if domain == .land && unit.isEmbarkAllWater() && !pEvalPlot->isShallowWater() {
                            score += 200
                        }*/
                    }

                    if score > bestPlotScore {

                        bestPlot = evalPlot
                        bestPlotScore = score
                        foundNearbyExplorePlot = true
                    }
                }

                if bestPlot != nil && movementRange > 0 {

                    let explorationPlots = economicAI.explorationPlots()
                    if !explorationPlots.isEmpty {

                        bestPlotScore = 0

                        for explorationPlot in explorationPlots {

                            guard let evalPlot = gameModel.tile(at: explorationPlot.location) else {
                                continue
                            }

                            var plotScore = 0

                            if !self.isValidExplorerEndTurnPlot(unit: unit, evalPlot: evalPlot, in: gameModel) {
                                continue
                            }

                            let rating = explorationPlot.rating

                            // hitting the path finder, may not be the best idea. . .
                            guard let path = pathfinder.shortestPath(fromTileCoord: unit.location, toTileCoord: explorationPlot.location) else {
                                continue
                            }

                            let distance = path.cost + Double.random(minimum: 0.0, maximum: 0.5)
                            if distance == 0 {
                                plotScore = 1000 * rating
                            } else {
                                plotScore = (1000 * rating) / Int(distance)
                            }

                            if plotScore > bestPlotScore {

                                let (endTurnPointRef, _) = path.last ?? (nil, -1)

                                guard let endTurnPoint = endTurnPointRef else {
                                    continue
                                }

                                guard let endTurnPlot = gameModel.tile(at: endTurnPoint) else {
                                    continue
                                }

                                if endTurnPoint == unit.location {
                                    bestPlot = nil
                                    bestPlotScore = plotScore
                                } else if self.isValidExplorerEndTurnPlot(unit: unit, evalPlot: endTurnPlot, in: gameModel) {
                                    bestPlot = endTurnPlot
                                    bestPlotScore = plotScore
                                } else {
                                    // not a valid destination
                                    continue
                                }
                            }
                        }
                    }
                }

                if let bestPlot = bestPlot {
                    let unitMission = UnitMission(type: .moveTo, buildType: nil, at: bestPlot.point, options: .none)
                    unit.push(mission: unitMission, in: gameModel)

                    // Only mark as done if out of movement
                    if unit.moves() <= 0 {
                        self.unitProcessed(unit: unit)
                    }
                } else {
                    if unitPlayer.isHuman() {
                        unit.automate(with: .none)
                        self.unitProcessed(unit: unit)
                    } else {
                        // If this is a land explorer and there is no ignore unit path to a friendly city, then disband him
                        if unit.task() == .explore {

                            /*CvCity* pLoopCity;
                            int iLoop;*/
                            var foundPath = false

                            for cityRef in gameModel.cities(of: player) {

                                guard let city = cityRef else {
                                    continue
                                }

                                if pathfinder.doesPathExist(fromTileCoord: unit.location, toTileCoord: city.location) {
                                    foundPath = true
                                    break
                                }
                            }

                            if !foundPath {
                                self.unitProcessed(unit: unit)
                                unit.doKill(delayed: false, by: nil, in: gameModel)
                                player.economicAI?.incrementExplorersDisbanded()
                            }
                        } else if unit.task() == .exploreSea {
                            // NOOP
                        }
                    }
                }
            }
        }
    }

    func isValidExplorerEndTurnPlot(unit: AbstractUnit?, evalPlot plot: AbstractTile?, in gameModel: GameModel?) -> Bool {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let plot = plot else {
            fatalError("cant get plot")
        }

        if unit.location == plot.point {
            return false
        }

        if !plot.isDiscovered(by: unit.player) {
            return false
        }

        /*FIXME let domain = unit.domain()

        if plot.sameContinent(as: <#T##AbstractTile#>) (pPlot->area() != pUnit->area())
        {
            if (!pUnit->CanEverEmbark())
            {
                if (!(eDomain == DOMAIN_SEA && pPlot->isWater()))
                {
                    return false;
                }
            }
        }*/

        // don't let the auto-explore end it's turn in a city
        if plot.isCity() {
            return false
        }

        if !unit.canMove(into: plot.point, options: MoveOptions.none, in: gameModel) {
            return false
        }

        return true
    }

    /// Creates cities for AI civs on first turn
    func executeFirstTurnSettlerMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        for currentMoveUnit in self.currentMoveUnits {

            if let unit = currentMoveUnit?.unit {

                unit.push(mission: UnitMission(type: .found), in: gameModel)
                self.unitProcessed(unit: unit)

                print("Founded city at, \(unit.location)")
            }
        }
    }

    /// Moves units to explore the map
    private func executeWorkerMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let player = player else {
            fatalError("no player given")
        }

        guard let dangerPlotsAI = player.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }

        for currentMoveUnit in self.currentMoveUnits {

            if let unit = currentMoveUnit?.unit {

                let danger = dangerPlotsAI.danger(at: unit.location)

                if danger > 0.0 {

                    if self.moveCivilianToSafety(unit: unit, in: gameModel) {

                        print("\(player.leader) moves \(unit.name()) in turn \(gameModel.currentTurn) to 1st Safety,")

                        unit.finishMoves()
                        self.unitProcessed(unit: unit)
                        continue
                    }
                }

                let actionPerformed = self.executeWorkerMove(for: unit, in: gameModel)
                if actionPerformed {
                    continue
                }

                // if there's nothing else to do, move to the safest spot nearby
                if self.moveCivilianToSafety(unit: unit, ignoreUnits: true, in: gameModel ) {

                    print("\(player.leader) moves \(unit.name()) in turn \(gameModel.currentTurn) to 2nd Safety,")

                    unit.push(mission: UnitMission(type: .skip), in: gameModel)

                    if !player.isHuman() {
                        unit.finishMoves()
                    }

                    self.unitProcessed(unit: unit)
                    continue
                }

                // slewis - this was removed because a unit would eat all its moves. So if it didn't do anything this turn, it wouldn't be able to work
                unit.push(mission: UnitMission(type: .skip), in: gameModel)

                if !player.isHuman() {
                    unit.finishMoves()
                }
                self.unitProcessed(unit: unit)
            }
        }
    }

    private func executeWorkerMove(for unit: AbstractUnit?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }

        guard let player = player else {
            fatalError("no player given")
        }

        guard let unit = unit else {
            fatalError("no unit given")
        }

        // evaluator
        if let directive = player.builderTaskingAI?.evaluateBuilder(unit: unit, in: gameModel) {

            switch directive.type {

            case .buildImprovementOnResource,
                 .buildImprovement,
                 .repair,
                 .buildRoute,
                 .chop,
                 .removeRoad:

                    // are we already there?
                    if directive.target == unit.location {

                        // check to see if we already have this mission as the unit's head mission
                        var pushMission = true
                        if let missionData = unit.peekMission() {

                            if missionData.type == .build && missionData.buildType == directive.build {
                                pushMission = false
                            }
                        }

                        if pushMission {

                            let unitMission = UnitMission(type: .build)
                            unitMission.buildType = directive.build
                            unit.push(mission: unitMission, in: gameModel)
                        }

                        if unit.readyToMove() {
                            unit.finishMoves()
                        }
                        self.unitProcessed(unit: unit)

                    } else {
                        unit.push(mission: UnitMission(type: .moveTo, at: directive.target), in: gameModel)
                        unit.finishMoves()
                        self.unitProcessed(unit: unit)
                    }

                    return true

            case .none:
                // NOOP
                break
            }
        } else {
            print("builder has no directive")
        }

        return false
    }

    /// Fleeing to safety for civilian units
    private func moveCivilianToSafety(unit: AbstractUnit?, ignoreUnits: Bool = false, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let dangerPlotsAI = player.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        let searchRange = unit.search(range: 1, in: gameModel)

        var bestValue = -999999
        var bestPlot: AbstractTile?

        for point in unit.location.areaWith(radius: searchRange) {

            guard let tile = gameModel.tile(at: point) else {
                continue
            }

            if !unit.validTarget(at: point, in: gameModel) {
                continue
            }

            if gameModel.isEnemyVisible(at: point, for: self.player) {
                continue
            }

            // if we can't get there this turn, forget it
            let path = unit.path(towards: point, options: .none, in: gameModel)
            if path == nil || path!.count > 1 {
                continue
            }

            var value = 0
            if tile.owner()?.leader == self.player?.leader {
                // if this is within our territory, provide a minor benefit
                value += 1
            }

            let city = gameModel.city(at: point)

            if city != nil && city?.player?.leader == self.player?.leader {

                value += city!.defensiveStrength(against: nil, on: tile, ranged: false, in: gameModel)

            } else if !ignoreUnits {

                if let otherUnit = gameModel.unit(at: point, of: .combat) {

                    if otherUnit.player?.leader == unit.player?.leader {

                        if otherUnit.canDefend() && otherUnit.location != unit.location {

                            if otherUnit.isWaiting() || !otherUnit.canMove() {
                                value += otherUnit.defensiveStrength(against: nil, or: nil, on: tile, ranged: false, in: gameModel)
                            }
                        }
                    }
                }
            }

            value -= Int(dangerPlotsAI.danger(at: point))

            if value > bestValue {
                bestValue = value
                bestPlot = tile
            }
        }

        if let bestPlot = bestPlot {

            if unit.location == bestPlot.point {

                // print("\(unit.name()) tried to move to safety, but is already at the best spot, \(bestPlot.point)")

                if unit.canHold(at: bestPlot.point, in: gameModel) {

                    print("\(unit.name()) tried to move to safety, but is already at the best spot, \(bestPlot.point)")
                    unit.push(mission: UnitMission(type: .skip), in: gameModel)
                    return true

                } else {

                    print("\(unit.name()) tried to move to safety, but cannot hold in current location, \(bestPlot.point)")
                    unit.automate(with: .none)
                }
            } else {

                print("\(unit.name()) moving to safety, \(bestPlot.point)")
                unit.push(mission: UnitMission(type: .moveTo, at: bestPlot.point), in: gameModel)
                return true
            }

        } else {
            print("\(unit.name()) tried to move to a safe point but couldn't find a good place to go")
        }

        return false
    }

    /// Remove a unit that we've allocated from list of units to move this turn
    func unitProcessed(unit: AbstractUnit?) {
        self.currentTurnUnits.removeAll(where: { $0?.location == unit?.location })
        unit?.set(turnProcessed: true)
    }
}
