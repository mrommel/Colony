//
//  EconomicAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class EconomicAI: Codable {

    enum CodingKeys: String, CodingKey {

        case economicStrategyAdoption
        case flavors

        case reconState
        case navalReconState
        case lastTurnBuilderDisbanded
        case explorersDisbanded
    }

    var player: Player?

    // MARK: internal variables

    private let economicStrategyAdoption: EconomicStrategyAdoption
    private var flavors: Flavors

    private var reconStateVal: EconomicReconState
    private var navalReconStateVal: EconomicReconState
    private var lastTurnBuilderDisbandedVal: Int
    private var explorersDisbandedValue: Int

    public var explorationPlotsDirty: Bool = true
    private var goodyHutUnitAssignments: [GoodyHutUnitAssignment]
    private var explorationPlotsArray: [ExplorationPlot]
    private var explorers: [AbstractUnit?]

    // MARK: internal classes

    struct GoodyHutUnitAssignment {

        var unit: AbstractUnit?
        let location: HexPoint // of goody hut
    }

    struct ExplorationPlot {

        let location: HexPoint
        let rating: Int
    }

    class EconomicStrategyAdoptionItem: Codable {

        enum CodingKeys: String, CodingKey {

            case economicStrategy
            case adopted
            case turnOfAdoption
        }

        let economicStrategy: EconomicStrategyType
        var adopted: Bool
        var turnOfAdoption: Int

        init(economicStrategy: EconomicStrategyType, adopted: Bool, turnOfAdoption: Int) {

            self.economicStrategy = economicStrategy
            self.adopted = adopted
            self.turnOfAdoption = turnOfAdoption
        }

        required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.economicStrategy = try container.decode(EconomicStrategyType.self, forKey: .economicStrategy)
            self.adopted = try container.decode(Bool.self, forKey: .adopted)
            self.turnOfAdoption = try container.decode(Int.self, forKey: .turnOfAdoption)
        }

        func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.economicStrategy, forKey: .economicStrategy)
            try container.encode(self.adopted, forKey: .adopted)
            try container.encode(self.turnOfAdoption, forKey: .turnOfAdoption)
        }
    }

    class EconomicStrategyAdoption: Codable {

        enum CodingKeys: String, CodingKey {

            case adoptions
        }

        var adoptions: [EconomicStrategyAdoptionItem]

        init() {

            self.adoptions = []

            for economicStrategyType in EconomicStrategyType.all {

                adoptions.append(EconomicStrategyAdoptionItem(economicStrategy: economicStrategyType, adopted: false, turnOfAdoption: -1))
            }
        }

        required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.adoptions = try container.decode([EconomicStrategyAdoptionItem].self, forKey: .adoptions)
        }

        func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.adoptions, forKey: .adoptions)
        }

        func adopted(economicStrategy: EconomicStrategyType) -> Bool {

            if let item = self.adoptions.first(where: { $0.economicStrategy == economicStrategy }) {

                return item.adopted
            }

            return false
        }

        func turnOfAdoption(of economicStrategy: EconomicStrategyType) -> Int {

            if let item = self.adoptions.first(where: { $0.economicStrategy == economicStrategy }) {

                return item.turnOfAdoption
            }

            fatalError("cant get turn of adoption - not set")
        }

        func adopt(economicStrategy: EconomicStrategyType, turnOfAdoption: Int) {

            if let item = self.adoptions.first(where: { $0.economicStrategy == economicStrategy }) {

                item.adopted = true
                item.turnOfAdoption = turnOfAdoption
            }
        }

        func abandon(economicStrategy: EconomicStrategyType) {

            if let item = self.adoptions.first(where: { $0.economicStrategy == economicStrategy }) {

                item.adopted = false
                item.turnOfAdoption = -1
            }
        }
    }

    // MARK: constructors

    init(player: Player?) {

        self.player = player
        self.economicStrategyAdoption = EconomicStrategyAdoption()
        self.flavors = Flavors()

        self.reconStateVal = .none
        self.navalReconStateVal = .none

        self.lastTurnBuilderDisbandedVal = 0

        self.goodyHutUnitAssignments = []
        self.explorationPlotsArray = []
        self.explorers = []
        self.explorersDisbandedValue = 0
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.player = nil

        self.economicStrategyAdoption = try container.decode(EconomicStrategyAdoption.self, forKey: .economicStrategyAdoption)
        self.flavors = try container.decode(Flavors.self, forKey: .flavors)

        self.reconStateVal = try container.decode(EconomicReconState.self, forKey: .reconState)
        self.navalReconStateVal = try container.decode(EconomicReconState.self, forKey: .navalReconState)
        self.lastTurnBuilderDisbandedVal = try container.decode(Int.self, forKey: .lastTurnBuilderDisbanded)
        self.explorersDisbandedValue = try container.decode(Int.self, forKey: .explorersDisbanded)

        self.explorationPlotsDirty = true
        self.goodyHutUnitAssignments = []
        self.explorationPlotsArray = []
        self.explorers = []
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.economicStrategyAdoption, forKey: .economicStrategyAdoption)
        try container.encode(self.flavors, forKey: .flavors)

        try container.encode(self.reconStateVal, forKey: .reconState)
        try container.encode(self.navalReconStateVal, forKey: .navalReconState)
        try container.encode(self.lastTurnBuilderDisbandedVal, forKey: .lastTurnBuilderDisbanded)
        try container.encode(self.explorersDisbandedValue, forKey: .explorersDisbanded)
    }

    // MARK: methods

    func turn(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        self.updatePlots(in: gameModel)

        self.updateReconState(in: gameModel)

        for economicStrategyType in EconomicStrategyType.all {

            // Minor Civs can't run some Strategies
            // FIXME

            // check tech
            let requiredTech = economicStrategyType.required()
            let isTechGiven = requiredTech == nil ? true : player.has(tech: requiredTech!)
            let obsoleteTech = economicStrategyType.obsolete()
            let isTechObsolete = obsoleteTech == nil ? false : player.has(tech: obsoleteTech!)

            // Do we already have this EconomicStrategy adopted?
            var shouldCityStrategyStart = true
            if self.economicStrategyAdoption.adopted(economicStrategy: economicStrategyType) {

                shouldCityStrategyStart = false

            } else if !isTechGiven {

                shouldCityStrategyStart = false

            } else if gameModel.currentTurn < economicStrategyType.notBeforeTurnElapsed() { // Not time to check this yet?

                shouldCityStrategyStart = false
            }

            var shouldCityStrategyEnd = false
            if self.economicStrategyAdoption.adopted(economicStrategy: economicStrategyType) {

                if economicStrategyType.checkEachTurns() > 0 {

                    // Is it a turn where we want to check to see if this Strategy is maintained?
                    if gameModel.currentTurn - self.economicStrategyAdoption.turnOfAdoption(of: economicStrategyType) % economicStrategyType.checkEachTurns() == 0 {
                        shouldCityStrategyEnd = true
                    }
                }

                if shouldCityStrategyEnd && economicStrategyType.minimumAdoptionTurns() > 0 {

                    // Has the minimum # of turns passed for this Strategy?
                    if gameModel.currentTurn < self.economicStrategyAdoption.turnOfAdoption(of: economicStrategyType) + economicStrategyType.minimumAdoptionTurns() {
                        shouldCityStrategyEnd = false
                    }
                }
            }

            // Check EconomicStrategy Triggers
            // Functionality and existence of specific CityStrategies is hardcoded here, but data is stored in XML so it's easier to modify
            if shouldCityStrategyStart || shouldCityStrategyEnd {

                // Has the Tech which obsoletes this Strategy? If so, Strategy should be deactivated regardless of other factors
                var strategyShouldBeActive = false

                // Strategy isn't obsolete, so test triggers as normal
                if !isTechObsolete {
                    strategyShouldBeActive = economicStrategyType.shouldBeActive(for: self.player, in: gameModel)
                }

                // This variable keeps track of whether or not we should be doing something (i.e. Strategy is active now but should be turned off, OR Strategy is inactive and should be enabled)
                var bAdoptOrEndStrategy = false

                // Strategy should be on, and if it's not, turn it on
                if strategyShouldBeActive {
                    if shouldCityStrategyStart {

                        bAdoptOrEndStrategy = true
                    } else if shouldCityStrategyEnd {

                        bAdoptOrEndStrategy = false
                    }
                }
                // Strategy should be off, and if it's not, turn it off
                    else {
                        if shouldCityStrategyStart {

                            bAdoptOrEndStrategy = false
                        } else if shouldCityStrategyEnd {

                            bAdoptOrEndStrategy = true
                        }
                }

                if bAdoptOrEndStrategy {

                    if shouldCityStrategyStart {

                        self.economicStrategyAdoption.adopt(economicStrategy: economicStrategyType, turnOfAdoption: gameModel.currentTurn)
                    } else if shouldCityStrategyEnd {

                        self.economicStrategyAdoption.abandon(economicStrategy: economicStrategyType)
                    }
                }
            }
        }

        self.updateFlavors()

        //print("economic strategy flavors")
        //print(self.flavors)
        if !player.isHuman() {
            //self.doHurry()
            self.doPlotPurchases(in: gameModel)
            //self.disbandExtraWorkers()
        }
    }

    func setExplorationPlotsDirty() {

        self.explorationPlotsDirty = true
    }

    func incrementExplorersDisbanded() {

        self.explorersDisbandedValue += 1
    }

    func explorersDisbanded() -> Int {

        return self.explorersDisbandedValue
    }

    func updateReconState(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        let mapSize = gameModel.mapSize()

        // Start at 1 so we don't get divide-by-0 errors
        //   Land recon counters
        var iNumLandPlotsRevealed = 1
        var iNumLandPlotsWithAdjacentFog = 1

        //   Naval recon counters
        var iNumCoastalTilesRevealed = 1
        var iNumCoastalTilesWithAdjacentFog = 1

        for x in 0..<mapSize.width() {

            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)

                if let tile = gameModel.tile(at: pt) {

                    if tile.isDiscovered(by: self.player) {

                        if tile.terrain().isLand() {
                            iNumLandPlotsRevealed += 1
                        } else if gameModel.isCoastal(at: pt) {
                            iNumCoastalTilesRevealed += 1
                        }

                        for neighbor in pt.neighbors() {

                            if !gameModel.valid(point: neighbor) {
                                continue
                            }

                            if let neighborTile = gameModel.tile(at: neighbor) {

                                if !neighborTile.isDiscovered(by: self.player) {

                                    if neighborTile.terrain().isLand() {
                                        iNumLandPlotsWithAdjacentFog += 1
                                    } else if gameModel.isCoastal(at: pt) {
                                        iNumCoastalTilesWithAdjacentFog += 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // RECON ON OUR HOME CONTINENT

        let iNumExploringUnits = gameModel.units(of: player).count(where: { $0!.task() == .explore }) + self.explorersDisbandedValue
        var iStrategyWeight = 100.0
        var iWeightThreshold = 110 - player.personalAndGrandStrategyFlavor(for: .recon) * 10

        // Safety check even if personality flavor is higher than expected
        if iWeightThreshold > 100 {
            iWeightThreshold = 100
        }

        iStrategyWeight *= Double(iNumLandPlotsWithAdjacentFog)
        var iNumExplorerDivisor = iNumExploringUnits + 1
        iStrategyWeight /= Double(iNumExplorerDivisor * iNumExplorerDivisor)
        iStrategyWeight /= sqrt(Double(iNumLandPlotsRevealed))

        if Int(iStrategyWeight) > iWeightThreshold {
            self.reconStateVal = .needed
        } else {
            if Int(iStrategyWeight) > (iWeightThreshold / 4) {
                self.reconStateVal = .neutral
            } else {
                self.reconStateVal = .enough
            }
        }

        // NAVAL RECON ACROSS THE ENTIRE MAP

        // No coastal cities?  Moot point...
        var foundedCoastalCity = false
        for cityRef in gameModel.cities(of: player) {

            if let city = cityRef {
                if gameModel.isCoastal(at: city.location) {
                    foundedCoastalCity = true
                }
            }
        }

        if !foundedCoastalCity {

            self.navalReconStateVal = .enough

        } else {
            // How many Units do we have exploring or being trained to do this job? The more Units we have the less we want this Strategy
            let iNumExploringUnits = gameModel.units(of: player).count(where: { $0!.task() == .exploreSea })
            var iStrategyWeight = 100.0
            var iWeightThreshold = 110 - player.personalAndGrandStrategyFlavor(for: .navalRecon) * 10

            // Safety check even if personality flavor is higher than expected
            if iWeightThreshold > 100 {
                iWeightThreshold = 100
            }

            iStrategyWeight *= Double(iNumCoastalTilesWithAdjacentFog)
            iNumExplorerDivisor = iNumExploringUnits + 1
            iStrategyWeight /= Double(iNumExplorerDivisor * iNumExplorerDivisor)
            iStrategyWeight /= sqrt(Double(iNumCoastalTilesRevealed))

            if Int(iStrategyWeight) > iWeightThreshold {
                self.navalReconStateVal = .needed
            } else {
                if Int(iStrategyWeight) > (iWeightThreshold / 4) {
                    self.navalReconStateVal = .neutral
                } else {
                    self.navalReconStateVal = .enough

                    // FIXME: Return all/most boats to normal unit AI since have enough recon
                }
            }
        }
    }

    func adopted(economicStrategy: EconomicStrategyType) -> Bool {

        return self.economicStrategyAdoption.adopted(economicStrategy: economicStrategy)
    }

    func reconState() -> EconomicReconState {

        return self.reconStateVal
    }

    func navalReconState() -> EconomicReconState {

        return self.navalReconStateVal
    }

    func updateFlavors() {

        self.flavors.reset()

        for economicStrategyType in EconomicStrategyType.all {

            if self.economicStrategyAdoption.adopted(economicStrategy: economicStrategyType) {

                for economicStrategyTypeFlavor in economicStrategyType.flavorModifiers() {

                    self.flavors += economicStrategyTypeFlavor
                }
            }
        }

        // FIXME: inform
    }

    func lastTurnBuilderDisbanded() -> Int {

        return self.lastTurnBuilderDisbandedVal
    }

    func minimumSettleFertility() -> Int {

        return 5000 // AI_STRATEGY_MINIMUM_SETTLE_FERTILITY
    }

    func unitTargetGoodyPlot(for unit: AbstractUnit?, in gameModel: GameModel?) -> AbstractTile? {

        if self.explorationPlotsDirty {
            self.updatePlots(in: gameModel)
        }

        for goodyHutUnitAssignment in self.goodyHutUnitAssignments {

            if let goodyHutUnit = goodyHutUnitAssignment.unit {

                if goodyHutUnit.isEqual(to: unit) {
                    if let goodyHutPlot = gameModel?.tile(at: goodyHutUnitAssignment.location) {
                        return goodyHutPlot
                    }
                }
            }
        }

        return nil
    }

    /// Go through the plots for the exploration automation to evaluate
    func updatePlots(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        // reset all plots
        self.explorationPlotsArray.removeAll()
        self.goodyHutUnitAssignments.removeAll()

        // find the center of all the cities
        var totalX = 0
        var totalY = 0
        var cityCount = 0

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                fatalError("cant get city")
            }

            totalX += city.location.x
            totalY += city.location.y
            cityCount += 1
        }

        let mapSize = gameModel.mapSize()
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let point = HexPoint(x: x, y: y)
                guard let tile = gameModel.tile(at: point) else {
                    continue
                }

                if !tile.isDiscovered(by: player) {
                    continue
                }

                if tile.has(improvement: .goodyHut) && !gameModel.isEnemyVisible(at: point, for: player) {

                    goodyHutUnitAssignments.append(GoodyHutUnitAssignment(unit: nil, location: point))
                }

                if tile.has(improvement: .barbarianCamp) && !gameModel.isEnemyVisible(at: point, for: player) {

                    goodyHutUnitAssignments.append(GoodyHutUnitAssignment(unit: nil, location: point))
                }

                var domain: UnitDomainType = .land
                if tile.terrain().isWater() {
                    domain = .sea
                }

                let score = self.scoreExplore(plot: point, for: player, range: 1, domain: domain, in: gameModel)
                if score <= 0 {
                    continue
                }

                self.explorationPlotsArray.append(ExplorationPlot(location: point, rating: score))
            }
        }

        // assign explorers to goody huts

        // build explorer list
        self.explorers.removeAll()

        for unitRef in gameModel.units(of: player) {

            guard let unit = unitRef else {
                continue
            }

            // non-automated human-controlled units should not be considered
            if player.isHuman() && !unit.isAutomated() {
                continue
            }

            if unit.task() != .explore && unit.automateType() != .explore {
                continue
            }

            if unit.army() != nil {
                continue
            }

            self.explorers.append(unit)
        }

        if self.explorers.count >= self.goodyHutUnitAssignments.count {
            self.assignExplorersToHuts(in: gameModel)
        } else {
            self.assignHutsToExplorers(in: gameModel)
        }

        self.explorationPlotsDirty = false
    }

    func explorationPlots() -> [ExplorationPlot] {

        return self.explorationPlotsArray
    }

    private func assignExplorersToHuts(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        //CvTwoLayerPathFinder& kPathFinder = GC.getPathFinder();

        for var goodyHutUnitAssignment in self.goodyHutUnitAssignments {

            guard gameModel.tile(at: goodyHutUnitAssignment.location) != nil else {
                continue
            }

            var closestEstimateTurns = Int.max
            var closestUnit: AbstractUnit? = nil

            for explorerRef in self.explorers {

                guard let explorer = explorerRef else {
                    continue
                }

                let distance = explorer.location.distance(to: goodyHutUnitAssignment.location)

                var estimateTurns = Int.max
                if explorer.maxMoves(in: gameModel) >= 1 {
                    estimateTurns = distance / explorer.maxMoves(in: gameModel)
                }

                if estimateTurns < closestEstimateTurns {

                    // Now check path
                    let pathFinder = AStarPathfinder()
                    pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: explorer.movementType(), for: player, unitMapType: .combat, canEmbark: true)

                    if pathFinder.shortestPath(fromTileCoord: explorer.location, toTileCoord: goodyHutUnitAssignment.location) != nil {

                        closestEstimateTurns = estimateTurns
                        closestUnit = explorer
                    }
                }

            }

            if closestUnit != nil {

                goodyHutUnitAssignment.unit = closestUnit

                self.explorers.removeAll(where: { $0?.location == closestUnit?.location })
            }
        }
    }

    //    ---------------------------------------------------------------------------
    private func assignHutsToExplorers(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        // Create copy list of huts
        // FIXME: check that this is really a copy
        var goodyHutUnitAssignmentsCopy = self.goodyHutUnitAssignments

        for explorerRef in self.explorers {

            guard let explorer = explorerRef else {
                continue
            }

            var hutLocation: HexPoint? = nil
            var closestEstimateTurns = Int.max

            for goodyHutUnitAssignment in goodyHutUnitAssignmentsCopy {

                guard gameModel.tile(at: goodyHutUnitAssignment.location) != nil else {
                    continue
                }

                let distance = goodyHutUnitAssignment.location.distance(to: explorer.location)

                var estimateTurns = Int.max
                if explorer.maxMoves(in: gameModel) >= 1 {
                    estimateTurns = distance / explorer.maxMoves(in: gameModel)
                }

                if estimateTurns < closestEstimateTurns {

                    // Now check path
                    let pathFinder = AStarPathfinder()
                    pathFinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: explorer.movementType(), for: player, unitMapType: .combat, canEmbark: true)

                    if pathFinder.shortestPath(fromTileCoord: explorer.location, toTileCoord: goodyHutUnitAssignment.location) != nil {

                        closestEstimateTurns = estimateTurns
                        hutLocation = goodyHutUnitAssignment.location
                    }
                }
            }

            if let hutLocation = hutLocation {

                goodyHutUnitAssignmentsCopy.removeAll(where: { $0.location == hutLocation })

                guard let index = self.goodyHutUnitAssignments.firstIndex(where: { $0.location == hutLocation }) else {
                    fatalError("cant find good hut assignment")
                }
                self.goodyHutUnitAssignments[index].unit = explorerRef
            }
        }
    }

    func scoreExplore(plot: HexPoint, for player: AbstractPlayer?, range: Int, domain: UnitDomainType, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let player = self.player else {
            fatalError("no player given")
        }

        var resultValue = 0
        let adjacencyBonus = 1
        let badScore = 10
        let goodScore = 100
        let reallyGoodScore = 200

        for evalPoint in plot.areaWith(radius: range) {

            if evalPoint == plot {
                continue
            }

            guard let evalTile = gameModel.tile(at: evalPoint) else {
                continue
            }

            if evalTile.isDiscovered(by: player) {
                continue
            }

            if gameModel.isAdjacentDiscovered(of: evalPoint, for: player) {

                if evalPoint.distance(to: plot) > 1 {

                    //CvPlot* pAdjacentPlot;
                    var viewBlocked = true
                    for adjacent in evalPoint.neighbors() {

                        guard let adjacentTile = gameModel.tile(at: adjacent) else {
                            continue
                        }

                        if adjacentTile.isDiscovered(by: player) {

                            let distance = adjacent.distance(to: plot)
                            if distance > range {
                                continue
                            }

                            // this cheats, because we can't be sure that between the target and the viewer
                            if evalTile.canSee(tile: adjacentTile, for: player, range: range, in: gameModel) {
                                viewBlocked = false
                            }

                            if !viewBlocked {
                                break
                            }
                        }
                    }

                    if viewBlocked {
                        continue
                    }
                }

                // "cheating" to look to see what the next tile is.
                // a human should be able to do this by looking at the transition from the tile to the next
                switch domain {
                case .sea:

                    //FeatureTypes eFeature = pEvalPlot->getFeatureType();
                    if evalTile.terrain().isWater() /*|| (eFeature != NO_FEATURE && GC.getFeatureInfo(eFeature)->isImpassable()))*/ {
                        resultValue += badScore
                    } else if evalTile.has(feature: .mountains) || evalTile.hasHills() /* || (eFeature != NO_FEATURE && GC.getFeatureInfo(eFeature)->getSeeThroughChange() > 0))*/ {
                        resultValue += goodScore
                    } else {
                        resultValue += reallyGoodScore
                    }

                case .land:
                    if evalTile.has(feature: .mountains) || evalTile.terrain().isWater() {
                        resultValue += badScore
                    } else if evalTile.hasHills() {
                        resultValue += reallyGoodScore
                    } else {
                        resultValue += goodScore
                    }
                default:
                    // NOOP
                    break
                }
            } else {
                resultValue += goodScore
            }

            let distance = plot.distance(to: evalPoint)
            resultValue += (range - distance) * adjacencyBonus
        }

        return resultValue
    }

    func advisorMessages() -> [AdvisorMessage] {

        var messages: [AdvisorMessage] = []

        for economicStrategyType in EconomicStrategyType.all {

            if self.economicStrategyAdoption.adopted(economicStrategy: economicStrategyType) {

                if let message = economicStrategyType.advisorMessage() {
                    messages.append(message)
                }
            }
        }

        return messages
    }

    /// Spend money buying plots
    func doPlotPurchases(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let militaryAI = player.militaryAI else {
            fatalError("cant get militaryAI")
        }

        guard let treasury = player.treasury else {
            fatalError("cant get treasury")
        }

        var bestCity: AbstractCity? = nil
        var bestPoint: HexPoint = HexPoint(x: -1, y: -1)

        // No plot buying when at war
        if militaryAI.adopted(militaryStrategy: .atWar) {
            return
        }

        // Set up the parameters
        var bestScore = 150 /* AI_GOLD_PRIORITY_MINIMUM_PLOT_BUY_VALUE */
        let currentCost = player.buyPlotCost()
        let goldForHalfCost = 1000 /* AI_GOLD_BALANCE_TO_HALVE_PLOT_BUY_MINIMUM */
        let balance = Int(treasury.value())

        // Let's always invest any money we have in plot purchases
        //  (LATER -- save up money to spend at newly settled cities)
        if currentCost < balance && goldForHalfCost > currentCost {

            // Lower our requirements if we're building up a sizable treasury
            let discountPercent = 50 * (balance - currentCost) / (goldForHalfCost - currentCost)
            bestScore = bestScore - (bestScore * discountPercent / 100)

            // Find the best city to buy a plot
            for loopCityRef in gameModel.cities(of: player) {

                guard let loopCity = loopCityRef else {
                    continue
                }

                //if loopCity.canBuyAnyPlot() {
                let (score, tempPoint) = loopCity.buyPlotScore(in: gameModel)

                if score > bestScore {
                    bestCity = loopCity
                    bestScore = score
                    bestPoint = tempPoint
                }
                //}
            }

            if let bestCity = bestCity {

                let cost = bestCity.buyPlotCost(at: bestPoint, in: gameModel)

                if self.canWithdrawMoneyForPurchase(of: .tile, amount: Int(cost), priority: bestScore) {
                    /*if (GC.getLogging() && GC.getAILogging())
                    {
                        CvString strLogString;
                        strLogString.Format("Buying plot, X: %d, Y: %d, Cost: %d, Balance (before buy): %d, Priority: %d", iBestX, iBestY,
                            iCost, m_pPlayer->GetTreasury()->GetGold(), iBestScore);
                        m_pPlayer->GetHomelandAI()->LogHomelandMessage(strLogString);
                    }*/
                    bestCity.doBuyPlot(at: bestPoint, in: gameModel)
                }

            }
        }
    }

    /// Returns true if have enough saved up for this purchase. May return false if have enough but higher priority requests have dibs on the gold.
    //  (Priority of -1 (default parameter) means use existing priority
    func canWithdrawMoneyForPurchase(of purchaseType: PurchaseType, amount: Int, priority: Int) -> Bool {

        // FIXME
        return true
    }
}
