//
//  City.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// Amenities https://www.youtube.com/watch?v=I_LH7BdkrWc

public enum CityError: Error {

    case tileOwned
    case tileOwnedByAnotherCity
    case tileWorkedAlready

    case cantWorkCenter
}

public protocol AbstractCity: AnyObject, Codable {

    var name: String { get }
    var player: AbstractPlayer? { get set }
    var leader: LeaderType { get } // for restore from file only
    var buildings: AbstractBuildings? { get }
    var wonders: AbstractWonders? { get }
    var districts: AbstractDistricts? { get }
    var location: HexPoint { get }

    var buildQueue: BuildQueue { get }

    var cityStrategy: CityStrategyAI? { get }
    var cityCitizens: CityCitizens? { get }
    var cityTourism: CityTourism? { get }
    var cityTradingPosts: AbstractCityTradingPosts? { get }
    var cityReligion: AbstractCityReligion? { get }
    var greatWorks: GreatWorks? { get }

    // static func found(name: String, at location: HexPoint, capital: Bool, owner: AbstractPlayer?) -> AbstractCity
    func initialize(in gameModel: GameModel?)

    func set(name: String)

    func isBarbarian() -> Bool
    func isHuman() -> Bool

    func foodConsumption() -> Double

    func isCapital() -> Bool
    func setIsCapital(to value: Bool)
    func setEverCapital(to value: Bool)
    func isOriginalCapital(in gameModel: GameModel?) -> Bool
    func originalLeader() -> LeaderType
    func set(originalLeader: LeaderType)
    func previousLeader() -> LeaderType
    func set(previousLeader: LeaderType)
    func doFoundMessage()

    func isEverCapital() -> Bool
    func cultureLevel() -> Int

    func population() -> Int
    func set(population: Int, reassignCitizen: Bool, in gameModel: GameModel?)
    func change(population: Int, reassignCitizen: Bool, in gameModel: GameModel?)

    func set(gameTurnFounded: Int)
    func gameTurnFounded() -> Int

    func doTurn(in gameModel: GameModel?)

    func kill(in gameModel: GameModel?)
    func preKill(in gameModel: GameModel?)
    func postKill(capital: Bool, tile: AbstractTile?, workPlotDistance: Int, owner: LeaderType, in gameModel: GameModel?)

    func has(district: DistrictType) -> Bool
    func location(of district: DistrictType) -> HexPoint?
    func has(building: BuildingType) -> Bool
    func has(wonder: WonderType) -> Bool
    func has(project: ProjectType) -> Bool

    func canTrain(unit: UnitType, in gameModel: GameModel?) -> Bool
    func canBuild(building: BuildingType, in gameModel: GameModel?) -> Bool
    func canBuild(wonder: WonderType, in gameModel: GameModel?) -> Bool
    func canBuild(wonder: WonderType, at point: HexPoint, in gameModel: GameModel?) -> Bool
    func bestLocation(for wonderType: WonderType, in gameModel: GameModel?) -> HexPoint?
    func canBuild(district districtType: DistrictType, in gameModel: GameModel?) -> Bool
    func canBuild(district districtType: DistrictType, at point: HexPoint, in gameModel: GameModel?) -> Bool
    func bestLocation(for districtType: DistrictType, in gameModel: GameModel?) -> HexPoint?
    func canBuild(project: ProjectType) -> Bool

    func startTraining(unit: UnitType)
    func startBuilding(building: BuildingType)
    func startBuilding(wonder: WonderType, at point: HexPoint, in gameModel: GameModel?)
    func startBuilding(district: DistrictType, at point: HexPoint, in gameModel: GameModel?)
    func startBuilding(project: ProjectType, at point: HexPoint, in gameModel: GameModel?)

    func canPurchase(unit unitType: UnitType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool
    func canPurchase(building buildingType: BuildingType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool

    func faithPurchaseCost(of unitType: UnitType, in gameModel: GameModel?) -> Double
    func faithPurchaseCost(of buildingType: BuildingType) -> Double
    func goldPurchaseCost(of unitType: UnitType, in gameModel: GameModel?) -> Double
    func goldPurchaseCost(of buildingType: BuildingType) -> Double

    @discardableResult
    func purchase(unit unitType: UnitType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool
    @discardableResult
    func purchase(district districtType: DistrictType, at location: HexPoint, in gameModel: GameModel?) -> Bool
    @discardableResult
    func purchase(building buildingType: BuildingType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool
    @discardableResult
    func purchase(project projectType: ProjectType, in gameModel: GameModel?) -> Bool

    func doSpawn(greatPerson: GreatPerson, in gameModel: GameModel?)

    func buildingProductionTurnsLeft(for buildingType: BuildingType) -> Int
    func unitProductionTurnsLeft(for unitType: UnitType) -> Int
    func districtProductionTurnsLeft(for districtType: DistrictType) -> Int
    func wonderProductionTurnsLeft(for wonderType: WonderType) -> Int

    func featureProduction() -> Double
    func changeFeatureProduction(change: Double)
    func setFeatureProduction(to: Double)

    func currentBuildableItem() -> BuildableItem?

    func foodPerTurn(in gameModel: GameModel?) -> Double
    func productionPerTurn(in gameModel: GameModel?) -> Double
    func goldPerTurn(in gameModel: GameModel?) -> Double
    func sciencePerTurn(in gameModel: GameModel?) -> Double
    func culturePerTurn(in gameModel: GameModel?) -> Double
    func faithPerTurn(in gameModel: GameModel?) -> Double
    func greatPeoplePointsPerTurn(in gameModel: GameModel?) -> GreatPersonPoints

    func foodBasket() -> Double
    func set(foodBasket: Double)
    func hasOnlySmallFoodSurplus() -> Bool // < 2 food surplus
    func hasFoodSurplus() -> Bool // < 4 food surplus
    func hasEnoughFood() -> Bool

    func lastTurnFoodHarvested() -> Double
    // ...
    func amenitiesModifier(in gameModel: GameModel?) -> Double
    func housingModifier(in gameModel: GameModel?) -> Double
    func lastTurnFoodEarned() -> Double
    func growthInTurns() -> Int
    func maxGrowthInTurns() -> Int

    func housingPerTurn(in gameModel: GameModel?) -> Double
    func baseHousing(in gameModel: GameModel?) -> Double
    func housingFromBuildings() -> Double
    func housingFromWonders(in gameModel: GameModel?) -> Double
    func housingFromDistricts(in gameModel: GameModel?) -> Double

    func amenitiesPerTurn(in gameModel: GameModel?) -> Double
    func amenitiesFromDistrict(in gameModel: GameModel?) -> Double
    func amenitiesFromWonders(in gameModel: GameModel?) -> Double
    func amenitiesFromBuildings() -> Double
    func amenitiesFromLuxuries() -> Double
    func amenitiesNeeded() -> Double
    func amenitiesForWarWeariness() -> Int
    func set(amenitiesForWarWeariness: Int)

    func maintenanceCostsPerTurn() -> Double

    func productionLastTurn() -> Double

    func resetLuxuries()
    func luxuriesNeeded(in gameModel: GameModel?) -> Double
    func add(luxury: ResourceType)
    func has(luxury: ResourceType) -> Bool
    func numberOfDifferentStrategicResources(in gameModel: GameModel?) -> Int

    func healthPoints() -> Int
    func set(healthPoints: Int)
    func add(healthPoints: Int)

    func add(damage: Int)
    func set(damage: Int)
    func damage() -> Int
    func maxHealthPoints() -> Int

    func power(in gameModel: GameModel?) -> Int
    func updateStrengthValue(in gameModel: GameModel?)
    func strengthValue() -> Int

    func garrisonedUnit() -> AbstractUnit?
    func hasGarrison() -> Bool
    func setGarrison(unit: AbstractUnit?)

    func combatStrength(against attacker: AbstractUnit?, in gameModel: GameModel?) -> Int
    func baseCombatStrength(in gameModel: GameModel?) -> Int
    func combatStrengthModifiers(against attacker: AbstractUnit?, in gameModel: GameModel?) -> [CombatModifier]

    func canRangeStrike() -> Bool
    func canRangeStrike(towards point: HexPoint) -> Bool
    func rangedCombatTargetLocations(in gameModel: GameModel?) -> [HexPoint]
    func isEnemyInRange(in gameModel: GameModel?) -> Bool
    func rangedCombatStrength(against defender: AbstractUnit?, on toTile: AbstractTile?) -> Int
    func defensiveStrength(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool, in gameModel: GameModel?) -> Int
    func doRangeAttack(at location: HexPoint, in gameModel: GameModel?) -> Bool
    func setMadeAttack(to madeAttack: Bool)
    func madeAttack() -> Bool

    func work(tile: AbstractTile) throws
    func isCoastal(in gameModel: GameModel?) -> Bool

    func isFeatureSurrounded() -> Bool

    func isBlockaded() -> Bool
    func setRouteToCapitalConnected(value connected: Bool)
    func isRouteToCapitalConnected() -> Bool

    func processSpecialist(specialistType: SpecialistType, change: Int)

    // military properties
    func threatValue() -> Int

    func lastTurnGarrisonAssigned() -> Int
    func setLastTurnGarrisonAssigned(turn: Int)

    @discardableResult
    func doBuyPlot(at point: HexPoint, in gameModel: GameModel?) -> Bool
    func numPlotsAcquired(by otherPlayer: AbstractPlayer?) -> Int
    func buyPlotCost(at point: HexPoint, in gameModel: GameModel?) -> Int?
    func buyPlotScore(in gameModel: GameModel?) -> (Int, HexPoint)
    func doAcquirePlot(at point: HexPoint, in gameModel: GameModel?)
    func changeNumPlotsAcquiredBy(otherPlayer: AbstractPlayer?, change: Int)
    func countNumImprovedPlots(in gameModel: GameModel?) -> Int

    func numLocalResources(of resourceType: ResourceType, in gameModel: GameModel?) -> Int
    func numLocalLuxuryResources(in gameModel: GameModel?) -> Int

    func isProductionAutomated() -> Bool
    func setProductionAutomated(to newValue: Bool, clear: Bool, in gameModel: GameModel?)

    func slots(for slotType: GreatWorkSlotType) -> Int

    // religion
    func religiousMajority() -> ReligionType
    func isHolyCity(for religion: ReligionType, in gameModel: GameModel?) -> Bool
    func isHolyCityOfAnyReligion(in gameModel: GameModel?) -> Bool
    func numReligiousCitizen() -> Int
    // religion modifier
    func religiousTradeRouteModifier() -> Int

    // loyalty
    func loyalty() -> Int
    func loyaltyState() -> LoyaltyState
    func loyaltyPressureFromNearbyCitizen(in gameModel: GameModel?) -> Double
    func loyaltyFromGovernors(in gameModel: GameModel?) -> Double
    func loyaltyFromHappiness(in gameModel: GameModel?) -> Double
    func loyaltyFromTradeRoutes(in gameModel: GameModel?) -> Double
    func loyaltyFromOthersEffects(in gameModel: GameModel?) -> Double

    // governors
    func governorType() -> GovernorType?
    func governor() -> Governor?
    func assign(governor: GovernorType?)
    func value(of governorType: GovernorType, in gameModel: GameModel?) -> Double
    func hasGovernorTitle(of title: GovernorTitleType) -> Bool

    // tourism
    func baseTourism(in gameModel: GameModel?) -> Double

    // intern
    func set(scratch: Int)
    func scratch() -> Int
}

public class LeaderWeightList: WeightedList<LeaderType> {

    override func fill() {

        for leaderType in LeaderType.all {
            self.add(weight: 0.0, for: leaderType)
        }
    }

    public func removeAll() {

        self.items.removeAll()
    }
}

// swiftlint:disable type_body_length file_length
public class City: AbstractCity {

    static let workRadius = 3

    enum CodingKeys: CodingKey {

        case name
        case population
        case location
        case leader
        case originalLeader
        case previousLeader
        case capital
        case everCapital
        case gameTurnFounded
        case razingTurns

        case districts
        case buildings
        case wonders
        case projects
        case buildQueue
        case cityCitizens
        case cityTourism
        case greatWorks
        case cityReligion
        case cityTradingPosts

        case healthPoints

        case isFeatureSurrounded
        case productionLastTurn
        case featureProduction

        case foodBasket
        case lastTurnFoodHarvested
        case lastTurnFoodEarned

        case cityStrategy

        case madeAttack
        case routeToCapitalConnectedThisTurn
        case routeToCapitalConnectedLastTurn
        case lastTurnGarrisonAssigned

        case luxuries

        case baseYieldRateFromSpecialists
        case extraSpecialistYield

        case productionAutomated

        case numPlotsAcquiredList

        case cheapestPlotInfluence
        case cultureStored
        case cultureLevel

        case loyalty
        case amenitiesForWarWeariness

        case governor
    }

    public var name: String
    var populationValue: Double
    public let location: HexPoint
    public var player: AbstractPlayer?
    private(set) public var leader: LeaderType // for restoring from file
    private var originalLeaderValue: LeaderType
    private var previousLeaderValue: LeaderType
    var capitalValue: Bool
    private var everCapitalValue: Bool // has this city ever been (or is) capital?
    private var gameTurnFoundedValue: Int

    public var districts: AbstractDistricts?
    public var buildings: AbstractBuildings? // buildings that are currently build in this city
    public var wonders: AbstractWonders?
    internal var projects: AbstractProjects? // projects that are currently build in this city
    public var buildQueue: BuildQueue
    public var cityCitizens: CityCitizens?
    public var cityTourism: CityTourism?
    public var greatWorks: GreatWorks?
    public var cityReligion: AbstractCityReligion?
    public var cityTradingPosts: AbstractCityTradingPosts?

    private var healthPointsValue: Int // 0..200
    private var threatVal: Int
    private var amenitiesForWarWearinessValue: Int

    private var isFeatureSurroundedValue: Bool
    private var productionLastTurnValue: Double = 1.0
    private var featureProductionValue: Double = 0

    var foodBasketValue: Double
    private var lastTurnFoodHarvestedValue: Double = 1.0
    private var lastTurnFoodEarnedValue: Double = 0.0

    public var cityStrategy: CityStrategyAI?

    private var madeAttackValue: Bool = false
    private var routeToCapitalConnectedThisTurn: Bool = false
    private var routeToCapitalConnectedLastTurn: Bool = false
    private var lastTurnGarrisonAssignedValue: Int = 0

    private var garrisonedUnitValue: AbstractUnit?

    private var luxuries: [ResourceType] = []

    // yields
    var baseYieldRateFromSpecialists: YieldList
    private var extraSpecialistYield: YieldList

    private var productionAutomatedValue: Bool

    private var numPlotsAcquiredList: LeaderWeightList

    private var cheapestPlotInfluenceValue: Int = 0
    private var cultureStoredValue: Double = 0.0
    private var cultureLevelValue: Int = 0

    // governor
    private var governorValue: GovernorType?

    // scratch
    private var scratchValue: Int = 0
    private var strengthVal: Int = 0
    private var loyaltyValue: Double = 100.0

    // MARK: constructor

    public init(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) {

        self.name = name
        self.location = location
        self.capitalValue = capital
        self.everCapitalValue = capital
        self.populationValue = 0
        self.gameTurnFoundedValue = 0

        self.buildQueue = BuildQueue()

        self.foodBasketValue = 1.0

        self.player = owner
        self.leader = owner!.leader
        self.originalLeaderValue = owner!.leader
        self.previousLeaderValue = .none

        self.isFeatureSurroundedValue = false
        self.threatVal = 0

        self.healthPointsValue = 200
        self.amenitiesForWarWearinessValue = 0

        self.baseYieldRateFromSpecialists = YieldList()
        self.baseYieldRateFromSpecialists.fill()

        self.extraSpecialistYield = YieldList()
        self.extraSpecialistYield.fill()

        self.productionAutomatedValue = false

        self.numPlotsAcquiredList = LeaderWeightList()
        self.numPlotsAcquiredList.fill()
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.populationValue = try container.decode(Double.self, forKey: .population)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.leader = try container.decode(LeaderType.self, forKey: .leader)
        self.originalLeaderValue = try container.decode(LeaderType.self, forKey: .originalLeader)
        self.previousLeaderValue = try container.decode(LeaderType.self, forKey: .previousLeader)
        self.capitalValue = try container.decode(Bool.self, forKey: .capital)
        self.everCapitalValue = try container.decode(Bool.self, forKey: .everCapital)
        self.gameTurnFoundedValue = try container.decode(Int.self, forKey: .gameTurnFounded)

        self.buildQueue = BuildQueue()

        self.foodBasketValue = 1.0

        self.isFeatureSurroundedValue = false
        self.threatVal = 0

        self.healthPointsValue = 200

        self.baseYieldRateFromSpecialists = YieldList()
        self.baseYieldRateFromSpecialists.fill()

        self.extraSpecialistYield = YieldList()
        self.extraSpecialistYield.fill()

        self.productionAutomatedValue = false

        self.numPlotsAcquiredList = LeaderWeightList()
        self.numPlotsAcquiredList.fill()

        self.districts = try container.decode(Districts.self, forKey: .districts)
        self.buildings = try container.decode(Buildings.self, forKey: .buildings)
        self.wonders = try container.decode(Wonders.self, forKey: .wonders)
        self.projects = try container.decode(Projects.self, forKey: .projects)
        self.buildQueue = try container.decode(BuildQueue.self, forKey: .buildQueue)
        self.cityCitizens = try container.decode(CityCitizens.self, forKey: .cityCitizens)
        self.cityTourism = try container.decode(CityTourism.self, forKey: .cityTourism)
        self.greatWorks = try container.decode(GreatWorks.self, forKey: .greatWorks)
        self.cityReligion = try container.decode(CityReligion.self, forKey: .cityReligion)
        self.cityTradingPosts = try container.decode(CityTradingPosts.self, forKey: .cityTradingPosts)

        self.healthPointsValue = try container.decode(Int.self, forKey: .healthPoints)

        self.isFeatureSurroundedValue = try container.decode(Bool.self, forKey: .isFeatureSurrounded)
        self.productionLastTurnValue = try container.decode(Double.self, forKey: .productionLastTurn)
        self.featureProductionValue = try container.decode(Double.self, forKey: .featureProduction)

        self.foodBasketValue = try container.decode(Double.self, forKey: .foodBasket)
        self.lastTurnFoodHarvestedValue = try container.decode(Double.self, forKey: .lastTurnFoodHarvested)
        self.lastTurnFoodEarnedValue = try container.decode(Double.self, forKey: .lastTurnFoodEarned)

        self.cityStrategy = try container.decode(CityStrategyAI.self, forKey: .cityStrategy)

        self.madeAttackValue = try container.decode(Bool.self, forKey: .madeAttack)
        self.routeToCapitalConnectedThisTurn = try container.decode(Bool.self, forKey: .routeToCapitalConnectedThisTurn)
        self.routeToCapitalConnectedLastTurn = try container.decode(Bool.self, forKey: .routeToCapitalConnectedLastTurn)
        self.lastTurnGarrisonAssignedValue = try container.decode(Int.self, forKey: .lastTurnGarrisonAssigned)

        // self.garrisonedUnitValue = try container.decode(CityCitizens.self, forKey: .cityCitizens): AbstractUnit? = nil

        self.luxuries = try container.decode([ResourceType].self, forKey: .luxuries)
        self.amenitiesForWarWearinessValue = try container.decodeIfPresent(Int.self, forKey: .amenitiesForWarWeariness) ?? 0

        // yields
        self.baseYieldRateFromSpecialists = try container.decode(YieldList.self, forKey: .baseYieldRateFromSpecialists)
        self.extraSpecialistYield = try container.decode(YieldList.self, forKey: .extraSpecialistYield)

        self.productionAutomatedValue = try container.decode(Bool.self, forKey: .productionAutomated)

        self.numPlotsAcquiredList = try container.decode(LeaderWeightList.self, forKey: .numPlotsAcquiredList)

        self.cheapestPlotInfluenceValue = try container.decode(Int.self, forKey: .cheapestPlotInfluence)
        self.cultureStoredValue = try container.decode(Double.self, forKey: .cultureStored)
        self.cultureLevelValue = try container.decode(Int.self, forKey: .cultureLevel)

        self.loyaltyValue = try container.decode(Double.self, forKey: .loyalty)

        self.governorValue = try container.decodeIfPresent(GovernorType.self, forKey: .governor)

        // setup
        self.districts?.city = self
        self.buildings?.city = self
        self.wonders?.city = self
        self.projects?.city = self
        self.cityCitizens?.city = self
        self.cityReligion?.city = self
        self.cityTourism?.city = self
        self.cityStrategy?.city = self
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.name, forKey: .name)
        try container.encode(self.populationValue, forKey: .population)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.player!.leader, forKey: .leader)
        try container.encode(self.originalLeaderValue, forKey: .originalLeader)
        try container.encode(self.previousLeaderValue, forKey: .previousLeader)
        try container.encode(self.capitalValue, forKey: .capital)
        try container.encode(self.everCapitalValue, forKey: .everCapital)
        try container.encode(self.gameTurnFoundedValue, forKey: .gameTurnFounded)

        try container.encode(self.districts as! Districts, forKey: .districts)
        try container.encode(self.buildings as! Buildings, forKey: .buildings)
        try container.encode(self.wonders as! Wonders, forKey: .wonders)
        try container.encode(self.projects as! Projects, forKey: .projects)
        try container.encode(self.buildQueue, forKey: .buildQueue)
        try container.encode(self.cityCitizens, forKey: .cityCitizens)
        try container.encode(self.cityTourism, forKey: .cityTourism)
        try container.encode(self.greatWorks, forKey: .greatWorks)
        try container.encode(self.cityReligion as! CityReligion, forKey: .cityReligion)
        try container.encode(self.cityTradingPosts as! CityTradingPosts, forKey: .cityTradingPosts)

        try container.encode(self.healthPointsValue, forKey: .healthPoints)

        try container.encode(self.isFeatureSurroundedValue, forKey: .isFeatureSurrounded)
        try container.encode(self.productionLastTurnValue, forKey: .productionLastTurn)
        try container.encode(self.featureProductionValue, forKey: .featureProduction)

        try container.encode(self.foodBasketValue, forKey: .foodBasket)
        try container.encode(self.lastTurnFoodHarvestedValue, forKey: .lastTurnFoodHarvested)
        try container.encode(self.lastTurnFoodEarnedValue, forKey: .lastTurnFoodEarned)

        try container.encode(self.cityStrategy, forKey: .cityStrategy)

        try container.encode(self.madeAttackValue, forKey: .madeAttack)
        try container.encode(self.routeToCapitalConnectedThisTurn, forKey: .routeToCapitalConnectedThisTurn)
        try container.encode(self.routeToCapitalConnectedLastTurn, forKey: .routeToCapitalConnectedLastTurn)
        try container.encode(self.lastTurnGarrisonAssignedValue, forKey: .lastTurnGarrisonAssigned)

        // try container.encode(self.featureProductionValue, forKey: .featureProduction)
        // private var garrisonedUnitValue: AbstractUnit? = nil

        try container.encode(self.luxuries, forKey: .luxuries)
        try container.encode(self.amenitiesForWarWearinessValue, forKey: .amenitiesForWarWeariness)

        try container.encode(self.baseYieldRateFromSpecialists, forKey: .baseYieldRateFromSpecialists)
        try container.encode(self.extraSpecialistYield, forKey: .extraSpecialistYield)

        try container.encode(self.productionAutomatedValue, forKey: .productionAutomated)

        try container.encode(self.numPlotsAcquiredList, forKey: .numPlotsAcquiredList)

        try container.encode(self.cheapestPlotInfluenceValue, forKey: .cheapestPlotInfluence)
        try container.encode(self.cultureStoredValue, forKey: .cultureStored)
        try container.encode(self.cultureLevelValue, forKey: .cultureLevel)

        try container.encode(self.loyaltyValue, forKey: .loyalty)

        try container.encodeIfPresent(self.governorValue, forKey: .governor)
    }

    public func set(name: String) {

        self.name = name
    }

    public func initialize(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        self.gameTurnFoundedValue = gameModel.currentTurn

        self.districts = Districts(city: self)
        self.buildings = Buildings(city: self)
        self.wonders = Wonders(city: self)
        self.projects = Projects(city: self)

        self.build(district: .cityCenter, at: self.location, in: gameModel)

        if self.capitalValue {
            do {
                try self.buildings?.build(building: .palace)
            } catch {
                fatalError("cant build palace")
            }
        }

        self.cityStrategy = CityStrategyAI(city: self)
        self.cityCitizens = CityCitizens(city: self)
        self.greatWorks = GreatWorks(city: self)
        self.cityReligion = CityReligion(city: self)
        self.cityTradingPosts = CityTradingPosts(city: self)
        self.cityTourism = CityTourism(city: self)

        self.cityCitizens?.initialize(in: gameModel)

        if player.leader.civilization().ability() == .allRoadsLeadToRome {
            self.cityTradingPosts?.buildTradingPost(for: player.leader)
        }

        if player.leader.ability() == .trajansColumn {
            // All founded cities start with a free monument in the City Center.
            try? self.buildings?.build(building: .monument)
        }

        // Update Proximity between this Player and all others
        for otherPlayer in gameModel.players where otherPlayer.leader != self.player?.leader {

            if otherPlayer.isAlive() && diplomacyAI.hasMet(with: otherPlayer) {
                // Fixme
                // Players do NOT have to know one another in order to calculate proximity.  Having this info available (even when they haven't met) can be useful
                player.doUpdateProximity(towards: otherPlayer, in: gameModel)
                otherPlayer.doUpdateProximity(towards: player, in: gameModel)
            }
        }

        self.doUpdateCheapestPlotInfluence(in: gameModel)

        // discover the surrounding area
        for pointToDiscover in self.location.areaWith(radius: 2) {

            if let tile = gameModel.tile(at: pointToDiscover) {
                tile.discover(by: self.player, in: gameModel)
            }
        }

        // Every city automatically creates a road on its tile, which remains even if the feature is pillaged or the city is razed.
        if let tile = gameModel.tile(at: self.location) {
            tile.set(route: .ancientRoad)
        }

        // claim ownership for direct neighbors (if not taken)
        for pointToClaim in self.location.areaWith(radius: 1) {

            if let tile = gameModel.tile(at: pointToClaim) {
                do {
                    // FIXME 
                    try tile.set(owner: self.player)
                    try tile.setWorkingCity(to: self)
                } catch {
                    // fatalError("cant set owner")
                }
            }
        }

        // Founded cities start with eight additional tiles.
        if player.leader.civilization().ability() == .motherRussia {

            let tiles = self.location.areaWith(radius: 2).shuffled()
            var additional = 0

            for pointToClaim in tiles {

                if let tile = gameModel.tile(at: pointToClaim) {

                    if !tile.hasOwner() && additional < 8 {
                        do {
                            try tile.set(owner: self.player)
                            try tile.setWorkingCity(to: self)

                            additional += 1
                        } catch {
                            // fatalError("cant set owner")
                        }
                    }
                }
            }
        }

        self.cityCitizens?.doFound(in: gameModel)

        self.player?.updatePlots(in: gameModel)

        if self.capitalValue {
            self.player?.set(capitalCity: self, in: gameModel)
        }

        self.set(population: 1, in: gameModel)
    }

    public func isBarbarian() -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        return player.isBarbarian()
    }

    public func isHuman() -> Bool {

           guard let player = self.player else {
               fatalError("cant get player")
           }

           return player.isHuman()
       }

    public func doFoundMessage() {

        print("show popup func doFoundMessage()")
        return
    }

    public func isCapital() -> Bool {

        return self.capitalValue
    }

    public func setIsCapital(to value: Bool) {

        self.capitalValue = value
    }

    public func setEverCapital(to value: Bool) {

        self.everCapitalValue = value
    }

    /*static func found(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) -> AbstractCity {
        
        let city = City(name: name, at: location, capital: capital, owner: owner)
        city.initialize()
        
        return city
    }*/

    // MARK: public methods

    public func doTurn(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        if self.damage() > 0 {
            // CvAssertMsg(m_iDamage <= GC.getMAX_CITY_HIT_POINTS(), "Somehow a city has more damage than hit points. Please show this to a gameplay programmer immediately.");

            var hitsHealed = 20 /* CITY_HIT_POINTS_HEALED_PER_TURN */
            if self.isCapital() {
                hitsHealed += 1
            }

            self.add(healthPoints: hitsHealed)
        }
        if self.damage() < 0 {
            self.set(damage: 0)
        }

        // setDrafted(false);
        // setAirliftTargeted(false);
        // setCurrAirlift(0);
        self.setMadeAttack(to: false)
        // GetCityBuildings()->SetSoldBuildingThisTurn(false);

        self.updateFeatureSurrounded(in: gameModel)

        self.cityStrategy?.turn(with: gameModel)

        self.cityCitizens?.doTurn(with: gameModel)

        // AI_doTurn();
        if !player.isHuman() {
            // AI_stealPlots();
        }

        // self.doResistanceTurn();

        let allowNoProduction = !self.doCheckProduction(in: gameModel)

        self.doGrowth(in: gameModel)

        // self.doUpdateIndustrialRouteToCapital();

        self.doProduction(allowNoProduction: allowNoProduction, in: gameModel)

        // self.doDecay();

        // self.doMeltdown();

        for loopPoint in self.location.areaWith(radius: City.workRadius) {

            if let loopPlot = gameModel.tile(at: loopPoint) {

                if cityCitizens.isWorked(at: loopPoint) {
                    loopPlot.doImprovement()
                }
            }
        }

        // Following function also looks at WLTKD stuff
        // self.doTestResourceDemanded();

        // Culture accumulation
        var currentCulture = self.culturePerTurn(in: gameModel)

        if self.player?.religion?.pantheon() == .religiousSettlements {
            // Border expansion rate is 15% faster.
            currentCulture *= 1.15
        }

        if currentCulture > 0 {
            self.updateCultureStored(to: self.cultureStored() + currentCulture)
        }

        // Enough Culture to acquire a new Plot?
        if self.cultureStored() >= self.cultureThreshold() {
            self.cultureLevelIncrease(in: gameModel)
        }

        // Resource Demanded Counter
        // if (GetResourceDemandedCountdown() > 0) {
        //     ChangeResourceDemandedCountdown(-1)

        //     if (GetResourceDemandedCountdown() == 0) {
                // Pick a Resource to demand
        //         self.doPickResourceDemanded();
        //   }
        // }

        self.updateStrengthValue(in: gameModel)
        self.updateLoyaltyValue(in: gameModel)

        self.doNearbyEnemy(in: gameModel)

        // Check for Achievements
        /*if(isHuman() && !GC.getGame().isGameMultiPlayer() && GET_PLAYER(GC.getGame().getActivePlayer()).isLocalPlayer()) {
            if(getJONSCulturePerTurn()>=100) {
                gDLL->UnlockAchievement( ACHIEVEMENT_CITY_100CULTURE );
            }
            if(getYieldRate(YIELD_GOLD)>=100) {
                gDLL->UnlockAchievement( ACHIEVEMENT_CITY_100GOLD );
            }
            if(getYieldRate(YIELD_SCIENCE)>=100 ) {
                gDLL->UnlockAchievement( ACHIEVEMENT_CITY_100SCIENCE );
            }
        }*/

        // sending notifications on when routes are connected to the capital
        if !self.isCapital() {

            /*CvNotifications* pNotifications = GET_PLAYER(m_eOwner).GetNotifications();
            if (pNotifications)
            {
                CvCity* pPlayerCapital = GET_PLAYER(m_eOwner).getCapitalCity();
                CvAssertMsg(pPlayerCapital, "No capital city?");

                if (m_bRouteToCapitalConnectedLastTurn != m_bRouteToCapitalConnectedThisTurn && pPlayerCapital)
                {
                    Localization::String strMessage;
                    Localization::String strSummary;

                    if (m_bRouteToCapitalConnectedThisTurn) // connected this turn
                    {
                        strMessage = Localization::Lookup( "TXT_KEY_NOTIFICATION_TRADE_ROUTE_ESTABLISHED" );
                        strSummary = Localization::Lookup("TXT_KEY_NOTIFICATION_SUMMARY_TRADE_ROUTE_ESTABLISHED");
                    }
                    else // lost connection this turn
                    {
                        strMessage = Localization::Lookup( "TXT_KEY_NOTIFICATION_TRADE_ROUTE_BROKEN" );
                        strSummary = Localization::Lookup("TXT_KEY_NOTIFICATION_SUMMARY_TRADE_ROUTE_BROKEN");
                    }

                    strMessage << getNameKey();
                    strMessage << pPlayerCapital->getNameKey();
                    pNotifications->Add( NOTIFICATION_GENERIC, strMessage.toUTF8(), strSummary.toUTF8(), -1, -1, -1 );
                }
            }*/

            self.routeToCapitalConnectedLastTurn = self.routeToCapitalConnectedThisTurn
        }
    }

    //    --------------------------------------------------------------------------------
    func doNearbyEnemy(in gameModel: GameModel?) {

        // Can't actually range strike
        if !self.canRangeStrike() {
            return
        }

        if self.madeAttack() {
            return
        }

        if self.isEnemyInRange(in: gameModel) {

            self.player?.notifications()?.add(notification: .cityCanShoot(cityName: self.name, location: self.location))
        }
    }

    public func isEnemyInRange(in gameModel: GameModel?) -> Bool {

        return !self.rangedCombatTargetLocations(in: gameModel).isEmpty
    }

    public func kill(in gameModel: GameModel?) {

        guard let plot = gameModel?.tile(at: self.location) else {
            fatalError("cant get tile")
        }

        let owner = self.leader
        let capital = self.isCapital()

        /*IDInfo* pUnitNode;
        CvUnit* pLoopUnit;
        pUnitNode = pPlot->headUnitNode();

        FFastSmallFixedList<IDInfo, 25, true, c_eCiv5GameplayDLL > oldUnits;

        while (pUnitNode != NULL)
        {
            oldUnits.insertAtEnd(pUnitNode);
            pUnitNode = pPlot->nextUnitNode((IDInfo*)pUnitNode);
        }

        pUnitNode = oldUnits.head();

        while (pUnitNode != NULL)
        {
            pLoopUnit = ::GetPlayerUnit(*pUnitNode);
            pUnitNode = oldUnits.next(pUnitNode);

            if (pLoopUnit)
            {
                if (pLoopUnit->IsImmobile() && !pLoopUnit->isCargo())
                {
                    pLoopUnit->kill(false);
                }
            }
        }*/

        self.preKill(in: gameModel)

        // get spies out of city
        /*CvCityEspionage* pCityEspionage = GetCityEspionage();
        if (pCityEspionage)
        {
            for (int i = 0; i < MAX_MAJOR_CIVS; i++)
            {
                int iAssignedSpy = pCityEspionage->m_aiSpyAssignment[i];
                // if there is a spy in the city
                if (iAssignedSpy != -1)
                {
                    GET_PLAYER((PlayerTypes)i).GetEspionage()->ExtractSpyFromCity(iAssignedSpy);
                }
            }
        }*/

        // Delete the city's information here!!!
        /*CvGameTrade* pkGameTrade = GC.getGame().GetGameTrade();
        if (pkGameTrade)
        {
            pkGameTrade->ClearAllCityTradeRoutes(plot(), true);
        }*/

        // save this before deleting the city
        let workPlotDistance = 4 // getWorkPlotDistance();
        self.player?.delete(city: self, in: gameModel)
        // GET_PLAYER(eOwner).GetCityConnections()->SetDirty();

        // clean up
        self.postKill(capital: capital, tile: plot, workPlotDistance: workPlotDistance, owner: owner, in: gameModel)
    }

    public func preKill(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get city citizens")
        }

        self.setProductionAutomated(to: false, clear: true, in: gameModel)
        self.set(population: 0, in: gameModel)

        player.tradeRoutes?.clearTradeRoutes(at: self.location)

        self.districts?.clear()
        self.buildings?.clear()
        self.wonders?.clear()

        self.cleanUpQueue(in: gameModel)

        for point in cityCitizens.workingTileLocations() {

            guard let tile = gameModel.tile(at: point) else {
                continue
            }

            if player.isEqual(to: tile.owner()) {
                do {
                    try tile.removeOwner()
                } catch {
                    fatalError("cant remove owner")
                }
            }
        }

        guard let cityTile = gameModel.tile(at: self.location) else {
            fatalError("cant get city tile")
        }

        do {
            try cityTile.set(city: nil)
        } catch {
            fatalError("cant remove city")
        }

        self.player?.updatePlots(in: gameModel)

        // self.player?.changeNumCities(by: -1)
        // gameModel?.changeNumCities(by: -1)
    }

