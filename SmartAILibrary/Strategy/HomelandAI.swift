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
class HomelandAI {
    
    var player: Player?
    var currentTurnUnits: [AbstractUnit?]
    var currentMoveUnits: [HomelandUnit?]
    
    var movePriorityList: [HomelandMove]
    var movePriorityTurn: Int = 0
    
    var currentBestMoveUnit: AbstractUnit? = nil
    var currentBestMoveUnitTurns: Int = Int.max
    
    let flavorDampening = 0.3
    
    var targetedCities: [HomelandTarget]
    var targetedSentryPoints: [HomelandTarget]
    var targetedForts: [HomelandTarget]
    var targetedNavalResources: [HomelandTarget]
    var targetedHomelandRoads: [HomelandTarget]
    var targetedAncientRuins: [HomelandTarget]
    
    // MARK: internal structs / enums
    
    enum HomelandMoveType {
        
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
        //case treasure // AI_HOMELAND_MOVE_TREASURE,
        //case none // AI_HOMELAND_MOVE_PROPHET_RELIGION,
        //case missionary // AI_HOMELAND_MOVE_MISSIONARY,
        // case inquisitor // AI_HOMELAND_MOVE_INQUISITOR,
        //case tradeUnit // AI_HOMELAND_MOVE_TRADE_UNIT,
        //case archaeologist // AI_HOMELAND_MOVE_ARCHAEOLOGIST,
        //case addSpaceshipPart // AI_HOMELAND_MOVE_ADD_SPACESHIP_PART,
        //case airlift // AI_HOMELAND_MOVE_AIRLIFT
        
        static var all: [HomelandMoveType] {
            
            return [
                .explore, .exploreSea, .settle, .garrison, .heal, .toSafety, .mobileReserve, .sentry, .worker, .workerSea, .patrol, .upgrade, ancientRuins, .aircraftToTheFront
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
            }
        }
    }
    
    // Object stored in the list of move priorities (movePriorityList)
    class HomelandMove: Comparable {
        
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
        var target: HexPoint? = nil
        
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
    
    enum HomelandTargetType {
        
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
        var target: HexPoint? = nil
        var city: AbstractCity? = nil
        var threatValue: Int = 0
        var improvement: TileImprovementType = .none
        
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
                if !unit.processedInTurn() && /*!unit.isDelayedDeath() &&*/ unit.task != .unknown && unit.canMove() {
                
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
            
            if loopUnit.isAutomated() && !loopUnit.processedInTurn() && loopUnit.task != .unknown && loopUnit.canMove() {
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
                            
                            // Don't send another unit if the tactical AI already sent a garrison here
                            var addTarget = false
                            if let unit = gameModel.unit(at: point) {
                            
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
                    }

                    // ... naval resource?
                    else if tile.terrain().isWater() && tile.has(improvement: .none) {
                        
                        if tile.hasAnyResource() {
                            
                            if let workingCity = tile.worked(), workingCity.player?.leader == player.leader {
                                
                                // Find proper improvement
                                if let improvement = tile.possibleImprovements().first {
                                    
                                    let newTarget = HomelandTarget(targetType: .navalResource)
                                    newTarget.target = point
                                    newTarget.improvement = improvement
                                    self.targetedNavalResources.append(newTarget)
                                }
                            }
                        }
                    }

                    // ... unpopped goody hut?
                    else if tile.has(improvement: .goodyHut) {
                        
                        let newTarget = HomelandTarget(targetType: .ancientRuin)
                        newTarget.target = point
                        self.targetedAncientRuins.append(newTarget)
                    }

                    // ... enemy civilian (or embarked) unit?
                    else if let targetUnit = gameModel.unit(at: point) {
                        
                        if diplomacyAI.isAtWar(with: targetUnit.player) && !targetUnit.canDefend() {
                            
                            let newTarget = HomelandTarget(targetType: .ancientRuin)
                            newTarget.target = point
                            self.targetedAncientRuins.append(newTarget)
                        }
                    }

                    // ... possible sentry point? (must be empty or only have friendly units)
                    else if tile.terrain().isLand() && gameModel.unit(at: point) == nil {
                        
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
                    }

                    // ... road segment in friendly territory?
                    else if tile.owner()?.leader == player.leader && tile.has(improvement: .road) {
 
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
        
        let flavorDefense = Int(Double(player.valueOfPersonalityFlavor(of: .defense)) * self.flavorDampening)
        //let flavorOffense = Int(Double(player.valueOfPersonalityFlavor(of: .offense)) * self.flavorDampening)
        let flavorExpand = player.valueOfPersonalityFlavor(of: .expansion)
        let flavorImprove = 0
        let flavorNavalImprove = 0
        let flavorExplore = Int(Double(player.valueOfPersonalityFlavor(of: .recon)) * self.flavorDampening)
        //let flavorGold = player.valueOfPersonalityFlavor(of: .gold)
        //let flavorScience = player.valueOfPersonalityFlavor(of: .science)
        //let flavorWonder = player.valueOfPersonalityFlavor(of: .wonder)
        let flavorMilitaryTraining = player.valueOfPersonalityFlavor(of: .militaryTraining)

        self.movePriorityList.removeAll()
        self.movePriorityTurn = gameModel.turnsElapsed


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
                    if gameModel.cities(of: player).count == 0 && self.currentMoveUnits.count == 0 {
                        if currentTurnUnit.canFound(at: currentTurnUnit.location, in: gameModel) {
                            
                            let homelandUnit = HomelandUnit(unit: currentTurnUnit)
                            self.currentMoveUnits.append(homelandUnit)
                            goingToSettle = true
                        }
                    }
                }
                
                // If we find a settler that isn't in an operation, let's keep him in place
                if !goingToSettle && currentTurnUnit.isFound() && currentTurnUnit.army() == nil {
                    
                    currentTurnUnit.push(mission: UnitMission(type: .skip, pushTurn: gameModel.turnsElapsed), in: gameModel)
                    currentTurnUnit.finishMoves()
                }
            }
        }