    public func postKill(capital: Bool, tile: AbstractTile?, workPlotDistance: Int, owner: LeaderType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let owningPlayer = gameModel.player(for: owner) else {
            fatalError("cant get owning player")
        }

        // owningPlayer.CalculateNetHappiness();

        // Update Unit Maintenance for the player
        // owningPlayer.UpdateUnitProductionMaintenanceMod();

        // Update Proximity between this Player and all others
        for playerLoop in gameModel.players where playerLoop.leader != owner {

            guard playerLoop.isAlive() else {
                continue
            }

            guard playerLoop.hasMet(with: owningPlayer) else {
                continue
            }

            owningPlayer.doUpdateProximity(towards: playerLoop, in: gameModel)
            playerLoop.doUpdateProximity(towards: owningPlayer, in: gameModel)
        }

        guard let areaPoints = tile?.point.areaWith(radius: workPlotDistance) else {
            fatalError("cant get area points")
        }

        for pt in areaPoints {

            guard let loopTile = gameModel.tile(at: pt) else {
                continue
            }

            if loopTile.workingCity()?.location == self.location {
                do {
                    try loopTile.removeWorked()
                } catch {

                }
            }
        }

        if capital {
            owningPlayer.findNewCapital(in: gameModel)
            owningPlayer.set(hasLostCapital: true, to: self.player, in: gameModel)
            // GET_TEAM(owningPlayer.getTeam()).resetVictoryProgress();
        }

        tile?.set(improvement: .ruins)
    }

    public func updateStrengthValue(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let techs = self.player?.techs else {
            fatalError("cant get techs")
        }

        guard let cityBuildings = self.buildings else {
            fatalError("cant get buildings")
        }

        guard let tile = gameModel.tile(at: self.location) else {
            fatalError("cant get tile")
        }

        // Default Strength
        var strength = 600 /* CITY_STRENGTH_DEFAULT */

        // Population mod
        strength += self.population() * 25 /* CITY_STRENGTH_POPULATION_CHANGE */

        // Building Defense
        var buildingDefense = cityBuildings.defense()

        buildingDefense *= (100 + cityBuildings.defenseModifier())
        buildingDefense /= 100

        strength += buildingDefense

        // Garrisoned Unit
        var strengthFromUnits = 0
        if let garrisonedUnit = self.garrisonedUnit() {
            if !garrisonedUnit.isOutOfAttacks() {
                let maxHits = 100 /* MAX_HIT_POINTS */
                strengthFromUnits = garrisonedUnit.baseCombatStrength(ignoreEmbarked: true) * 100 * (maxHits - garrisonedUnit.damage()) / maxHits
            }
        }

        strength += (strengthFromUnits * 100) / 300 /* CITY_STRENGTH_UNIT_DIVISOR */

        // Tech Progress increases City Strength
        var techProgress = Double(techs.numberOfDiscoveredTechs()) * 100.0 / Double(TechType.all.count)

        // Want progress to be a value between 0 and 5
        techProgress = techProgress / 100.0 * 5 /* CITY_STRENGTH_TECH_BASE */
        let techExponent = 2.0 /* CITY_STRENGTH_TECH_EXPONENT */
        let techMultiplier = 2.0 /* CITY_STRENGTH_TECH_MULTIPLIER */

        // The way all of this adds up...
        // 25% of the way through the game provides an extra 3.12
        // 50% of the way through the game provides an extra 12.50
        // 75% of the way through the game provides an extra 28.12
        // 100% of the way through the game provides an extra 50.00

        var techMod = pow(techProgress, techExponent)
        techMod *= techMultiplier

        techMod *= 100    // Bring it back into hundreds
        // Adding a small amount to prevent small fp accuracy differences from generating
        // a different integer result on the Mac and PC. Assuming fTechMod is positive, round to nearest hundredth
        strength += Int(techMod + 0.005)

        var strengthMod = 0

        // Terrain mod
        if tile.hasHills() {
            strengthMod += 15 /* CITY_STRENGTH_HILL_MOD */
        }

        // Player-wide strength mod (Policies, etc.)
        // strengthMod += GET_PLAYER(getOwner()).GetCityStrengthMod();

        // Apply Mod
        strength *= (100 + strengthMod)
        strength /= 100

        self.strengthVal = strength

        // DLLUI->setDirty(CityInfo_DIRTY_BIT, true);
    }

    public func strengthValue() -> Int {

        return self.strengthVal
    }

    // Pressure from nearby Citizens.
    // Domestic Pressure = Age Factor * Sum of [ each Domestic Population * (10 - Distance Away) ]
    public func loyaltyPressureFromNearbyCitizen(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let area10 = HexArea(center: self.location, radius: 10)

        var domesticPressure: Double = 0.0

        for domesticCityRef in gameModel.cities(of: player, in: area10) {

            guard let domesticCity = domesticCityRef else {
                continue
            }

            let distance: Int = domesticCity.location.distance(to: self.location)
            var domesticCityPressure: Double = Double(domesticCity.population() * (10 - distance)) * player.currentAge().loyalityFactor()

            // Note that a Capital is counted twice: the first time with its Citizen Population affected by the Age Factor and the second time it is assumed to be in a Normal Age.
            if domesticCity.isCapital() {

                domesticCityPressure += Double(domesticCity.population() * (10 - distance)) * AgeType.normal.loyalityFactor()
            }

            // The Bread and Circuses project from a nearby Entertainment Complex or Water Park also has the effect of doubling the Citizen Population count, so a Bread and Circuses project in a highly populated city can be very powerful.
            if domesticCity.has(project: .breadAndCircuses) {

                domesticCityPressure *= 2
            }

            domesticPressure += domesticCityPressure
        }

        // Foreign Pressure = Sum of [ each Foreign Population * (10 - Distance Away) * Age Factor of Foreign Civ ]
        var foreignPressure: Double = 0.0

        for foreignCityRef in gameModel.cities(in: area10) {

            guard let foreignCity = foreignCityRef else {
                continue
            }

            // only foreign city
            guard foreignCity.leader != player.leader else {
                continue
            }

            guard let foreignPlayer = foreignCity.player else {
                continue
            }

            guard !foreignPlayer.isBarbarian() && !foreignPlayer.isFreeCity() && !foreignPlayer.isCityState() else {
                continue
            }

            let distance = foreignCity.location.distance(to: self.location)
            let foreignCityLoyalityFactor = foreignCity.player?.currentAge().loyalityFactor() ?? 1.0
            var foreignCityPressure: Double = Double(foreignCity.population()) * Double(10 - distance) * foreignCityLoyalityFactor

            // This final pressure value is capped at ±20. In other words, even if nearby cities have enough Citizens to exert more than 20 points of pressure, the final effect won't exceed +20 or -20.
            foreignCityPressure = min(20, max(-20, foreignCityPressure))

            foreignPressure += foreignCityPressure
        }

        // Pressure from Nearby Citizens = 10 * (Domestic - Foreign) / (minimum of [Domestic, Foreign] + 0.5)
        return 10.0 * (domesticPressure - foreignPressure) / (min(domesticPressure, foreignPressure) + 0.5)
    }

    public func loyaltyFromGovernors(in gameModel: GameModel?) -> Double {

        // The effect of domestic and foreign Governors.
        var loyaltyFromGovernors = 0.0
        // +8 Loyalty per turn for having any Governor assigned to that city (activated from the moment you assign the Governor, not the moment they actually become established).
        if self.governor() != nil {
            loyaltyFromGovernors += 8.0
        }

        // -2 Loyalty per turn if a foreign city has their Governor Amani, with the Emissary title, established in a city within 9 tiles.
        // +2 Loyalty per turn for having Governor Amani, with the Prestige title, established in another city within 9 tiles.
        // +4 Loyalty per turn for having Governor Victor, with the Garrison Commander title, established in another city within 9 tiles.

        return loyaltyFromGovernors
    }

    // Happiness of the citizens in the city.
    public func loyaltyFromHappiness(in gameModel: GameModel?) -> Double {

        var happinessOfTheCitizens: Double = 0.0

        switch self.amenitiesState(in: gameModel) {

        case .unrest, .unhappy, .revolt:
            happinessOfTheCitizens = -6.0
        case .displeased:
            happinessOfTheCitizens = -3.0
        case .content:
            happinessOfTheCitizens = 0.0
        case .happy:
            happinessOfTheCitizens = 3.0
        case .ecstatic:
            happinessOfTheCitizens = 6.0
        }

        return happinessOfTheCitizens
    }

    public func loyaltyFromTradeRoutes(in gameModel: GameModel?) -> Double {

        return 0
    }

    public func loyaltyFromWonders(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var loyaltyFromWonders: Double = 0.0

        var locationOfColosseum: HexPoint = .invalid

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            if city.has(wonder: .colosseum) {
                locationOfColosseum = city.location
            }
        }

        // colosseum - +2 Loyalty for every city in 6 tiles
        if self.has(wonder: .colosseum) || locationOfColosseum.distance(to: self.location) <= 6 {
            loyaltyFromWonders += 2.0
        }