        if !self.currentMoveUnits.isEmpty {
            self.executeFirstTurnSettlerMoves(in: gameModel)
        }
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
                // FIXME self.plotExplorerSeaMoves()
                break
            case .settle:
                // AI_HOMELAND_MOVE_SETTLE:
                self.plotFirstTurnSettlerMoves(in: gameModel)
            case .garrison:
                // AI_HOMELAND_MOVE_GARRISON:
                // FIXME self.plotGarrisonMoves()
                break
            case .heal:
                // AI_HOMELAND_MOVE_HEAL:
                // FIXME self.plotHealMoves()
                break
            case .toSafety:
                // AI_HOMELAND_MOVE_TO_SAFETY:
                // FIXME self.plotMovesToSafety()
                break
            case .mobileReserve:
                // AI_HOMELAND_MOVE_MOBILE_RESERVE:
                // FIXME self.plotMobileReserveMoves()
                break
            case .sentry:
                // AI_HOMELAND_MOVE_SENTRY:
                // FIXME self.plotSentryMoves()
                break
            case .worker:
                // AI_HOMELAND_MOVE_WORKER:
                // FIXME self.plotWorkerMoves()
                break
            case .workerSea:
                // AI_HOMELAND_MOVE_WORKER_SEA:
                // FIXME self.plotWorkerSeaMoves()
                break
            case .patrol:
                // AI_HOMELAND_MOVE_PATROL:
                // FIXME self.plotPatrolMoves()
                break
            case .upgrade:
                // AI_HOMELAND_MOVE_UPGRADE:
                // FIXME self.plotUpgradeMoves()
                break
            case .ancientRuins:
                // AI_HOMELAND_MOVE_ANCIENT_RUINS:
                // FIXME self.plotAncientRuinMoves()
                break
            case .aircraftToTheFront:
                // AI_HOMELAND_MOVE_AIRCRAFT_TO_THE_FRONT:
                // FIXME self.plotAircraftMoves()
                break
            default:
                // NOOP
                break
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
                
                currentTurnUnit.push(mission: UnitMission(type: .skip, pushTurn: gameModel.turnsElapsed), in: gameModel)
                currentTurnUnit.set(turnProcessed: true)
                