        return loyaltyFromWonders
    }

    public func loyaltyFromOthersEffects(in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let government = player.government else {
            fatalError("cant get government")
        }

        // Other factors.
        var otherFactors: Double = 0.0

        // ////////////////////////////
        // policyCards
        // ////////////////////////////

        // +2 with the Limitanei policy card and if the city is garrisoned.
        if government.has(card: .limitanei) && self.hasGarrison() {
            otherFactors += 2.0
        }

        // +2 with the Praetorium policy card and if the city has a Governor.
        if government.has(card: .praetorium) && governor() != nil {
            otherFactors += 2.0
        }
        // +1-6 with the Communications Office policy card and if the city has a Governor.
        // +3 with the Colonial Offices policy card and if the city is not on your Capital Capital's continent.

        // ////////////////////////////
        // buildings
        // ////////////////////////////
        // +1 if the city has constructed a Monument.
        if self.has(building: .monument) {
            otherFactors += 1
        }
        // +8 if the city has constructed the Government Plaza.
        // -2 if the Audience Chamber has been constructed in the civilization's Government Plaza district and the city is without a Governor.

        // ////////////////////////////
        // additionally
        // ////////////////////////////
        // +3 if the city is following the religion you have founded.
        // -3 if you have founded a religion and the city doesn't follow it.
        // -5 if the city is Occupied (which may be negated by keeping a unit garrisoned in it).
        // Variable penalty to Loyalty if the city has been conquered and you have lots of Grievances Grievances with its founder.
        // -4 if the city is facing starvation (for example, if its Farms have been pillaged).
        // +10 as a base level for Free Cities.
        // +20 as a base level for city-states.

        // ////////////////////////////
        // finally
        // ////////////////////////////
        // +4 for English cities on a separate continent from the Capital Capital with a Royal Navy Dockyard.
        // +2 for Spanish cities on a separate continent from their Capital Capital with a Mission adjacent to their City Center.
        // +3 for Zulu cities with a garrisoned unit, increased to +5 if unit is a Corps or Army.
        // +5 for Persian cities with a garrisoned unit.
        // +2 for Dutch cities per each starting domestic Trade Route Trade Route.
        // +2 for Swedish cities with an Open-Air Museum.
        // +2 from having the Colosseum Wonder within 6 tiles.

        return otherFactors
    }

    // https://civilization.fandom.com/wiki/Loyalty_(Civ6)
    func updateLoyaltyValue(in gameModel: GameModel?) {

        var loyalty: Double = 0.0

        loyalty += self.loyaltyPressureFromNearbyCitizen(in: gameModel)
        loyalty += self.loyaltyFromGovernors(in: gameModel)
        loyalty += self.loyaltyFromWonders(in: gameModel)
        loyalty += self.loyaltyFromHappiness(in: gameModel)
        loyalty += self.loyaltyFromTradeRoutes(in: gameModel)
        loyalty += self.loyaltyFromOthersEffects(in: gameModel)

        self.loyaltyValue = loyalty

        // https://civilization.fandom.com/wiki/Loyalty_(Civ6)#Free_Cities
        if self.loyaltyValue < 0 {

            // become a free city
            self.doRevolt(in: gameModel)
        }
    }

    func doRevolt(in gameModel: GameModel?) {

        guard let oldPlayer = self.player else {
            fatalError("cant get player")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get city citizens")
        }

        // inform user
        if oldPlayer.isHuman() {
            // our own city revolted
            gameModel?.userInterface?.showPopup(popupType: .cityRevolted(city: self))
        } else if oldPlayer.hasMet(with: gameModel?.humanPlayer()) {
            // foreign city revolted
            gameModel?.userInterface?.showPopup(popupType: .foreignCityRevolted(city: self))
        }

        let newPlayer = gameModel?.freeCityPlayer()

        // hide city to old player
        gameModel?.conceal(city: self)

        self.leader = .freeCities
        self.player = newPlayer

        // reveal city to new 'owner'
        gameModel?.sight(city: self)

        // update owned tiles
        for loopPoint in cityCitizens.workingTileLocations() {

            guard let loopTile = gameModel?.tile(at: loopPoint) else {
                continue
            }

            // hm, maybe this is too much?
            guard loopTile.ownerLeader() == oldPlayer.leader else {
                continue
            }

            do {
                try loopTile.change(owner: newPlayer)
            } catch {
                fatalError("could not change owner: \(error)")
            }
        }

        oldPlayer.updatePlots(in: gameModel)
        newPlayer?.updatePlots(in: gameModel)

        // update UI
        gameModel?.userInterface?.update(city: self)

        if self.capitalValue {

            oldPlayer.findNewCapital(in: gameModel)
            oldPlayer.set(hasLostCapital: true, to: newPlayer, in: gameModel)
        }
    }

    public func loyalty() -> Int {

        return Int(self.loyaltyValue)
    }

    public func loyaltyState() -> LoyaltyState {

        // Loyal (76-100): no penalties.
        if self.loyaltyValue > 75.0 {
            return .loyal
        }

        // Wavering Loyalty (51-75): 75% Citizen Population growth, -25% to all yields.
        if self.loyaltyValue > 50.0 {
            return .wavering
        }

        // Disloyal (26-50): 25% Citizen Population growth, -50% to all yields.
        if self.loyaltyValue > 25.0 {
            return .disloyal
        }

        // Unrest (1-25): no Citizen Population growth, -100% to all yields, meaning that the city effectively becomes non-functional.
        return .unrest
    }

    public func governor() -> Governor? {

        if let governorType = self.governorValue {
            return self.player?.governors?.governor(with: governorType)
        }

        return nil
    }

    public func governorType() -> GovernorType? {

        return self.governorValue
    }

    public func assign(governor: GovernorType?) {

        self.governorValue = governor
    }

    public func value(of governorType: GovernorType, in gameModel: GameModel?) -> Double {

        let oldGovernor = self.governorType()

        // reset
        self.assign(governor: nil)

        let oldFood = self.foodPerTurn(in: gameModel)
        let oldProduction = self.productionPerTurn(in: gameModel)
        let oldGold = self.goldPerTurn(in: gameModel)

        // test
        self.assign(governor: governorType)

        let newFood = self.foodPerTurn(in: gameModel)
        let newProduction = self.productionPerTurn(in: gameModel)
        let newGold = self.goldPerTurn(in: gameModel)

        // restore
        self.assign(governor: oldGovernor)

        return (newFood - oldFood).positiveValue +
            (newProduction - oldProduction).positiveValue +
            (newGold - oldGold).positiveValue
    }

    public func hasGovernorTitle(of title: GovernorTitleType) -> Bool {

        if let governor = self.governorValue {

            if governor.defaultTitle() == title {
                return true
            }

            if let governor = self.governor() {
                return governor.has(title: title)
            }
        }

        return false
    }

    func numOfGovernorTitles() -> Int {

        if let governor = self.governor() {
            return governor.titles.count - 1 // default title is already included
        }

        return 0
    }

    public func lastTurnFoodHarvested() -> Double {

        return self.lastTurnFoodHarvestedValue
    }

    private func setLastTurn(foodHarvested: Double) {

        self.lastTurnFoodHarvestedValue = foodHarvested
    }

    public func lastTurnFoodEarned() -> Double {

        return self.lastTurnFoodEarnedValue
    }

    private func setLastTurn(foodEarned: Double) {

        self.lastTurnFoodEarnedValue = foodEarned
    }

    func amountOfNearby(resource: ResourceType, in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var resourceValue = 0.0

        for neighbor in self.location.areaWith(radius: 2) {

            if let neighborTile = gameModel.tile(at: neighbor) {
                if neighborTile.resource(for: self.player) == resource {
                    resourceValue += 1.0
                }
            }
        }

        return resourceValue
    }

    func amountOfNearby(terrain: TerrainType, in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var terrainValue = 0.0

        for neighbor in self.location.areaWith(radius: 2) {

            if let neighborTile = gameModel.tile(at: neighbor) {
                if neighborTile.terrain() == terrain {
                    terrainValue += 1.0
                }
            }
        }

        return terrainValue
    }

    public func resetLuxuries() {

        self.luxuries = []
    }

    public func luxuriesNeeded(in gameModel: GameModel?) -> Double {

        let amenitiesFromBuildings = self.amenitiesFromBuildings()
        let amenitiesFromWonders = self.amenitiesFromWonders(in: gameModel)
        return Double(self.population()) - 2.0 - Double(self.luxuries.count) - amenitiesFromBuildings - amenitiesFromWonders
    }

    public func add(luxury: ResourceType) {

        guard luxury.usage() == .luxury else {
            fatalError("resource must be luxury")
        }

        self.luxuries.append(luxury)
    }

    public func has(luxury: ResourceType) -> Bool {

        return self.luxuries.contains(luxury)
    }

    public func amenitiesFromLuxuries() -> Double {

        return Double(self.luxuries.count)
    }

    public func amenitiesFromBuildings() -> Double {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var amenitiesFromBuildings: Double = 0.0

        // gather amenities from buildingss
        for building in BuildingType.all {
            if buildings.has(building: building) {
                amenitiesFromBuildings += Double(building.amenities())
            }
        }

        return amenitiesFromBuildings
    }

    public func amenitiesFromWonders(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var locationOfColosseum: HexPoint = .invalid

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            if city.has(wonder: .colosseum) {
                locationOfColosseum = city.location
            }
        }

        var amenitiesFromWonders: Double = 0.0

        // gather amenities from buildingss
        for wonder in WonderType.all {
            if self.has(wonder: wonder) {
                amenitiesFromWonders += Double(wonder.amenities())
            }
        }

        // temple of artemis
        if self.has(wonder: .templeOfArtemis) {
            for loopPoint in self.location.areaWith(radius: 3) {

                guard let loopTile = gameModel.tile(at: loopPoint) else {
                    continue
                }
                if loopTile.has(improvement: .camp) || loopTile.has(improvement: .pasture) || loopTile.has(improvement: .plantation) {
                    // Each Camp, Pasture, and Plantation improvement within 4 tiles of this wonder provides +1 Amenities6 Amenity.
                    amenitiesFromWonders += 1.0
                }
            }
        }

        // colosseum - +2 [Culture] Culture, +2 Loyalty, +2 [Amenities] Amenities from entertainment
        // to each City Center within 6 tiles.
        if self.has(wonder: .colosseum) || locationOfColosseum.distance(to: self.location) <= 6 {
            amenitiesFromWonders += 2.0
        }

        return amenitiesFromWonders
    }

    // amenities from districts
    public func amenitiesFromDistrict(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var amenitiesFromDistrict: Double = 0.0

        // "All cities with a district receive +1 Housing6 Housing and +1 Amenities6 Amenity."
        if government.currentGovernment() == .classicalRepublic {

            if districts.hasAny() {
                amenitiesFromDistrict += 1.0
            }
        }

        if self.has(district: .holySite) {

            // riverGoddess - +2 [Amenities] Amenities and +2 [Housing] Housing to cities if they have a Holy Site district adjacent to a River.
            if let holySiteLocation = self.location(of: .holySite) {

                var isHolySiteAdjacentToRiver = false

                for neighbor in holySiteLocation.neighbors() {

                    if gameModel.river(at: neighbor) {
                        isHolySiteAdjacentToRiver = true
                        break
                    }
                }

                if isHolySiteAdjacentToRiver {
                    amenitiesFromDistrict += 2.0
                }
            }
        }

        return amenitiesFromDistrict
    }

    private func amenitiesFromTiles(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var amenitiesFromTiles: Double = 0.0

        var hueyTeocalliLocation: HexPoint = .invalid
        if player.has(wonder: .hueyTeocalli, in: gameModel) {
            for point in cityCitizens.workingTileLocations() {
                if cityCitizens.isWorked(at: point) {
                    if let adjacentTile = gameModel.tile(at: point) {
                        if adjacentTile.has(wonder: .hueyTeocalli) {
                            hueyTeocalliLocation = point
                        }
                    }
                }
            }
        }

        // +1 Amenity from entertainment for each Lake tile within one tile of Huey Teocalli.
        // (This includes the Lake tile where the wonder is placed.)
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                // if let adjacentTile = gameModel.tile(at: point) {
                if point == hueyTeocalliLocation || point.isNeighbor(of: hueyTeocalliLocation) {
                    amenitiesFromTiles += 1
                }
                // }
            }
        }

        return amenitiesFromTiles
    }

    public func amenitiesFromCivics(in gameModel: GameModel?) -> Double {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        var amenitiesFromCivics: Double = 0.0

        // Retainers - +1 Amenity in cities with a garrisoned unit.
        if government.has(card: .retainers) {
            if self.garrisonedUnitValue != nil {
                amenitiesFromCivics += 1
            }
        }

        // Civil Prestige - +1 Amenity and +2 Housing in cities with established Governors with 2+ promotions.
        if government.has(card: .retainers) {
            if let governor = self.governorValue {
                if governor.titles().count >= 2 {
                    amenitiesFromCivics += 1
                }
            }
        }

        // Liberalism - +1 Amenity in cities with 2+ specialty districts.
        if government.has(card: .liberalism) {
            if districts.numberOfBuiltDistricts() >= 2 {
                amenitiesFromCivics += 1
            }
        }

        // Police State - -2 Spy operation level in your lands. -1 Amenity in all cities.
        if government.has(card: .policyState) {
            amenitiesFromCivics -= 1
        }

        // New Deal - +2 Amenities and +4 Housing in all cities with 3+ specialty districts.
        if government.has(card: .newDeal) {
            if districts.numberOfBuiltDistricts() >= 3 {
                amenitiesFromCivics += 2
            }
        }

        /*
         - Sports Media    +100% Theater Square adjacency bonuses, and Stadiums generate +1 Amenities Amenity.
         - Music Censorship    Other civs' Rock Bands cannot enter your territory. -1 Amenities Amenity in all cities.
         - Robber Barons    +50% Gold Gold in cities with a Stock Exchange. +25% Production Production in cities with a Factory.
            BUT: -2 Amenities Amenities in all cities.
         - Automated Workforce    +20% Production Production towards city projects.
            BUT: -1 Amenities Amenity and -5 Loyalty in all cities.
         */

        return amenitiesFromCivics
    }

    public func amenitiesPerTurn(in gameModel: GameModel?) -> Double {

        var amenitiesPerTurn: Double = 0.0

        amenitiesPerTurn += self.amenitiesFromTiles(in: gameModel)
        amenitiesPerTurn += self.amenitiesFromLuxuries()
        amenitiesPerTurn += self.amenitiesFromDistrict(in: gameModel)
        amenitiesPerTurn += self.amenitiesFromBuildings()
        amenitiesPerTurn += self.amenitiesFromWonders(in: gameModel)
        amenitiesPerTurn += self.amenitiesFromCivics(in: gameModel)

        return amenitiesPerTurn
    }

    public func amenitiesForWarWeariness() -> Int {

        return self.amenitiesForWarWearinessValue
    }

    public func set(amenitiesForWarWeariness: Int) {

        self.amenitiesForWarWearinessValue = amenitiesForWarWeariness
    }

    public func amenitiesNeeded() -> Double {

        return max(0, self.populationValue - 2.0) + Double(self.amenitiesForWarWearinessValue)
    }

    public func amenitiesState(in gameModel: GameModel?) -> AmenitiesState {

        let amenities = self.amenitiesPerTurn(in: gameModel)
        let amenitiesDiff = amenities - self.populationValue + 2.0 // first two people dont need amentities

        if amenitiesDiff >= 3.0 {
            return .ecstatic
        } else if amenitiesDiff == 1.0 || amenitiesDiff == 2.0 {
            return .happy
        } else if amenitiesDiff == 0.0 {
            return .content
        } else if amenitiesDiff == -1.0 || amenitiesDiff == -2.0 {
            return .displeased
        } else if amenitiesDiff == -3.0 || amenitiesDiff == -4.0 {
            return .unhappy
        } else if amenitiesDiff == -5.0 || amenitiesDiff == -6.0 {
            return .unrest
        } else {
            return .revolt
        }
    }

    // https://civilization.fandom.com/wiki/Amenities_(Civ6)
    public func amenitiesModifier(in gameModel: GameModel?) -> Double {

        switch self.amenitiesState(in: gameModel) {

        case .ecstatic: return 1.2
        case .happy: return 1.1
        case .content: return 1.0
        case .displeased: return 0.85
        case .unhappy: return 0.70
        case .unrest: return 0.0
        case .revolt: return 0.0
        }
    }

    // https://civilization.fandom.com/wiki/Housing_(Civ6)
    public func housingModifier(in gameModel: GameModel?) -> Double {

        let housing = self.housingPerTurn(in: gameModel)
        let housingDiff = Int(housing) - Int(self.populationValue)

        if housingDiff >= 2 { // 2 or more    100%
            return 1.0
        } else if housingDiff == 1 { // 1    50%
            return 0.5
        } else if 0 <= housingDiff && housingDiff <= -4 { // 0 to -4    25%
            return 0.25
        } else { // -5 or less    0%
            return 0.0
        }
    }

    public func doGrowth(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var wonderModifier: Double = 1.0

        // hanging gardens
        if player.has(wonder: .hangingGardens, in: gameModel) {
            // Increases growth by 15% in all cities.
            wonderModifier += 0.15
        }

        // fertilityRites
        if player.religion?.pantheon() == .fertilityRites {
            // City growth rate is 10% higher.
            wonderModifier = 0.10
        }

        // update housing value
        self.buildings?.updateHousing()
        self.districts?.updateHousing()

        let foodPerTurn = self.foodPerTurn(in: gameModel)
        self.setLastTurn(foodHarvested: foodPerTurn)
        let foodEatenPerTurn = self.foodConsumption()
        var foodDiff = foodPerTurn - foodEatenPerTurn

        if foodDiff < 0 {

            // notify human about starvation
            if player.isHuman() {
                self.player?.notifications()?.add(notification: .starving(cityName: self.name, location: self.location))
            }
        }

        // housing
        foodDiff *= self.housingModifier(in: gameModel)

        // amenities
        foodDiff *= self.amenitiesModifier(in: gameModel)

        // wonder - fixme move to function
        foodDiff *= wonderModifier

        self.setLastTurn(foodEarned: foodDiff)

        self.set(foodBasket: self.foodBasket() + foodDiff)

        if self.foodBasket() >= self.growthThreshold() {

            if cityCitizens.isForcedAvoidGrowth() {
                // don't grow a city, if we are at avoid growth
                self.set(foodBasket: self.growthThreshold())
            } else {
                self.set(foodBasket: 0)
                self.set(population: self.population() + 1, in: gameModel)

                gameModel.userInterface?.update(city: self)

                // Only show notification if the city is small
                if self.populationValue <= 5 {

                    if player.isHuman() {
                        self.player?.notifications()?.add(
                            notification: .cityGrowth(
                                cityName: self.name,
                                population: self.population(),
                                location: self.location
                            )
                        )
                    }
                }

                // moments
                if self.populationValue > 10 {
                    if !player.hasMoment(of: .firstBustlingCity(cityName: self.name)) &&
                        !player.hasMoment(of: .worldsFirstBustlingCity(cityName: self.name)) {

                        // check if someone else already had a bustling city
                        if gameModel.anyHasMoment(of: .worldsFirstBustlingCity(cityName: self.name)) {
                            player.addMoment(of: .firstBustlingCity(cityName: self.name), in: gameModel)
                        } else {
                            player.addMoment(of: .worldsFirstBustlingCity(cityName: self.name), in: gameModel)
                        }
                    }
                }

                if self.populationValue > 15 {
                    if !player.hasMoment(of: .firstLargeCity(cityName: self.name)) &&
                        !player.hasMoment(of: .worldsFirstLargeCity(cityName: self.name)) {

                        // check if someone else already had a bustling city
                        if gameModel.anyHasMoment(of: .worldsFirstLargeCity(cityName: self.name)) {
                            player.addMoment(of: .firstLargeCity(cityName: self.name), in: gameModel)
                        } else {
                            player.addMoment(of: .worldsFirstLargeCity(cityName: self.name), in: gameModel)
                        }
                    }
                }

                if self.populationValue > 20 {
                    if !player.hasMoment(of: .firstEnormousCity(cityName: self.name)) &&
                        !player.hasMoment(of: .worldsFirstEnormousCity(cityName: self.name)) {

                        // check if someone else already had a bustling city
                        if gameModel.anyHasMoment(of: .worldsFirstEnormousCity(cityName: self.name)) {
                            player.addMoment(of: .firstEnormousCity(cityName: self.name), in: gameModel)
                        } else {
                            player.addMoment(of: .worldsFirstEnormousCity(cityName: self.name), in: gameModel)
                        }
                    }
                }

                if self.populationValue > 25 {
                    if !player.hasMoment(of: .firstGiganticCity(cityName: self.name)) &&
                        !player.hasMoment(of: .worldsFirstGiganticCity(cityName: self.name)) {

                        // check if someone else already had a bustling city
                        if gameModel.anyHasMoment(of: .worldsFirstGiganticCity(cityName: self.name)) {
                            player.addMoment(of: .firstGiganticCity(cityName: self.name), in: gameModel)
                        } else {
                            player.addMoment(of: .worldsFirstGiganticCity(cityName: self.name), in: gameModel)
                        }
                    }
                }
            }
        } else if self.foodBasket() < 0 {

            self.set(foodBasket: 0)

            if self.population() > 1 {
                self.set(population: self.population() - 1, in: gameModel)
            }
        }
    }

    public func growthInTurns() -> Int {

        let foodNeeded = self.growthThreshold() - self.foodBasket()

        if self.lastTurnFoodEarned() == 0.0 {
            return 0
        }

        if self.populationValue == 0 {
            return 0
        }

        return Int(foodNeeded / self.lastTurnFoodEarned())
    }

    public func maxGrowthInTurns() -> Int {

        let foodNeeded = self.growthThreshold()

        if self.lastTurnFoodEarned() == 0.0 {
            return Int(foodNeeded)
        }

        if self.populationValue == 0 {
            return 0
        }

        return Int(foodNeeded / self.lastTurnFoodEarned())
    }

    func doCheckProduction(in gameModel: GameModel?) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var okay = true

        // let maxedUnitGoldPercent = 100 /* MAXED_UNIT_GOLD_PERCENT*/
        // let maxedBuildingGoldPercent = 100 /* MAXED_BUILDING_GOLD_PERCENT */
        // let maxedProjectGoldPercent = 300 /* MAXED_PROJECT_GOLD_PERCENT */

        /*for unitType in UnitType.all {
            
            let unitProduction = self.unitProduction(of: unitType)
            if unitProduction > 0 {
                
                if player.isProductionMaxedUnitClass((UnitClassTypes)(pkUnitInfo)->GetUnitClassType()) {
                    
                    let productionGold = ((unitProduction * maxedUnitGoldPercent) / 100)

                    if productionGold > 0 {
                        
                        player.GetTreasury()->ChangeGold(iProductionGold);

                        if (getOwner() == GC.getGame().getActivePlayer())
                        {
                            Localization::String localizedText = Localization::Lookup("TXT_KEY_MISC_LOST_WONDER_PROD_CONVERTED");
                            localizedText << getNameKey() << GC.getUnitInfo((UnitTypes)iI)->GetTextKey() << iProductionGold;
                            DLLUI->AddCityMessage(0, GetIDInfo(), getOwner(), false, GC.getEVENT_MESSAGE_TIME(), localizedText.toUTF8());
                        }
                    }

                    setUnitProduction(((UnitTypes)iI), 0);
                }
            }
        }*/

        /*for buildingType in BuildingType.all {
            
            const BuildingTypes eExpiredBuilding = static_cast<BuildingTypes>(iI);
            CvBuildingEntry* pkExpiredBuildingInfo = GC.getBuildingInfo(eExpiredBuilding);

            //skip if null
            if(pkExpiredBuildingInfo == NULL)
                continue;

            int iBuildingProduction = m_pCityBuildings->GetBuildingProduction(eExpiredBuilding);
            if (iBuildingProduction > 0)
            {
                const BuildingClassTypes eExpiredBuildingClass = (BuildingClassTypes) (pkExpiredBuildingInfo->GetBuildingClassType());

                if (thisPlayer.isProductionMaxedBuildingClass(eExpiredBuildingClass))
                {
                    // Beaten to a world wonder by someone?
                    if (isWorldWonderClass(pkExpiredBuildingInfo->GetBuildingClassInfo()))
                    {
                        for (iPlayerLoop = 0; iPlayerLoop < MAX_MAJOR_CIVS; iPlayerLoop++)
                        {
                            eLoopPlayer = (PlayerTypes) iPlayerLoop;

                            // Found the culprit
                            if (GET_PLAYER(eLoopPlayer).getBuildingClassCount(eExpiredBuildingClass) > 0)
                            {
                                GET_PLAYER(getOwner()).GetDiplomacyAI()->ChangeNumWondersBeatenTo(eLoopPlayer, 1);
                                break;
                            }
                        }

                        auto_ptr<ICvCity1> pDllCity(new CvDllCity(this));
                        DLLUI->AddDeferredWonderCommand(WONDER_REMOVED, pDllCity.get(), (BuildingTypes) eExpiredBuilding, 0);
                        //Add "achievement" for sucking it up
                        gDLL->IncrementSteamStatAndUnlock( ESTEAMSTAT_BEATWONDERS, 10, ACHIEVEMENT_SUCK_AT_WONDERS );
                    }

                    iProductionGold = ((iBuildingProduction * iMaxedBuildingGoldPercent) / 100);

                    if (iProductionGold > 0)
                    {
                        thisPlayer.GetTreasury()->ChangeGold(iProductionGold);

                        if (getOwner() == GC.getGame().getActivePlayer())
                        {
                            Localization::String localizedText = Localization::Lookup("TXT_KEY_MISC_LOST_WONDER_PROD_CONVERTED");
                            localizedText << getNameKey() << pkExpiredBuildingInfo->GetTextKey() << iProductionGold;
                            DLLUI->AddCityMessage(0, GetIDInfo(), getOwner(), false, GC.getEVENT_MESSAGE_TIME(), localizedText.toUTF8());
                        }
                    }

                    m_pCityBuildings->SetBuildingProduction(eExpiredBuilding, 0);
                }
            }
        }*/

        /*for projectType in ProjectType.all {
            
            int iProjectProduction = getProjectProduction((ProjectTypes)iI);
            if (iProjectProduction > 0)
            {
                if (thisPlayer.isProductionMaxedProject((ProjectTypes)iI))
                {
                    iProductionGold = ((iProjectProduction * iMaxedProjectGoldPercent) / 100);

                    if (iProductionGold > 0)
                    {
                        thisPlayer.GetTreasury()->ChangeGold(iProductionGold);

                        if (getOwner() == GC.getGame().getActivePlayer())
                        {
                            Localization::String localizedText = Localization::Lookup("TXT_KEY_MISC_LOST_WONDER_PROD_CONVERTED");
                            localizedText << getNameKey() << GC.getProjectInfo((ProjectTypes)iI)->GetTextKey() << iProductionGold;
                            DLLUI->AddCityMessage(0, GetIDInfo(), getOwner(), false, GC.getEVENT_MESSAGE_TIME(), localizedText.toUTF8());
                        }
                    }

                    setProjectProduction(((ProjectTypes)iI), 0);
                }
            }
        }*/

        if !self.isProduction() && player.isHuman() && !self.isProductionAutomated() {

            self.player?.notifications()?.add(notification: .productionNeeded(cityName: self.name, location: self.location))
            return okay
        }

        // Can now construct an Upgraded version of this Unit
        /*for (iI = 0; iI < iNumUnitInfos; iI++)
        {
            if (getFirstUnitOrder((UnitTypes)iI) != -1)
            {
                // If we can still actually train this Unit type then don't auto-upgrade it yet
                if (canTrain((UnitTypes)iI, true))
                {
                    continue;
                }

                eUpgradeUnit = allUpgradesAvailable((UnitTypes)iI);

                if (eUpgradeUnit != NO_UNIT)
                {
                    CvAssertMsg(eUpgradeUnit != iI, "Trying to upgrade a Unit to itself");
                    iUpgradeProduction = getUnitProduction((UnitTypes)iI);
                    setUnitProduction(((UnitTypes)iI), 0);
                    setUnitProduction(eUpgradeUnit, iUpgradeProduction);

                    pOrderNode = headOrderQueueNode();

                    while (pOrderNode != NULL)
                    {
                        if (pOrderNode->eOrderType == ORDER_TRAIN)
                        {
                            if (pOrderNode->iData1 == iI)
                            {
                                thisPlayer.changeUnitClassMaking(((UnitClassTypes)(GC.getUnitInfo((UnitTypes)(pOrderNode->iData1))->GetUnitClassType())), -1);
                                pOrderNode->iData1 = eUpgradeUnit;
                                thisPlayer.changeUnitClassMaking(((UnitClassTypes)(GC.getUnitInfo((UnitTypes)(pOrderNode->iData1))->GetUnitClassType())), 1);
                            }
                        }

                        pOrderNode = nextOrderQueueNode(pOrderNode);
                    }
                }
            }
        }*/

        // Can now construct an Upgraded version of this Building
        /*for (iI = 0; iI < iNumBuildingInfos; iI++)
        {
            const BuildingTypes eBuilding = static_cast<BuildingTypes>(iI);
            CvBuildingEntry* pkBuildingInfo = GC.getBuildingInfo(eBuilding);
            if(pkBuildingInfo)
            {
                if (getFirstBuildingOrder(eBuilding) != -1)
                {
                    BuildingClassTypes eBuildingClass = (BuildingClassTypes) pkBuildingInfo->GetReplacementBuildingClass();

                    if (eBuildingClass != NO_BUILDINGCLASS)
                    {
                        BuildingTypes eUpgradeBuilding = ((BuildingTypes) (thisPlayer.getCivilizationInfo().getCivilizationBuildings(eBuildingClass)));

                        if (canConstruct(eUpgradeBuilding))
                        {
                            CvAssertMsg(eUpgradeBuilding != iI, "Trying to upgrade a Building to itself");
                            iUpgradeProduction = m_pCityBuildings->GetBuildingProduction(eBuilding);
                            m_pCityBuildings->SetBuildingProduction((eBuilding), 0);
                            m_pCityBuildings->SetBuildingProduction(eUpgradeBuilding, iUpgradeProduction);

                            pOrderNode = headOrderQueueNode();

                            while (pOrderNode != NULL)
                            {
                                if (pOrderNode->eOrderType == ORDER_CONSTRUCT)
                                {
                                    if (pOrderNode->iData1 == iI)
                                    {
                                        CvBuildingEntry* pkOrderBuildingInfo = GC.getBuildingInfo((BuildingTypes)pOrderNode->iData1);
                                        CvBuildingEntry* pkUpgradeBuildingInfo = GC.getBuildingInfo(eUpgradeBuilding);

                                        if(NULL != pkOrderBuildingInfo && NULL != pkUpgradeBuildingInfo)
                                        {
                                            const BuildingClassTypes eOrderBuildingClass = (BuildingClassTypes)pkOrderBuildingInfo->GetBuildingClassType();
                                            const BuildingClassTypes eUpgradeBuildingClass = (BuildingClassTypes)pkUpgradeBuildingInfo->GetBuildingClassType();

                                            thisPlayer.changeBuildingClassMaking(eOrderBuildingClass, -1);
                                            pOrderNode->iData1 = eUpgradeBuilding;
                                            thisPlayer.changeBuildingClassMaking(eUpgradeBuildingClass, 1);

                                        }
                                    }
                                }

                                pOrderNode = nextOrderQueueNode(pOrderNode);
                            }
                        }
                    }
                }
            }
        }*/

        okay = self.cleanUpQueue(in: gameModel)

        return okay
    }

    /// remove items in the queue that are no longer valid
    @discardableResult
    func cleanUpQueue(in gameModel: GameModel?) -> Bool {

        var okay = true

        for buildItem in self.buildQueue {

            if !self.canContinueProduction(item: buildItem, in: gameModel) {
                self.buildQueue.remove(item: buildItem)
                okay = false
            }
        }

        return okay
    }

    func canContinueProduction(item: BuildableItem, in gameModel: GameModel?) -> Bool {

        switch item.type {

        case .unit:
            return self.canTrain(unit: item.unitType!, in: gameModel)
        case .building:
            return self.canBuild(building: item.buildingType!, in: gameModel)
        case .wonder:
            return self.canBuild(wonder: item.wonderType!, at: item.location!, in: gameModel)
        case .district:
            return self.canBuild(district: item.districtType!, at: item.location!, in: gameModel)
        case .project:
            return self.canBuild(project: item.projectType!)
        }
    }

    func isProduction() -> Bool {

        if self.buildQueue.peek() != nil {
            return true
        }

        return false
    }

    public func isProductionAutomated() -> Bool {

        return self.productionAutomatedValue
    }

    public func setProductionAutomated(to newValue: Bool, clear: Bool, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if self.isProductionAutomated() != newValue {

            self.productionAutomatedValue = newValue

            /*if ((getOwner() == GC.getGame().getActivePlayer()) && isCitySelected())
            {
                DLLUI->setDirty(SelectionButtons_DIRTY_BIT, true);
            }*/

            // if automated and not network game and all 3 modifiers down, clear the queue and choose again
            if newValue && clear {
                self.buildQueue.clear()
            }

            if !isProduction() && !player.isHuman() {
                self.AI_chooseProduction(interruptWonders: false, in: gameModel)
            }
        }
    }

    // --------------------------------------------------------------------------------
    // swiftlint:disable cyclomatic_complexity
    func doProduction(allowNoProduction: Bool, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if !player.isHuman() || self.isProductionAutomated() {
            if !self.isProduction() /*|| self.isProductionProcess() || AI_isChooseProductionDirty() */ {
                self.AI_chooseProduction(interruptWonders: false, in: gameModel /*bInterruptWonders*/)
            }
        }

        if !allowNoProduction && !self.isProduction() {
            return
        }

        // processes are wealth or science
        /*if self.isProductionProcess() {
            return
        }*/

        if self.isProduction() {

            var production: Double = self.productionPerTurn(in: gameModel)
            var modifierPercentage = 0.0

            guard let effects = self.player?.envoyEffects(in: gameModel) else {
                fatalError("cant get envoyEffects")
            }

            for effect in effects {

                // Industrial: +2 Production Production in the Capital Capital when producing wonders, buildings, and districts.
                if effect.isEqual(category: .industrial, at: .first) && self.capitalValue {
                    if self.buildQueue.isCurrentlyBuildingBuilding() ||
                        self.buildQueue.isCurrentlyBuildingDistrict() ||
                        self.buildQueue.isCurrentlyBuildingWonder() {

                        production += 2.0
                    }
                }

                // Industrial: +2 Production Production in every city with a Workshop building when producing wonders, buildings, and districts.
                if effect.isEqual(category: .industrial, at: .third) && self.has(building: .workshop) {
                    if self.buildQueue.isCurrentlyBuildingBuilding() ||
                        self.buildQueue.isCurrentlyBuildingDistrict() ||
                        self.buildQueue.isCurrentlyBuildingWonder() {

                        production += 2.0
                    }
                }

                // Industrial: +2 Production Production in every city with a Factory building when producing wonders, buildings, and districts.
                if effect.isEqual(category: .industrial, at: .sixth) /*&& self.has(building: .factory)*/ {
                    fatalError("not handled")
                    /* if self.buildQueue.isCurrentlyBuildingBuilding() ||
                        self.buildQueue.isCurrentlyBuildingDistrict() ||
                        self.buildQueue.isCurrentlyBuildingWonder() {

                        production += 2.0
                    }*/
                }

                // Militaristic: +2 Production Production in the Capital Capital when producing units.
                if effect.isEqual(category: .militaristic, at: .first) && self.capitalValue {
                    if self.buildQueue.isCurrentlyTrainingUnit() {

                        production += 2.0
                    }
                }

                // Militaristic: +2 Production Production in every city with a Barracks or Stable building when producing units.
                if effect.isEqual(category: .militaristic, at: .third) && (self.has(building: .barracks) || self.has(building: .stable)) {
                    if self.buildQueue.isCurrentlyTrainingUnit() {

                        production += 2.0
                    }
                }

                // Militaristic: +2 Production Production in every city with an Armory building when producing units.
                if effect.isEqual(category: .militaristic, at: .sixth) /*&& self.has(building: .armory)*/ {
                    fatalError("not handled")
                    /* if self.buildQueue.isCurrentlyTrainingUnit() {

                        production += 2.0
                    }*/
                }

                // brussels suzerain bonus
                // Your cities get +15% [Production] Production towards wonders.
                if effect.cityState == .brussels && effect.level == .suzerain {
                    if self.productionWonderType() != nil {
                        modifierPercentage += 0.15
                    }
                }
            }

            // +1 Production in all cities.
            if government.has(card: .urbanPlanning) {
                production += 1.0
            }

            // city state production bonus is 50%
            if player.isCityState() {
                modifierPercentage += 0.5
            }

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // +10% Production toward Wonders.
            if government.currentGovernment() == .autocracy {

                if self.productionWonderType() != nil {
                    modifierPercentage += 0.1
                }
            }

            // +15% Production toward Districts.
            if government.currentGovernment() == .merchantRepublic {

                if self.buildQueue.isCurrentlyBuildingDistrict() {
                    modifierPercentage += 0.15
                }
            }

            // +50% Production toward Units.
            if government.currentGovernment() == .fascism {

                if self.buildQueue.isCurrentlyTrainingUnit() {
                    modifierPercentage += 0.50
                }
            }

            // +15% Production.
            if government.currentGovernment() == .communism {
                modifierPercentage += 0.15
            }

            // +1 Civ6Production Production ... per District.
            if government.currentGovernment() == .democracy {

                production += Double(districts.numberOfBuiltDistricts())
            }

            // +20% Civ6Production Production towards Medieval, Renaissance, and Industrial Wonders.
            if player.leader.civilization().ability() == .grandTour {
                if let wonderType = self.productionWonderType() {
                    if wonderType.era() == .ancient || wonderType.era() == .classical {
                        modifierPercentage += 0.20
                    }
                }
            }

            // +15% Civ6Production Production towards District (Civ6) Districts and wonders built next to a river.
            if player.leader.civilization().ability() == .iteru {
                if gameModel.river(at: self.location) {
                    if self.productionWonderType() != nil || self.productionDistrictType() != nil {
                        modifierPercentage += 0.15
                    }
                }
            }

            // +15% Production toward Ancient and Classical wonders.
            if government.has(card: .corvee) {
                if let wonderType = self.productionWonderType() {
                    if wonderType.era() == .ancient || wonderType.era() == .classical {
                        modifierPercentage += 0.15
                    }
                }
            }

            // +30% Production toward Builders.
            if government.has(card: .ilkum) {
                if self.buildQueue.isCurrentlyTrainingUnit(of: .builder) {
                    modifierPercentage += 0.30
                }
            }

            // +50% Production toward Settlers.
            if government.has(card: .colonization) {
                if self.buildQueue.isCurrentlyTrainingUnit(of: .settler) {
                    modifierPercentage += 0.50
                }
            }

            // +50% Production toward Ancient and Classical era heavy and light cavalry units.
            if government.has(card: .maneuver) {
                if self.buildQueue.isCurrentlyTrainingUnit(of: .heavyCavalry) || self.buildQueue.isCurrentlyTrainingUnit(of: .lightCavalry) {
                    modifierPercentage += 0.50
                }
            }

            // +100% Production toward Ancient and Classical era naval units.
            if government.has(card: .maritimeIndustries) {
                if let unitType = self.productionUnitType() {
                    if unitType.unitClass() == .navalMelee && (unitType.era() == .ancient || unitType.era() == .classical) {
                        modifierPercentage += 1.0
                    }
                }
            }

            // +50% Production toward Ancient and Classical era melee, ranged units and anti-cavalry units.
            if government.has(card: .agoge) {
                if let unitType = self.productionUnitType() {
                    if (unitType.unitClass() == .melee || unitType.unitClass() == .ranged || unitType.unitClass() == .antiCavalry) &&
                        (unitType.era() == .ancient || unitType.era() == .classical) {
                        modifierPercentage += 0.50
                    }
                }
            }

            // cityPatronGoddess - +25% [Production] Production toward districts in cities without a specialty district.
            if player.religion?.pantheon() == .cityPatronGoddess {
                if !districts.hasAnySpecialtyDistrict() {
                    if self.buildQueue.isCurrentlyBuildingDistrict() {
                        modifierPercentage += 0.25
                    }
                }
            }

            // godOfTheForge - +25% [Production] Production toward Ancient and Classical military units.
            if player.religion?.pantheon() == .godOfTheForge {
                if let unitType = self.productionUnitType() {
                    if (unitType.unitClass() == .melee || unitType.unitClass() == .ranged) &&
                        (unitType.era() == .ancient || unitType.era() == .classical) {
                        modifierPercentage += 0.25
                    }
                }
            }

            // monumentToTheGods - +15% [Production] Production to Ancient and Classical era Wonders.
            if player.religion?.pantheon() == .monumentToTheGods {
                if let wonderType = self.productionWonderType() {
                    if wonderType.era() == .ancient || wonderType.era() == .classical {
                        modifierPercentage += 0.15
                    }
                }
            }

            // Zoning Commissioner - +20% Production towards constructing Districts in the city.
            if self.hasGovernorTitle(of: .zoningCommissioner) {
                if self.buildQueue.isCurrentlyBuildingDistrict() {
                    modifierPercentage += 0.20
                }
            }

            // Themistocles - +20% Production towards Naval Ranged promotion class.
            if player.hasRetired(greatPerson: .themistocles) {
                if let unitType = self.productionUnitType() {
                    if unitType.unitClass() == .navalRanged {
                        modifierPercentage += 0.20
                    }
                }
            }

            // statueOfZeus - +50% Production towards anti-cavalry units.
            if self.has(wonder: .statueOfZeus) {
                if let unitType = self.productionUnitType() {
                    if unitType.unitClass() == .antiCavalry {
                        modifierPercentage += 0.50
                    }
                }
            }

            production *= (1.0 + modifierPercentage)

            self.updateProduction(for: production, in: gameModel)

            self.setFeatureProduction(to: 0.0)
        } else {
            self.setFeatureProduction(to: 0.0)
        }
    }

    // TODO rename
    func AI_chooseProduction(interruptWonders: Bool, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let citySpecializationAI = player.citySpecializationAI else {
            fatalError("cant get citySpecializationAI")
        }

        var buildWonder = false

        // See if this is the one AI city that is supposed to be building wonders
        if citySpecializationAI.wonderBuildCity()?.location == self.location {

            // Is it still working on that wonder and we don't want to interrupt it?
            if !interruptWonders {

                if self.productionWonderType() != nil {
                    // Stay the course
                    return
                }
            }

            // So we're the wonder building city but it is not underway yet...

            // Has the designated wonder been poached by another civ?
            let (nextWonderType, nextWonderLocation) = citySpecializationAI.nextWonderDesired()
            if !self.canBuild(wonder: nextWonderType, at: nextWonderLocation, in: gameModel) {
                // Reset city specialization
                // citySpecializationAI.->SetSpecializationsDirty(SPECIALIZATION_UPDATE_WONDER_BUILT_BY_RIVAL);
                fatalError("need to trigger the selection of new wonder")
            } else {
                buildWonder = true
            }
        }

        if buildWonder {

            let (nextWonderType, nextWonderLocation) = citySpecializationAI.nextWonderDesired()
            self.startBuilding(wonder: nextWonderType, at: nextWonderLocation, in: gameModel)

            /*if (GC.getLogging() && GC.getAILogging())
            {
                CvString playerName;
                FILogFile *pLog;
                CvString strBaseString;
                CvString strOutBuf;

                m_pCityStrategyAI->LogCityProduction(buildable, false);

                playerName = kOwner.getCivilizationShortDescription();
                pLog = LOGFILEMGR.GetLog(kOwner.GetCitySpecializationAI()->GetLogFileName(playerName), FILogFile::kDontTimeStamp);
                strBaseString.Format ("%03d, ", GC.getGame().getElapsedGameTurns());
                strBaseString += playerName + ", ";
                strOutBuf.Format("%s, WONDER - Started %s, Turns: %d", getName().GetCString(), GC.getBuildingInfo((BuildingTypes)buildable.m_iIndex)->GetDescription(), buildable.m_iTurnsToConstruct);
                strBaseString += strOutBuf;
                pLog->Msg(strBaseString);
            }*/
        } else {
            self.cityStrategy?.chooseProduction(in: gameModel)
            gameModel?.userInterface?.update(city: self)
        }

        return
    }

    public func foodBasket() -> Double {

        return self.foodBasketValue
    }

    public func set(foodBasket: Double) {

        self.foodBasketValue = foodBasket
    }

    // MARK: production

    public func productionLastTurn() -> Double {

        return self.productionLastTurnValue
    }

    //    Be very careful with setting bReassignPop to false.  This assumes that the caller
    //  is manually adjusting the worker assignments *and* handling the setting of
    //  the CityCitizens unassigned worker value.
    public func set(population newPopulation: Int, reassignCitizen: Bool = true, in gameModel: GameModel?) {

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        let oldPopulation = self.population()
        let populationChange = newPopulation - oldPopulation

        if oldPopulation != newPopulation {

            // If we are reducing population, remove the workers first
            if reassignCitizen && populationChange < 0 {

                // Need to Remove Citizens
                for _ in 0..<(-populationChange) {
                    cityCitizens.doRemoveWorstCitizen(in: gameModel)
                }

                // Fixup the unassigned workers
                let unassignedWorkers = cityCitizens.numUnassignedCitizens()
                cityCitizens.changeNumUnassignedCitizens(change: max(populationChange, -unassignedWorkers))
            }

            if populationChange > 0 {
                self.cityCitizens?.changeNumUnassignedCitizens(change: populationChange)
            }
        }

        self.populationValue = Double(newPopulation)

        // FIXME:
        // update yields?
    }

    public func change(population change: Int, reassignCitizen: Bool = true, in gameModel: GameModel?) {

        self.set(population: self.population() + change, reassignCitizen: reassignCitizen, in: gameModel)
    }

    public func population() -> Int {

        return Int(self.populationValue)
    }

    public func set(gameTurnFounded: Int) {

        self.gameTurnFoundedValue = gameTurnFounded
    }

    public func gameTurnFounded() -> Int {

        return self.gameTurnFoundedValue
    }

    private func train(unit unitType: UnitType, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let government = player.government else {
            fatalError("cant get player government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var unitLocation = self.location

        if unitType.movementType() == .swim || unitType.movementType() == .swimShallow {
            if !self.isCoastal(in: gameModel) && districts.has(district: .harbor) {

                guard let harborLocation = districts.location(of: .harbor) else {
                    fatalError("cant get harbor location")
                }

                unitLocation = harborLocation
            }
        }

        let unit = Unit(at: unitLocation, type: unitType, owner: self.player)

        if unitType == .builder {
            // Guildmaster - All Builders trained in city get +1 build charge.
            if self.hasGovernorTitle(of: .guildmaster) {
                unit.changeBuildCharges(change: 1)
            }

            // serfdom - Newly trained Builders gain 2 extra build actions.
            if government.has(card: .serfdom) {
                unit.changeBuildCharges(change: 2)
            }
        }

        var experienceModifier: Double = 0.0

        // +25% combat experience for all melee, ranged and anti-cavalry land units trained in this city.
        if buildings.has(building: .barracks) &&
            (unitType.unitClass() == .melee || unitType.unitClass() == .ranged || unitType.unitClass() == .antiCavalry) {

            experienceModifier += 0.25
        }

        // +25% combat experience for all cavalry and siege class units trained in this city.
        if buildings.has(building: .stable) &&
            (unitType.unitClass() == .lightCavalry || unitType.unitClass() == .heavyCavalry || unitType.unitClass() == .siege) {

            experienceModifier += 0.25
        }

        // +25% combat experience for all naval units trained in this city.
        if buildings.has(building: .barracks) &&
            (unitType.unitClass() == .navalMelee || unitType.unitClass() == .navalRaider ||
             unitType.unitClass() ==  .navalRaider || unitType.unitClass() ==  .navalCarrier) {

            experienceModifier += 0.25
        }

        // +25% combat experience for all military land units trained in this city
        if buildings.has(building: .armory) {

            experienceModifier += 0.25
        }

        // +25% combat experience for all naval units trained in this city.
        if buildings.has(building: .shipyard) {

            experienceModifier += 0.25
        }

        unit.set(experienceModifier: experienceModifier)

        gameModel?.add(unit: unit)
        gameModel?.userInterface?.show(unit: unit, at: unitLocation)

        self.updateEurekas(in: gameModel)

        // check quests
        for quest in player.ownQuests(in: gameModel) {

            if quest.type == .trainUnit(type: unitType) && quest.leader == player.leader {
                let cityStatePlayer = gameModel?.cityStatePlayer(for: quest.cityState)
                cityStatePlayer?.fulfillQuest(by: player.leader, in: gameModel)
            }
        }
    }

    private func build(building buildingType: BuildingType, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        do {
            try self.buildings?.build(building: buildingType)
            self.updateEurekas(in: gameModel)

            // penBrushAndVoice + normal - construct a building with a Great Work slot.
            if player.currentAge() == .normal && player.has(dedication: .penBrushAndVoice) {
                if !buildingType.slotsForGreatWork().isEmpty {
                    player.addMoment(of: .dedicationTriggered(dedicationType: .penBrushAndVoice), in: gameModel)
                }
            }

            // freeInquiry + normal - constructing a building which provides [Science] Science
            if player.currentAge() == .normal && player.has(dedication: .freeInquiry) {
                if buildingType.yields().science > 0 {
                    player.addMoment(of: .dedicationTriggered(dedicationType: .freeInquiry), in: gameModel)
                }
            }

            self.greatWorks?.addPlaces(for: buildingType)

            // send gossip
            gameModel?.sendGossip(type: .buildingConstructed(building: buildingType), of: self.player)

            // update district tile
            guard let cityCitizens = self.cityCitizens else {
                fatalError("cant get citizen")
            }

            for loopPoint in cityCitizens.workingPlots {

                guard let loopTile = gameModel?.tile(at: loopPoint.location) else {
                    continue
                }

                if loopTile.district() == buildingType.district() {
                    gameModel?.userInterface?.refresh(tile: loopTile)
                }
            }

            // update city tile
            if buildingType.district() == .cityCenter {
                guard let cityTile = gameModel?.tile(at: self.location) else {
                    fatalError("cant get city tile")
                }

                gameModel?.userInterface?.refresh(tile: cityTile)
            }

        } catch {
            fatalError("cant build building: already build")
        }
    }

    private func build(district districtType: DistrictType, at point: HexPoint, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        do {
            try self.districts?.build(district: districtType, at: point)
            self.updateEurekas(in: gameModel)

            // moments
            if player.currentAge() == .normal && player.has(dedication: .monumentality) {
                if districtType.isSpecialty() {
                    player.addMoment(of: .dedicationTriggered(dedicationType: .monumentality), in: gameModel)
                }
            }

            // check quests
            for quest in player.ownQuests(in: gameModel) {

                if case .constructDistrict(type: let district) = quest.type {

                    if district == districtType && player.leader == quest.leader {
                        let cityStatePlayer = gameModel.cityStatePlayer(for: quest.cityState)
                        cityStatePlayer?.fulfillQuest(by: player.leader, in: gameModel)
                    }
                }
            }

            if districtType == .preserve {
                // Initiate a Culture Bomb on adjacent unowned tiles
                for neighborPoint in point.neighbors() {

                    guard let neighborTile = gameModel.tile(at: neighborPoint) else {
                        continue
                    }

                    if !neighborTile.hasOwner() {
                        self.doAcquirePlot(at: neighborPoint, in: gameModel)
                    }
                }
            }

            if districtType == .neighborhood {
                if !player.hasMoment(of: .firstNeighborhoodCompleted) && !player.hasMoment(of: .worldsFirstNeighborhood) {

                    // check if someone else already had a built a neighborhood district
                    if gameModel.anyHasMoment(of: .worldsFirstNeighborhood) {
                        player.addMoment(of: .firstNeighborhoodCompleted, in: gameModel)
                    } else {
                        player.addMoment(of: .worldsFirstNeighborhood, in: gameModel)
                    }
                }
            }

            // send gossip
            if districtType.isSpecialty() {
                gameModel.sendGossip(type: .districtConstructed(district: districtType), of: self.player)
            }

            tile.build(district: districtType)
            if districtType != .cityCenter {
                // the city does not exist yet - so no update
                gameModel.userInterface?.refresh(tile: tile)
            }
        } catch {
            fatalError("cant build district: already build")
        }
    }

    private func build(wonder wonderType: WonderType, at point: HexPoint, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        guard let player = self.player else {
            fatalError("cant get player ")
        }

        guard let techs = player.techs else {
            fatalError("cant get player techs")
        }

        guard let civics = player.civics else {
            fatalError("cant get player civics")
        }

        do {
            try self.wonders?.build(wonder: wonderType)
            self.greatWorks?.addPlaces(for: wonderType)

            // moments
            self.player?.addMoment(of: .wonderCompleted(wonder: wonderType), in: gameModel)

            if wonderType.era() < player.currentEra() {
                self.player?.addMoment(of: .oldWorldWonderCompleted, in: gameModel)
            }

            gameModel.build(wonder: wonderType)

            // pyramids
            if wonderType == .pyramids {

                // Grants a free Builder.
                let extraBuilder = Unit(at: self.location, type: .builder, owner: self.player)
                gameModel.add(unit: extraBuilder)
                gameModel.userInterface?.show(unit: extraBuilder, at: self.location)
            }

            // stonehenge
            if wonderType == .stonehenge {

                // Grants a free Great Prophet.
                let extraProphet = Unit(at: self.location, type: .prophet, owner: self.player)
                gameModel.add(unit: extraProphet)
                gameModel.userInterface?.show(unit: extraProphet, at: self.location)
            }

            // great library
            if wonderType == .greatLibrary {

                // Receive boosts to all Ancient and Classical era technologies.
                for techType in TechType.all {

                    if techType.era() == .ancient || techType.era() == .classical {
                        if !techs.eurekaTriggered(for: techType) {
                            techs.triggerEureka(for: techType, in: gameModel)
                        }
                    }
                }
            }

            // angkorWat
            if wonderType == .angkorWat {

                // +1 Citizen Population in all current cities when built.
                for cityRef in gameModel.cities(of: player) {

                    guard let city = cityRef else {
                        continue
                    }

                    city.change(population: 1, reassignCitizen: true, in: gameModel)
                }
            }

            // colossus
            if wonderType == .colossus {

                // Grants a Trader unit.
                let extraTrader = Unit(at: self.location, type: .trader, owner: self.player)
                gameModel.add(unit: extraTrader)
                gameModel.userInterface?.show(unit: extraTrader, at: self.location)
            }

            // statueOfZeus
            if wonderType == .statueOfZeus {

                // Grants 3 Spearmen, 3 Archers, and a Battering Ram.
                for _ in 0..<3 {
                    let extraSpearmen = Unit(at: self.location, type: .spearman, owner: self.player)
                    gameModel.add(unit: extraSpearmen)
                    extraSpearmen.jumpToNearestValidPlotWithin(range: 2, in: gameModel)
                    gameModel.userInterface?.show(unit: extraSpearmen, at: self.location)

                    let extraArcher = Unit(at: self.location, type: .archer, owner: self.player)
                    gameModel.add(unit: extraArcher)
                    extraArcher.jumpToNearestValidPlotWithin(range: 2, in: gameModel)
                    gameModel.userInterface?.show(unit: extraArcher, at: self.location)
                }

                let extraBatteringRam = Unit(at: self.location, type: .batteringRam, owner: self.player)
                gameModel.add(unit: extraBatteringRam)
                extraBatteringRam.jumpToNearestValidPlotWithin(range: 2, in: gameModel)
                gameModel.userInterface?.show(unit: extraBatteringRam, at: self.location)
            }

            // mahabodhiTemple
            if wonderType == .mahabodhiTemple {

                // Grants 2 Apostles.
                // let extraApostle = Unit(at: self.location, type: .apostle, owner: self.player)
                // gameModel?.add(unit: extraApostle)
                // gameModel?.userInterface?.show(unit: extraApostle)

                // let extraApostle = Unit(at: self.location, type: .apostle, owner: self.player)
                // gameModel?.add(unit: extraApostle)
                // gameModel?.userInterface?.show(unit: extraApostle)
            }

            // Drama and Poetry - Build a Wonder.
            if !civics.inspirationTriggered(for: .dramaAndPoetry) {
                civics.triggerInspiration(for: .dramaAndPoetry, in: gameModel)
            }

            tile.build(wonder: wonderType)
            gameModel.userInterface?.refresh(tile: tile)

            if player.isHuman() {

                gameModel.userInterface?.showPopup(popupType: .wonderBuilt(wonder: wonderType))
            } else {
                // inform human about foreign wonder built
                if player.hasMet(with: gameModel.humanPlayer()) {
                    // human known this player
                    gameModel.humanPlayer()?.notifications()?
                        .add(notification: .wonderBuilt(wonder: wonderType, civilization: player.leader.civilization()))
                } else {
                    // human has not met this player
                    gameModel.humanPlayer()?.notifications()?
                        .add(notification: .wonderBuilt(wonder: wonderType, civilization: .unmet))
                }
            }

        } catch {
            fatalError("cant build building: already build")
        }
    }

    public func canBuild(building: BuildingType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        // at least one required building is needed (if there is one)
        var hasOneRequiredBuilding = false
        for requiredBuilding in building.requiredBuildings() {

            if buildings.has(building: requiredBuilding) {
                hasOneRequiredBuilding = true
            }
        }

        if !building.requiredBuildings().isEmpty && !hasOneRequiredBuilding {
            return false
        }

        // if an obsolete building exists - this cant be built
        for obsoleteBuilding in building.obsoleteBuildings() {
            if buildings.has(building: obsoleteBuilding) {
                return false
            }
        }

        if !building.canBuild(in: self, in: gameModel) {
            return false
        }

        if buildings.has(building: building) {
            return false
        }

        if let requiredTech = building.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if let requiredCivic = building.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }

        if !self.has(district: building.district()) {
            return false
        }

        // special handling of the palace
        // can only be built once
        if building == .palace && gameModel.capital(of: player) != nil {
            return false
        }

        return true
    }

    public func canBuild(wonder wonderType: WonderType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get city citizens")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        // only major player can build wonders
        if !player.isHuman() && !player.isMajorAI() {
            return false
        }

        if wonders.has(wonder: wonderType) {
            return false
        }

        if let requiredTech = wonderType.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if let requiredCivic = wonderType.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }

        // check other cities of user (if they are currently building)
        let cities = gameModel.cities(of: player)

        // loop thru all cities but skip this city
        for cityRef in cities where cityRef?.location != self.location {

            guard let city = cityRef else {
                continue
            }

            if city.buildQueue.isBuilding(wonder: wonderType) {
                return false
            }
        }

        // has another player built this wonder already?
        if gameModel.alreadyBuilt(wonder: wonderType) {
            return false
        }

        var anyValidLocation: Bool = false
        for loopLocation in cityCitizens.workingTileLocations() {

            guard let tile = gameModel.tile(at: loopLocation) else {
                continue
            }

            // cant build wonders in cities, districts or other wonders
            if tile.isCity() || tile.district() != .none || tile.wonder() != .none {
                continue
            }

            if tile.workingCity()?.location != self.location {
                continue
            }

            if wonderType.canBuild(on: loopLocation, in: gameModel) {
                anyValidLocation = true
            }
        }

        if !anyValidLocation {
            return false
        }

        return true
    }

    public func canBuild(wonder: WonderType, at location: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }

        guard let tile = gameModel.tile(at: location) else {
            fatalError("cant get tile")
        }

        // only major player can build wonders
        if !player.isHuman() && !player.isMajorAI() {
            return false
        }

        // cant build wonders in cities, districts or other wonders
        if tile.isCity() || tile.district() != .none || tile.wonder() != .none {
            return false
        }

        if tile.workingCity()?.location != self.location {
            return false
        }

        if wonders.has(wonder: wonder) {
            return false
        }

        if let requiredTech = wonder.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if let requiredCivic = wonder.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }

        // check tile
        if !wonder.canBuild(on: location, in: gameModel) {
            return false
        }

        // check other cities of user (if they are currently building)
        let cities = gameModel.cities(of: player)

        // loop thru all cities but skip this city
        for cityRef in cities where cityRef?.location != self.location {

            guard let city = cityRef else {
                continue
            }

            if city.buildQueue.isBuilding(wonder: wonder) {
                return false
            }
        }

        // has another player built this wonder already?
        if gameModel.alreadyBuilt(wonder: wonder) {
            return false
        }

        return true
    }

    public func bestLocation(for wonderType: WonderType, in gameModel: GameModel?) -> HexPoint? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get city citizens")
        }

        for loopLocation in cityCitizens.workingTileLocations() {

            if wonderType.canBuild(on: loopLocation, in: gameModel) {
                return loopLocation
            }
        }

        return nil
    }

    public func canBuild(district districtType: DistrictType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get city citizens")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        // can build only once
        if self.has(district: districtType) {
            return false
        }

        if let requiredTech = districtType.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if let requiredCivic = districtType.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }

        if districtType.isSpecialty() {
            // specialty districts are limited by population
            if districts.numberOfSpecialtyDistricts() >= self.numberOfBuildableSpecialtyDistricts() {
                return false
            }

            // they can only be built once per city
            if districts.has(district: districtType) {
                return false
            }
        }

        var anyValidLocation: Bool = false
        for loopLocation in cityCitizens.workingTileLocations() {

            guard let tile = gameModel.tile(at: loopLocation) else {
                continue
            }

            // cant build districts in cities, wonders or other districts
            if tile.isCity() || tile.district() != .none || tile.wonder() != .none {
                continue
            }

            if tile.workingCity()?.location != self.location {
                continue
            }

            if districtType.canBuild(on: loopLocation, in: gameModel) {
                anyValidLocation = true
            }
        }

        if !anyValidLocation {
            return false
        }

        return true
    }

    public func canBuild(district districtType: DistrictType, at location: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let tile = gameModel.tile(at: location) else {
            fatalError("cant get tile")
        }

        // cant build districts in cities, wonders or other districts
        if tile.isCity() || tile.district() != .none || tile.wonder() != .none {
            return false
        }

        if tile.workingCity()?.location != self.location {
            return false
        }

        if let requiredTech = districtType.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if let requiredCivic = districtType.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }

        if districtType.isSpecialty() {
            // specialty districts are limited by population
            if districts.numberOfSpecialtyDistricts() >= self.numberOfBuildableSpecialtyDistricts() {
                return false
            }

            // they can only be built once per city
            if districts.has(district: districtType) {
                return false
            }
        }

        if districtType.oncePerCivilization() {
            for cityRef in gameModel.cities(of: player) {

                guard let cityDistricts = cityRef?.districts else {
                    continue
                }

                if cityDistricts.has(district: districtType) {
                    return false
                }
            }
        }

        if !districtType.canBuild(on: location, in: gameModel) {
            return false
        }

        return true
    }

    // For example a city of 6 pop can only build 2 districts but 7 can build 3.
    func numberOfBuildableSpecialtyDistricts() -> Int {

        return (Int(self.populationValue) + 2) / 3
    }

    public func bestLocation(for districtType: DistrictType, in gameModel: GameModel?) -> HexPoint? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get city citizens")
        }

        for loopLocation in cityCitizens.workingTileLocations() {

            guard let loopTile = gameModel.tile(at: loopLocation) else {
                continue
            }

            guard loopTile.workingCity()?.location == self.location else {
                continue
            }

            if districtType.canBuild(on: loopLocation, in: gameModel) {
                return loopLocation
            }
        }

        return nil
    }

    public func canTrain(unit unitType: UnitType, in gameModel: GameModel?) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let districts = self.districts else {
            fatalError("cant get city districts")
        }

        // city states cant build settlers or prophets
        if player.isCityState() && (unitType == .settler || unitType == .prophet) {
            return false
        }

        // filter great people
        if unitType.productionCost() < 0 {
            return false
        }

        if let requiredTech = unitType.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if unitType == .settler {
            if self.population() <= 1 {
                return false
            }
        }

        if unitType == .trader {
            if player.numberOfTradeRoutes() >= player.tradingCapacity() {
                return false
            }
        }

        if let requiredCivilization = unitType.civilization() {
            if player.leader.civilization() != requiredCivilization {
                return false
            }
        }

        // only coastal cities can build ships
        if unitType.unitClass() == .navalMelee || unitType.unitClass() == .navalRanged ||
            unitType.unitClass() == .navalRaider || unitType.unitClass() == .navalCarrier {

            if !self.isCoastal(in: gameModel) && !districts.has(district: .harbor) {
                return false
            }
        }

        return true
    }

    public func canBuild(project: ProjectType) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        // city states cant build project
        if player.isCityState() {
            return false
        }

        return false
    }

    public func has(district: DistrictType) -> Bool {

        if district == .cityCenter {
            return true
        }

        guard let districts = self.districts else {
            return false
        }

        return districts.has(district: district)
    }

    public func location(of district: DistrictType) -> HexPoint? {

        if district == .cityCenter {
            return self.location
        }

        guard let districts = self.districts else {
            return nil
        }

        return districts.location(of: district)
    }

    public func has(building: BuildingType) -> Bool {

        guard let buildings = self.buildings else {
            return false
        }

        return buildings.has(building: building)
    }

    func hasBuildings(in district: DistrictType) -> Bool {

        for buildingType in BuildingType.all {

            if self.has(building: buildingType) {
                if buildingType.district() == district {
                    return true
                }
            }
        }

        return false
    }

    public func has(wonder: WonderType) -> Bool {

        guard let wonders = self.wonders else {
            return false
        }

        return wonders.has(wonder: wonder)
    }

    public func has(project: ProjectType) -> Bool {

        guard let projects = self.projects else {
            return false
        }

        return projects.has(project: project)
    }

    func productionWonderType() -> WonderType? {

        if let currentProduction = self.buildQueue.peek() {

            if currentProduction.type == .wonder {
                return currentProduction.wonderType
            }
        }

        return nil
    }

    func productionUnitType() -> UnitType? {

        if let currentProduction = self.buildQueue.peek() {

            if currentProduction.type == .unit {
                return currentProduction.unitType
            }
        }

        return nil
    }

    func productionDistrictType() -> DistrictType? {

        if let currentProduction = self.buildQueue.peek() {

            if currentProduction.type == .district {
                return currentProduction.districtType
            }
        }

        return nil
    }

    public func setRouteToCapitalConnected(value connected: Bool) {

        self.routeToCapitalConnectedThisTurn = connected
    }

    public func isRouteToCapitalConnected() -> Bool {

        return self.routeToCapitalConnectedThisTurn
    }

    public func startTraining(unit unitType: UnitType) {

        self.buildQueue.append(item: BuildableItem(unitType: unitType))
    }

    public func startBuilding(building buildingType: BuildingType) {

        self.buildQueue.append(item: BuildableItem(buildingType: buildingType))
    }

    public func startBuilding(wonder wonderType: WonderType, at location: HexPoint, in gameModel: GameModel?) {

        guard let tile = gameModel?.tile(at: location) else {
            fatalError("cant get tile")
        }

        tile.startBuilding(wonder: wonderType)
        gameModel?.userInterface?.refresh(tile: tile)

        self.buildQueue.append(item: BuildableItem(wonderType: wonderType, at: location))

        // send gossip
        gameModel?.sendGossip(type: .wonderStarted(wonder: wonderType, cityName: self.name), of: self.player)
    }

    public func startBuilding(district districtType: DistrictType, at location: HexPoint, in gameModel: GameModel?) {

        guard let tile = gameModel?.tile(at: location) else {
            fatalError("cant get tile")
        }

        tile.startBuilding(district: districtType)
        gameModel?.userInterface?.refresh(tile: tile)

        self.buildQueue.append(item: BuildableItem(districtType: districtType, at: location))
    }

    public func startBuilding(project projectType: ProjectType, at point: HexPoint, in gameModel: GameModel?) {

        self.buildQueue.append(item: BuildableItem(projectType: projectType, at: location))
    }

    public func canPurchase(unit unitType: UnitType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {

        guard let playerReligion = self.player?.religion else {
            fatalError("cant get player religion")
        }

        guard let playerTreasury = self.player?.treasury else {
            fatalError("cant get player treasury")
        }

        guard yieldType == .faith || yieldType == .gold else {
            fatalError("invalid yield type: \(yieldType)")
        }

        if !self.canTrain(unit: unitType, in: gameModel) {
            return false
        }

        if yieldType == .gold {
            if unitType.purchaseCost() == -1 { // -1 is invalid
                return false
            }

            if self.goldPurchaseCost(of: unitType, in: gameModel) > playerTreasury.value() {
                return false
            }

        } else if yieldType == .faith {
            if unitType.faithCost() == -1 { // -1 is invalid
                return false
            }

            if self.faithPurchaseCost(of: unitType, in: gameModel) > playerReligion.faith() {
                return false
            }

        } else {
            return false
        }

        return true
    }

    public func canPurchase(building buildingType: BuildingType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {

        guard yieldType == .faith || yieldType == .gold else {
            fatalError("invalid yield type: \(yieldType)")
        }

        guard let playerReligion = self.player?.religion else {
            fatalError("cant get player religion")
        }

        guard let playerTreasury = self.player?.treasury else {
            fatalError("cant get player treasury")
        }

        if !self.canBuild(building: buildingType, in: gameModel) {
            return false
        }

        if yieldType == .gold {
            if buildingType.purchaseCost() == -1 { // -1 is invalid
                return false
            }

            if self.goldPurchaseCost(of: buildingType) > playerTreasury.value() {
                return false
            }

        } else if yieldType == .faith {
            if buildingType.faithCost() == -1 { // -1 is invalid
                return false
            }

            if self.faithPurchaseCost(of: buildingType) > playerReligion.faith() {
                return false
            }

        } else {
            return false
        }

        return true
    }

    public func goldPurchaseCost(of unitType: UnitType, in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let cost = unitType.purchaseCost()
        var modifier: Double = 1.0

        // monumentality + golden - Settlers and Builders' Purchases are 30% cheaper.
        if player.has(dedication: .monumentality) && player.currentAge() == .golden {
            if unitType == .settler || unitType == .builder {
                modifier -= 0.3
            }
        }

        // carthage - suzerain bonus:
        // Land combat units are 20% cheaper to purchase with Gold for each Encampment district building in that city.
        if player.isSuzerain(of: .carthage, in: gameModel) {

            for buildingType in BuildingType.all {

                // each building in the encampment district reduces by 20%
                if self.has(building: buildingType) && buildingType.district() == .encampment {
                    modifier -= 0.2
                }
            }
        }

        // clamp
        modifier = modifier.clamped(to: 0.0...1.0)

        return Double(cost) * modifier
    }

    public func faithPurchaseCost(of unitType: UnitType, in gameModel: GameModel?) -> Double {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let cost = unitType.faithCost()
        var modifier: Double = 1.0

        // monumentality + golden - Civilian units may be purchased with Faith.
        if player.has(dedication: .monumentality) && player.currentAge() == .golden {
            if unitType.unitClass() == .civilian {
                return Double(unitType.productionCost())
            }
        }

        // carthage - suzerain bonus:
        // Land combat units are 20% cheaper to purchase with Gold for each Encampment district building in that city.
        if player.isSuzerain(of: .carthage, in: gameModel) {

            for buildingType in BuildingType.all {

                // each building in the encampment district reduces by 20%
                if self.has(building: buildingType) && buildingType.district() == .encampment {
                    modifier -= 0.2
                }
            }
        }

        // clamp
        modifier = modifier.clamped(to: 0.0...1.0)

        return Double(cost) * modifier
    }

    public func goldPurchaseCost(of building: BuildingType) -> Double {

        let cost = building.purchaseCost()
        return Double(cost)
    }

    public func faithPurchaseCost(of building: BuildingType) -> Double {

        let cost = building.faithCost()
        return Double(cost)
    }

    public func purchase(unit unitType: UnitType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard self.canPurchase(unit: unitType, with: yieldType, in: gameModel) else {
            return false
        }

        if yieldType == .gold {
            let purchaseCost = self.goldPurchaseCost(of: unitType, in: gameModel)
            self.player?.treasury?.changeGold(by: -purchaseCost)
        } else if yieldType == .faith {
            let faithCost = self.faithPurchaseCost(of: unitType, in: gameModel)
            self.player?.religion?.change(faith: -faithCost)
        } else {
            fatalError("cant buy unit with \(yieldType)")
        }

        // check quests
        for quest in player.ownQuests(in: gameModel) {

            if quest.type == .trainUnit(type: unitType) && quest.leader == player.leader {
                let cityStatePlayer = gameModel?.cityStatePlayer(for: quest.cityState)
                cityStatePlayer?.fulfillQuest(by: player.leader, in: gameModel)
            }
        }

        // send gossip
        if unitType == .settler {
            gameModel?.sendGossip(type: .settlerTrained(cityName: self.name), of: self.player)
        }

        let unit = Unit(at: self.location, type: unitType, owner: self.player)
        gameModel?.add(unit: unit)
        gameModel?.userInterface?.show(unit: unit, at: self.location)

        return true
    }

    /// --- WARNING: THIS IS FOR TESTING ONLY ---
    public func purchase(district districtType: DistrictType, at location: HexPoint, in gameModel: GameModel?) -> Bool {

        if !Thread.current.isRunningXCTest {
            fatalError("--- WARNING: THIS IS FOR TESTING ONLY ---")
        }

        if !self.canBuild(district: districtType, at: location, in: gameModel) {
            print("cant build district: \(districtType) at: \(location)")
            return false
        }

        self.build(district: districtType, at: location, in: gameModel)

        return true
    }

    public func purchase(building buildingType: BuildingType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {

        guard self.canPurchase(building: buildingType, with: yieldType, in: gameModel) else {
            return false
        }

        if yieldType == .gold {
            self.player?.treasury?.changeGold(by: -Double(buildingType.purchaseCost()))
        } else if yieldType == .faith {
            self.player?.religion?.change(faith: -Double(buildingType.faithCost()))
        } else {
            fatalError("cant buy building with \(yieldType)")
        }

        self.build(building: buildingType, in: gameModel)

        return true
    }

    /// --- WARNING: THIS IS FOR TESTING ONLY ---
    public func purchase(project projectType: ProjectType, in gameModel: GameModel?) -> Bool {

        if !Thread.current.isRunningXCTest {
            fatalError("--- WARNING: THIS IS FOR TESTING ONLY ---")
        }

        guard let projects = self.projects else {
            fatalError("cant get projects")
        }

        do {
            try projects.build(project: projectType)
            return true
        } catch {
            return false
        }
    }

    func updateEurekas(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let civics = player.civics else {
            fatalError("cant get civics")
        }

        guard let techs = player.techs else {
            fatalError("cant get techs")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        // militaryTraining - Build any district.
        if !civics.inspirationTriggered(for: .stateWorkforce) {
            if districts.hasAny() { // city center is taken into account
                civics.triggerInspiration(for: .stateWorkforce, in: gameModel)
            }
        }

        // militaryTraining - Build an Encampment.
        if !civics.inspirationTriggered(for: .militaryTraining) {
            if districts.has(district: .encampment) {
                civics.triggerInspiration(for: .militaryTraining, in: gameModel)
            }
        }

        // recordedHistory - Build 2 Campus Districts.
        if !civics.inspirationTriggered(for: .recordedHistory) {
            if player.numberOfDistricts(of: .campus, in: gameModel) >= 2 {
                civics.triggerInspiration(for: .recordedHistory, in: gameModel)
            }
        }

        // construction - Build water mill.
        if !techs.eurekaTriggered(for: .construction) {
            if buildings.has(building: .waterMill) {
                techs.triggerEureka(for: .construction, in: gameModel)
            }
        }

        // engineering - Build ancient walls
        if !techs.eurekaTriggered(for: .engineering) {
            if buildings.has(building: .ancientWalls) {
                techs.triggerEureka(for: .engineering, in: gameModel)
            }
        }

        // shipBuilding - Own 2 Galleys
        if !techs.eurekaTriggered(for: .shipBuilding) {
            if gameModel.units(of: player).count(where: { $0?.type == .galley }) >= 2 {
                techs.triggerEureka(for: .shipBuilding, in: gameModel)
            }
        }

        // economics - build 2 banks
        if !techs.eurekaTriggered(for: .economics) {
            if player.numberBuildings(of: .bank, in: gameModel) >= 2 {
                techs.triggerEureka(for: .economics, in: gameModel)
            }
        }
    }

    public func doSpawn(greatPerson: GreatPerson, in gameModel: GameModel?) {

        let unitType = greatPerson.type().unitType()

        guard unitType.isGreatPerson() else {
            fatalError("\(unitType) is not a greap person type")
        }

        let unit = Unit(at: self.location, type: unitType, owner: self.player)
        unit.greatPerson = greatPerson
        unit.changeBuildCharges(change: greatPerson.charges())

        gameModel?.add(unit: unit)
        gameModel?.userInterface?.show(unit: unit, at: self.location)
    }

    public func buildingProductionTurnsLeft(for buildingType: BuildingType) -> Int {

        if let buildingTypeItem = self.buildQueue.building(of: buildingType) {
            return Int(buildingTypeItem.productionLeft() / self.productionLastTurnValue)
        }

        return 100
    }

    public func unitProductionTurnsLeft(for unitType: UnitType) -> Int {

        if let unitTypeItem = self.buildQueue.unit(of: unitType) {
            return Int(unitTypeItem.productionLeft() / self.productionLastTurnValue)
        }

        return 100
    }

    public func districtProductionTurnsLeft(for districtType: DistrictType) -> Int {

        if let districtTypeItem = self.buildQueue.district(of: districtType) {
            return Int(districtTypeItem.productionLeft() / self.productionLastTurnValue)
        }

        return 100
    }

    public func wonderProductionTurnsLeft(for wonderType: WonderType) -> Int {

        if let wonderTypeItem = self.buildQueue.wonder(of: wonderType) {
            return Int(wonderTypeItem.productionLeft() / self.productionLastTurnValue)
        }

        return 100
    }

    public func currentBuildableItem() -> BuildableItem? {

        return self.buildQueue.peek()
    }

    func growthThreshold() -> Double {

        // https://forums.civfanatics.com/threads/formula-thread.600534/
        // https://forums.civfanatics.com/threads/mathematical-model-comparison.634332/
        // Population growth (food)
        // 15+8*n+n^1.5 (n is current population-1)
        // 15+8*(N-1)+(N-1)^1.5
        // 1=>2 =>> 15+0+0^1.5=15
        // 2=>3 =>> 15+8+1^1.5=24
        // 3=>4 =>> 15+16+2^1.5=34

        let tmpPopulationValue = max(1, self.populationValue)

        var growthThreshold = 15.0 /* BASE_CITY_GROWTH_THRESHOLD */
        growthThreshold += (tmpPopulationValue - 1.0) * 8.0 /* CITY_GROWTH_MULTIPLIER */
        growthThreshold += pow(tmpPopulationValue - 1.0, 1.5 /* CITY_GROWTH_EXPONENT */ )

        return growthThreshold
    }

    func updateProduction(for productionPerTurn: Double, in gameModel: GameModel?) {

        guard let player = player else {
            fatalError("cant get player")
        }

        if let currentBuilding = self.currentBuildableItem() {

            currentBuilding.add(production: productionPerTurn)

            if currentBuilding.ready() {

                self.buildQueue.pop()

                switch currentBuilding.type {

                case .unit:
                    if let unitType = currentBuilding.unitType {

                        self.train(unit: unitType, in: gameModel)
                    }

                case .building:

                    if let buildingType = currentBuilding.buildingType {

                        self.build(building: buildingType, in: gameModel)
                    }

                case .wonder:

                    if let wonderType = currentBuilding.wonderType,
                       let wonderLocation = currentBuilding.location {

                        self.build(wonder: wonderType, at: wonderLocation, in: gameModel)
                    }

                case .district:

                    if let districtType = currentBuilding.districtType,
                       let districtLocation = currentBuilding.location {

                        self.build(district: districtType, at: districtLocation, in: gameModel)
                    }

                case .project:
                    // NOOP - FIXME
                    break
                }

                self.player?.doUpdateTradeRouteCapacity(in: gameModel)

                if player.isHuman() {
                    player.notifications()?.add(notification: .productionNeeded(cityName: self.name, location: self.location))
                } else {
                    self.cityStrategy?.chooseProduction(in: gameModel)
                }
            }

        } else {

            if player.isHuman() {
                player.notifications()?.add(notification: .productionNeeded(cityName: self.name, location: self.location))
            } else {
                self.cityStrategy?.chooseProduction(in: gameModel)
            }
        }

        self.productionLastTurnValue = productionPerTurn
    }

    public func featureProduction() -> Double {

        return self.featureProductionValue
    }

    public func changeFeatureProduction(change: Double) {

        self.featureProductionValue += change
    }

    public func setFeatureProduction(to value: Double) {

        self.featureProductionValue = value
    }

    // Each Citizen6 Citizen living in a city consumes 2 Food per turn, which forms the city's total food consumption.
    public func foodConsumption() -> Double {

        return Double(self.population()) * 2.0
    }

    public func hasOnlySmallFoodSurplus() -> Bool {

        let exceedFood = self.lastTurnFoodEarnedValue - Double(self.foodConsumption())

        return exceedFood < 2.0 && exceedFood > 0.0
    }

    public func hasFoodSurplus() -> Bool {

        let exceedFood = self.lastTurnFoodEarnedValue - Double(self.foodConsumption())

        return exceedFood < 4.0 && exceedFood > 0.0
    }

    public func hasEnoughFood() -> Bool {

        let exceedFood = self.lastTurnFoodEarnedValue - Double(self.foodConsumption())

        return exceedFood > 0.0
    }

    public func maintenanceCostsPerTurn() -> Double {

        guard let districts = self.districts else {
            fatalError("no districts set")
        }

        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }

        var costs = 0.0

        // gather costs from districts
        for district in DistrictType.all {
            if districts.has(district: district) {
                costs += Double(district.maintenanceCost())
            }
        }

        // gather costs from buildings
        for building in BuildingType.all {
            if buildings.has(building: building) {
                costs += Double(building.maintenanceCost())
            }
        }

        return costs
    }

    // MARK: attack / damage

    public func canRangeStrike() -> Bool {

        if !self.has(building: .ancientWalls) {
            return false
        }

        return true
    }

    public func canRangeStrike(towards point: HexPoint) -> Bool {

        if self.location.distance(to: point) > self.strikeRange() {
            return false
        }

        if !self.has(building: .ancientWalls) {
            return false
        }

        return true
    }

    public func rangedCombatTargetLocations(in gameModel: GameModel?) -> [HexPoint] {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var targets: [HexPoint] = []

        for targetLocation in self.location.areaWith(radius: self.strikeRange()) {

            guard let targetUnitRefs = gameModel?.units(at: targetLocation) else {
                continue
            }

            for targetUnitRef in targetUnitRefs {

                guard let targetUnit = targetUnitRef else {
                    continue
                }

                if targetUnit.isBarbarian() || player.isAtWar(with: targetUnit.player) {

                    if !targets.contains(targetLocation) {
                        targets.append(targetLocation)
                    }
                }
            }
        }

        return targets
    }

    public func baseCombatStrength(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        /* Base strength, equal to that of the strongest melee unit your civilization currently possesses minus 10, or to the unit which is garrisoned inside the city (whichever is greater). Note also that Corps or Army units are capable of pushing this number higher than otherwise possible for this Era, so when you station such a unit in a city, its CS will increase accordingly; */
        var bestUnitType: UnitType = UnitType.warrior
        for unitRef in gameModel.units(of: player) {

            guard let unit = unitRef else {
                continue
            }

            if unit.type.meleeStrength() > bestUnitType.meleeStrength() {
                bestUnitType = unit.type
            }
        }

        if let unit = self.garrisonedUnit() {

            let unitStrength = unit.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
            let warriorStrength = bestUnitType.meleeStrength() - 10

            return max(warriorStrength, unitStrength)
        } else {
            return bestUnitType.meleeStrength() - 10
        }
    }

    public func combatStrengthModifiers(against attacker: AbstractUnit? = nil, in gameModel: GameModel?) -> [CombatModifier] {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let districts = self.districts else {
            fatalError("cant get districts")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var modifiers: [CombatModifier] = []

        if let attacker = attacker {

            if let tile = gameModel.tile(at: self.location) {

                if let attackerTile = gameModel.tile(at: attacker.location) {
                    if tile.isRiverToCross(towards: attackerTile, wrapX: gameModel.wrappedX() ? gameModel.mapSize().width() : -1) {
                        modifiers.append(CombatModifier(value: 5, title: "River defense"))
                    }
                }

                if tile.hasHills() {
                    // Bonus if the city is built on a Hill; this is the normal +3 bonus which is native to Hills.
                    modifiers.append(CombatModifier(value: 3, title: "Ideal terrain"))
                }
            }
        }

        ////////////////////////
        // difficulty / handicap bonus
        ////////////////////////
        if self.isHuman() {
            let handicapBonus = gameModel.handicap.freeHumanCombatBonus()
            if handicapBonus != 0 {
                modifiers.append(CombatModifier(value: handicapBonus, title: "Bonus due to difficulty"))
            }
        } else if !self.isBarbarian() {
            let handicapBonus = gameModel.handicap.freeAICombatBonus()
            if handicapBonus != 0 {
                modifiers.append(CombatModifier(value: handicapBonus, title: "Bonus due to difficulty"))
            }
        }

        if attacker != nil {

            var wallDefensesValue = 0
            if buildings.has(building: .ancientWalls) {
                wallDefensesValue += 3
            }

            if buildings.has(building: .medievalWalls) {
                wallDefensesValue += 3
            }

            if buildings.has(building: .renaissanceWalls) {
                wallDefensesValue += 3
            }

            if wallDefensesValue > 0 {
                modifiers.append(CombatModifier(value: wallDefensesValue, title: "Wall defenses"))
            }

            if government.has(card: .bastions) {
                modifiers.append(CombatModifier(value: 5, title: "Enhanced defences"))
            }
        }

        if districts.hasAny() {
            modifiers.append(CombatModifier(value: 2 * districts.numberOfBuiltDistricts(), title: "from districts"))
        }

        // capital
        if self.isCapital() {
            modifiers.append(CombatModifier(value: 3, title: "Palace guard"))
        }

        return modifiers
    }

    // https://civilization.fandom.com/wiki/City_combat_(Civ5)
    public func combatStrength(against attacker: AbstractUnit? = nil, in gameModel: GameModel?) -> Int {

        var combatStrengthValue = 0

        combatStrengthValue += self.baseCombatStrength(in: gameModel)

        for combatStrengthModifier in self.combatStrengthModifiers(against: attacker, in: gameModel) {

            combatStrengthValue += combatStrengthModifier.value
        }

        return combatStrengthValue
    }

    public func rangedCombatStrength(against defender: AbstractUnit?, on toTile: AbstractTile?) -> Int {

        guard let player = self.player else {
            fatalError("no player provided")
        }

        guard let government = player.government else {
            fatalError("cant get government")
        }

        if let defender = defender {

            if !self.canRangeStrike(at: defender.location) {
                return 0
            }
        }

        var rangedStrength = 15 // slinger / no requirement

        // https://civilization.fandom.com/wiki/Archer_(Civ6)
        if player.has(tech: .archery) {
            rangedStrength = 25
        }

        // https://civilization.fandom.com/wiki/Crossbowman_(Civ6)
        if player.has(tech: .machinery) {
            rangedStrength = 40
        }

        // https://civilization.fandom.com/wiki/Field_Cannon_(Civ6)
        /*if player.has(tech: .ballistics) {
            rangedStrength = 60
        }*/

        // +5 City Ranged Strength.
        if government.has(card: .bastions) {
            rangedStrength += 5
        }

        // FIXME: ratio?

        return rangedStrength
    }

    public func defensiveStrength(against attacker: AbstractUnit?, on ownTile: AbstractTile?, ranged: Bool, in gameModel: GameModel?) -> Int {

        guard let government = self.player?.government else {
            fatalError("cant get government")
        }

        guard let buildings = self.buildings else {
            fatalError("no buildings provided")
        }

        var strengthValue = 0

        /* Base strength, equal to that of the strongest melee unit your civilization currently possesses minus 10, or to the unit which is garrisoned inside the city (whichever is greater). Note also that Corps or Army units are capable of pushing this number higher than otherwise possible for this Era, so when you station such a unit in a city, its CS will increase accordingly; */
        if let unit = self.garrisonedUnit() {

            let unitStrength = unit.attackStrength(against: nil, or: nil, on: nil, in: gameModel)
            let warriorStrength = UnitType.warrior.meleeStrength() - 10

            strengthValue = max(warriorStrength, unitStrength)
        } else {
            strengthValue = UnitType.warrior.meleeStrength() - 10
        }

        // Building Defense
        /* Wall defenses add +3 CS per each level of Walls (up to +9 for Renaissance Walls); this bonus is lost if/when the walls are brought down. Note that this bonus is only valid for 'ancient defenses' (i.e. pre-Urban Defenses Walls). If a city never built any walls and then got Urban Defenses, it will never get this bonus, despite actually having modern defensive capabilities. */
        /* The Capital6 Capital gains an additional boost of 3 CS thanks to its Palace; this is called "Palace Guard" in the strength breakdown. This can increase to +8 when Victor has moved to the city (takes 3 turns). */
        let buildingDefense = buildings.defense()
        strengthValue += buildingDefense

        // Terrain mod
        // Bonus if the city is built on a Hill; this is the normal +3 bonus which is native to Hills.
        if let tile = ownTile {
            if tile.hasHills() {
                strengthValue += 3 // CITY_STRENGTH_HILL_MOD
            }
        }

        // +6 City Defense Strength.
        if government.has(card: .bastions) {
            strengthValue += 6
        }

        // Increases city garrison Strength Combat Strength by +5
        if self.hasGovernorTitle(of: .redoubt) {
            strengthValue += 5
        }

        return strengthValue
    }

    func updateFeatureSurrounded(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        var totalPlots = 0
        var featuredPlots = 0

        // Look two tiles around this city in every direction to see if at least half the plots are covered in a removable feature
        let range = City.workRadius

        let surroundingArea = self.location.areaWith(radius: range)

        for pt in surroundingArea {

            if !gameModel.valid(point: pt) {
                continue
            }

            // Increase total plot count
            totalPlots += 1

            if let tile = gameModel.tile(at: pt) {

                var hasRemovableFeature = false
                for feature in FeatureType.all {
                    if tile.has(feature: feature) && feature.isRemovable() {
                        hasRemovableFeature = true
                    }
                }

                if hasRemovableFeature {
                    featuredPlots += 1
                }
            }
        }

        // At least half have coverage?
        if featuredPlots >= totalPlots / 2 {
            self.isFeatureSurroundedValue = true
        } else {
            self.isFeatureSurroundedValue = false
        }
    }

    public func isFeatureSurrounded() -> Bool {

        return self.isFeatureSurroundedValue
    }

    public func isBlockaded() -> Bool {
        return false
    }

    public func garrisonedUnit() -> AbstractUnit? {

        return self.garrisonedUnitValue
    }

    public func hasGarrison() -> Bool {

        return self.garrisonedUnitValue != nil
    }

    public func setGarrison(unit: AbstractUnit?) {

        self.garrisonedUnitValue = unit
    }

    public func power(in gameModel: GameModel?) -> Int {

        return Int(pow(Double(self.defensiveStrength(against: nil, on: nil, ranged: false, in: gameModel)) / 100.0, 1.5))
    }

    public func healthPoints() -> Int {

        return self.healthPointsValue
    }

    public func set(healthPoints: Int) {

        self.healthPointsValue = healthPoints

        self.healthPointsValue = max(self.healthPointsValue, self.maxHealthPoints())
        self.healthPointsValue = min(0, self.healthPointsValue)
    }

    public func add(healthPoints: Int) {

        self.healthPointsValue += healthPoints

        self.healthPointsValue = max(self.healthPointsValue, self.maxHealthPoints())
        self.healthPointsValue = min(0, self.healthPointsValue)
    }

    public func add(damage: Int) {

        self.healthPointsValue -= damage

        self.healthPointsValue = max(self.healthPointsValue, self.maxHealthPoints())
        self.healthPointsValue = min(0, self.healthPointsValue)
    }

    public func set(damage: Int) {

        self.healthPointsValue = self.maxHealthPoints() - damage

        self.healthPointsValue = max(self.healthPointsValue, self.maxHealthPoints())
        self.healthPointsValue = min(0, self.healthPointsValue)
    }

    public func damage() -> Int {

        return max(0, self.maxHealthPoints() - self.healthPointsValue)
    }

    public func maxHealthPoints() -> Int {

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        var healthPointsVal = 200

        if buildings.has(building: .ancientWalls) {
            healthPointsVal += 100
        }

        if buildings.has(building: .medievalWalls) {
            healthPointsVal += 100
        }

        if buildings.has(building: .renaissanceWalls) {
            healthPointsVal += 100
        }

        return healthPointsVal
    }

    // MARK: add citizen to work on tile

    public func work(tile: AbstractTile) throws {

        if !tile.hasOwner() {
            throw CityError.tileOwned
        }

        if tile.owner()?.leader != self.player?.leader {
            throw CityError.tileOwnedByAnotherCity
        }

        if tile.isWorked() {
            throw CityError.tileWorkedAlready
        }

        if tile.point == self.location {
            throw CityError.cantWorkCenter
        }

        self.cityCitizens?.setWorked(at: tile.point, worked: true, useUnassignedPool: true)
        try tile.setWorkingCity(to: self)
    }

    public func threatValue() -> Int {

        return self.threatVal
    }

    public func processSpecialist(specialistType: SpecialistType, change: Int) {

        // Civ6: Another difference with the previous game is that Specialists now provide yields only and not Great Person Points, which makes them somewhat less important.
        for yieldType in YieldType.all {
            self.changeBaseYieldRateFromSpecialists(for: yieldType, change: Int(specialistType.yields().value(of: yieldType)) * change)
        }

        self.updateExtraSpecialistYield()
    }

    func updateExtraSpecialistYield() {

        for yieldType in YieldType.all {

            let oldYield = self.extraSpecialistYield.weight(of: yieldType)

            var newYield = 0.0

            for specialistType in SpecialistType.all {
                newYield += Double(self.calculateExtraSpecialistYield(for: yieldType, and: specialistType))
            }

            if oldYield != newYield {
                self.extraSpecialistYield.set(weight: newYield, for: yieldType)
                self.changeBaseYieldRateFromSpecialists(for: yieldType, change: Int(newYield - oldYield))
            }
        }
    }

    func calculateExtraSpecialistYield(for yieldType: YieldType, and specialistType: SpecialistType) -> Int {

        /*guard let player = self.player else {
            fatalError("cant get player")
        }*/

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        // let yieldMultiplier = player.specialistExtraYield(for: specialistType, and: yieldType) + player.getSpecialistExtraYield(yieldType) /* + player.leader.traits().GetPlayerTraits()->GetSpecialistYieldChange(eSpecialist, eIndex);*/
        let yieldMultiplier = specialistType.yields().value(of: yieldType)
        let extraYield = Int(Double(cityCitizens.specialistCount(of: specialistType)) * yieldMultiplier)

        return extraYield
    }

    /// Base yield rate from Specialists
    func changeBaseYieldRateFromSpecialists(for yieldType: YieldType, change: Int) {

        if change != 0 {
            let oldYield = self.baseYieldRateFromSpecialists.weight(of: yieldType)
            self.baseYieldRateFromSpecialists.add(weight: Double(change) + oldYield, for: yieldType)

            // notify ui
            /*if (getTeam() == GC.getGame().getActiveTeam())
            {
                if (isCitySelected()) {
                    DLLUI->setDirty(CityScreen_DIRTY_BIT, true);
                }
            }*/
        }
    }

    private func strikeRange() -> Int {

        return 2
    }

    private func canRangeStrike(at point: HexPoint) -> Bool {

        return self.location.distance(to: point) <= self.strikeRange()
    }

    public func doRangeAttack(at location: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let tile = gameModel?.tile(at: location) else {
            return false
        }

        if !self.canRangeStrike(at: location) {
            return false
        }

        // No City
        if tile.isCity() {
            return false
        }

        guard let defender = gameModel?.unit(at: location, of: .combat) else {
            return false
        }

        Combat.doRangedAttack(between: self, and: defender, in: gameModel)

        self.setMadeAttack(to: true)

        return true
    }

    public func setMadeAttack(to madeAttack: Bool) {

        self.madeAttackValue = madeAttack
    }

    public func madeAttack() -> Bool {

        return self.madeAttackValue
    }

    public func lastTurnGarrisonAssigned() -> Int {

        return self.lastTurnGarrisonAssignedValue
    }

    public func setLastTurnGarrisonAssigned(turn: Int) {

        self.lastTurnGarrisonAssignedValue = turn
    }

    /// Buy the plot and set it's owner to us (executed by the network code)
    @discardableResult
    public func doBuyPlot(at point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            return false
        }

        guard let costValue = self.buyPlotCost(at: point, in: gameModel) else {
            return false
        }
        let cost: Double = Double(costValue)

        player.treasury?.changeGold(by: -cost)
        player.changeNumPlotsBought(change: 1)

        // See if there's anyone else nearby that could get upset by this action
        for tilePoint in self.location.areaWith(radius: City.workRadius) {

            if let city = gameModel.city(at: tilePoint) {

                if !player.isEqual(to: city.player) {
                    city.changeNumPlotsAcquiredBy(otherPlayer: city.player, change: 1)
                }
            }
        }

        self.doAcquirePlot(at: point, in: gameModel)

        // Achievement test for purchasing 1000 tiles
        return true
    }

    /// How much will purchasing this plot cost -- (-1,-1) will return the generic price
    public func buyPlotCost(at point: HexPoint, in gameModel: GameModel?) -> Int? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let government = player.government else {
            fatalError("cant get government")
        }

        if point.x == -1 && point.y == -1 {
            // return Double(player.buyPlotCost())
            fatalError("Why is this?")
        }

        guard let tile = gameModel.tile(at: point) else {
            return nil
        }

        // Base cost
        var cost = player.buyPlotCost()

        // Influence cost (e.g. Hills are more expensive than flat land)
        /*guard let cityTile = gameModel.tile(at: self.location) else {
            fatalError("cant get city tile")
        }*/

        var distance = gameModel.calculateInfluenceDistance(from: self.location, to: point, limit: City.workRadius, abc: false)

        // Critical hit!
        let wrapX: Int? = gameModel.wrappedX() ? gameModel.mapSize().width() : nil
        if point.distance(to: self.location, wrapX: wrapX) > City.workRadius {
            return nil
        }

        // Reduce distance by the cheapest available (so that the costs don't ramp up ridiculously fast)
        distance -= (self.cheapestPlotInfluence() - 1)    // Subtract one because we want 1 to be the lowest value possible

        var influenceCost = distance *  100 /* PLOT_INFLUENCE_DISTANCE_MULTIPLIER */

        // Resource here?
        if tile.resource(for: player) != .none {
            influenceCost -= 100 /* PLOT_BUY_RESOURCE_COST */
        }

        if influenceCost > 100 {
            cost *= influenceCost
            cost /= 100
        }

        // Game Speed Mod
        // iCost *= GC.getGame().getGameSpeedInfo().getGoldPercent();
        // iCost /= 100;

        // cost *= (100 + self.plotBuyCostModifier());
        // cost /= 100;

        // Now round so the number looks neat
        let divisor = 5 /* PLOT_COST_APPEARANCE_DIVISOR */
        cost /= divisor
        cost *= divisor

        // Reduces the cost of purchasing a tile by 20%.
        if government.has(card: .landSurveyors) {
            cost *= 4
            cost /= 5
        }

        return cost
    }

    /// What is the cheapest plot we can get
    func doUpdateCheapestPlotInfluence(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var lowestCost = Int.max

        for loopPoint in self.location.areaWith(radius: City.workRadius) {

            guard let loopPlot = gameModel.tile(at: loopPoint) else {
                continue
            }

            // If the plot's not owned by us, it doesn't matter
            if loopPlot.hasOwner() {
                continue
            }

            // we can use the faster, but slightly inaccurate pathfinder here - after all we are using a rand in the equation
            let influenceCost = gameModel.calculateInfluenceDistance(from: self.location, to: loopPoint, limit: City.workRadius, abc: false)

            if influenceCost > 0 {
                // Are we the cheapest yet?
                if influenceCost < lowestCost {
                    lowestCost = influenceCost
                }
            }
        }

        self.set(cheapestPlotInfluence: lowestCost)
    }

    func set(cheapestPlotInfluence: Int) {
        self.cheapestPlotInfluenceValue = cheapestPlotInfluence
    }

    func cheapestPlotInfluence() -> Int {

        return self.cheapestPlotInfluenceValue
    }

    func updateCultureStored(to value: Double) {

        self.cultureStoredValue = value
    }

    func cultureStored() -> Double {

        return self.cultureStoredValue
    }

    func changeCultureLevel(by delta: Int) {

        self.cultureLevelValue += delta
    }

    public func cultureLevel() -> Int {

        return self.cultureLevelValue
    }

    /// Amount of Culture needed in this City to acquire a new Plot
    func cultureThreshold() -> Double {

        var cultureThreshold = 15.0 /* CULTURE_COST_FIRST_PLOT */

        let exponent = 1.1 /* CULTURE_COST_LATER_PLOT_EXPONENT */

        /*int iPolicyExponentMod = GET_PLAYER(m_eOwner).GetPlotCultureExponentModifier();
        if(iPolicyExponentMod != 0)
        {
            fExponent = fExponent * (float)((100 + iPolicyExponentMod));
            fExponent /= 100.0f;
        }*/

        var additionalCost = Double(self.cultureLevel()) * 8.0 /* CULTURE_COST_LATER_PLOT_MULTIPLIER */
        additionalCost = pow(additionalCost, exponent)

        cultureThreshold += additionalCost

        // Religion modifier
        /*int iReligionMod = 0;
        ReligionTypes eMajority = GetCityReligions()->GetReligiousMajority();
        if(eMajority != NO_RELIGION)
        {
            const CvReligion* pReligion = GC.getGame().GetGameReligions()->GetReligion(eMajority, getOwner());
            if(pReligion)
            {
                iReligionMod = pReligion->m_Beliefs.GetPlotCultureCostModifier();
                BeliefTypes eSecondaryPantheon = GetCityReligions()->GetSecondaryReligionPantheonBelief();
                if (eSecondaryPantheon != NO_BELIEF)
                {
                    iReligionMod += GC.GetGameBeliefs()->GetEntry(eSecondaryPantheon)->GetPlotCultureCostModifier();
                }
            }
        }*/

        // governor
        if self.hasGovernorTitle(of: .landAcquisition) {

            cultureThreshold *= 80
            cultureThreshold /= 100
        }

        // -50 = 50% cost
        /*let modifier = GET_PLAYER(getOwner()).GetPlotCultureCostModifier() + m_iPlotCultureCostModifier + iReligionMod;
        if modifier != 0)
        {
            iModifier = max(iModifier, /*-85*/ GC.getCULTURE_PLOT_COST_MOD_MINIMUM());    // value cannot reduced by more than 85%
            iCultureThreshold *= (100 + iModifier);
            iCultureThreshold /= 100;
        }*/

        // Make the number not be funky
        let divisor = 5.0 /* CULTURE_COST_VISIBLE_DIVISOR */
        if cultureThreshold > divisor * 2.0 {
            cultureThreshold /= divisor
            cultureThreshold = Double(Int(cultureThreshold))
            cultureThreshold *= divisor
        }

        return cultureThreshold
    }

    /// What happens when you have enough Culture to acquire a new Plot?
    func cultureLevelIncrease(in gameModel: GameModel?) {

        let overflow = self.cultureStored() - self.cultureThreshold()
        self.updateCultureStored(to: overflow)
        self.changeCultureLevel(by: 1)

        // maybe the player owns ALL of the plots or there are none avaialable?
        if let plotToAcquire = self.nextBuyablePlot(in: gameModel) {
            self.doAcquirePlot(at: plotToAcquire, in: gameModel)
        }
    }

    /// Which plot will we buy next
    func nextBuyablePlot(in gameModel: GameModel?) -> HexPoint? {

        let plots = self.buyablePlotList(in: gameModel)

        if plots.count > 1 {
            return plots.randomItem()
        }

        return nil
    }

    private func buyablePlotList(in gameModel: GameModel?) -> [HexPoint] {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var aiPlotList: [HexPoint] = []

        var lowestCost = Int.max
        let maxRange = 5 /* MAXIMUM_ACQUIRE_PLOT_DISTANCE */

        let iPLOT_INFLUENCE_DISTANCE_MULTIPLIER =    100 /* PLOT_INFLUENCE_DISTANCE_MULTIPLIER */
        let iPLOT_INFLUENCE_RING_COST =                100 /* PLOT_INFLUENCE_RING_COST */
        let iPLOT_INFLUENCE_WATER_COST =            25 /* PLOT_INFLUENCE_WATER_COST */
        let iPLOT_INFLUENCE_IMPROVEMENT_COST =         -5 /* PLOT_INFLUENCE_IMPROVEMENT_COST */
        let iPLOT_INFLUENCE_ROUTE_COST =            0 /* PLOT_INFLUENCE_ROUTE_COST */
        let iPLOT_INFLUENCE_RESOURCE_COST =            -105 /* PLOT_INFLUENCE_RESOURCE_COST */
        let iPLOT_INFLUENCE_NW_COST =                -105 /* PLOT_INFLUENCE_NW_COST */
        let iPLOT_INFLUENCE_YIELD_POINT_COST =        -1 /* PLOT_INFLUENCE_YIELD_POINT_COST */

        let iPLOT_INFLUENCE_NO_ADJACENT_OWNED_COST = 1000 /* PLOT_INFLUENCE_NO_ADJACENT_OWNED_COST */

        for point in self.location.areaWith(radius: maxRange) {

            if let loopPlot = gameModel.tile(at: point) {

                guard !loopPlot.hasOwner() else {
                    continue
                }

                guard !loopPlot.isWorked() else {
                    continue
                }

                // we can use the faster, but slightly inaccurate pathfinder here - after all we are using a rand in the equation
                var influenceCost = gameModel.calculateInfluenceDistance(
                    from: self.location, to: point, limit: maxRange, abc: false) * iPLOT_INFLUENCE_DISTANCE_MULTIPLIER

                if influenceCost > 0 {
                    // Modifications for tie-breakers in a ring

                    // Resource Plots claimed first
                    let resource = loopPlot.resource(for: self.player)
                    if resource != .none {

                        influenceCost += iPLOT_INFLUENCE_RESOURCE_COST
                        if resource.usage() == .bonus {
                            // very slightly decrease value of bonus resources
                            influenceCost += 1
                        }
                    } else {

                        // Water Plots claimed later
                        if loopPlot.isWater() {
                            influenceCost += iPLOT_INFLUENCE_WATER_COST
                        }
                    }

                    // improved tiles get a slight priority (unless they are barbarian camps!)
                    let improvement = loopPlot.improvement()
                    if improvement != .none {
                        if improvement == .barbarianCamp {
                            influenceCost += iPLOT_INFLUENCE_RING_COST
                        } else {
                            influenceCost += iPLOT_INFLUENCE_IMPROVEMENT_COST
                        }
                    }

                    // roaded tiles get a priority - [not any more: weight above is 0 by default]
                    if loopPlot.hasAnyRoute() {
                        influenceCost += iPLOT_INFLUENCE_ROUTE_COST
                    }

                    // while we're at it, grab Natural Wonders quickly also
                    if loopPlot.feature().isNaturalWonder() {
                        influenceCost += iPLOT_INFLUENCE_NW_COST
                    }

                    // More Yield == more desirable
                    let yields = loopPlot.yields(for: self.player, ignoreFeature: false)
                    for yieldType in YieldType.all {
                        influenceCost += (iPLOT_INFLUENCE_YIELD_POINT_COST * Int(yields.value(of: yieldType)))
                    }

                    // all other things being equal move towards unclaimed resources
                    var unownedNaturalWonderAdjacentCount = false
                    for dir in HexDirection.all {

                        let neightbor = point.neighbor(in: dir)

                        if let adjacentPlot = gameModel.tile(at: neightbor) {
                            if !adjacentPlot.hasOwner() {
                                let plotDistance = self.location.distance(to: neightbor)
                                let adjacentResource = adjacentPlot.resource(for: self.player)
                                if adjacentResource != .none {
                                    // if we are close enough to work, or this is not a bonus resource
                                    if plotDistance <= 3 || adjacentResource.usage() != .bonus {
                                        influenceCost -= 1
                                    }
                                }

                                if adjacentPlot.feature().isNaturalWonder() {
                                    if plotDistance <= 3 {
                                        // grab for this city
                                        unownedNaturalWonderAdjacentCount = true
                                    }
                                    // but we will slightly grow towards it for style in any case
                                    influenceCost -= 1
                                }
                            }
                        }
                    }

                    // move towards unclaimed NW
                    influenceCost += unownedNaturalWonderAdjacentCount ? -1 : 0

                    // Plots not adjacent to another Plot acquired by this City are pretty much impossible to get
                    var foundAdjacentOwnedByCity = false
                    for dir in HexDirection.all {

                        if let adjacentPlot = gameModel.tile(at: point.neighbor(in: dir)) {
                            // Have to check plot ownership first because the City IDs match between different players!!!
                            if adjacentPlot.ownerLeader() == leader && adjacentPlot.workingCityName() == self.name {
                                foundAdjacentOwnedByCity = true
                                break
                            }
                        }
                    }

                    if !foundAdjacentOwnedByCity {
                        influenceCost += iPLOT_INFLUENCE_NO_ADJACENT_OWNED_COST
                    }

                    // Are we cheap enough to get picked next?
                    if influenceCost < lowestCost {

                        // clear reset list
                        aiPlotList.removeAll()
                        aiPlotList.append(point)
                        lowestCost = influenceCost
                    }

                    if influenceCost == lowestCost {
                        aiPlotList.append(point)
                    }
                }
            }
        }

        return aiPlotList
    }

    /// Compute how valuable buying a plot is to this city
    public func buyPlotScore(in gameModel: GameModel?) -> (Int, HexPoint) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var bestScore = -1
        var bestPoint: HexPoint = HexPoint.zero

        // int iDX, iDY;

        for tilePoint in self.location.areaWith(radius: City.workRadius) {

            guard let tile = gameModel.tile(at: tilePoint) else {
                continue
            }

            if self.canBuyPlot(at: tilePoint, in: gameModel) {

                let tempScore = self.individualPlotScore(for: tile, in: gameModel)

                if tempScore > bestScore {
                    bestScore = tempScore
                    bestPoint = tilePoint
                }
            }
        }

        return (bestScore, bestPoint)
    }

    /// Can a specific plot be bought for the city
    func canBuyPlot(at point: HexPoint, ignoreCost: Bool = true, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            return false
        }

        guard let targetPlot = gameModel.tile(at: point) else {
            return false
        }

        // if this plot belongs to someone, bail!
        if targetPlot.hasOwner() {
            return false
        }

        // Must be adjacent to a plot owned by this city
        var foundAdjacent = false
        for adjacentPoint in point.neighbors() {

            guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                continue
            }

            if player.isEqual(to: adjacentPlot.owner()) {

                if adjacentPlot.workingCity()?.location == self.location {
                    foundAdjacent = true
                    break
                }
            }
        }

        if !foundAdjacent {
            return false
        }

        // Max range of 3
        if point.distance(to: self.location) > City.workRadius {
            return false
        }

        // check money
        if !ignoreCost {

            guard let treasury = player.treasury else {
                fatalError("cant get treasury")
            }

            guard let cost = self.buyPlotCost(at: point, in: gameModel) else {
                fatalError("cant get tile buy cost")
            }

            if treasury.value() < Double(cost) {
                return false
            }
        }

        return true
    }

    /// Compute value of a plot we might buy
    func individualPlotScore(for tile: AbstractTile?, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let cityStrategyAI = self.cityStrategy else {
            fatalError("cant get cityStrategyAI")
        }

        var rtnValue = 0

        let specializationType = cityStrategyAI.specialization()
        var specializationYield: YieldType = .none

        if specializationType != .none {
            specializationYield = specializationType.yieldType()!
        }

        // Does it have a resource?
        let resource = tile.resource(for: player)
        if resource != .none {

            if let revealTech = resource.revealTech() {
                if player.has(tech: revealTech) {

                    let resourceUsage = resource.usage()
                    if resourceUsage == .strategic {
                        // strategic resource?
                        rtnValue += 50 /* AI_PLOT_VALUE_STRATEGIC_RESOURCE */
                    } else if resourceUsage == .luxury {
                        // Luxury resource?
                        var luxuryValue = 40 /* AI_PLOT_VALUE_LUXURY_RESOURCE */

                        // Luxury we don't have yet?
                        if player.numAvailable(resource: resource) == 0 {
                            luxuryValue *= 2
                        }

                        rtnValue += luxuryValue
                    }
                }
            }
        }

        var yieldValue = 0

        // Valuate the yields from this plot
        for yieldType in YieldType.all {

            yieldValue = Int(tile.yields(for: self.player, ignoreFeature: false).value(of: yieldType))
            var tempValue = 0

            if yieldType == specializationYield {
                tempValue += yieldValue * 20 /* AI_PLOT_VALUE_SPECIALIZATION_MULTIPLIER */
            } else {
                tempValue += yieldValue * 10 /* AI_PLOT_VALUE_YIELD_MULTIPLIER */
            }

            // Deficient? If so, give it a boost
            if cityStrategyAI.isDeficient(for: yieldType, in: gameModel) {
                tempValue *= 5 /* AI_PLOT_VALUE_DEFICIENT_YIELD_MULTIPLIER */
            }

            yieldValue += tempValue
        }

        rtnValue += yieldValue

        // For each player not on our team, check how close their nearest city is to this plot
        // CvPlayer& owningPlayer = GET_PLAYER(m_eOwner);
        // CvDiplomacyAI* owningPlayerDiploAI = owningPlayer.GetDiplomacyAI();

        for loopPlayer in gameModel.players {

            if loopPlayer.isAlive() {

                if !player.isEqual(to: loopPlayer) && player.hasMet(with: loopPlayer) {

                    let landDisputeLevel = diplomacyAI.landDisputeLevel(with: loopPlayer)

                    if landDisputeLevel != .none {

                        if let city = tile.workingCity() {

                            let distance = tile.point.distance(to: city.location)

                            // Only want to account for civs with a city within 10 tiles
                            if distance < 10 {

                                switch landDisputeLevel {
                                case .fierce:
                                    rtnValue += (10 - distance) *  6 /* AI_PLOT_VALUE_FIERCE_DISPUTE */
                                case .strong:
                                    rtnValue += (10 - distance) * 4 /* AI_PLOT_VALUE_STRONG_DISPUTE */
                                case .weak:
                                    rtnValue += (10 - distance) * 2 /* AI_PLOT_VALUE_WEAK_DISPUTE */
                                default:
                                    // NOOP
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }

        // Modify value based on cost - the higher it is compared to the "base" cost the less the value
        if let cost = self.buyPlotCost(at: tile.point, in: gameModel) {

            rtnValue *= player.buyPlotCost()

            // Protect against div by 0.
            if cost != 0 {
                rtnValue /= cost
            } else {
                rtnValue = 0
            }
        }

        return rtnValue
    }

    /// Acquire the plot and set it's owner to us
    public func doAcquirePlot(at point: HexPoint, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        do {
            try tile.set(owner: self.player)
            try tile.setWorkingCity(to: self)
        } catch {
            fatalError("cant set owner: \(error)")
        }

        self.player?.addPlot(at: point)

        self.doUpdateCheapestPlotInfluence(in: gameModel)

        // clear barbarian camps / goodyhuts
        if tile.has(improvement: .barbarianCamp) {
            self.player?.doClearBarbarianCamp(at: tile, in: gameModel)
        } else if tile.has(improvement: .goodyHut) {
            self.player?.doGoodyHut(at: tile, by: nil, in: gameModel)
        }

        // repaint newly acquired tile ...
        gameModel.userInterface?.refresh(tile: tile)

        // ... and neighbors
        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            gameModel.userInterface?.refresh(tile: neighborTile)
        }
    }

    public func changeNumPlotsAcquiredBy(otherPlayer: AbstractPlayer?, change: Int) {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        self.numPlotsAcquiredList.add(weight: change, for: otherPlayer.leader)
    }

    public func numPlotsAcquired(by otherPlayer: AbstractPlayer?) -> Int {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        return Int(self.numPlotsAcquiredList.weight(of: otherPlayer.leader))
    }

    public func countNumImprovedPlots(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel,
              let cityCitizens = self.cityCitizens,
              let player = self.player else {

            fatalError("cant get basics")
        }

        var result = 0

        for point in cityCitizens.workingTileLocations() {

            if let tile = gameModel.tile(at: point) {
                if tile.hasAnyImprovement() && player.isEqual(to: tile.owner()) {
                    result += 1
                }
            }
        }

        return result
    }

    public func numLocalResources(of resourceType: ResourceType, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel,
              let cityCitizens = self.cityCitizens,
              let player = self.player else {

            fatalError("cant get basics")
        }

        var result = 0

        for point in cityCitizens.workingTileLocations() {

            if let tile = gameModel.tile(at: point) {
                if tile.resource(for: player) == resourceType && player.isEqual(to: tile.owner()) {
                    result += tile.resourceQuantity()
                }
            }
        }

        return result
    }

    public func numLocalLuxuryResources(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel,
              let cityCitizens = self.cityCitizens,
              let player = self.player else {

            fatalError("cant get basics")
        }

        var result = 0

        for point in cityCitizens.workingTileLocations() {

            if let tile = gameModel.tile(at: point) {
                if tile.resource(for: player).usage() == .luxury && player.isEqual(to: tile.owner()) {
                    result += tile.resourceQuantity()
                }
            }
        }

        return result
    }

    //    --------------------------------------------------------------------------------
    func isVisible(to otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let tile = gameModel.tile(at: self.location) {

            return tile.isVisible(to: otherPlayer)
        }

        return false
    }

    //    --------------------------------------------------------------------------------
    func isCapital(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if let capital = gameModel.capital(of: player) {

            return self.location == capital.location && self.name == capital.name
        } else {
            return false
        }
    }

    public func originalLeader() -> LeaderType {

        return self.originalLeaderValue
    }

    public func set(originalLeader: LeaderType) {

        self.originalLeaderValue = originalLeader
    }

    public func previousLeader() -> LeaderType {

        return self.previousLeaderValue
    }

    public func set(previousLeader: LeaderType) {

        self.previousLeaderValue = previousLeader
    }

    //    --------------------------------------------------------------------------------
    /// Was this city originally any player's capital?
    public func isOriginalCapital(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let originalPlayer = gameModel.player(for: self.originalLeader()) else {
            return false
        }

        return originalPlayer.originalCapitalLocation() == self.location
    }

    //    --------------------------------------------------------------------------------
    public func isEverCapital() -> Bool {

        return self.everCapitalValue
    }

    //    --------------------------------------------------------------------------------
    func set(everCapital: Bool) {

        self.everCapitalValue = everCapital
    }

    public func slots(for slotType: GreatWorkSlotType) -> Int {

        guard let greatWorks = self.greatWorks else {
            fatalError("cant get greatWorks")
        }

        return greatWorks.slotsAvailable(for: slotType)
    }

    public func isHolyCity(for religionType: ReligionType, in gameModel: GameModel?) -> Bool {

        if let religionRef = gameModel?.religions().first(where: { $0?.currentReligion() == religionType }) {

            if religionRef?.holyCityLocation() == self.location {
                return true
            }
        }

        return false
    }

    public func isHolyCityOfAnyReligion(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for religionRef in gameModel.religions() {

            if religionRef?.holyCityLocation() == self.location {
                return true
            }
        }

        return false
    }

    public func numReligiousCitizen() -> Int {

        guard let cityReligion = self.cityReligion else {
            fatalError("cant get city religion")
        }

        var religiousCitizen: Int = 0

        for religionType in ReligionType.all {

            religiousCitizen += cityReligion.numFollowers(following: religionType)
        }

        return religiousCitizen
    }

    public func religiousMajority() -> ReligionType {

        guard let cityReligion = self.cityReligion else {
            fatalError("cant get city religion")
        }

        return cityReligion.religiousMajority()
    }

    public func religiousTradeRouteModifier() -> Int {

        var modifier: Int = 0

        // Religious pressure to adjacent cities is 100% stronger from this city. 
        if self.hasGovernorTitle(of: .bishop) {
            modifier += 100
        }

        return modifier
    }

    // MARK: tourism

    public func baseTourism(in gameModel: GameModel?) -> Double {

        guard let cityTourism = self.cityTourism else {
            fatalError("cant get city tourism")
        }

        return cityTourism.baseTourism(in: gameModel)
    }

    //    --------------------------------------------------------------------------------
    public func isCoastal(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        return gameModel.isCoastal(at: self.location)
    }

    public func set(scratch: Int) {

        self.scratchValue = scratch
    }

    public func scratch() -> Int {

        return self.scratchValue
    }
}