                print("Unassigned \(currentTurnUnit.name()) at \(currentTurnUnit.location)")
            }
        }
    }
    
    /// Get units with explore AI and plan their moves
    func plotExplorerMoves(in gameModel: GameModel?) {
        
        self.clearCurrentMoveUnits()

        // Loop through all recruited units
        for currentTurnUnitRef in self.currentTurnUnits {
            
            if let currentTurnUnit = currentTurnUnitRef {
                
                if currentTurnUnit.task == .explore || (currentTurnUnit.isAutomated() && currentTurnUnit.domain() == .land && currentTurnUnit.automateType() == .explore) {
                    
                    let homelandUnit = HomelandUnit(unit: currentTurnUnit)
                    self.currentMoveUnits.append(homelandUnit)
                }
            }
        }

        if self.currentMoveUnits.count > 0 {
            
            // Execute twice so explorers who can reach the end of their sight can move again
            self.executeExplorerMoves(in: gameModel)
            self.executeExplorerMoves(in: gameModel)
        }
    }
    
    /// Moves units to explore the map
    private func executeExplorerMoves(in gameModel: GameModel?) {
        
        guard let economicAI = player?.economicAI else {
            fatalError("cant get economicAI")
        }

        economicAI.updatePlots(in: gameModel)

        //let pathFinder = AStarPathfinder()
        //pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: enemyUnit.movementType(), for: enemyUnit.player)
        
        for homelandUnit in self.currentMoveUnits {
            
            if homelandUnit?.unit == nil {
                continue
            }
            
            if let unit = homelandUnit?.unit {
            
                if unit.processedInTurn() {
                    continue
                }
                
                if let goodyPlot = economicAI.unitTargetGoodyPlot(for: unit, in: gameModel) {

                    print("Unit \(unit.name()) has goody target \(unit.location)")
                }
                
                /*if (pGoodyPlot && (pGoodyPlot->isGoody(m_pPlayer->getTeam()) || pGoodyPlot->HasBarbarianCamp()) && !pGoodyPlot->isVisibleEnemyDefender(pUnit.pointer()))
                {
                    var canFindPath = false
                    if (pkStepPlot)    // Do we already have our first step point?
                    {
                        if (IsValidExplorerEndTurnPlot(pUnit.pointer(), pkStepPlot))
                            bCanFindPath = true;
                        pEconomicAI->ClearUnitTargetGoodyStepPlot(pUnit.pointer());
                    }
                    if (!pkStepPlot || !bCanFindPath)
                    {
                        bCanFindPath = kPathFinder.GenerateUnitPath(pUnit.pointer(), iUnitX, iUnitY, pGoodyPlot->getX(), pGoodyPlot->getY(), MOVE_TERRITORY_NO_ENEMY | MOVE_MAXIMIZE_EXPLORE | MOVE_UNITS_IGNORE_DANGER /*iFlags*/, true/*bReuse*/);
                    if (bCanFindPath)
                    {
                            pkStepPlot = kPathFinder.GetPathEndTurnPlot();
                        }
                    }
                    if (bCanFindPath)
                    {
                        if pkStepPlot {
                            
                            print("Unit \(unit.name()) Moving to goody hut , from \(unit.location)")
                            CvAssert(!pUnit->atPlot(*pkStepPlot));
                            if (GC.getLogging() && GC.getAILogging())
                            {
                                CvString strLogString;
                                strLogString.Format("UnitID: %d Moving to goody hut, X: %d, Y: %d, from X: %d Y: %d", pUnit->GetID(), pkStepPlot->getX(), pkStepPlot->getY(), pUnit->getX(), pUnit->getY());
                                LogHomelandMessage(strLogString);
                            }
                            unit.push(mission: UnitMission(type: .moveTo, target: <#T##HexPoint?#>))//(CvTypes::getMISSION_MOVE_TO(), pkStepPlot->getX(), pkStepPlot->getY(), MOVE_TERRITORY_NO_ENEMY | MOVE_MAXIMIZE_EXPLORE | MOVE_UNITS_IGNORE_DANGER, false, false, MISSIONAI_EXPLORE, pkStepPlot);
                            
                            unit.finishMoves()
                            self.unitProcessed(unit)
                        
                        } else {
                            print("Unit \(unit.name()) no end turn plot to goody from \(unit.location)")
                        }
                        
                        continue

                    } else {
                        
                        print("Unit \(unit.name()) can't find path to goody from \(unit.location)")
                    }
                }

                CvPlot* pBestPlot = NULL;
                int iBestPlotScore = 0;

                TeamTypes eTeam = pUnit->getTeam();
                int iBaseSightRange = pUnit->getUnitInfo().GetBaseSightRange();

                int iMovementRange = pUnit->movesLeft() / GC.getMOVE_DENOMINATOR();
                for (int iX = -iMovementRange; iX <= iMovementRange; iX++)
                {
                    for (int iY = -iMovementRange; iY <= iMovementRange; iY++)
                    {
                        CvPlot* pEvalPlot = plotXYWithRangeCheck(iUnitX, iUnitY, iX, iY, iMovementRange);
                        if (!pEvalPlot)
                        {
                            continue;
                        }

                        if (!IsValidExplorerEndTurnPlot(pUnit.pointer(), pEvalPlot))
                        {
                            continue;
                        }

                        bool bCanFindPath = kPathFinder.GenerateUnitPath(pUnit.pointer(), pUnit->getX(), pUnit->getY(), pEvalPlot->getX(), pEvalPlot->getY(), MOVE_TERRITORY_NO_ENEMY | MOVE_MAXIMIZE_EXPLORE | MOVE_UNITS_IGNORE_DANGER /*iFlags*/, true/*bReuse*/);
                        if (!bCanFindPath)
                        {
                            continue;
                        }

                        CvAStarNode* pNode = kPathFinder.GetLastNode();
                        int iDistance = pNode->m_iData2;
                        if (iDistance > 1)
                        {
                            continue;
                        }

                        DomainTypes eDomain = pUnit->getDomainType();
                        int iScore = CvEconomicAI::ScoreExplorePlot(pEvalPlot, eTeam, iBaseSightRange, eDomain);
                        if (iScore > 0)
                        {
                            if (eDomain == DOMAIN_LAND && pEvalPlot->isHills())
                            {
                                iScore += 50;
                            }
                            else if (eDomain == DOMAIN_SEA && pEvalPlot->isAdjacentToLand())
                            {
                                iScore += 200;
                            }
                            else if (eDomain == DOMAIN_LAND && pUnit->IsEmbarkAllWater() && !pEvalPlot->isShallowWater())
                            {
                                iScore += 200;
                            }
                        }

                        if (iScore > iBestPlotScore)
                        {
                            pBestPlot = pEvalPlot;
                            iBestPlotScore = iScore;
                            bFoundNearbyExplorePlot = true;
                        }
                    }
                }

                if(!pBestPlot && iMovementRange > 0)
                {
                    FFastVector<int>& aiExplorationPlots = pEconomicAI->GetExplorationPlots();
                    if (aiExplorationPlots.size() > 0)
                    {
                        FFastVector<int>& aiExplorationPlotRatings = pEconomicAI->GetExplorationPlotRatings();

                        aBestPlotList.clear();
                        aBestPlotList.reserve(aiExplorationPlots.size());

                        iBestPlotScore = 0;

                        for(uint ui = 0; ui < aiExplorationPlots.size(); ui++)
                        {
                            int iPlot = aiExplorationPlots[ui];
                            if(iPlot < 0)
                            {
                                continue;
                            }

                            CvPlot* pEvalPlot = GC.getMap().plotByIndex(iPlot);
                            if(!pEvalPlot)
                            {
                                continue;
                            }

                            int iPlotScore = 0;

                            if(!IsValidExplorerEndTurnPlot(pUnit.pointer(), pEvalPlot))
                            {
                                continue;
                            }

                            int iRating = aiExplorationPlotRatings[ui];

                            // hitting the path finder, may not be the best idea. . .
                            bool bCanFindPath = GC.getPathFinder().GenerateUnitPath(pUnit.pointer(), iUnitX, iUnitY, pEvalPlot->getX(), pEvalPlot->getY(), MOVE_TERRITORY_NO_ENEMY | MOVE_MAXIMIZE_EXPLORE | MOVE_UNITS_IGNORE_DANGER /*iFlags*/, true/*bReuse*/);
                            if(!bCanFindPath)
                            {
                                continue;
                            }

                            CvAStarNode* pNode = GC.getPathFinder().GetLastNode();
                            int iDistance = pNode->m_iData2;
                            if(iDistance == 0)
                            {
                                iPlotScore = 1000 * iRating;
                            }
                            else
                            {
                                iPlotScore = (1000 * iRating) / iDistance;
                            }

                            if(iPlotScore > iBestPlotScore)
                            {
                                CvPlot* pEndTurnPlot = GC.getPathFinder().GetPathEndTurnPlot();
                                if(pEndTurnPlot == pUnit->plot())
                                {
                                    pBestPlot = NULL;
                                    iBestPlotScore = iPlotScore;
                                }
                                else if(IsValidExplorerEndTurnPlot(pUnit.pointer(), pEndTurnPlot))
                                {
                                    pBestPlot = pEndTurnPlot;
                                    iBestPlotScore = iPlotScore;
                                }
                                else
                                {
                                    // not a valid destination
                                    continue;
                                }
                            }
                        }
                    }
                }

                if(pBestPlot)
                {
                    CvAssertMsg(!pUnit->atPlot(*pBestPlot), "Exploring unit is already at the best place to explore");
                    pUnit->PushMission(CvTypes::getMISSION_MOVE_TO(), pBestPlot->getX(), pBestPlot->getY(), MOVE_TERRITORY_NO_ENEMY | MOVE_MAXIMIZE_EXPLORE | MOVE_UNITS_IGNORE_DANGER, false, false, MISSIONAI_EXPLORE, pBestPlot);

                    // Only mark as done if out of movement
                    if(pUnit->getMoves() <= 0)
                    {
                        UnitProcessed(pUnit->GetID());
                    }

                    if(GC.getLogging() && GC.getAILogging())
                    {
                        CvString strLogString;
                        if(bFoundNearbyExplorePlot)
                        {
                            strLogString.Format("UnitID: %d Explored to nearby target, To X: %d, Y: %d, From X: %d, Y: %d", pUnit->GetID(), pUnit->getX(), pUnit->getY(), iUnitX, iUnitY);
                        }
                        else
                        {
                            strLogString.Format("UnitID: %d Explored to distant target, To X: %d, Y: %d, From X: %d, Y: %d", pUnit->GetID(), pUnit->getX(), pUnit->getY(), iUnitX, iUnitY);
                        }
                        LogHomelandMessage(strLogString);
                    }
                }
                else
                {
                    if(pUnit->isHuman())
                    {
                        if(GC.getLogging() && GC.getAILogging())
                        {
                            CvString strLogString;
                            strLogString.Format("UnitID: %d Explorer (human) found no target, X: %d, Y: %d", pUnit->GetID(), pUnit->getX(), pUnit->getY());
                            LogHomelandMessage(strLogString);
                        }
                        pUnit->SetAutomateType(NO_AUTOMATE);
                        UnitProcessed(pUnit->GetID());
                    }
                    else
                    {
                        // If this is a land explorer and there is no ignore unit path to a friendly city, then disband him
                        if(pUnit->AI_getUnitAIType() == UNITAI_EXPLORE)
                        {
                            if(GC.getLogging() && GC.getAILogging())
                            {
                                CvString strLogString;
                                strLogString.Format("UnitID: %d Explorer (AI) found no target, X: %d, Y: %d", pUnit->GetID(), pUnit->getX(), pUnit->getY());
                                LogHomelandMessage(strLogString);
                            }

                            CvCity* pLoopCity;
                            int iLoop;
                            bool bFoundPath = false;
                            for(pLoopCity = m_pPlayer->firstCity(&iLoop); pLoopCity != NULL; pLoopCity = m_pPlayer->nextCity(&iLoop))
                            {
                                if(GC.getIgnoreUnitsPathFinder().DoesPathExist(*(pUnit), pUnit->plot(), pLoopCity->plot()))
                                {
                                    bFoundPath = true;
                                    break;
                                }
                            }
                            if(!bFoundPath)
                            {
                                CvString strLogString;
                                strLogString.Format("UnitID: %d Disbanding explorer, X: %d, Y: %d", pUnit->GetID(), pUnit->getX(), pUnit->getY());
                                LogHomelandMessage(strLogString);

                                UnitProcessed(pUnit->GetID());
                                pUnit->kill(true);
                                m_pPlayer->GetEconomicAI()->IncrementExplorersDisbanded();
                            }
                        }
                        else if(pUnit->AI_getUnitAIType() == UNITAI_EXPLORE_SEA)
                        {
                            if(GC.getLogging() && GC.getAILogging())
                            {
                                CvString strLogString;
                                strLogString.Format("UnitID: %d Sea explorer (AI) found no target, X: %d, Y: %d", pUnit->GetID(), pUnit->getX(), pUnit->getY());
                                LogHomelandMessage(strLogString);
                            }
                        }
                    }
                }*/
            }
        }
    }
    
    /// Creates cities for AI civs on first turn
    func executeFirstTurnSettlerMoves(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no gameModel given")
        }
        
        for currentMoveUnit in self.currentMoveUnits {

            if let unit = currentMoveUnit?.unit {
                
                unit.push(mission: UnitMission(type: .found, pushTurn: gameModel.turnsElapsed), in: gameModel)
                self.unitProcessed(unit: unit)
                
                print("Founded city at, X: %d, Y: %d")
            }
        }
    }
    
    /// Remove a unit that we've allocated from list of units to move this turn
    func unitProcessed(unit: AbstractUnit?) {
        //print("before unitProcessed: \(self.currentTurnUnits.count)")
        self.currentTurnUnits.removeAll(where: { $0?.location == unit?.location })
        //print("after unitProcessed: \(self.currentTurnUnits.count)")
        unit?.set(turnProcessed: true)
    }
}
