//
//  Player.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SwiftUI

public class AgeThresholds {

    public let lower: Int
    public let upper: Int

    init(lower: Int, upper: Int) {

        self.lower = lower
        self.upper = upper
    }
}

class ResourceInventory: WeightedList<ResourceType> {

    override func fill() {

        for resourceType in ResourceType.all {
            self.add(weight: 0.0, for: resourceType)
        }
    }
}

class ImprovementCountList: WeightedList<ImprovementType> {

    override func fill() {

        for improvementType in ImprovementType.all {
            self.items[improvementType] = 0.0
        }

        // also add goody hut / tribal village
        self.items[.goodyHut] = 0.0

        // and barb camp
        self.items[.barbarianCamp] = 0.0
    }
}

extension Comparable {

    public func clamped(to limits: ClosedRange<Self>) -> Self {

        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

public protocol AbstractPlayer: AnyObject, Codable {

    var leader: LeaderType { get }
    var techs: AbstractTechs? { get }
    var civics: AbstractCivics? { get }
    var government: AbstractGovernment? { get }
    var treasury: AbstractTreasury? { get }
    var religion: AbstractPlayerReligion? { get }
    var greatPeople: AbstractGreatPeople? { get }
    var tradeRoutes: AbstractTradeRoutes? { get }
    var governors: AbstractPlayerGovernors? { get }
    var tourism: AbstractPlayerTourism? { get }

    var grandStrategyAI: GrandStrategyAI? { get }
    var diplomacyAI: DiplomaticAI? { get }
    var diplomacyRequests: DiplomacyRequests? { get }
    var diplomacyDealAI: DiplomaticDealAI? { get }
    var economicAI: EconomicAI? { get }
    var militaryAI: MilitaryAI? { get }
    var tacticalAI: TacticalAI? { get }
    var dangerPlotsAI: DangerPlotsAI? { get }
    var builderTaskingAI: BuilderTaskingAI? { get }
    var citySpecializationAI: CitySpecializationAI? { get }
    var wonderProductionAI: WonderProductionAI? { get }
    var religionAI: ReligionAI? { get }

    var cityConnections: CityConnections? { get }

    var area: HexArea { get }
    var armies: Armies? { get }

    func initialize()

    func hasActiveDiplomacyRequests() -> Bool
    func canFinishTurn() -> Bool
    func turnFinished() -> Bool
    func doTurnPostDiplomacy(in gameModel: GameModel?)
    func finishTurn()
    func resetFinishTurnButtonPressed()
    func updateTimers(in gameModel: GameModel?)
    func isEndTurn() -> Bool
    func setEndTurn(to value: Bool, in gameModel: GameModel?)

    func hasProcessedAutoMoves() -> Bool
    func setProcessedAutoMoves(value: Bool)
    func isAutoMoves() -> Bool
    func setAutoMoves(to value: Bool)

    func doFirstContact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func doDefensivePact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool

    func isOpenBordersTradingAllowed() -> Bool
    func hasEmbassy(with otherPlayer: AbstractPlayer?) -> Bool
    func hasSentDelegation(to otherPlayer: AbstractPlayer?) -> Bool
    func isAllowsOpenBorders(with otherPlayer: AbstractPlayer?) -> Bool
    func isAllowEmbassyTradingAllowed() -> Bool

    func valueOfPersonalityFlavor(of flavor: FlavorType) -> Int
    func valueOfPersonalityIndividualFlavor(of flavor: FlavorType) -> Int
    func valueOfStrategyAndPersonalityFlavor(of flavor: FlavorType) -> Int
    func valueOfStrategyAndPersonalityApproach(of approach: PlayerApproachType) -> Int
    func personalAndGrandStrategyFlavor(for flavorType: FlavorType) -> Int
    func hiddenAgenda() -> LeaderAgendaType?

    func calculateGoldPerTurn(in gamemModel: GameModel?) -> Double
    func currentAge() -> AgeType
    func currentDedications() -> [DedicationType]
    func has(dedication: DedicationType) -> Bool
    func select(dedications: [DedicationType])

    func prepareTurn(in gamemModel: GameModel?)
    func startTurn(in gameModel: GameModel?)
    func endTurn(in gameModel: GameModel?)
    func unitUpdate(in gameModel: GameModel?)
    func lastSliceMoved() -> Int
    func setLastSliceMoved(to value: Int)

    func verifyAlive(in gameModel: GameModel?)
    func isAlive() -> Bool
    func isEverAlive() -> Bool
    func isActive() -> Bool
    func isTurnActive() -> Bool

    func isHuman() -> Bool
    func isMajorAI() -> Bool
    func isBarbarian() -> Bool
    func isFreeCity() -> Bool
    func isCityState() -> Bool

    // diplomatics methods
    func hasMet(with otherPlayer: AbstractPlayer?) -> Bool
    func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool
    func atWarCount() -> Int
    func canDeclareWar(to otherPlayer: AbstractPlayer?) -> Bool
    func doDeclareWar(to otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func doEstablishPeaceTreaty(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func makePeace(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func warWeariness(with otherPlayer: AbstractPlayer?) -> Int
    func updateWarWeariness(against otherPlayer: AbstractPlayer?, at point: HexPoint, killed: Bool, in gameModel: GameModel?)

    func doUpdateProximity(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func proximity(to otherPlayer: AbstractPlayer?) -> PlayerProximityType

    // envoys / suzerain methods
    func changeUnassignedEnvoys(by value: Int)
    func numberOfAvailableEnvoys() -> Int
    func envoysAssigned(to cityState: CityStateType) -> Int
    @discardableResult func assignEnvoy(to cityState: CityStateType, in gameModel: GameModel?) -> Bool
    @discardableResult func unassignEnvoy(from cityState: CityStateType, in gameModel: GameModel?) -> Bool
    func metCityStates(in gameModel: GameModel?) -> [CityStateType]

    func set(suzerain leader: LeaderType)
    func resetSuzerain()
    func suzerain() -> LeaderType?

    func quest(for leader: LeaderType) -> CityStateQuest? // quest of city state to leader
    func fulfillQuest(by leader: LeaderType, in gameModel: GameModel?)
    func obsoleteQuest(by leader: LeaderType, in gameModel: GameModel?)
    func doQuests(in gameModel: GameModel?)
    func set(quest: CityStateQuest, for leader: LeaderType) // for testing
    func resetQuests(in gameModel: GameModel?)

    func envoyEffects(in gameModel: GameModel?) -> [EnvoyEffect]
    func isSuzerain(of cityState: CityStateType, in gameModel: GameModel?) -> Bool
    func ownQuests(in gameModel: GameModel?) -> [CityStateQuest]

    // capital conquerer methods
    func hasHasLostCapital() -> Bool
    func capitalConqueror() -> LeaderType?
    func set(hasLostCapital value: Bool, to conqueror: AbstractPlayer?, in gameModel: GameModel?) // checks for domination victory
    func set(beingResurrected: Bool)
    func beingResurrected() -> Bool
    func set(liberatedBy: LeaderType)
    func liberatedBy() -> LeaderType

    // notification methods
    func updateNotifications(in gameModel: GameModel?)
    func set(blockingNotification: NotificationItem?)
    func blockingNotification() -> NotificationItem?
    func hasReadyUnit(in gameModel: GameModel?) -> Bool
    func firstReadyUnit(in gameModel: GameModel?) -> AbstractUnit?
    func endTurnsForReadyUnits(in gameModel: GameModel?)
    func hasPromotableUnit(in gameModel: GameModel?) -> Bool
    func firstPromotableUnit(in gameModel: GameModel?) -> AbstractUnit?

    // era
    func currentEra() -> EraType
    func set(era: EraType, in gameModel: GameModel?)
    func eraScore() -> Int
    func ageThresholds(in gameModel: GameModel?) -> AgeThresholds
    func estimateNextAge(in gameModel: GameModel?) -> AgeType

    // tech
    func has(tech: TechType) -> Bool
    func numberOfDiscoveredTechs() -> Int
    func canEmbark() -> Bool
    func canEnterOcean() -> Bool

    // civic
    func has(civic: CivicType) -> Bool
    func addGovernorTitle()

    // buildings
    func has(building: BuildingType, in gameModel: GameModel?) -> Bool

    // wonders
    func has(wonder: WonderType, in gameModel: GameModel?) -> Bool
    func city(with wonder: WonderType, in gameModel: GameModel?) -> AbstractCity?

    // advisors
    func advisorMessages() -> [AdvisorMessage]

    // ???
    func militaryMight(in gameModel: GameModel?) -> Int
    func economicMight(in gameModel: GameModel?) -> Int

    // city methods
    func found(at location: HexPoint, named name: String?, in gameModel: GameModel?)
    func newCityName(in gameModel: GameModel?) -> String
    func registerBuild(cityName: String)
    func cityStrengthModifier() -> Int
    func acquire(city oldCity: AbstractCity?, conquest: Bool, gift: Bool, in gameModel: GameModel?)
    func canRaze(city cityRef: AbstractCity?, ignoreCapitals: Bool, in gameModel: GameModel?) -> Bool
    func doRaze(city: AbstractCity?, in gameModel: GameModel?) -> Bool
    func canLiberate(city: AbstractCity?, in gameModel: GameModel?) -> Bool
    func doLiberate(city: AbstractCity?, forced: Bool, in gameModel: GameModel?) -> Bool
    func disband(city: AbstractCity?, in gameModel: GameModel?)
    func delete(city: AbstractCity?, in gameModel: GameModel?)
    func numberOfCitiesFounded() -> Int
    func numberOfCitiesLost() -> Int

    func capitalCity(in gameModel: GameModel?) -> AbstractCity?
    func set(capitalCity newCapitalCity: AbstractCity?, in gameModel: GameModel?)

    // yields
    func science(in gameModel: GameModel?) -> Double
    func scienceFromCities(in gameModel: GameModel?) -> YieldValues
    func culture(in gameModel: GameModel?, consume: Bool) -> Double
    func cultureFromCities(in gameModel: GameModel?) -> YieldValues
    func cultureFromCityStates(in gameModel: GameModel?) -> YieldValues
    func faith(in gameModel: GameModel?) -> Double
    func faithFromCities(in gameModel: GameModel?) -> Double

    // operation methods
    func operationsOf(type: UnitOperationType) -> [Operation]
    func hasOperationsOf(type: UnitOperationType) -> Bool
    func delete(operation: Operation)
    func numberOfOperationsOf(type: UnitOperationType) -> Int
    func isCityAlreadyTargeted(city: AbstractCity?, via domain: UnitDomainType, percentToTarget: Int, in gameModel: GameModel?) -> Bool
    @discardableResult func addOperation(of type: UnitOperationType, towards otherPlayer: AbstractPlayer?, target targetCity: AbstractCity?, in area: HexArea?, muster musterCity: AbstractCity?, in gameModel: GameModel?) -> Operation

    // misc
    func bestSettleAreasWith(minimumSettleFertility minScore: Int, in gameModel: GameModel?) -> (Int, HexArea?, HexArea?)
    func bestSettlePlot(for firstSettler: AbstractUnit?, in gameModel: GameModel?, escorted: Bool, area: HexArea?) -> AbstractTile?
    func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool
    func canBuild(build: BuildType, at point: HexPoint, testGold: Bool, in gameModel: GameModel?) -> Bool

    func updatePlots(in gameModel: GameModel?)
    func plots() -> HexArea
    func addPlot(at point: HexPoint)
    func buyPlotCost() -> Int
    func changeNumPlotsBought(change: Int)
    func numberOfDiscoveredPlots(in gameModel: GameModel?) -> Int

    func numberOfAvailable(resource: ResourceType) -> Double
    func changeNumberOfAvailable(resource: ResourceType, change: Double)

    func changeNumberOfItemsInStockpile(of resource: ResourceType, by change: Double)
    func numberOfItemsInStockpile(of resource: ResourceType) -> Double
    func numberOfStockpileCapacity(of resource: ResourceType) -> Double

    // units
    func canTrain(unitType: UnitType, continueFlag: Bool, testVisible: Bool, ignoreCost: Bool, ignoreUniqueUnitStatus: Bool) -> Bool
    func canPurchaseInAnyCity(unit: UnitType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool
    func numberOfUnitsNeededToBeBuilt() -> Int
    func countReadyUnits(in gameModel: GameModel?) -> Int
    func hasUnitsThatNeedAIUpdate(in gameModel: GameModel?) -> Bool
    func countUnitsWith(defaultTask: UnitTaskType, in gameModel: GameModel?) -> Int
    func hasBusyUnitOrCity() -> Bool
    func changeTrainedSettlers(by value: Int)
    func numberOfTrainedSettlers() -> Int
    func productionCost(of unitType: UnitType) -> Int

    // buildings / districts
    func canPurchaseInAnyCity(building: BuildingType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool
    func numberOfDistricts(of districtType: DistrictType, in gameModel: GameModel?) -> Int
    func numberBuildings(of buildingType: BuildingType, in gameModel: GameModel?) -> Int

    // religion
    func faithPurchaseType() -> FaithPurchaseType
    func set(faithPurchaseType: FaithPurchaseType)
    func majorityOfCitiesFollows(religion: ReligionType, in gameModel: GameModel?) -> Bool
    func doFound(religion: ReligionType, at city: AbstractCity?, in gameModel: GameModel?)

    func hasCapital(in gameModel: GameModel?) -> Bool
    func hasDiscoveredCapital(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func discoverCapital(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func findNewCapital(in gameModel: GameModel?)

    func changeImprovementCount(of improvement: ImprovementType, change: Int)
    func changeTotalImprovementsBuilt(change: Int)
    func changeCitiesLost(by delta: Int)

    func bestRoute(at tile: AbstractTile?) -> RouteType
    func isBridgeBuilding() -> Bool

    func reportCultureFromKills(at point: HexPoint, culture cultureVal: Int, wasBarbarian: Bool, in gameModel: GameModel?)
    func reportGoldFromKills(at point: HexPoint, gold goldVal: Int, in gameModel: GameModel?)

    func doGoodyHut(at tile: AbstractTile?, by unit: AbstractUnit?, in gameModel: GameModel?)
    func doClearBarbarianCamp(at tile: AbstractTile?, in gameModel: GameModel?)
    func isBarbarianCampDiscovered(at point: HexPoint) -> Bool
    func discoverBarbarianCamp(at point: HexPoint)
    func forgetDiscoverBarbarianCamp(at point: HexPoint)

    func score(for gameModel: GameModel?) -> Int

    func notifications() -> Notifications?

    func originalCapitalLocation() -> HexPoint
    func isCramped() -> Bool

    // government
    func canChangeGovernment() -> Bool
    func set(canChangeGovernment: Bool)

    // trade routes
    func tradingCapacity() -> Int
    func numberOfTradeRoutes() -> Int
    func numberOfUnassignedTraders(in gameModel: GameModel?) -> Int
    func canEstablishTradeRoute() -> Bool
    func possibleTradeRouteTargets(from originCity: AbstractCity?, in gameModel: GameModel?) -> [AbstractCity?]
    func possibleTradeRoutes(from originCityRef: AbstractCity?, in gameModel: GameModel?) -> [TradeRoute]
    func doUpdateTradeRouteCapacity(in gameModel: GameModel?)
    func hasTradeRoute(from: HexPoint, to: HexPoint) -> Bool

    @discardableResult
    func doEstablishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool
    func doFinish(tradeRoute: TradeRoute?, in gameModel: GameModel?)

    // great persons
    func canRecruitGreatPerson(in gameModel: GameModel?) -> Bool
    func recruit(greatPerson: GreatPerson, in gameModel: GameModel?)
    func retire(greatPerson: GreatPerson, in gameModel: GameModel?)
    func hasRetired(greatPerson: GreatPerson) -> Bool

    // distance / cities
    func cityDistancePathLength(of point: HexPoint, in gameModel: GameModel?) -> Int
    func numberOfCities(in gameModel: GameModel?) -> Int
    func countCitiesFeatureSurrounded(in gameModel: GameModel?) -> Int

    // victory checks
    func scienceVictoryProgress(in gameModel: GameModel?) -> Int
    func hasScienceVictory(in gameModel: GameModel?) -> Bool
    func hasCulturalVictory(in gameModel: GameModel?) -> Bool
    func hasReligiousVictory(in gameModel: GameModel?) -> Bool

    // tourism
    func domesticTourists() -> Int
    func visitingTourists(in gameModel: GameModel?) -> Int
    func currentTourism(in gameModel: GameModel?) -> Double
    func tourismModifier(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Int // in percent

    // moments
    func addMoment(of type: MomentType, in gameModel: GameModel?)
    func hasMoment(of type: MomentType) -> Bool
    func moments() -> [Moment]

    // moment helper
    func hasDiscovered(naturalWonder: FeatureType) -> Bool
    func doDiscover(naturalWonder: FeatureType)
    func hasSettled(on continent: ContinentType) -> Bool
    func markSettled(on continent: ContinentType)
    func checkWorldCircumnavigated(in gameModel: GameModel?)
    func hasWorldCircumnavigated() -> Bool
    func set(worldCircumnavigated: Bool)
    func hasEverEstablishedTradingPost(with leader: LeaderType) -> Bool
    func markEstablishedTradingPost(with leader: LeaderType)
    func numEverEstablishedTradingPosts(in gameModel: GameModel?) -> Int

    // marker
    func addMarker(type: MapMarkerType, name: String, at location: HexPoint, in gameModel: GameModel?)
    func removeMarker(at location: HexPoint, in gameModel: GameModel?)
    func marker(at location: HexPoint) -> MapMarker?
    func markers() -> [MapMarker]

    // intern
    func isEqual(to other: AbstractPlayer?) -> Bool
}

// swiftlint:disable type_body_length file_length
public class Player: AbstractPlayer {

    enum CodingKeys: CodingKey {

        case leader
        case alive
        case human
        case personalityFlavor

        case area
        case armies
        case numPlotsBought
        case discoveredBarbarianCampLocations

        case improvementCountList
        case totalImprovementsBuilt
        case citiesFound
        case citiesLost
        case builtCityNames

        case techs
        case civics
        case religion
        case treasury
        case greatPeople
        case government
        case tourism
        case moments
        case envoys
        case suzerain
        case quests
        case oldQuests
        case influencePoints

        case currentEra
        case currentAge
        case numberOfDarkAges
        case numberOfGoldenAges
        case currentDedications

        case grandStrategyAI
        case diplomacyAI
        case diplomacyRequests
        case diplomacyDealAI
        case economicAI
        case militaryAI
        case tacticalAI
        case dangerPlotsAI
        case homelandAI
        case builderTaskingAI
        case citySpecializationAI
        case wonderProductionAI
        case religionAI

        case cityConnections
        case goodyHuts
        case tradeRoutes
        case governors

        case operations
        case notifications
        case resourceProduction
        case resourceStockpile
        case resourceMaxStockpile

        case originalCapitalLocation
        case lostCapital
        case conqueror
        case beingResurrected
        case liberatedBy

        case canChangeGovernment
        case happiness

        case faithPurchaseType
        case boostExoplanetExpedition
        case discoveredNaturalWonders
        case settledContinents
        case hasWorldCircumnavigated
        case establishedTradingPosts
        case tradingCapacity
        case trainedSettlers

        case cramped
        case combatThisTurn

        case markers
    }

    private let kBaseStockPileAmount: Double = 50.0

    public var leader: LeaderType
    internal var isAliveVal: Bool
    internal let isHumanVal: Bool
    private var personalityFlavor: Flavors

    public var grandStrategyAI: GrandStrategyAI?
    public var diplomacyAI: DiplomaticAI?
    public var diplomacyRequests: DiplomacyRequests?
    public var diplomacyDealAI: DiplomaticDealAI?
    public var economicAI: EconomicAI?
    public var militaryAI: MilitaryAI?
    public var tacticalAI: TacticalAI?
    public var dangerPlotsAI: DangerPlotsAI?
    public var homelandAI: HomelandAI?
    public var builderTaskingAI: BuilderTaskingAI?
    public var citySpecializationAI: CitySpecializationAI?
    public var wonderProductionAI: WonderProductionAI?
    public var religionAI: ReligionAI?

    public var cityConnections: CityConnections?
    private var goodyHuts: GoodyHuts?

    public var techs: AbstractTechs?
    public var civics: AbstractCivics?
    public var religion: AbstractPlayerReligion?
    public var treasury: AbstractTreasury?
    public var greatPeople: AbstractGreatPeople?
    public var tradeRoutes: AbstractTradeRoutes?
    public var governors: AbstractPlayerGovernors?
    public var tourism: AbstractPlayerTourism?
    public var momentsVal: AbstractPlayerMoments?
    private var envoys: AbstractPlayerEnvoys?
    private var suzerainValue: LeaderType?
    private var oldQuestsValue: [CityStateQuest] = []
    private var questsValue: [CityStateQuest] = []
    private var influencePointsValue: Int = 0

    public var government: AbstractGovernment?
    internal var currentEraVal: EraType = .ancient
    internal var currentAgeVal: AgeType = .normal
    internal var currentDedicationsVal: [DedicationType] = []
    internal var numberOfDarkAgesVal: Int = 0
    internal var numberOfGoldenAgesVal: Int = 0

    internal var operations: Operations?
    public var armies: Armies?

    public var area: HexArea
    internal var numPlotsBoughtValue: Int
    internal var discoveredBarbarianCampLocationsValue: [HexPoint] = []

    internal var resourceProduction: ResourceInventory?
    internal var resourceStockpile: ResourceInventory?
    internal var resourceMaxStockpile: ResourceInventory?
    internal var improvementCountList: ImprovementCountList
    internal var totalImprovementsBuilt: Int
    internal var citiesFoundValue: Int
    internal var citiesLostValue: Int
    internal var builtCityNames: [String]

    private var turnActive: Bool = false
    private var finishTurnButtonPressedValue: Bool = false
    private var processedAutoMovesValue: Bool = false
    private var autoMovesValue: Bool = false
    private var endTurnValue: Bool = false
    private var lastSliceMovedValue: Int = 0

    internal var cultureEarned: Int = 0
    internal var faithEarned: Int = 0
    internal var boostExoplanetExpeditionValue: Int = 0

    private var notificationsValue: Notifications?
    private var blockingNotificationValue: NotificationItem?

    private var originalCapitalLocationValue: HexPoint = HexPoint.invalid
    private var lostCapitalValue: Bool = false
    private var conquerorValue: LeaderType?
    private var beingResurrectedValue: Bool = false
    private var liberatedByValue: LeaderType = .none

    private var canChangeGovernmentValue: Bool = true
    private var happinessValue: Int = 0
    private var faithPurchaseTypeVal: FaithPurchaseType = .noAutomaticFaithPurchase
    private var discoveredNaturalWonders: [FeatureType] = []
    private var settledContinents: [ContinentType] = []
    private var hasWorldCircumnavigatedVal: Bool = false
    private var establishedTradingPosts: [LeaderType] = []
    private var tradingCapacityValue: Int = 0
    private var trainedSettlersValue: Int = 1 // first settler is not trained but counts

    private var crampedValue: Bool = false
    private var combatThisTurnValue: Bool = false

    private var markersValue: [MapMarker] = []

    // MARK: constructor

    public init(leader: LeaderType, isHuman: Bool = false) {

        self.leader = leader
        self.isAliveVal = true
        self.isHumanVal = isHuman
        self.personalityFlavor = Flavors()

        self.area = HexArea(points: [])
        self.armies = Armies()

        self.numPlotsBoughtValue = 0

        self.improvementCountList = ImprovementCountList()
        self.improvementCountList.fill()

        self.totalImprovementsBuilt = 0
        self.citiesFoundValue = 0
        self.citiesLostValue = 0
        self.builtCityNames = []

        self.originalCapitalLocationValue = HexPoint.invalid
        self.lostCapitalValue = false
        self.conquerorValue = nil

        self.faithPurchaseTypeVal = .noAutomaticFaithPurchase
        self.discoveredNaturalWonders = []
        self.settledContinents = []
        self.hasWorldCircumnavigatedVal = false
        self.establishedTradingPosts = []

        self.crampedValue = false
        self.combatThisTurnValue = false
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.leader = try container.decode(LeaderType.self, forKey: .leader)
        self.isAliveVal = try container.decode(Bool.self, forKey: .alive)
        self.isHumanVal = try container.decode(Bool.self, forKey: .human)
        self.personalityFlavor = try container.decodeIfPresent(Flavors.self, forKey: .personalityFlavor) ?? Flavors()

        self.area = try container.decode(HexArea.self, forKey: .area)
        self.armies = try container.decode(Armies.self, forKey: .armies)
        self.discoveredBarbarianCampLocationsValue =
            try container.decodeIfPresent([HexPoint].self, forKey: .discoveredBarbarianCampLocations) ?? []

        self.numPlotsBoughtValue = 0
        self.improvementCountList = ImprovementCountList()
        self.improvementCountList.fill()

        self.totalImprovementsBuilt = try container.decode(Int.self, forKey: .totalImprovementsBuilt)
        self.citiesFoundValue = try container.decode(Int.self, forKey: .citiesFound)
        self.citiesLostValue = try container.decode(Int.self, forKey: .citiesLost)
        self.builtCityNames = try container.decode([String].self, forKey: .builtCityNames)

        self.grandStrategyAI = try container.decode(GrandStrategyAI.self, forKey: .grandStrategyAI)
        self.diplomacyAI = try container.decode(DiplomaticAI.self, forKey: .diplomacyAI)
        self.diplomacyRequests = try container.decode(DiplomacyRequests.self, forKey: .diplomacyRequests)
        self.diplomacyDealAI = try container.decode(DiplomaticDealAI.self, forKey: .diplomacyDealAI)
        self.economicAI = try container.decode(EconomicAI.self, forKey: .economicAI)
        self.militaryAI = try container.decode(MilitaryAI.self, forKey: .militaryAI)
        self.tacticalAI = try container.decode(TacticalAI.self, forKey: .tacticalAI)
        self.dangerPlotsAI = try container.decode(DangerPlotsAI.self, forKey: .dangerPlotsAI)
        self.homelandAI = HomelandAI(player: self) // try container.decode(HomelandAI.self, forKey: .homelandAI)
        self.builderTaskingAI = BuilderTaskingAI(player: self) // try container.decode(BuilderTaskingAI.self, forKey: .builderTaskingAI)
        self.citySpecializationAI = CitySpecializationAI(player: self)// try container.decode(CitySpecializationAI.self, forKey: .citySpecializationAI)
        self.wonderProductionAI = WonderProductionAI(player: self)// try container.decode(WonderProductionAI.self, forKey: .wonderProductionAI)
        self.religionAI = ReligionAI(player: self)

        self.cityConnections = try container.decode(CityConnections.self, forKey: .cityConnections)
        self.goodyHuts = try container.decode(GoodyHuts.self, forKey: .goodyHuts)
        self.tradeRoutes = try container.decode(TradeRoutes.self, forKey: .tradeRoutes)
        self.governors = try container.decode(PlayerGovernors.self, forKey: .governors)
        self.tourism = try container.decode(PlayerTourism.self, forKey: .tourism)
        self.momentsVal = try container.decode(PlayerMoments.self, forKey: .moments)
        self.envoys = try container.decode(PlayerEnvoys.self, forKey: .envoys)
        self.suzerainValue = try container.decodeIfPresent(LeaderType.self, forKey: .suzerain)
        self.questsValue = try container.decode([CityStateQuest].self, forKey: .quests)
        self.oldQuestsValue = try container.decode([CityStateQuest].self, forKey: .oldQuests)
        self.influencePointsValue = try container.decode(Int.self, forKey: .influencePoints)

        self.techs = try container.decode(Techs.self, forKey: .techs)
        self.civics = try container.decode(Civics.self, forKey: .civics)
        self.religion = try container.decode(PlayerReligion.self, forKey: .religion)
        self.treasury = try container.decode(Treasury.self, forKey: .treasury)
        self.greatPeople = try container.decode(GreatPeople.self, forKey: .greatPeople)
        self.government = try container.decode(Government.self, forKey: .government)

        self.currentEraVal = try container.decode(EraType.self, forKey: .currentEra)
        self.currentAgeVal = try container.decode(AgeType.self, forKey: .currentAge)
        self.currentDedicationsVal = try container.decode([DedicationType].self, forKey: .currentDedications)
        self.numberOfDarkAgesVal = try container.decode(Int.self, forKey: .numberOfDarkAges)
        self.numberOfGoldenAgesVal = try container.decode(Int.self, forKey: .numberOfGoldenAges)

        self.operations = try container.decode(Operations.self, forKey: .operations)
        self.notificationsValue = try container.decode(Notifications.self, forKey: .notifications)

        self.resourceProduction = try container.decode(ResourceInventory.self, forKey: .resourceProduction)
        self.resourceStockpile = try container.decode(ResourceInventory.self, forKey: .resourceStockpile)
        self.resourceMaxStockpile = try container.decode(ResourceInventory.self, forKey: .resourceMaxStockpile)

        self.originalCapitalLocationValue = try container.decode(HexPoint.self, forKey: .originalCapitalLocation)
        self.lostCapitalValue = try container.decode(Bool.self, forKey: .lostCapital)
        self.conquerorValue = try container.decodeIfPresent(LeaderType.self, forKey: .conqueror)
        self.beingResurrectedValue = try container.decode(Bool.self, forKey: .beingResurrected)
        self.liberatedByValue = try container.decode(LeaderType.self, forKey: .liberatedBy)

        self.canChangeGovernmentValue = try container.decode(Bool.self, forKey: .canChangeGovernment)
        self.happinessValue = try container.decodeIfPresent(Int.self, forKey: .happiness) ?? 0
        self.faithPurchaseTypeVal = try container.decode(FaithPurchaseType.self, forKey: .faithPurchaseType)
        self.boostExoplanetExpeditionValue = try container.decode(Int.self, forKey: .boostExoplanetExpedition)
        self.discoveredNaturalWonders = try container.decode([FeatureType].self, forKey: .discoveredNaturalWonders)
        self.settledContinents = try container.decode([ContinentType].self, forKey: .settledContinents)
        self.hasWorldCircumnavigatedVal = try container.decode(Bool.self, forKey: .hasWorldCircumnavigated)
        self.establishedTradingPosts = try container.decode([LeaderType].self, forKey: .establishedTradingPosts)
        self.tradingCapacityValue = try container.decode(Int.self, forKey: .tradingCapacity)
        self.trainedSettlersValue = try container.decode(Int.self, forKey: .trainedSettlers)

        self.crampedValue = try container.decode(Bool.self, forKey: .cramped)
        self.combatThisTurnValue = try container.decodeIfPresent(Bool.self, forKey: .combatThisTurn) ?? false

        self.markersValue = try container.decode([MapMarker].self, forKey: .markers)

        // setup
        self.techs?.player = self
        self.civics?.player = self
        self.religion?.player = self
        self.treasury?.player = self
        self.government?.player = self
        self.greatPeople?.player = self
        self.tradeRoutes?.player = self
        self.governors?.player = self
        self.tourism?.player = self
        self.momentsVal?.player = self
        self.envoys?.player = self

        self.grandStrategyAI?.player = self
        self.diplomacyAI?.player = self
        self.diplomacyRequests?.player = self
        self.diplomacyDealAI?.player = self
        self.economicAI?.player = self
        self.militaryAI?.player = self
        self.tacticalAI?.player = self
        self.dangerPlotsAI?.player = self
        self.homelandAI?.player = self
        self.builderTaskingAI?.player = self
        self.citySpecializationAI?.player = self
        self.wonderProductionAI?.player = self

        self.cityConnections?.player = self
        self.goodyHuts?.player = self
        self.notificationsValue?.player = self

        if self.personalityFlavor.isEmpty {
            self.setupFlavors()
        }
    }

    // swiftlint:disable force_cast
    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.leader, forKey: .leader)
        try container.encode(self.isAliveVal, forKey: .alive)
        try container.encode(self.isHumanVal, forKey: .human)
        try container.encode(self.personalityFlavor, forKey: .personalityFlavor)

        try container.encode(self.area, forKey: .area)
        try container.encode(self.armies, forKey: .armies)
        try container.encode(self.numPlotsBoughtValue, forKey: .numPlotsBought)
        try container.encode(self.discoveredBarbarianCampLocationsValue, forKey: .discoveredBarbarianCampLocations)

        try container.encode(self.improvementCountList, forKey: .improvementCountList)
        try container.encode(self.totalImprovementsBuilt, forKey: .totalImprovementsBuilt)
        try container.encode(self.citiesFoundValue, forKey: .citiesFound)
        try container.encode(self.citiesLostValue, forKey: .citiesLost)
        try container.encode(self.builtCityNames, forKey: .builtCityNames)

        try container.encode(self.grandStrategyAI, forKey: .grandStrategyAI)
        try container.encode(self.diplomacyAI, forKey: .diplomacyAI)
        try container.encode(self.diplomacyRequests, forKey: .diplomacyRequests)
        try container.encode(self.diplomacyDealAI, forKey: .diplomacyDealAI)
        try container.encode(self.economicAI, forKey: .economicAI)
        try container.encode(self.militaryAI, forKey: .militaryAI)
        try container.encode(self.tacticalAI, forKey: .tacticalAI)
        try container.encode(self.dangerPlotsAI, forKey: .dangerPlotsAI)
        // try container.encode(self.homelandAI, forKey: .homelandAI)
        // try container.encode(self.builderTaskingAI, forKey: .builderTaskingAI)
        // try container.encode(self.citySpecializationAI, forKey: .citySpecializationAI)
        // try container.encode(self.wonderProductionAI, forKey: .wonderProductionAI)

        try container.encode(self.cityConnections, forKey: .cityConnections)
        try container.encode(self.goodyHuts, forKey: .goodyHuts)
        try container.encode(self.tradeRoutes as! TradeRoutes, forKey: .tradeRoutes)
        try container.encode(self.governors as! PlayerGovernors, forKey: .governors)

        try container.encode(self.techs as! Techs, forKey: .techs)
        try container.encode(self.civics as! Civics, forKey: .civics)
        try container.encode(self.religion as! PlayerReligion, forKey: .religion)
        try container.encode(self.treasury as! Treasury, forKey: .treasury)
        try container.encode(self.greatPeople as! GreatPeople, forKey: .greatPeople)
        try container.encode(self.tourism as! PlayerTourism, forKey: .tourism)
        try container.encode(self.momentsVal as! PlayerMoments, forKey: .moments)
        try container.encode(self.envoys as! PlayerEnvoys, forKey: .envoys)
        try container.encodeIfPresent(self.suzerainValue, forKey: .suzerain)
        try container.encode(self.questsValue, forKey: .quests)
        try container.encode(self.oldQuestsValue, forKey: .oldQuests)
        try container.encode(self.influencePointsValue, forKey: .influencePoints)
        try container.encode(self.government as! Government, forKey: .government)

        try container.encode(self.currentEraVal, forKey: .currentEra)
        try container.encode(self.currentAgeVal, forKey: .currentAge)
        try container.encode(self.currentDedicationsVal, forKey: .currentDedications)
        try container.encode(self.numberOfDarkAgesVal, forKey: .numberOfDarkAges)
        try container.encode(self.numberOfGoldenAgesVal, forKey: .numberOfGoldenAges)

        try container.encode(self.operations, forKey: .operations)
        try container.encode(self.notificationsValue, forKey: .notifications)
        try container.encode(self.resourceProduction, forKey: .resourceProduction)
        try container.encode(self.resourceStockpile, forKey: .resourceStockpile)
        try container.encode(self.resourceMaxStockpile, forKey: .resourceMaxStockpile)

        try container.encode(self.originalCapitalLocationValue, forKey: .originalCapitalLocation)
        try container.encode(self.lostCapitalValue, forKey: .lostCapital)
        try container.encodeIfPresent(self.conquerorValue, forKey: .conqueror)
        try container.encode(self.beingResurrectedValue, forKey: .beingResurrected)
        try container.encode(self.liberatedByValue, forKey: .liberatedBy)

        try container.encode(self.canChangeGovernmentValue, forKey: .canChangeGovernment)
        try container.encode(self.happinessValue, forKey: .happiness)
        try container.encode(self.faithPurchaseTypeVal, forKey: .faithPurchaseType)
        try container.encode(self.boostExoplanetExpeditionValue, forKey: .boostExoplanetExpedition)
        try container.encode(self.discoveredNaturalWonders, forKey: .discoveredNaturalWonders)
        try container.encode(self.settledContinents, forKey: .settledContinents)
        try container.encode(self.hasWorldCircumnavigatedVal, forKey: .hasWorldCircumnavigated)
        try container.encode(self.establishedTradingPosts, forKey: .establishedTradingPosts)
        try container.encode(self.tradingCapacityValue, forKey: .tradingCapacity)
        try container.encode(self.trainedSettlersValue, forKey: .trainedSettlers)

        try container.encode(self.crampedValue, forKey: .cramped)
        try container.encode(self.combatThisTurnValue, forKey: .combatThisTurn)

        try container.encode(self.markersValue, forKey: .markers)
    }
    // swiftlint:enable force_cast

    // public methods

    public func initialize() {

        self.setupFlavors()

        self.grandStrategyAI = GrandStrategyAI(player: self)
        self.diplomacyAI = DiplomaticAI(player: self)
        self.diplomacyRequests = DiplomacyRequests(player: self)
        self.diplomacyDealAI = DiplomaticDealAI(player: self)
        self.economicAI = EconomicAI(player: self)
        self.militaryAI = MilitaryAI(player: self)
        self.tacticalAI = TacticalAI(player: self)
        self.dangerPlotsAI = DangerPlotsAI(player: self)
        self.homelandAI = HomelandAI(player: self)
        self.builderTaskingAI = BuilderTaskingAI(player: self)
        self.citySpecializationAI = CitySpecializationAI(player: self)
        self.wonderProductionAI = WonderProductionAI(player: self)
        self.religionAI = ReligionAI(player: self)

        self.cityConnections = CityConnections(player: self)
        self.goodyHuts = GoodyHuts(player: self)
        self.tradeRoutes = TradeRoutes(player: self)
        self.governors = PlayerGovernors(player: self)
        self.tourism = PlayerTourism(player: self)
        self.momentsVal = PlayerMoments(player: self)
        self.envoys = PlayerEnvoys(player: self)

        self.techs = Techs(player: self)
        self.civics = Civics(player: self)
        self.religion = PlayerReligion(player: self)
        self.treasury = Treasury(player: self)
        self.greatPeople = GreatPeople(player: self)

        self.government = Government(player: self)

        self.operations = Operations()
        self.notificationsValue = Notifications(player: self)

        self.resourceProduction = ResourceInventory()
        self.resourceProduction?.fill()
        self.resourceStockpile = ResourceInventory()
        self.resourceStockpile?.fill()
        self.resourceMaxStockpile = ResourceInventory()

        for resource in ResourceType.strategic {
            self.resourceMaxStockpile?.add(weight: kBaseStockPileAmount, for: resource)
        }
    }

    func setupFlavors() {

        if !self.personalityFlavor.isEmpty {
            return
        }

        let defaultFlavorValue = 5 // DEFAULT_FLAVOR_VALUE

        if self.isHumanVal {
            // Human player, just set all flavors to average (5)
            for flavorType in FlavorType.all {
                self.personalityFlavor.set(value: defaultFlavorValue, for: flavorType)
            }
        } else {
            for flavorType in FlavorType.all {
                var leaderFlavor = self.leader.flavor(for: flavorType)

                // If no Flavor value is set use the Default
                if leaderFlavor == -1 {
                    leaderFlavor = defaultFlavorValue
                }

                self.personalityFlavor.set(value: leaderFlavor, for: flavorType)
            }

            if !Thread.current.isRunningXCTest {
                // Tweak from default values
                // Make a random adjustment to each flavor value for this leader so they don't play exactly the same
                for flavorType in FlavorType.all {

                    let currentFlavor = self.personalityFlavor.value(of: flavorType)

                    // Don't modify it if it's zero-ed out in the XML
                    guard currentFlavor > 0 else {
                        continue
                    }

                    let adjusted = Flavors.adjustedValue(of: currentFlavor, plusMinus: 2, min: 0, max: 20)
                    self.personalityFlavor.set(value: adjusted, for: flavorType)
                }
            }
        }

        // print("---------------------------------------------------")
        // print("\(self.leader) start with the following flavors:")
        // print("\(self.personalityFlavor)")
    }

    public func hasActiveDiplomacyRequests() -> Bool {

        return false
    }

    public func canFinishTurn() -> Bool {

        if !self.isHuman() {
            return false
        }

        if !self.isAlive() {
            return false
        }

        if !self.isActive() {
            return false
        }

        if !self.hasProcessedAutoMoves() {
            return false
        }

        if self.blockingNotification() != nil {
            return false
        }

        return true
    }

    public func turnFinished() -> Bool {

        return self.finishTurnButtonPressedValue
    }

    public func finishTurn() {

        self.finishTurnButtonPressedValue = true
    }

    public func resetFinishTurnButtonPressed() {

        self.finishTurnButtonPressedValue = false
    }

    public func lastSliceMoved() -> Int {

        return self.lastSliceMovedValue
    }

    public func setLastSliceMoved(to value: Int) {

        self.lastSliceMovedValue = value
    }

    // MARK: - ---

    public func valueOfPersonalityFlavor(of flavor: FlavorType) -> Int {

        return self.leader.flavor(for: flavor)
    }

    public func valueOfPersonalityIndividualFlavor(of flavor: FlavorType) -> Int {

        return self.personalityFlavor.value(of: flavor)
    }

    public func valueOfStrategyAndPersonalityFlavor(of flavor: FlavorType) -> Int {

        guard let activeStrategy = self.grandStrategyAI?.activeStrategy else {
            fatalError("cant get active strategy")
        }

        if activeStrategy == .none {
            return self.personalityFlavor.value(of: flavor)
        }

        return self.personalityFlavor.value(of: flavor) + activeStrategy.flavor(for: flavor)
    }

    public func valueOfStrategyAndPersonalityApproach(of approach: PlayerApproachType) -> Int {

        return self.leader.approachBias(for: approach)
    }

    public func isBarbarian() -> Bool {

        return self.leader == .barbar
    }

    public func isFreeCity() -> Bool {

        return self.leader == .freeCities
    }

    public func isCityState() -> Bool {

        if case .cityState = self.leader {
            return true
        }

        return false
    }

    public func doFirstContact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get other player")
        }

        guard self.leader != otherPlayer.leader else {
            fatalError("cant do first contact with self")
        }

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        self.diplomacyAI?.doFirstContact(with: otherPlayer, in: gameModel)
        otherPlayer.diplomacyAI?.doFirstContact(with: self, in: gameModel)

        if otherPlayer.isMajorAI() || otherPlayer.isHuman() {
            // moment
            self.addMoment(of: .metNewCivilization(civilization: otherPlayer.leader.civilization()), in: gameModel)

            // update eurekas
            if !techs.eurekaTriggered(for: .writing) {
                techs.triggerEureka(for: .writing, in: gameModel)
            }
        }

        if self.isCityState() {
            self.doQuests(in: gameModel)
        }

        if otherPlayer.isCityState() {
            otherPlayer.doQuests(in: gameModel)
        }
    }

    // MARK: defensive pact handling

    public func doDefensivePact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        self.diplomacyAI?.doDefensivePact(with: otherPlayer, in: gameModel)
        otherPlayer?.diplomacyAI?.doDefensivePact(with: self, in: gameModel)
    }

    public func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool {

        if let diplomacyAI = self.diplomacyAI {

            return diplomacyAI.isDefensivePactActive(with: otherPlayer)
        }

        return false
    }

    public func isOpenBordersTradingAllowed() -> Bool {

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        return civics.has(civic: .codeOfLaws)
    }

    public func hasEmbassy(with otherPlayer: AbstractPlayer?) -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.hasEmbassy(with: otherPlayer)
    }

    public func hasSentDelegation(to otherPlayer: AbstractPlayer?) -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.hasSentDelegation(to: otherPlayer)
    }

    public func isAllowsOpenBorders(with otherPlayer: AbstractPlayer?) -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.isOpenBorderAgreementActive(by: otherPlayer)
    }

    public func isAllowEmbassyTradingAllowed() -> Bool {

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        return techs.has(tech: .writing)
    }

    /// is player at war with a specific player/leader?
    public func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.isAtWar(with: otherPlayer)
        // return self.diplomacyAI?.approach(towards: otherPlayer) == .war
    }

    /// is player at war with any player/leader?
    func isAtWar() -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.isAtWar()
    }

    public func atWarCount() -> Int {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.atWarCount()
    }

    public func canDeclareWar(to otherPlayer: AbstractPlayer?) -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.canDeclareWar(to: otherPlayer)
    }

    public func doDeclareWar(to otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get otherPlayer leader")
        }

        diplomacyAI.doDeclareWar(to: otherPlayer, in: gameModel)

        // inform other players, that a city was conquered
        gameModel?.sendGossip(type: .declarationsOfWar(leader: otherLeader), of: self)
    }

    public func doEstablishPeaceTreaty(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get other player")
        }

        print("### add war weariness for \(self.leader) against \(otherPlayer.leader): -2000")
        self.changeWarWeariness(with: otherPlayer, by: -2000)

        diplomacyAI.doEstablishPeaceTreaty(with: otherPlayer, in: gameModel)
    }

    public func makePeace(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        self.doEstablishPeaceTreaty(with: otherPlayer, in: gameModel)
    }

    public func warWeariness(with otherPlayer: AbstractPlayer?) -> Int {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.warWeariness(with: otherPlayer)
    }

    public func changeWarWeariness(with otherPlayer: AbstractPlayer?, by value: Int) {

        self.diplomacyAI?.changeWarWeariness(with: otherPlayer, by: value)
    }

    // https://civilization.fandom.com/wiki/War_weariness_(Civ6)
    public func updateWarWeariness(against otherPlayer: AbstractPlayer?, at point: HexPoint, killed: Bool, in gameModel: GameModel?) {

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get other player")
        }

        guard let tile = gameModel?.tile(at: point) else {
            fatalError("cant get tile")
        }

        // the fight against barbarians does not trigger war weariness
        if self.isBarbarian() || otherPlayer.isBarbarian() {
            return
        }

        // war type / Casus Belli not implemented
        let baseValue = self.currentEraVal.warWearinessValue(formal: false)
        let ownTerritoty = self.isEqual(to: tile.owner())

        let warWearinessVal = baseValue * (ownTerritoty ? 1 : 2) + baseValue * (killed ? 0 : 3)

        print("### add war weariness for \(self.leader) against \(otherPlayer.leader): \(warWearinessVal)")
        self.changeWarWeariness(with: otherPlayer, by: warWearinessVal)

        self.combatThisTurnValue = true
    }

    public func notifications() -> Notifications? {

        return self.notificationsValue
    }

    public func updateNotifications(in gameModel: GameModel?) {

        if let notifications = self.notifications() {
            notifications.update(in: gameModel)
        }

        // if self.diplomacyRequests.up
        /*if (GetDiplomacyRequests())
        {
            GetDiplomacyRequests()->Update();
        }*/
    }

    public func set(blockingNotification: NotificationItem?) {

        self.blockingNotificationValue = blockingNotification
    }

    public func blockingNotification() -> NotificationItem? {

        return self.blockingNotificationValue
    }

    //    --------------------------------------------------------------------------------
    public func hasPromotableUnit(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let activePlayer = gameModel.activePlayer() {

            for loopUnitRef in gameModel.units(of: activePlayer) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if loopUnit.isPromotionReady() && !loopUnit.isDelayedDeath() {
                    return true
                }
            }
        }
        return false
    }

    //    --------------------------------------------------------------------------------
    public func firstPromotableUnit(in gameModel: GameModel?) -> AbstractUnit? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let activePlayer = gameModel.activePlayer() {

            for loopUnitRef in gameModel.units(of: activePlayer) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if loopUnit.isPromotionReady() && !loopUnit.isDelayedDeath() {
                    return loopUnitRef
                }
            }
        }

        return nil
    }

    //    --------------------------------------------------------------------------------
    public func hasReadyUnit(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let activePlayer = gameModel.activePlayer() {

            for loopUnitRef in gameModel.units(of: activePlayer) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if loopUnit.readyToMove() && !loopUnit.isDelayedDeath() {
                    return true
                }
            }
        }

        return false
    }

    //    --------------------------------------------------------------------------------
    public func countReadyUnits(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var rtnValue = 0

        for loopUnitRef in gameModel.units(of: self) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            if loopUnit.readyToMove() && !loopUnit.isDelayedDeath() {
                rtnValue += 1
            }
        }

        return rtnValue
    }

    //    --------------------------------------------------------------------------------
    public func firstReadyUnit(in gameModel: GameModel?) -> AbstractUnit? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let activePlayer = gameModel.activePlayer() {

            for loopUnitRef in gameModel.units(of: activePlayer) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if loopUnit.readyToMove() && !loopUnit.isDelayedDeath() {
                    return loopUnitRef
                }
            }
        }

        return nil
    }

    public func endTurnsForReadyUnits(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let activePlayer = gameModel.activePlayer() {

            for loopUnitRef in gameModel.units(of: activePlayer) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if loopUnit.readyToMove() && !loopUnit.isDelayedDeath() {
                    loopUnit.finishMoves()
                }
            }
        }
    }

    // MARK: proximity functions

    public func doUpdateProximity(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        self.diplomacyAI?.updateProximity(to: otherPlayer, in: gameModel)
    }

    public func proximity(to otherPlayer: AbstractPlayer?) -> PlayerProximityType {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.proximity(to: otherPlayer)
    }

    public func changeUnassignedEnvoys(by value: Int) {

        guard let playerEnvoys = self.envoys else {
            fatalError("cant get playerEnvoys")
        }

        playerEnvoys.changeUnassignedEnvoys(by: value)
    }

    public func numberOfAvailableEnvoys() -> Int {

        guard let playerEnvoys = self.envoys else {
            fatalError("cant get playerEnvoys")
        }

        return playerEnvoys.unassignedEnvoys()
    }

    public func envoysAssigned(to cityState: CityStateType) -> Int {

        guard let playerEnvoys = self.envoys else {
            fatalError("cant get playerEnvoys")
        }

        return playerEnvoys.envoys(in: cityState)
    }

    @discardableResult
    public func assignEnvoy(to cityState: CityStateType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let government = self.government else {
            fatalError("cant get government")
        }

        guard let playerEnvoys = self.envoys else {
            fatalError("cant get playerEnvoys")
        }

        guard let cityStatePlayer = gameModel.cityStatePlayer(for: cityState) else {
            fatalError("cant get player for city state")
        }

        let previouslyAssignedEnvoys = playerEnvoys.envoys(in: cityState)

        let result = playerEnvoys.assignEnvoy(to: cityState)

        if result {

            if previouslyAssignedEnvoys == 0 {
                // diplomaticLeague - The first [Envoy] Envoy you send to each city-state counts as two [Envoy] Envoys.
                if government.has(card: .diplomaticLeague) {
                    self.changeUnassignedEnvoys(by: 1)
                    _ = playerEnvoys.assignEnvoy(to: cityState) // ignore return value
                }
            }

            let cityStateSuzerain = cityStatePlayer.suzerain() != nil ? gameModel.player(for: cityStatePlayer.suzerain()!) : nil

            // check if player is suzerain
            if playerEnvoys.envoys(in: cityState) >= 3 && !self.isEqual(to: cityStateSuzerain) {
                if let playerWithMostEnvoys = gameModel.playerWithMostEnvoys(in: cityState) {
                    if playerWithMostEnvoys.isEqual(to: self) {
                        cityStatePlayer.set(suzerain: self.leader)

                        if !gameModel.anyHasMoment(of: .cityStatesFirstSuzerain(cityState: cityState)) {
                            self.addMoment(of: .cityStatesFirstSuzerain(cityState: cityState), in: gameModel)
                        }
                    }
                } else {
                    // no player with most envoys
                    cityStatePlayer.resetSuzerain()
                }
            }
        }

        return result
    }

    @discardableResult
    public func unassignEnvoy(from cityState: CityStateType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let playerEnvoys = self.envoys else {
            fatalError("cant get playerEnvoys")
        }

        guard let cityStatePlayer = gameModel.cityStatePlayer(for: cityState) else {
            fatalError("cant get player for city state")
        }

        let result = playerEnvoys.unassignEnvoy(from: cityState)

        if result {
            let cityStateSuzerain = cityStatePlayer.suzerain() != nil ? gameModel.player(for: cityStatePlayer.suzerain()!) : nil

            if playerEnvoys.envoys(in: cityState) < 3 && self.isEqual(to: cityStateSuzerain) {

                if let playerWithMostEnvoys = gameModel.playerWithMostEnvoys(in: cityState) {
                    if playerWithMostEnvoys.envoysAssigned(to: cityState) >= 3 {
                        cityStatePlayer.set(suzerain: playerWithMostEnvoys.leader)
                    } else {
                        cityStatePlayer.resetSuzerain()
                    }
                } else {
                    // no player with most envoys
                    cityStatePlayer.resetSuzerain()
                }
            }
        }

        return result
    }

    public func metCityStates(in gameModel: GameModel?) -> [CityStateType] {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        var cityStatesArr: [CityStateType] = []

        for player in gameModel.players {

            guard !player.isEqual(to: self) else {
                continue
            }

            if player.isCityState() {
                if diplomacyAI.hasMet(with: player) {
                    if case .cityState(type: let cityStateType) = player.leader {
                        cityStatesArr.append(cityStateType)
                    }
                }
            }
        }

        return cityStatesArr
    }

    public func set(suzerain leader: LeaderType) {

        self.suzerainValue = leader
    }

    public func resetSuzerain() {

        self.suzerainValue = nil
    }

    public func suzerain() -> LeaderType? {

        return self.suzerainValue
    }

    public func envoyEffects(in gameModel: GameModel?) -> [EnvoyEffect] {

        guard let playerEnvoys = self.envoys else {
            fatalError("cant get playerEnvoys")
        }

        return playerEnvoys.envoyEffects(in: gameModel)
    }

    public func isSuzerain(of cityState: CityStateType, in gameModel: GameModel?) -> Bool {

        guard let playerEnvoys = self.envoys else {
            fatalError("cant get playerEnvoys")
        }

        return playerEnvoys.isSuzerain(of: cityState, in: gameModel)
    }

    public func quest(for leader: LeaderType) -> CityStateQuest? {

        guard self.isCityState() else {
            return nil
        }

        if let quest = self.questsValue.first(where: { $0.leader == leader }) {
            return quest
        }

        return nil
    }

    public func fulfillQuest(by leader: LeaderType, in gameModel: GameModel?) {

        guard let quest = self.questsValue.first(where: { $0.leader == leader }) else {
            fatalError("cant get quest")
        }

        self.questsValue.removeAll(where: { $0.leader == leader })

        if let player = gameModel?.player(for: leader) {
            player.changeUnassignedEnvoys(by: 1)

            if player.isHuman() {
                // inform player
                player.notifications()?.add(
                    notification: .questCityStateFulfilled(
                        cityState: quest.cityState,
                        quest: quest.type
                    )
                )
            }
        }
    }

    public func obsoleteQuest(by leader: LeaderType, in gameModel: GameModel?) {

        guard let quest = self.questsValue.first(where: { $0.leader == leader }) else {
            fatalError("cant get quest")
        }

        self.questsValue.removeAll(where: { $0.leader == leader })

        if let player = gameModel?.player(for: leader) {

            if player.isHuman() {
                // inform player
                player.notifications()?.add(
                    notification: .questCityStateObsolete(
                        cityState: quest.cityState,
                        quest: quest.type
                    )
                )
            }
        }
    }

    public func doQuests(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard self.isCityState() else {
            return
        }

        for questPlayer in gameModel.players {

            guard !questPlayer.isCityState() && !questPlayer.isBarbarian() && !questPlayer.isFreeCity() else {
                continue
            }

            guard self.hasMet(with: questPlayer) else {
                continue
            }

            guard self.quest(for: questPlayer.leader) == nil else {
                continue
            }

            var possibleQuests: [CityStateQuestType] = []

            for questType in CityStateQuestType.all {

                switch questType {

                case .none:
                    // NOOP
                    break

                case .trainUnit(type: _):

                    var possibleUnitTypes = UnitType.all
                        .filter({ unitType in
                            if unitType.isGreatPerson() {
                                return false
                            }

                            if !self.canTrain(unitType: unitType, continueFlag: false, testVisible: false, ignoreCost: true, ignoreUniqueUnitStatus: false) {
                                return false
                            }

                            return true
                        })

                    // check last quest
                    if let lastQuest = self.oldQuestsValue.last {
                        if case .trainUnit(type: let unitType) = lastQuest.type {

                            // filter out the last type
                            possibleUnitTypes = possibleUnitTypes.filter { $0 != unitType }
                        }
                    }

                    if !possibleUnitTypes.isEmpty {
                        // Train a certain unit. (Will be lost if the unit becomes obsolete.)
                        let selectedUnitType = possibleUnitTypes.randomItem()
                        possibleQuests.append(.trainUnit(type: selectedUnitType))
                    }

                case .constructDistrict(type: _):

                    var possibleDistricts = DistrictType.all
                        .filter({ districtType in
                            if let requiredTech = districtType.requiredTech() {
                                if !questPlayer.has(tech: requiredTech) {
                                    return false
                                }
                            }

                            if let requiredCivic = districtType.requiredCivic() {
                                if !questPlayer.has(civic: requiredCivic) {
                                    return false
                                }
                            }

                            if districtType == .cityCenter {
                                return false
                            }

                            return true
                        })

                    // check last quest
                    if let lastQuest = self.oldQuestsValue.last {
                        if case .constructDistrict(type: let districtType) = lastQuest.type {

                            // filter out the last type
                            possibleDistricts = possibleDistricts.filter { $0 != districtType }
                        }
                    }

                    if !possibleDistricts.isEmpty {
                        // Construct a certain district.
                        let selectedDistrict = possibleDistricts.randomItem()
                        possibleQuests.append(.constructDistrict(type: selectedDistrict))
                    }

                case .triggerEureka(tech: _):

                    guard let techs = questPlayer.techs else {
                        continue
                    }

                    // get all civics that did not trigger an inspiration yet
                    var possibleTechs = techs.possibleTechs()
                        .filter { !techs.eurekaTriggered(for: $0) }

                    // check last quest
                    if let lastQuest = self.oldQuestsValue.last {
                        if case .triggerEureka(tech: let techType) = lastQuest.type {

                            // filter out the last type
                            possibleTechs = possibleTechs.filter { $0 != techType }
                        }
                    }

                    // Trigger a Eureka Eureka for a certain tech.
                    // (Can be completed by a Spy that succeeds at a Steal Tech Boost mission. Will be lost if you research the tech.)
                    if !possibleTechs.isEmpty {
                        let selectedTech = possibleTechs.randomItem()
                        possibleQuests.append(.triggerEureka(tech: selectedTech))
                    }

                case .triggerInspiration(civic: _):

                    guard let civics = questPlayer.civics else {
                        continue
                    }

                    // get all civics that did not trigger an inspiration yet
                    var possibleCivics = civics.possibleCivics()
                        .filter { !civics.inspirationTriggered(for: $0) }

                    // check last quest
                    if let lastQuest = self.oldQuestsValue.last {
                        if case .triggerInspiration(civic: let civicType) = lastQuest.type {

                            // filter out the last type
                            possibleCivics = possibleCivics.filter { $0 != civicType }
                        }
                    }

                    // Trigger an Inspiration Inspiration for a certain civic. (Will be lost if you unlock the civic.)
                    if !possibleCivics.isEmpty {
                        let selectedCivic = possibleCivics.randomItem()
                        possibleQuests.append(.triggerInspiration(civic: selectedCivic))
                    }

                case .recruitGreatPerson(greatPerson: _):

                    var greatPersonTypes = GreatPersonType.all

                    // check last quest
                    if let lastQuest = self.oldQuestsValue.last {
                        if case .recruitGreatPerson(greatPerson: let greatPersonType) = lastQuest.type {

                            // filter out the last type
                            greatPersonTypes = greatPersonTypes.filter { $0 != greatPersonType }
                        }
                    }

                    let selectedGreatPersonType = greatPersonTypes.randomItem()

                    // Recruit a certain type of Great Person Great Person.
                    possibleQuests.append(.recruitGreatPerson(greatPerson: selectedGreatPersonType))

                case .convertToReligion(religion: _):
                    // Convert the city-state to your religion. (Given only if you have founded a religion.)
                    if let questPlayerReligion = questPlayer.religion?.currentReligion() {
                        if let cityStateReligion = self.religion?.currentReligion() {
                            if questPlayerReligion != .none && cityStateReligion != questPlayerReligion {
                                possibleQuests.append(.convertToReligion(religion: questPlayerReligion))
                            }
                        }
                    }

                case .sendTradeRoute:
                    var lastQuestWasSendTradeRoute = false
                    if let lastQuest = self.oldQuestsValue.last {
                        if lastQuest.type == .sendTradeRoute {
                            lastQuestWasSendTradeRoute = true
                        }
                    }

                    if !lastQuestWasSendTradeRoute {
                        // Send a Trade Route Trade Route to the city-state.
                        possibleQuests.append(.sendTradeRoute)
                    }

                case .destroyBarbarianOutput(location: _):
                    // Destroy a Barbarian Outpost within 5 tiles of the city-state.
                    // (Will be lost if anyone else destroys it first.)
                    if let capital = self.capitalCity(in: gameModel) {
                        for point in capital.location.areaWith(radius: 5) {

                            guard let tile = gameModel.tile(at: point) else {
                                continue
                            }

                            if tile.has(improvement: .barbarianCamp) {
                                // note: this is not necessarily the nearest barbarian camp
                                possibleQuests.append(.destroyBarbarianOutput(location: point))
                                break
                            }
                        }
                    }
                }
            }

            guard !possibleQuests.isEmpty else {
                print("no quests possible")
                return
            }

            guard case .cityState(type: let cityStateType) = self.leader else {
                fatalError("this is not a city state")
            }

            let quest = CityStateQuest(cityState: cityStateType, leader: questPlayer.leader, type: possibleQuests.randomItem())
            self.oldQuestsValue.append(quest)
            self.questsValue.append(quest)

            if self.isHuman() {
                //
                self.notifications()?.add(notification: .questCityStateGiven(cityState: cityStateType, quest: quest.type))
            }
        }
    }

    public func ownQuests(in gameModel: GameModel?) -> [CityStateQuest] {

        guard let gameModel = gameModel else {
            return []
        }

        var ownQuests: [CityStateQuest] = []

        for player in gameModel.players {

            guard player.isCityState() else {
                continue
            }

            guard case .cityState(type: let cityStateType) = player.leader else {
                fatalError("this is not a city state")
            }

            if let playerQuest = player.quest(for: self.leader) {
                let quest = CityStateQuest(cityState: cityStateType, leader: self.leader, type: playerQuest.type)
                ownQuests.append(quest)
            }
        }

        return ownQuests
    }

    /// --- WARNING: THIS IS FOR TESTING ONLY ---
    public func set(quest: CityStateQuest, for leader: LeaderType) {

        if !Thread.current.isRunningXCTest {
            fatalError("--- WARNING: THIS IS FOR TESTING ONLY ---")
        }

        self.questsValue.removeAll(where: { $0.leader == leader })

        self.questsValue.append(quest)
    }

    public func resetQuests(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        for quest in self.questsValue {

            guard let player = gameModel.player(for: quest.leader) else {
                continue
            }

            if player.isHuman() {
                player.notifications()?.add(notification: .questCityStateObsolete(cityState: quest.cityState, quest: quest.type))
            }
        }

        self.questsValue.removeAll()
    }

    /// Have we lost our capital in war?
    public func hasHasLostCapital() -> Bool {

        return self.lostCapitalValue
    }

    /// Player who first captured our capital
    public func capitalConqueror() -> LeaderType? {

        return self.conquerorValue
    }

    /// Sets us to having lost our capital in war
    /// also checks for domination victory
    // void CvPlayer::SetHasLostCapital(bool bValue, PlayerTypes eConqueror)
    public func set(hasLostCapital value: Bool, to conqueror: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        if value != self.lostCapitalValue {

            self.lostCapitalValue = value
            self.conquerorValue = conqueror?.leader

            // Someone just lost their capital, test to see if someone wins
            if value {

                // slewis - Moved Conquest victory elsewhere so that victory is more accurately awarded
                // GC.getGame().DoTestConquestVictory();

                // notify users about another player lost his capital
                if self.isHuman() {
                    gameModel.userInterface?.showPopup(popupType: .lostOwnCapital)
                } else {
                    if self.hasMet(with: gameModel.humanPlayer()) {
                        gameModel.userInterface?.showPopup(popupType: .lostCapital(leader: self.leader))
                    } else {
                        gameModel.userInterface?.showPopup(popupType: .lostCapital(leader: .unmet))
                    }
                }

                // todo: add replay message
                // GC.getGame().addReplayMessage(REPLAY_MESSAGE_MAJOR_EVEN
            }
        }
    }

    public func set(beingResurrected: Bool) {

        self.beingResurrectedValue = beingResurrected
    }

    public func beingResurrected() -> Bool {

        return self.beingResurrectedValue
    }

    public func set(liberatedBy: LeaderType) {

        self.liberatedByValue = liberatedBy
    }

    public func liberatedBy() -> LeaderType {

        return self.liberatedByValue
    }

    public func hasMet(with otherPlayer: AbstractPlayer?) -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        if otherPlayer.isBarbarian() {
            return false
        }

        return diplomacyAI.hasMet(with: otherPlayer)
    }

    func isForcePeace(with otherPlayer: AbstractPlayer?) -> Bool {

        // return self.diplomacyAI?.
        return false
    }

    public func isAlive() -> Bool {

        return self.isAliveVal
    }

    public func set(alive: Bool, in gameModel: GameModel?) {

        if self.isAliveVal != alive {

            self.isAliveVal = alive

            if !alive {
                // cleanup
                // killUnits();
                // killCities();
                // GC.getGame().GetGameDeals()->DoCancelAllDealsWithPlayer(GetID());

                if self.isHuman() {
                    gameModel?.set(gameState: .over)
                }

                self.endTurn(in: gameModel)
            }
        }
    }

    public func isEverAlive() -> Bool {

        return true
    }

    public func verifyAlive(in gameModel: GameModel?) {

        if self.isAlive() {

            if !self.isBarbarian() && !self.isFreeCity() {

                if self.numberOfCities(in: gameModel) == 0 && self.numUnits(in: gameModel) == 0 {

                    self.set(alive: false, in: gameModel)
                }
            }
        } else {
            // if dead but has received units / cities - revive
            if self.numUnits(in: gameModel) > 0 || self.numberOfCities(in: gameModel) > 0 {
                self.set(alive: true, in: gameModel)
            }
        }
    }

    public func isActive() -> Bool {

        return self.turnActive
    }

    public func isHuman() -> Bool {

        return self.isHumanVal
    }

    public func isMajorAI() -> Bool {

        return !self.isHuman() && !self.isFreeCity() && !self.isBarbarian() && !self.isCityState()
    }

    public func eraScore() -> Int {

        return self.momentsVal?.eraScore() ?? 0
    }

    // https://civilization.fandom.com/wiki/Age_(Civ6)
    public func ageThresholds(in gameModel: GameModel?) -> AgeThresholds {

        let numberOfGoldenAges = self.numberOfGoldenAgesVal
        let numberOfDarkAges = self.numberOfDarkAgesVal
        let cities = gameModel?.cities(of: self).count ?? 0
        let lowerThreshold = 11 + numberOfGoldenAges * 5 - numberOfDarkAges * 5 + cities
        let upperThreshold = lowerThreshold + 12

        return AgeThresholds(
            lower: lowerThreshold,
            upper: upperThreshold
        )
    }

    public func estimateNextAge(in gameModel: GameModel?) -> AgeType {

        let eraScore: Int = self.eraScore()
        let thresholds = self.ageThresholds(in: gameModel)

        if eraScore < thresholds.lower {
            return .dark
        } else if eraScore >= thresholds.upper {
            return .golden
        } else {
            return .normal
        }
    }

    func selectCurrentAge(in gameModel: GameModel?) {

        let nextAge = self.estimateNextAge(in: gameModel)

        if nextAge == .dark {
            self.numberOfDarkAgesVal += 1

            self.addMoment(of: .darkAgeBegins, in: gameModel)
        } else if nextAge == .golden {
            self.numberOfGoldenAgesVal += 1
        }

        self.currentAgeVal = nextAge
    }

    public func currentAge() -> AgeType {

        return self.currentAgeVal
    }

    public func currentDedications() -> [DedicationType] {

        return self.currentDedicationsVal
    }

    public func has(dedication: DedicationType) -> Bool {

        return self.currentDedicationsVal.contains(dedication)
    }

    public func select(dedications: [DedicationType]) {

        self.currentDedicationsVal = dedications
    }

    public func calculateGoldPerTurn(in gameModel: GameModel?) -> Double {

        guard let treasury = self.treasury else {
            fatalError("cant get treasury")
        }

        return treasury.calculateGrossGold(in: gameModel)
    }

    func hasActiveDiploRequestWithHuman() -> Bool {

        return false
    }

    public func isTurnActive() -> Bool {

        return self.turnActive
    }

    public func prepareTurn(in gameModel: GameModel?) {

        // Barbarians get all Techs that 3/4 of alive players get
        if isBarbarian() {
            // self.doBarbarianTech()
        }

        /*for (iI = 0; iI < GC.getNumTechInfos(); iI++)  {
            GetTeamTechs()->SetNoTradeTech(((TechTypes)iI), false);
        }

        DoTestWarmongerReminder();

        DoTestSmallAwards(); */
        self.checkWorldCircumnavigated(in: gameModel)
    }

    public func startTurn(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard isTurnActive() == false else {
            print("try to start already active turn")
            return
        }

        if self.isHuman() {
            print("--- start turn for HUMAN player \(self.leader) ---")
        } else if self.isBarbarian() {
            print("--- start turn for barbarian player ---")
        } else if case .cityState(type: let cityStateType) = self.leader {
            print("--- start turn for city state \(cityStateType.name()) ---")
        } else if self.isMajorAI() {
            print("--- start turn for AI player \(self.leader) ---")
        }
        gameModel.userInterface?.update(activePlayer: self)

        self.turnActive = true
        self.setEndTurn(to: false, in: gameModel)
        self.setAutoMoves(to: false)

        /////////////////////////////////////////////
        // TURN IS BEGINNING
        /////////////////////////////////////////////

        // self.doUnitAttrition()
        self.verifyAlive(in: gameModel)

        self.setAllUnitsUnprocessed(in: gameModel)

        gameModel.updateTacticalAnalysisMap(for: self)

        //
        self.updateTimers(in: gameModel)

        // This block all has things which might change based on city connections changing
        self.cityConnections?.turn(with: gameModel)
        self.builderTaskingAI?.update(in: gameModel)

        if gameModel.currentTurn > 0 {

            if self.isAlive() {

                self.doTurn(in: gameModel)
                self.doTurnUnits(in: gameModel)
            }
        }

        if gameModel.currentTurn == 1 && gameModel.showTutorialInfos() {

            if self.isHuman() {
                gameModel.userInterface?.showPopup(popupType: .tutorialStart(tutorial: gameModel.tutorialInfos()))
            }
        }
    }

    public func endTurn(in gameModel: GameModel?) {

        guard self.isTurnActive() == true else {
            fatalError("try to end an inactive turn")
        }

        // print("--- unit animation running: \(gameModel?.userInterface?.animationsAreRunning(for: self.leader)) ---")
        print("--- end turn for \(self.isHuman() ? "HUMAN": "AI") player \(self.leader) ---")

        self.turnActive = false

        /////////////////////////////////////////////
        // TURN IS ENDING
        /////////////////////////////////////////////

        self.doUnitReset(in: gameModel)
        self.set(canChangeGovernment: false)

        if let notifications = self.notificationsValue {
            notifications.cleanUp(in: gameModel)
        }

        if let diplomacyRequests = self.diplomacyRequests {
            diplomacyRequests.endTurn()
        }
    }

    internal func doTurn(in gameModel: GameModel?) {

        guard let userInterface = gameModel?.userInterface else {
            fatalError("cant get userInterface")
        }

        self.doEurekas(in: gameModel)
        self.doResourceStockpile(in: gameModel)
        self.doSpaceRace(in: gameModel)
        self.tourism?.doTurn(in: gameModel)

        // inform ui about new notifications
        self.notificationsValue?.update(in: gameModel)

        var hasActiveDiploRequest = false
        if self.isAlive() {

            if !self.isBarbarian() && !self.isFreeCity() && !self.isCityState() {

                // self.doUnitDiversity()
                self.doUpdateCramped(in: gameModel)
                // DoUpdateUprisings();
                // DoUpdateCityRevolts();
                // CalculateNetHappiness();
                // SetBestWonderCities();
                self.doUpdateTradeRouteCapacity(in: gameModel)

                self.grandStrategyAI?.doTurn(in: gameModel)

                // Do diplomacy for toward everyone
                self.diplomacyAI?.doTurn(in: gameModel)
                self.governors?.doTurn(in: gameModel)

                if !self.isHuman() {
                    hasActiveDiploRequest = self.hasActiveDiploRequestWithHuman()
                }
            }

            if self.isCityState() {
                self.doQuests(in: gameModel)
            }
        }

        if (hasActiveDiploRequest || userInterface.isShown(screen: .diplomatic)) && !self.isHuman() {
            gameModel?.setWaitingForBlockingInput(of: self)
        } else {
            self.doTurnPostDiplomacy(in: gameModel)
        }
    }

    public func doTurnPostDiplomacy(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        if self.isAlive() {
            if !self.isBarbarian() && !self.isFreeCity() {
                self.economicAI?.doTurn(in: gameModel)
                self.militaryAI?.doTurn(in: gameModel)
                self.citySpecializationAI?.doTurn(in: gameModel)
            }
        }

        // Golden Age
        self.doProcessAge(in: gameModel)

        self.doUpdateWarWeariness(in: gameModel)

        // balance amenities
        self.doCityAmenities(in: gameModel)

        // Do turn for all Cities
        for cityRef in gameModel.cities(of: self) {

            cityRef?.doTurn(in: gameModel)
        }

        // Gold GetTreasury()->DoGold();
        self.treasury?.doTurn(in: gameModel)

        // Culture / Civics
        self.doCivics(in: gameModel)

        // Science / Techs
        self.doTechs(in: gameModel) // doResearch

        // government
        self.doGovernment(in: gameModel)

        // faith / religion
        self.doFaith(in: gameModel)

        // great people
        self.doGreatPeople(in: gameModel)

        self.doTurnPost()
    }

    /// Is the player is cramped in his current area?
    public func isCramped() -> Bool {

        return self.crampedValue
    }

    /// Determines if the player is cramped in his current area.  Not a perfect algorithm, as it will double-count Plots shared by different Cities, but it should be good enough
    func doUpdateCramped(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        self.crampedValue = false

        var totalPlotsNearby = 0
        var usablePlotsNearby = 0

        let range = 5 // CRAMPED_RANGE_FROM_CITY

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            for neighborPoint in city.location.areaWith(radius: range) {

                guard let tile = gameModel.tile(at: neighborPoint) else {
                    continue
                }

                if !tile.hasOwner() || tile.ownerLeader() != self.leader {

                    totalPlotsNearby += 1

                    // A "good" unowned Plot
                    if !tile.hasOwner() /*&& tile.isValidMovePlot(GetID())*/ && !tile.isWater() {
                        usablePlotsNearby += 1
                    }
                }
            }
        }

        if totalPlotsNearby > 0 && (100 * usablePlotsNearby) / totalPlotsNearby <= 20 /* CRAMPED_USABLE_PLOT_PERCENT */ {
            self.crampedValue = true
        }
    }

    func doEurekas(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        if !civics.inspirationTriggered(for: .earlyEmpire) {
            if self.population(in: gameModel) >= 6 {
                civics.triggerInspiration(for: .earlyEmpire, in: gameModel)
            }
        }
    }

    func doSpaceRace(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.has(project: .terrestrialLaserStation) {
                self.boostExoplanetExpeditionValue += 1
            }
        }
    }

    func doGovernment(in gameModel: GameModel?) {

        guard let government = self.government else {
            fatalError("cant get government")
        }

        guard let notifications = self.notifications() else {
            fatalError("cant get notifications")
        }

        // update influence points
        if let currentGovernmentType = government.currentGovernment() {
            self.influencePointsValue += currentGovernmentType.influcencePointsPerTurn()

            if self.influencePointsValue > currentGovernmentType.envoyPerInflucencePoints() {

                self.changeUnassignedEnvoys(by: currentGovernmentType.envoysFromInflucencePoints())
                self.influencePointsValue = 0
            }
        }

        if self.canChangeGovernment() {
            if self.isHuman() {
                notifications.add(notification: .canChangeGovernment)
            } else {
                self.government?.chooseBestGovernment(in: gameModel)
            }
        }

        if !government.hasPolicyCardsFilled(in: gameModel) && self.capitalCity(in: gameModel) != nil {

            if self.isHuman() {
                notifications.add(notification: .policiesNeeded)
            } else {
                self.government?.fillPolicyCards(in: gameModel)
            }
        }
    }

    func doGreatPeople(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        guard let greatPeople = self.greatPeople else {
            fatalError("cant get greatPeople")
        }

        if self.isBarbarian() {
            // no great people for barbarians
            return
        }

        // effects from builds / wonders in each city
        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            let greatPeoplePoints = city.greatPeoplePointsPerTurn(in: gameModel)
            greatPeople.add(points: greatPeoplePoints)
        }

        // add effects from policy cards
        greatPeople.add(points: self.greatPeoplePointsFromPolicyCards(in: gameModel))

        // add effects from dedication
        // exodusOfTheEvangelists + golden - +4 Great Prophet Great Prophet points per turn.
        if self.currentAgeVal == .golden && self.has(dedication: .exodusOfTheEvangelists) {
            greatPeople.add(points: GreatPersonPoints(greatProphet: 4))
        }

        // check if points are enough to gain a great person
        for greatPersonType in GreatPersonType.all {

            if let greatPersonToSpawn = gameModel.greatPerson(of: greatPersonType, points: greatPeople.value(for: greatPersonType), for: self) {

                if self.isHuman() {

                    // User get notification
                    self.notifications()?.add(notification: .canRecruitGreatPerson(greatPerson: greatPersonToSpawn))

                } else {
                    // AI always takes great persons
                    self.recruit(greatPerson: greatPersonToSpawn, in: gameModel)
                }
            }
        }
    }

    private func greatPeoplePointsFromPolicyCards(in gameModel: GameModel?) -> GreatPersonPoints {

        guard let government = self.government else {
            fatalError("cant get government")
        }

        let greatPeoplePointsFromPolicyCards: GreatPersonPoints = GreatPersonPoints()

        // strategos - +2 Great General points per turn.
        if government.has(card: .strategos) {
            greatPeoplePointsFromPolicyCards.greatGeneral += 2
        }

        // inspiration - +2 Great Scientist points per turn.
        if government.has(card: .inspiration) {
            greatPeoplePointsFromPolicyCards.greatScientist += 2
        }

        // revelation - +2 Great Prophet points per turn.
        if government.has(card: .revelation) {
            greatPeoplePointsFromPolicyCards.greatProphet += 2
        }

        // literaryTradition - +2 Great Writer points per turn.
        if government.has(card: .literaryTradition) {
            greatPeoplePointsFromPolicyCards.greatWriter += 2
        }

        // navigation - +2 Great Admiral points per turn.
        if government.has(card: .navigation) {
            greatPeoplePointsFromPolicyCards.greatAdmiral += 2
        }

        // travelingMerchants - +2 Great Merchant points per turn.
        if government.has(card: .travelingMerchants) {
            greatPeoplePointsFromPolicyCards.greatMerchant += 2
        }

        // invention - +4 [GreatEngineer] Great Engineer points per turn. +2 additional [GreatEngineer] Great Engineer points for every Workshop.
        if government.has(card: .invention) {
            greatPeoplePointsFromPolicyCards.greatEngineer += 4
        }

        // frescoes - +2 [GreatArtist] Great Artist points per turn. +2 additional [GreatArtist] Great Artist points for every Art Museum.
        if government.has(card: .frescoes) {
            greatPeoplePointsFromPolicyCards.greatArtist += 2
        }

        // nobelPrize - +4 [GreatScientist] Great Scientist points per turn.
        if government.has(card: .nobelPrize) {
            greatPeoplePointsFromPolicyCards.greatArtist += 4
        }

        return greatPeoplePointsFromPolicyCards
    }

    public func recruit(greatPerson: GreatPerson, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        // spawn
        if let capital = gameModel.capital(of: self) {
            // add units
            capital.doSpawn(greatPerson: greatPerson, in: gameModel)

            // moments
            self.addMoment(of: .greatPersonRecruited, in: gameModel)

            if greatPerson.era() < self.currentEraVal {
                self.addMoment(of: .oldGreatPersonRecruited, in: gameModel)
            }

            // check quests
            for quest in self.ownQuests(in: gameModel) {

                if case .recruitGreatPerson(greatPerson: let greatPersonType) = quest.type {

                    if greatPerson.type() == greatPersonType {
                        if let cityStatePlayer = gameModel.cityStatePlayer(for: quest.cityState) {
                            cityStatePlayer.fulfillQuest(by: self.leader, in: gameModel)
                        }
                    }
                }
            }

            // notify the user
            self.notifications()?.add(notification: .greatPersonJoined)

            // send gossip
            gameModel.sendGossip(type: .greatPeopleRecruited(greatPeople: greatPerson), of: self)

            gameModel.invalidate(greatPerson: greatPerson)
            self.greatPeople?.resetPoint(for: greatPerson.type())
            self.greatPeople?.increaseNumberOfSpawned(greatPersonType: greatPerson.type())
        }
    }

    public func canRecruitGreatPerson(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        guard let greatPeople = self.greatPeople else {
            fatalError("cant get greatPeople")
        }

        for greatPersonType in GreatPersonType.all
            where gameModel.greatPerson(of: greatPersonType, points: greatPeople.value(for: greatPersonType), for: self) != nil {

            return true
        }

        return false
    }

    public func retire(greatPerson: GreatPerson, in gameModel: GameModel?) {

        guard let greatPeople = self.greatPeople else {
            fatalError("cant get greatPeople")
        }

        greatPeople.retire(greatPerson: greatPerson, in: gameModel)
    }

    public func hasRetired(greatPerson: GreatPerson) -> Bool {

        guard let greatPeople = self.greatPeople else {
            fatalError("cant get greatPeople")
        }

        return greatPeople.hasRetired(greatPerson: greatPerson)
    }

    // -------------------------------------

    // https://civilization.fandom.com/wiki/Age_(Civ6)
    func doProcessAge(in gameModel: GameModel?) {

        // 
    }

    func doResourceStockpile(in gameModel: GameModel?) {

        guard let resourceStockpile = self.resourceStockpile,
              let resourceMaxStockpile = self.resourceMaxStockpile else {
            fatalError("cant get stock piles")
        }

        guard let government = self.government else {
            fatalError("cant get government")
        }

        // check max stockpile
        for resource in ResourceType.strategic {

            var amount: Double = kBaseStockPileAmount

            // Strategic Resource stockpiles increased by 10
            let numArmories = self.numberBuildings(of: .armory, in: gameModel)
            amount += 10.0 * Double(numArmories)

            self.resourceMaxStockpile?.set(weight: amount, for: resource)
        }

        for resource in ResourceType.strategic {

            var newResource = self.numberOfAvailable(resource: resource)

            // equestrianOrders - All improved Horses and Iron resources yield 1 additional resource per turn.
            if government.has(card: .equestrianOrders) {
                if resource == .horses || resource == .iron {
                    newResource += 1
                }
            }

            for governorType in GovernorType.all {
                if let governor = governors?.governor(with: governorType) {
                    // defenseLogistics - Accumulating Strategic resources gain an additional +1 per turn.
                    if governor.has(title: .defenseLogistics) {
                        newResource += 1
                    }
                }
            }

            resourceStockpile.add(weight: newResource, for: resource)

            // limit
            let maxStockpileValue = resourceMaxStockpile.weight(of: resource)
            if resourceStockpile.weight(of: resource) > maxStockpileValue {
                resourceStockpile.set(weight: maxStockpileValue, for: resource)
            }
        }
    }

    func doUpdateWarWeariness(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        // When at peace with every civilization, you lose 200 WWP per turn.
        if !diplomacyAI.isAtWar() {

            for player in gameModel.players {

                guard self.hasMet(with: player) else {
                    continue
                }

                // hm, with every player?
                self.changeWarWeariness(with: player, by: -200)
            }
        } else {

            // When at war, you lose 50 WWP at the end of every turn without a battle.
            if !self.combatThisTurnValue {

                for player in gameModel.players {

                    guard self.hasMet(with: player) else {
                        continue
                    }

                    self.changeWarWeariness(with: player, by: -50)
                }
            }
        }

        self.combatThisTurnValue = false
    }

    func doCityAmenities(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }

        for cityRef in gameModel.cities(of: self) {

            cityRef?.resetLuxuries()
        }

        var luxuriesToDistribute: [ResourceType] = []

        for resource in ResourceType.all {

            guard resource.usage() == .luxury else {
                continue
            }

            let amountOfResource = Int(self.numberForCityAvailable(resource: resource))

            for _ in 0..<amountOfResource {
                luxuriesToDistribute.append(resource)
            }
        }

        for luxuryToDistribute in luxuriesToDistribute {

            if let city = self.cityNeedsMostLuxuriesButHasnt(luxury: luxuryToDistribute, in: gameModel) {
                city.add(luxury: luxuryToDistribute)
            }
        }

        // amenities from war weariness
        var sumWarWeariness = 0
        for player in gameModel.players {

            if player.isBarbarian() {
                continue
            }

            if !self.hasMet(with: player) {
                continue
            }

            sumWarWeariness += self.warWeariness(with: player)
        }

        let amenitiesNeedForWarWeariness: Int = sumWarWeariness / 400

        // distribute to city based on population
        let sumOfPopulation: Int = self.population(in: gameModel)
        let amenitiesNeedPerPopulation: Double = Double(amenitiesNeedForWarWeariness) / Double(sumOfPopulation)
        var distributedAmenities: Int = 0

        // full numbers
        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            let amenitiesNeeded: Double = Double(city.population()) * amenitiesNeedPerPopulation
            let val: Int = Int(amenitiesNeeded)
            city.set(amenitiesForWarWeariness: val)
            distributedAmenities += val
        }

        // fraction numbers
        while amenitiesNeedForWarWeariness > distributedAmenities {

            // find city that has the greatest gap
            var bestCityRef: AbstractCity?
            var bestDelta: Double = 0.0
            for cityRef in gameModel.cities(of: self) {

                guard let city = cityRef else {
                    continue
                }

                let amenitiesNeeded: Double = Double(city.population()) * amenitiesNeedPerPopulation
                let delta = amenitiesNeeded - Double(city.amenitiesForWarWeariness())

                if delta > bestDelta {
                    bestDelta = delta
                    bestCityRef = cityRef
                }
            }

            if let bestCity = bestCityRef {
                bestCity.set(amenitiesForWarWeariness: bestCity.amenitiesForWarWeariness() + 1)
                distributedAmenities += 1
            }
        }
    }

    private func cityNeedsMostLuxuriesButHasnt(luxury: ResourceType, in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var bestCity: AbstractCity?
        var bestValue: Double = -1.0

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                fatalError("cant get city")
            }

            if city.has(luxury: luxury) {
                continue
            }

            let value = city.luxuriesNeeded(in: gameModel)

            if value > bestValue {
                bestValue = value
                bestCity = city
            }
        }

        return bestCity
    }

    func doCivics(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let civics = self.civics else {
            fatalError("cant get techs")
        }

        let cultureVal = self.culture(in: gameModel, consume: true)
        civics.add(culture: cultureVal)

        do {
            try civics.checkCultureProgress(in: gameModel)
        } catch {
            fatalError("cant check culture progress: \(error)")
        }
    }

    /// How long until a RA with a player takes effect
    func doTechs(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        let scienceVal = self.science(in: gameModel)
        techs.add(science: scienceVal)

        do {
            try techs.checkScienceProgress(in: gameModel)
        } catch {
            fatalError("cant check science progress: \(error)")
        }
    }

    /// Religious activities at the start of a player's turn
    func doFaith(in gameModel: GameModel?) {

        guard let religion = self.religion else {
            fatalError("cant get religion")
        }

        guard let religionAI = self.religionAI else {
            fatalError("cant get religion ai")
        }

        let faithAtStart = religion.faith()
        let faithPerTurn = self.faith(in: gameModel)

        if faithPerTurn > 0 {
            religion.change(faith: faithPerTurn)
        }

        // If just now can afford missionary, add a notification
        var sendFaithPurchaseNotification = self.isHuman() && self.faithPurchaseType() == .noAutomaticFaithPurchase

        if sendFaithPurchaseNotification {
            let couldAtStartAffordFaithPurchase = religion.canAffordFaithPurchase(with: faithAtStart, in: gameModel)
            let canNowAffordFaithPurchase = religion.canAffordFaithPurchase(with: religion.faith(), in: gameModel) // faith has been updated

            sendFaithPurchaseNotification = !couldAtStartAffordFaithPurchase && canNowAffordFaithPurchase
        }

        if sendFaithPurchaseNotification {
            if self.isHuman() {
                gameModel?.userInterface?.showPopup(popupType: .religionCanBuyMissionary)
            }
        }

        // Check for pantheon or great prophet spawning (now restricted so must occur before Industrial era)
        if religion.faith() > 0 && self.currentEra() <= .renaissance {

            if religion.canCreatePantheon(checkFaithTotal: true, in: gameModel) == .okay {

                // Create the pantheon
                if self.isHuman() {
                    // If the player is human then a net message will be received which will pick the pantheon.
                    // You have enough faith to found a pantheon!
                    self.notifications()?.add(notification: .canFoundPantheon)
                } else {
                    // const BeliefTypes eBelief = kPlayer.GetReligionAI()->ChoosePantheonBelief();
                    let pantheonType = religionAI.choosePantheonType(in: gameModel)
                    self.religion?.foundPantheon(with: pantheonType, in: gameModel)
                    gameModel?.foundPantheon(for: self, with: pantheonType)
                }
            }
        }

        // Pick a Reformation belief?
        /*ReligionTypes eReligionCreated = GetFounderBenefitsReligion(ePlayer);
        if (eReligionCreated > RELIGION_PANTHEON && !HasAddedReformationBelief(ePlayer) && (kPlayer.GetPlayerPolicies()->HasPolicyGrantingReformationBelief() || kPlayer.IsReformation()))
        {
            if (!kPlayer.isHuman())
            {
                BeliefTypes eReformationBelief = kPlayer.GetReligionAI()->ChooseReformationBelief(ePlayer, eReligionCreated);
                AddReformationBelief(ePlayer, eReligionCreated, eReformationBelief);
            }
            else
            {
                CvNotifications* pNotifications;
                pNotifications = kPlayer.GetNotifications();
                if(pNotifications)
                {
                    CvString strBuffer = GetLocalizedText("TXT_KEY_NOTIFICATION_ADD_REFORMATION_BELIEF");
                    CvString strSummary = GetLocalizedText("TXT_KEY_NOTIFICATION_SUMMARY_ADD_REFORMATION_BELIEF");
                    pNotifications->Add(NOTIFICATION_ADD_REFORMATION_BELIEF, strBuffer, strSummary, -1, -1, -1);
                }
            }
        }*/

        // Automatic faith purchases?
        var selectionStillValid: Bool = true
        let religionType: ReligionType = religionAI.religionToSpread()

        switch self.faithPurchaseType() {

        case .saveForProphet:
            fatalError("FAITH_PURCHASE_SAVE_PROPHET")
            /*if (eReligion <= RELIGION_PANTHEON && GetNumReligionsStillToFound() <= 0 && !kPlayer.GetPlayerTraits()->IsAlwaysReligion())
            {
                UnitTypes eProphetType = kPlayer.GetSpecificUnitType("UNITCLASS_PROPHET", true);
                szItemName = GetLocalizedText("TXT_KEY_RO_AUTO_FAITH_PROPHET_PARAM", GC.getUnitInfo(eProphetType)->GetDescription());
                bSelectionStillValid = false;
            }
            else if (kPlayer.GetCurrentEra() >= GetFaithPurchaseGreatPeopleEra(&kPlayer))
            {
                UnitTypes eProphetType = kPlayer.GetSpecificUnitType("UNITCLASS_PROPHET", true);
                szItemName = GetLocalizedText("TXT_KEY_RO_AUTO_FAITH_PROPHET_PARAM", GC.getUnitInfo(eProphetType)->GetDescription());

                bSelectionStillValid = false;
            }
            break;*/

        case .purchaseUnit:
            fatalError("FAITH_PURCHASE_UNIT")
                /*UnitTypes eUnit = (UnitTypes)kPlayer.GetFaithPurchaseIndex();
                CvUnitEntry *pkUnit = GC.getUnitInfo(eUnit);
                if (pkUnit)
                {
                    szItemName = pkUnit->GetDescriptionKey();
                }

                if (!kPlayer.IsCanPurchaseAnyCity(false, false /* Don't worry about faith balance */, eUnit, NO_BUILDING, YIELD_FAITH))
                {
                    bSelectionStillValid = false;
                }
                else
                {
                    if (kPlayer.IsCanPurchaseAnyCity(true, true /* Check faith balance */, eUnit, NO_BUILDING, YIELD_FAITH))
                    {
                        CvCity *pCity = CvReligionAIHelpers::GetBestCityFaithUnitPurchase(kPlayer, eUnit, eReligion);
                        if (pCity)
                        {
                            pCity->Purchase(eUnit, NO_BUILDING, NO_PROJECT, YIELD_FAITH);

                            CvNotifications* pNotifications = kPlayer.GetNotifications();
                            if(pNotifications)
                            {
                                CvString strBuffer = GetLocalizedText("TXT_KEY_NOTIFICATION_AUTOMATIC_FAITH_PURCHASE", szItemName, pCity->getNameKey());
                                CvString strSummary = GetLocalizedText("TXT_KEY_NOTIFICATION_SUMMARY_AUTOMATIC_FAITH_PURCHASE");
                                pNotifications->Add(NOTIFICATION_CAN_BUILD_MISSIONARY, strBuffer, strSummary, pCity->getX(), pCity->getY(), -1);
                            }
                        }
                        else
                        {
                            bSelectionStillValid = false;
                        }
                    }
                }*/

        case .purchaseBuilding:
            fatalError("FAITH_PURCHASE_BUILDING")
                /*BuildingTypes eBuilding = (BuildingTypes)kPlayer.GetFaithPurchaseIndex();
                CvBuildingEntry *pkBuilding = GC.getBuildingInfo(eBuilding);
                if (pkBuilding)
                {
                    szItemName = pkBuilding->GetDescriptionKey();
                }

                if (!kPlayer.IsCanPurchaseAnyCity(false, false, NO_UNIT, eBuilding, YIELD_FAITH))
                {
                    bSelectionStillValid = false;
                }
                else
                {
                    if (kPlayer.IsCanPurchaseAnyCity(true, true /* Check faith balance */, NO_UNIT, eBuilding, YIELD_FAITH))
                    {
                        CvCity *pCity = CvReligionAIHelpers::GetBestCityFaithBuildingPurchase(kPlayer, eBuilding, eReligion);
                        if (pCity)
                        {
                            pCity->Purchase(NO_UNIT, eBuilding, NO_PROJECT, YIELD_FAITH);

                            CvNotifications* pNotifications = kPlayer.GetNotifications();
                            if(pNotifications)
                            {
                                CvString strBuffer = GetLocalizedText("TXT_KEY_NOTIFICATION_AUTOMATIC_FAITH_PURCHASE", szItemName, pCity->getNameKey());
                                CvString strSummary = GetLocalizedText("TXT_KEY_NOTIFICATION_SUMMARY_AUTOMATIC_FAITH_PURCHASE");
                                pNotifications->Add(NOTIFICATION_CAN_BUILD_MISSIONARY, strBuffer, strSummary, -1, -1, -1);
                            }
                        }
                        else
                        {
                            bSelectionStillValid = false;
                        }
                    }
                }*/
        default:
            // NOOP
        print("")
        }

        if !selectionStillValid {

            if self.isHuman() {
                gameModel?.userInterface?.showPopup(popupType: .religionNeedNewAutomaticFaithSelection)
            }
        }
    }

    func doTurnPost() {

        if self.isHuman() {
            return
        }

        if self.isBarbarian() {
            return
        }

        /*for (int i = 0; i < GC.getNumVictoryInfos(); ++i)
        {
            AI_launch((VictoryTypes)i);
        }*/
    }

    // CvPlayerAI::AI_unitUpdate()
    public func unitUpdate(in gameModel: GameModel?) {

        // Now its the homeland AI's turn.
        if self.isHuman() {
            self.homelandAI?.doTurn(in: gameModel)
        } else {
            // Now let the tactical AI run.  Putting it after the operations update allows units who have
            // just been handed off to the tactical AI to get a move in the same turn they switch between
            self.tacticalAI?.doTurn(in: gameModel)
            self.homelandAI?.doTurn(in: gameModel)
        }
    }

    func doTurnUnits(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Start: OPERATIONAL AI UNIT PROCESSING
        self.operations?.doDelayedDeath(in: gameModel)
        self.armies?.doDelayedDeath()

        for unitRef in gameModel.units(of: self) {
            unitRef?.doDelayedDeath(in: gameModel)
        }

        self.operations?.doTurn(in: gameModel)

        self.operations?.doDelayedDeath(in: gameModel)

        self.armies?.doTurn(in: gameModel)

        // Homeland AI
        // self.homelandAI?.doTurn(in: gameModel) is empty

        // Start: old unit AI processing
        for pass in 0..<4 {

            for loopUnitRef in gameModel.units(of: self) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                switch loopUnit.domain() {
                case .air:
                    if pass == 1 {
                        loopUnit.doTurn(in: gameModel)
                    }
                case .sea:
                    if pass == 2 {
                        loopUnit.doTurn(in: gameModel)
                    }
                case .land:
                    if pass == 3 {
                        loopUnit.doTurn(in: gameModel)
                    }
                case .immobile:
                    if pass == 0 {
                        loopUnit.doTurn(in: gameModel)
                    }
                case .none:
                    fatalError("Unit with no Domain")
                }
            }
        }

        self.doTurnUnitsPost(in: gameModel) // AI_doTurnUnitsPost();
    }

    func doTurnUnitsPost(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if self.isHuman() {
            return
        }

        for loopUnitRef in gameModel.units(of: self) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            // loopUnit.promot
        }
    }

    /// Units heal and then get their movement back
    func doUnitReset(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for loopUnitRef in gameModel.units(of: self) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            // HEAL UNIT?
            if !loopUnit.isEmbarked() {

                if !loopUnit.hasMoved(in: gameModel) {
                    if loopUnit.isHurt() {
                        loopUnit.doHeal(in: gameModel)
                    }
                }
            }

            // int iCitadelDamage;
            /*if (pLoopUnit->IsNearEnemyCitadel(iCitadelDamage))
            {
                pLoopUnit->changeDamage(iCitadelDamage, NO_PLAYER, /*fAdditionalTextDelay*/ 0.5f);
            }*/

            // Finally (now that healing is done), restore movement points
            loopUnit.resetMoves(in: gameModel)
            // pLoopUnit->SetIgnoreDangerWakeup(false);
            loopUnit.setMadeAttack(to: false)
            // pLoopUnit->setMadeInterception(false);

            if !self.isHuman() {

                if let mission = loopUnit.peekMission() {
                    if mission.type == .rangedAttack {
                        // CvAssertMsg(0, "An AI unit has a combat mission queued at the end of its turn.");
                        loopUnit.clearMissions()    // Clear the whole thing, the AI will re-evaluate next turn.
                    }
                }
            }
        }
    }

    func setAllUnitsUnprocessed(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            return
        }

        for unitRef in gameModel.units(of: self) {

            unitRef?.set(turnProcessed: false)
        }
    }

    public func updateTimers(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            return
        }

        for unitRef in gameModel.units(of: self) {

            guard let unit = unitRef else {
                continue
            }

            unit.updateMission(in: gameModel)
            unit.doDelayedDeath(in: gameModel)
        }

        self.diplomacyAI?.update(in: gameModel)
    }

    // https://civilization.fandom.com/wiki/Victory_(Civ6)
    /*
     Era Score points.
     15 points for each wonder owned.
     10 points for founding a religion.
     5 points for each Great Person Great Person earned.
     5 points for each city owned.
     3 points for each civic researched.
     2 points for each foreign city following the player's religion.
     2 points for each technology researched.
     2 points for each district owned (4 points if it is a unique district).
     1 point for each building (including the Palace).
     1 point for each Citizen Citizen in the player's empire.

     */
    public func score(for gameModel: GameModel?) -> Int {

        if !self.isAliveVal {
            // no need to update, the player died
            return 0
        }

        var scoreVal = 0

        scoreVal += self.scoreFromCities(for: gameModel)
        scoreVal += self.scoreFromBuildings(for: gameModel)
        scoreVal += self.scoreFromPopulation(for: gameModel)
        scoreVal += self.scoreFromTechs(for: gameModel)
        scoreVal += self.scoreFromLand(for: gameModel)
        scoreVal += self.scoreFromCivics(for: gameModel)
        scoreVal += self.scoreFromWonder(for: gameModel)
        scoreVal += self.scoreFromTech(for: gameModel)
        scoreVal += self.scoreFromReligion(for: gameModel)

        return scoreVal
    }

    // 5 points for each city owned.
    private func scoreFromCities(for gameModel: GameModel?) -> Int {

        if let cities = gameModel?.cities(of: self),
            let mapSizeModifier = gameModel?.mapSizeModifier() {

            var score = cities.count * 5

            // weight with map size
            score *= 100
            score /= mapSizeModifier

            return score
        }

        return 0
    }

    // 1 point for each building (including the Palace).
    private func scoreFromBuildings(for gameModel: GameModel?) -> Int {

        if let cities = gameModel?.cities(of: self), let mapSizeModifier = gameModel?.mapSizeModifier() {

            var score = 0

            for cityRef in cities {
                guard let cityBuildings = cityRef?.buildings else {
                    continue
                }

                score += cityBuildings.numberOfBuildings()
            }

            // weight with map size
            score *= 100
            score /= mapSizeModifier

            return score
        }

        return 0
    }

    // 1 point for each Citizen6 Citizen in the player's empire.
    private func scoreFromPopulation(for gameModel: GameModel?) -> Int {

        if let cities = gameModel?.cities(of: self),
            let mapSizeModifier = gameModel?.mapSizeModifier() {

            var score = 0

            for cityRef in cities {
                if let city = cityRef {
                    score += city.population() * 1
                }
            }

            // weight with map size
            score *= 100
            score /= mapSizeModifier

            return score
        }

        return 0
    }

    // 2 points for each technology researched.
    private func scoreFromTechs(for gameModel: GameModel?) -> Int {

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        return techs.numberOfDiscoveredTechs() * 2
    }

    // 2 points for each district owned
    private func scoreFromLand(for gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var score = self.area.size * 2 /*SCORE_LAND_MULTIPLIER */

        // weight with map size
        let mapSizeModifier = gameModel.mapSizeModifier()
        score *= 100
        score /= mapSizeModifier

        return score
    }

    // 3 points for each civic researched.
    private func scoreFromCivics(for gameModel: GameModel?) -> Int {

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        return civics.numberOfDiscoveredCivics() * 3
    }

    // Score from world wonders: 15 points for each wonder owned.
    private func scoreFromWonder(for gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var number = 0

        for city in gameModel.cities(of: self) {

            guard let cityWonders = city?.wonders else {
                fatalError("cant get cityWonders")
            }

            number += cityWonders.numberOfBuiltWonders()
        }

        let score = number * 15 /* SCORE_WONDER_MULTIPLIER */
        return score
    }

    // Score from Tech: 4 per
    private func scoreFromTech(for gameModel: GameModel?) -> Int {

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        // Normally we recompute it each time
        let score = techs.numberOfDiscoveredTechs() * 4 /* SCORE_TECH_MULTIPLIER */
        return score
    }

    // 10 points for founding a religion.
    // 2 points for each foreign city following the player's religion.
    private func scoreFromReligion(for gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let religion = self.religion else {
            fatalError("cant get religion")
        }

        var score = 0

        if religion.currentReligion() != .none {
            // 10 points for founding a religion.
            score += 10

            var numberOfCitiesFollingReligion = 0
            for player in gameModel.players {

                if player.isEqual(to: self) {
                    continue
                }

                for cityRef in gameModel.cities(of: player) {

                    guard let city = cityRef else {
                        continue
                    }

                    if city.religiousMajority() == religion.currentReligion() {
                        numberOfCitiesFollingReligion += 1
                    }
                }
            }

            // 2 points for each foreign city following the player's religion.
            score += numberOfCitiesFollingReligion * 2
        }

        return score
    }

    public func personalAndGrandStrategyFlavor(for flavorType: FlavorType) -> Int {

        guard let grandStrategyAI = self.grandStrategyAI else {
            fatalError("grandStrategyAI not initialized")
        }

        if grandStrategyAI.activeStrategy == .none {
            return self.personalityFlavor.value(of: flavorType)
        }

        let value = self.personalityFlavor.value(of: flavorType) + grandStrategyAI.activeStrategy.flavorModifier(for: flavorType)

        if value < 0 {
            return 0
        }

        return value
    }

    public func hiddenAgenda() -> LeaderAgendaType? {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.currentHiddenAgenda()
    }

    // MARK: era

    public func currentEra() -> EraType {

        return self.currentEraVal
    }

    public func set(era: EraType, in gameModel: GameModel?) {

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        guard era > self.currentEraVal else {
            fatalError("era should be greater")
        }

        self.currentEraVal = era
        self.selectCurrentAge(in: gameModel)

        self.momentsVal?.resetEraScore()

        // Seoul suzerain bonus
        // When you enter a new era, earn 1 random [Eureka] Eureka from that era.
        if self.isSuzerain(of: .seoul, in: gameModel) {

            let possibleTechs = TechType.all
                .filter { $0.era() == self.currentEraVal }
                .filter { !techs.eurekaTriggered(for: $0) }

            if !possibleTechs.isEmpty {
                let selectedTech = possibleTechs.randomItem()
                techs.triggerEureka(for: selectedTech, in: gameModel)
            }
        }

        if !self.isHumanVal {
            var dedications: [DedicationType] = era.dedications()

            let selectable = self.currentAgeVal.numDedicationsSelectable()
            var selected: [DedicationType] = []
            for _ in 0..<selectable {
                let selectedDedication = dedications.randomItem()
                selected.append(selectedDedication)
                dedications.removeAll(where: { $0 == selectedDedication })
            }

            self.select(dedications: selected)
        }
    }

    public func has(tech techType: TechType) -> Bool {

        if let techs = self.techs {
            return techs.has(tech: techType)
        }

        return false
    }

    public func numberOfDiscoveredTechs() -> Int {

        if let techs = self.techs {
            return techs.numberOfDiscoveredTechs()
        }

        return 0
    }

    public func canEmbark() -> Bool {

        return self.has(tech: .shipBuilding)
    }

    public func canEnterOcean() -> Bool {

        return self.has(tech: .cartography)
    }

    public func has(civic civicType: CivicType) -> Bool {

        if let civics = self.civics {
            return civics.has(civic: civicType)
        }

        return false
    }

    public func addGovernorTitle() {

        self.governors?.addTitle()
    }

    public func has(building buildingType: BuildingType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.has(building: buildingType) {
                return true
            }
        }

        return false
    }

    public func has(wonder wonderType: WonderType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.has(wonder: wonderType) {
                return true
            }
        }

        return false
    }

    public func city(with wonderType: WonderType, in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.has(wonder: wonderType) {
                return cityRef
            }
        }

        return nil
    }

    public func advisorMessages() -> [AdvisorMessage] {

        var messages: [AdvisorMessage] = []

        if let militaryAI = self.militaryAI {
            for message in militaryAI.advisorMessages() {
                messages.append(message)
            }
        }

        if let economicAI = self.economicAI {
            for message in economicAI.advisorMessages() {
                messages.append(message)
            }
        }

        return messages
    }

    public func militaryMight(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var might = 0.0

        // Current combat strength strength
        for unitRef in gameModel.units(of: self) {

            if let unit = unitRef {
                might += Double(unit.power())
            }
        }

        // Simplistic increase based on player's gold
        // 500 gold will increase might by 22%, 2000 by 45%, 8000 gold by 90%
        let treasureValue = max(0.0, self.treasury!.value())
        var goldMultiplier = 1.0 + sqrt(treasureValue) / 100.0
        if goldMultiplier > 2.0 { goldMultiplier = 2.0 }

        might *= goldMultiplier

        return Int(might)
    }

    public func economicMight(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Default to 5 so that a fluctuation in Population early doesn't swing things wildly
        var might = 5

        let cities = gameModel.cities(of: self)

        might += cities.map({ $0?.population() ?? 0 }).reduce(0, +)

        return might
    }

    // MARK: city methods

    public func found(at location: HexPoint, named name: String?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: location) else {
            fatalError("cant get tile")
        }

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        let cityName = name ?? self.newCityName(in: gameModel)

        // moments
        // check if tile is on a continent that the player has not settler yet
        if let tileContinent: ContinentType = gameModel.continent(at: location)?.type() {
            if !self.hasSettled(on: tileContinent) {
                self.markSettled(on: tileContinent)

                // only from second city (capital == first city is also founded on a 'new' continent)
                if !gameModel.cities(of: self).isEmpty {
                    let momentType: MomentType = .cityOnNewContinent(cityName: cityName, continentName: tileContinent.name())
                    self.addMoment(of: momentType, in: gameModel)
                }
            }
        }

        if tile.terrain() == .tundra {
            self.addMoment(of: .tundraCity(cityName: cityName), in: gameModel)
        }

        if tile.terrain() == .desert {
            self.addMoment(of: .desertCity(cityName: cityName), in: gameModel)
        }

        if tile.terrain() == .snow {
            self.addMoment(of: .snowCity(cityName: cityName), in: gameModel)
        }

        if gameModel.isLargest(player: self) && !self.hasMoment(of: .worldsLargestCivilization) {
            self.addMoment(of: .worldsLargestCivilization, in: gameModel)
        }

        var nearVolcano: Bool = false
        var nearNaturalWonder: Bool = false
        for neighbor in location.areaWith(radius: 2) {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            if neighborTile.has(feature: .volcano) {
                nearVolcano = true
            }

            if neighborTile.feature().isNaturalWonder() {
                nearNaturalWonder = true
            }
        }

        if nearVolcano && !self.hasMoment(of: .cityNearVolcano(cityName: "")) {
            self.addMoment(of: .cityNearVolcano(cityName: cityName), in: gameModel)
        }

        if nearNaturalWonder && !self.hasMoment(of: .cityOfAwe(cityName: "")) {
            self.addMoment(of: .cityOfAwe(cityName: cityName), in: gameModel)
        }

        let isCapital = gameModel.cities(of: self).isEmpty

        let city = City(name: cityName, at: location, capital: isCapital, owner: self)
        city.initialize(in: gameModel)

        gameModel.add(city: city)

        if self.isHuman() {

            // Human player is prompted to choose production BEFORE the AI runs for the turn.
            // So we'll force the AI strategies on the city now, just after it is founded.
            // And if the very first turn, we haven't even run player strategies once yet, so do that too.
            if gameModel.currentTurn == 0 {
                self.economicAI?.doTurn(in: gameModel)
                self.militaryAI?.doTurn(in: gameModel)
            }

            city.cityStrategy?.turn(with: gameModel)

            if self.isActive() {
                self.notifications()?.add(notification: .productionNeeded(cityName: city.name, location: city.location))
            }

            city.doFoundMessage()

            // If this is the first city (or we still aren't getting tech for some other reason) notify the player
            if techs.needToChooseTech() && self.science(in: gameModel) > 0.0 {

                self.notifications()?.add(notification: .techNeeded)
            }

            // If this is the first city (or ..) notify the player
            if civics.needToChooseCivic() && self.culture(in: gameModel, consume: false) > 0.0 {

                self.notifications()?.add(notification: .civicNeeded)
            }

            if isCapital {
                self.notifications()?.add(notification: .policiesNeeded)
            }

        } else {
            city.doFoundMessage()

            // AI civ, may need to redo city specializations
            self.citySpecializationAI?.setSpecializationsDirty()
        }

        // roman roads
        if self.leader.civilization().ability() == .allRoadsLeadToRome {

            if !isCapital {
                guard let capital = gameModel.capital(of: self) else {
                    fatalError("cant get capital")
                }

                let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
                    for: .walk,
                    for: self,
                    unitMapType: .combat,
                    canEmbark: false,
                    canEnterOcean: self.canEnterOcean()
                )
                let pathFinder = AStarPathfinder(with: pathFinderDataSource)

                if let path = pathFinder.shortestPath(fromTileCoord: location, toTileCoord: capital.location) {
                    // If within TradeRoute6 Trade Route range of the Capital6 Capital, a road to it.
                    if path.count <= TradeRoutes.landRange {

                        for pathLocation in path {

                            if let pathTile = gameModel.tile(at: pathLocation) {
                                pathTile.set(route: self.bestRoute())
                            }
                        }
                    }
                }
            }
        }

        // send gossip
        gameModel.sendGossip(type: .cityFounded(cityName: cityName), of: self)

        self.citiesFoundValue += 1

        if gameModel.tutorialInfos() == .foundFirstCity && self.isHuman() {
            if self.citiesFoundValue >= Tutorials.FoundFirstCityTutorial.citiesToFound {
                gameModel.userInterface?.finish(tutorial: .foundFirstCity)
                gameModel.enable(tutorial: .none)
            }
        }
    }

    public func newCityName(in gameModel: GameModel?) -> String {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var possibleNames = self.leader.civilization().cityNames()

        if self.isCityState() && possibleNames.isEmpty {

            guard case .cityState(type: let cityStateType) = self.leader else {
                fatalError("cant get city state")
            }

            possibleNames.append(cityStateType.name())
        }

        for builtCityName in self.builtCityNames {
            possibleNames.removeAll(where: { $0 == builtCityName })
        }

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            possibleNames.removeAll(where: { $0 == city.name })
        }

        if let firstName = possibleNames.first {
            return firstName
        }

        return "TXT_KEY_CITY_NAME_GENERIC"
    }

    public func registerBuild(cityName: String) {

        self.builtCityNames.append(cityName)
    }

    public func cityStrengthModifier() -> Int {

        guard let government = self.government else {
            fatalError("cant get government")
        }

        var returnValue = 0

        if government.has(card: .bastions) {

            returnValue += 6
        }

        return returnValue
    }

    func cityRangedStrengthModifier() -> Int {

        guard let government = self.government else {
            fatalError("cant get government")
        }

        var returnValue = 0

        if government.has(card: .bastions) {

            returnValue += 5
        }

        return returnValue
    }

    // MARK: AI

    public func operationsOf(type: UnitOperationType) -> [Operation] {

        guard let operations = self.operations else {
            fatalError("cant get operations")
        }

        return operations.operationsOf(type: type)
    }

    public func hasOperationsOf(type: UnitOperationType) -> Bool {

        guard let operations = self.operations else {
            fatalError("cant get operations")
        }

        return !operations.operationsOf(type: type).isEmpty
    }

    public func delete(operation: Operation) {

        guard let operations = self.operations else {
            fatalError("cant get operations")
        }

        operations.delete(operation: operation)
    }

    public func numberOfOperationsOf(type: UnitOperationType) -> Int {

        guard let operations = self.operations else {
            fatalError("cant get operations")
        }

        return operations.operationsOf(type: type).count
    }

    /// Is an existing operation already going after this city?
    public func isCityAlreadyTargeted(city: AbstractCity?, via domain: UnitDomainType, percentToTarget: Int = 100, in gameModel: GameModel?) -> Bool {

        guard let operations = self.operations else {
            fatalError("cant get operations")
        }

        return operations.isCityAlreadyTargeted(city: city, via: domain, in: gameModel)
    }

    @discardableResult public func addOperation(of type: UnitOperationType, towards otherPlayer: AbstractPlayer?, target targetCity: AbstractCity?, in area: HexArea?, muster musterCity: AbstractCity? = nil, in gameModel: GameModel?) -> Operation {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var operation: Operation

        switch type {

        case .foundCity:
            operation = FoundCityOperation()

        case .cityCloseDefense:
            operation = CityCloseDefenseOperation()

        case .basicCityAttack:
            operation = BasicCityAttackOperation()

        case .pillageEnemy:
            operation = PillageEnemyOperation()

        case .rapidResponse:
            operation = RapidResponseOperation()

        case .destroyBarbarianCamp:
            operation = DestroyBarbarianCampOperation()

        case .navalAttack:
            operation = NavalAttackOperation()

        case .navalSuperiority:
            operation = NavalSuperiorityOperation()

        case .navalBombard:
            operation = NavalBombardmentOperation()

        case .colonize:
             operation = NavalEscortedOperation()

        case .notSoQuickColonize:
            operation = QuickColonizeOperation() // ???

        case .quickColonize:
            operation = QuickColonizeOperation()

        case .pureNavalCityAttack:
            operation = PureNavalCityAttackOperation()

        case .smallCityAttack:
            operation = SmallCityAttackOperation()

        case .sneakCityAttack:
            if gameModel.currentTurn < 50 && self.leader.trait(for: .boldness) >= 5 {
                operation = QuickSneakCityAttackOperation()
            } else {
                operation = SneakCityAttackOperation()
            }

        case .navalSneakAttack:
            operation = NavalSneakAttackOperation()
        }

        operation.initialize(for: self, enemy: otherPlayer, area: area, target: targetCity, muster: musterCity, in: gameModel)
        self.operations?.add(operation: operation)
        return operation
    }

    /// Find the best spot in the entire world for this unit to settle
    public func bestSettlePlot(for firstSettler: AbstractUnit?, in gameModel: GameModel?, escorted: Bool, area: HexArea? = nil) -> AbstractTile? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let firstSettler = firstSettler else {
            return nil
        }

        let unitArea = gameModel.area(of: firstSettler.location)

        var bestFoundValue = 0
        var bestFoundPlot: AbstractTile?

        var evalDistance = 12 /*SETTLER_EVALUATION_DISTANCE */
        let distanceDropoffMod = 99 /*SETTLER_DISTANCE_DROPOFF_MODIFIER */

        evalDistance += (gameModel.currentTurn * 5) / 100

        // scale this based on world size
        let defaultNumTiles = MapSize.standard.numberOfTiles()
        let defaultEvalDistance = evalDistance
        evalDistance = (evalDistance * gameModel.mapSize().numberOfTiles()) / defaultNumTiles
        evalDistance = max(defaultEvalDistance, evalDistance)

        //  is this primarily a naval map
        if escorted && gameModel.isPrimarilyNaval() {
            evalDistance *= 3
            evalDistance /= 2
        }

        // Stay close to home if don't have an escort
        if !escorted {
            evalDistance /= 2
        }

        let foundEvaluator = gameModel.citySiteEvaluator()

        for x in 0..<gameModel.mapSize().width() {

            for y in 0..<gameModel.mapSize().height() {

                let loc = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: loc) {

                    if tile.owner() != nil && tile.owner()?.leader != self.leader {
                        continue
                    }

                    if !tile.isDiscovered(by: self) {
                        continue
                    }

                    if !self.canFound(at: loc, in: gameModel) {
                        continue
                    }

                    if area != nil && tile.area != unitArea {
                        continue
                    }

                    /* FIXME
                     if (pPlot->IsAdjacentOwnedByOtherTeam(eTeam)) {
                         continue;
                     }
                     */

                    // Do we have to check if this is a safe place to go?
                    if escorted || !gameModel.isEnemyVisible(at: loc, for: self) {

                        var value = Int(foundEvaluator.value(of: loc, for: self))

                        // FIXME - used to be 5000
                        if value > 5 {

                            let settlerDistance = loc.distance(to: firstSettler.location)
                            let distanceDropoff = max(0, min(99, (distanceDropoffMod * settlerDistance) / evalDistance))
                            value = value * (100 - distanceDropoff) / 100

                            if tile.area != unitArea {

                                value *= 2
                                value /= 3
                            }

                            if value > bestFoundValue {

                                bestFoundValue = value
                                bestFoundPlot = tile
                            }
                        }
                    }
                }
            }
        }

        return bestFoundPlot
    }

    public func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // FIXME check deals
        // Has the AI agreed to not settle here?

        // FIXME Settlers cannot found cities while empire is very unhappy

        if let tile = gameModel.tile(at: location) {
            if gameModel.citySiteEvaluator().canCityBeFound(on: tile, by: self) {
                return true
            }
        }

        return false
    }

    /// Can we eBuild on pPlot?
    public func canBuild(build: BuildType, at point: HexPoint, testGold: Bool, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        if !tile.canBuild(buildType: build, by: self) {
            return false
        }

        if let required = build.required() {

            if !self.has(tech: required) {
                return false
            }
        }

        // Is this an improvement that is only useable by a specific civ?
        if let improvement = build.improvement() {
            if let improvementCivilization = improvement.civilization() {
                if improvementCivilization != self.leader.civilization() {
                    return false
                }
            }
        }

        // IsBuildBlockedByFeature
        if tile.hasAnyFeature() {

            for feature in FeatureType.all {

                if tile.has(feature: feature) {

                    if build.keeps(feature: feature) {
                        continue
                    }

                    if !build.canRemove(feature: feature) {
                        return false
                    }

                    if let removeTech = build.requiredRemoveTech(for: feature) {
                        if !self.has(tech: removeTech) {
                            return false
                        }
                    }
                }
            }
        }

        if testGold {
            /*if (max(0, self.treasury?.value()) < getBuildCost(pPlot, eBuild))
            {
                return false
            }*/
        }

        return true
    }

    public func bestSettleAreasWith(minimumSettleFertility minScore: Int, in gameModel: GameModel?) -> (Int, HexArea?, HexArea?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var bestScore = -1
        var bestArea: HexArea?
        var secondBestScore = -1
        var secondBestArea: HexArea?

        // Find best two scores above minimum
        for area in gameModel.areas() {

            let score = Int(area.getValue())

            if score > minScore {

                if score > bestScore {

                    // Already have a best area?  If so demote to 2nd
                    if bestScore > minScore {
                        secondBestScore = bestScore
                        secondBestArea = bestArea
                    }

                    bestScore = score
                    bestArea = area

                } else if score > secondBestScore {

                    secondBestScore = score
                    secondBestArea = area
                }
            }
        }

        let numberOfAreas = bestScore != -1 ? 1 : 0 + secondBestScore != -1 ? 1 : 0

        return (numberOfAreas, bestArea, secondBestArea)
    }

    func canBuild(buildType: BuildType, at tile: AbstractTile?) -> Bool {

        if let tile = tile {
            if !tile.canBuild(buildType: buildType, by: self) {
                return false
            }
        }

        if let requiredTech = buildType.required() {
            if !self.has(tech: requiredTech) {
                return false
            }
        }

        if let requiredEra = buildType.route()?.era() {
            if self.currentEra() != requiredEra {
                return false
            }
        }

        // FIXME: check cost

        return true
    }

    public func bestRoute(at tile: AbstractTile? = nil) -> RouteType {

        for buildType in BuildType.all {

            if let routeType = buildType.route() {
                if self.canBuild(buildType: buildType, at: tile) {
                    return routeType
                }
            }
        }

        return .none
    }

    public func isBridgeBuilding() -> Bool {

        return self.currentEra() >= .classical
    }

    func isCapitalConnectedTo(city targetCity: AbstractCity?, via routeType: RouteType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let targetCity = targetCity else {
            fatalError("cant get targetCity")
        }

        guard let playerCapital = gameModel.capital(of: self) else {
            return false
        }

        let pathfinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: self,
            unitMapType: .combat,
            canEmbark: self.canEmbark(),
            canEnterOcean: self.canEnterOcean()
        )
        let pathfinder = AStarPathfinder(with: pathfinderDataSource)

        if let _ = pathfinder.shortestPath(fromTileCoord: playerCapital.location, toTileCoord: targetCity.location) {
            return true
        }

        return false
    }

    /// This determines what plots the player has under control
    public func updatePlots(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // init
        let tmpArea = HexArea(points: [])

        let mapSize = gameModel.mapSize()
        tmpArea.points.reserveCapacity(mapSize.numberOfTiles())

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {

                    if self.isEqual(to: tile.owner()) {
                        tmpArea.add(point: pt)
                    }
                }
            }
        }

        self.area = tmpArea
    }

    public func addPlot(at point: HexPoint) {

        self.area.add(point: point)
    }

    public func plots() -> HexArea {

        return self.area
    }

    /// Gold cost of buying a new Plot
    public func buyPlotCost() -> Int {

        var cost = 50 /* PLOT_BASE_COST */
        cost += (5 /* PLOT_ADDITIONAL_COST_PER_PLOT */ * self.numPlotsBought())

        // Cost Mod (Policies, etc.)
        /*if (GetPlotGoldCostMod() != 0)
        {
            iCost *= (100 + GetPlotGoldCostMod());
            iCost /= 100;
        }*/

        return cost
    }

    func numPlotsBought() -> Int {

        return self.numPlotsBoughtValue
    }

    public func changeNumPlotsBought(change: Int) {

        self.numPlotsBoughtValue += change
    }

    public func numberOfDiscoveredPlots(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            return 0
        }

        var number: Int = 0

        for loopPoint in gameModel.points() {

            guard let loopTile = gameModel.tile(at: loopPoint) else {
                continue
            }

            if loopTile.isDiscovered(by: self) {
                number += 1
            }
        }

        return number
    }

    public func numberOfAvailable(resource: ResourceType) -> Double {

        if let resourceInventory = self.resourceProduction {
            return resourceInventory.weight(of: resource)
        }

        return 0.0
    }

    public func numberForCityAvailable(resource: ResourceType) -> Double {

        if let resourceInventory = self.resourceProduction {
            return resourceInventory.weight(of: resource) * Double(resource.amenities())
        }

        return 0.0
    }

    public func changeNumberOfAvailable(resource: ResourceType, change: Double) {

        guard let resourceInventory = self.resourceProduction else {
            fatalError("cant get resourceInventory")
        }

        resourceInventory.add(weight: change, for: resource)
    }

    public func changeNumberOfItemsInStockpile(of resource: ResourceType, by change: Double) {

        guard let resourceStockpile = self.resourceStockpile else {
            fatalError("cant get resource stockpile")
        }

        resourceStockpile.add(weight: change, for: resource)
    }

    public func numberOfItemsInStockpile(of resource: ResourceType) -> Double {

        if let resourceStockpile = self.resourceStockpile {
            return resourceStockpile.weight(of: resource)
        }

        return 0.0
    }

    public func numberOfStockpileCapacity(of resource: ResourceType) -> Double {

        if let resourceMaxStockpile = self.resourceMaxStockpile {
            return resourceMaxStockpile.weight(of: resource)
        }

        return 0.0
    }

    public func numberOfUnitsNeededToBeBuilt() -> Int {

        guard let operations = self.operations else {
            fatalError("cant get operations")
        }

        return operations.numUnitsNeededToBeBuilt()
    }

    public func hasUnitsThatNeedAIUpdate(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for loopUnitRef in gameModel.units(of: self) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            if !loopUnit.processedInTurn() && (loopUnit.isAutomated() && loopUnit.task() != .unknown && loopUnit.canMove()) {
                return true
            }
        }

        return false
    }

    public func countUnitsWith(defaultTask: UnitTaskType, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var value = 0
        for loopUnitRef in gameModel.units(of: self) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            if loopUnit.type.defaultTask() == defaultTask {
                value += 1
            }
        }

        return value
    }

    public func hasBusyUnitOrCity() -> Bool {

        // FIXME
        return false
    }

    public func changeTrainedSettlers(by value: Int) {

        self.trainedSettlersValue += value
    }

    public func numberOfTrainedSettlers() -> Int {

        return self.trainedSettlersValue
    }

    public func productionCost(of unitType: UnitType) -> Int {

        guard let government = self.government else {
            fatalError("cant get player government")
        }

        if unitType == .settler {

            var policyCardModifier: Double = 1.0

            // expropriation - Settler cost reduced by 50%. Plot purchase cost reduced by 20%.
            if government.has(card: .expropriation) {
                policyCardModifier -= 0.5
            }

            // The Production Production cost of a Settler scales according to the following formula, in which x is the number of Settlers you've trained (including your initial one): 30*x+50
            return Int(Double(30 * self.trainedSettlersValue + 50) * policyCardModifier)
        }

        return unitType.productionCost()
    }

    public func isAutoMoves() -> Bool {

        return self.autoMovesValue
    }

    public func setAutoMoves(to value: Bool) {

        if self.autoMovesValue != value {
            self.autoMovesValue = value
            self.processedAutoMovesValue = false
        }
    }

    public func isEndTurn() -> Bool {

        return self.endTurnValue
    }

    public func setEndTurn(to value: Bool, in gameModel: GameModel?) {

        if !self.isEndTurn() && self.isHuman() && gameModel?.activePlayer()?.leader != self.leader {
            if self.hasBusyUnitOrCity() || self.hasReadyUnit(in: gameModel) {
                return
            }
        } else if !self.isHuman() {
            if self.hasBusyUnitOrCity() {
                return
            }
        }

        if self.isEndTurn() != value {

            assert(self.isTurnActive(), "isTurnActive is expected to be true")

            self.endTurnValue = value

            if self.isEndTurn() {
                setAutoMoves(to: true)
            } else {
                setAutoMoves(to: false)
            }
        } else {
            // This check is here for the AI.  Currently, the setEndTurn(true) never seems to get called for AI players, the automoves are just set directly
            // Why is this?  It would be great if all players were processed the same.
            if !value && self.isAutoMoves() {
                setAutoMoves(to: false)
            }
        }
    }

    public func hasProcessedAutoMoves() -> Bool {

        return self.processedAutoMovesValue
    }

    public func setProcessedAutoMoves(value: Bool) {

        self.processedAutoMovesValue = value
    }

    // buildings + policies
    func specialistExtraYield(for specialistType: SpecialistType, and yieldType: YieldType) -> Int {

        return 0
    }

    public func changeImprovementCount(of improvement: ImprovementType, change: Int) {

        self.improvementCountList.add(weight: change, for: improvement)
    }

    public func changeTotalImprovementsBuilt(change: Int) {

        self.totalImprovementsBuilt += change
    }

    public func changeCitiesLost(by delta: Int) {

        self.citiesLostValue += delta
    }

    // MARK: trade route functions

    public func tradingCapacity() -> Int {

        return self.tradingCapacityValue
    }

    // https://civilization.fandom.com/wiki/Trade_Route_(Civ6)#Trading_Capacity
    public func doUpdateTradeRouteCapacity(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            return // early exit 
        }

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        guard let government = self.government else {
            fatalError("cant get government")
        }

        var numberOfTradingCapacity = 0

        // The Foreign Trade Civic (one of the earliest of the Ancient Era) grants a Trading Capacity of one, meaning that your empire can have one TradeRoute6 Trade Route at a time.
        if civics.has(civic: .foreignTrade) {
            numberOfTradingCapacity += 1
        }

        if self.leader.civilization().ability() == .satrapies && civics.has(civic: .politicalPhilosophy) {
            // Gains +1 Trade Route capacity with Political Philosophy.
            numberOfTradingCapacity += 1
        }

        for loopCityRef in gameModel.cities(of: self) {

            guard let loopCity = loopCityRef else {
                continue
            }

            // Each city with a Commercial Hub or a Harbor (or, from Rise and Fall onwards, a Market or a Lighthouse)
            // increases a civilization's Trading Capacity by one. These bonuses are not cumulative: a city with both
            // a Commercial Hub/Market and a Harbor/Lighthouse adds only one Trading Capacity, not two.
            if /*loopCity.has(district: .harbor) ||
                loopCity.has(district: .commercialHub) ||*/
                loopCity.has(building: .market) ||
                loopCity.has(building: .lighthouse) {

                numberOfTradingCapacity += 1
            }

            // The effects of the Colossus and Great Zimbabwe wonders increase Trading Capacity by one.
            if loopCity.has(wonder: .colossus) || loopCity.has(wonder: .greatZimbabwe) {
                // +1 Trade Route capacity
                numberOfTradingCapacity += 1
            }
        }

        if government.currentGovernment() == .merchantRepublic {
            numberOfTradingCapacity += 2
        }

        if self.hasRetired(greatPerson: .zhangQian) {

            // Increases Trade Route capacity by 1.
            numberOfTradingCapacity += 1
        }

        if self.tradingCapacityValue != numberOfTradingCapacity {

            if self.tradingCapacityValue < numberOfTradingCapacity {
                if self.isHuman() {
                    self.notifications()?.add(notification: .tradeRouteCapacityIncreased)
                }
            }

            self.tradingCapacityValue = numberOfTradingCapacity
        }
    }

    public func hasTradeRoute(from: HexPoint, to: HexPoint) -> Bool {

        guard let tradeRoutes = self.tradeRoutes else {
            fatalError("cant get tradeRoutes")
        }

        return tradeRoutes.hasTradeRoute(from: from, to: to)
    }

    public func numberOfTradeRoutes() -> Int {

        guard let tradeRoutes = self.tradeRoutes else {
            fatalError("cant get tradeRoutes")
        }

        return tradeRoutes.numberOfTradeRoutes()
    }

    public func numberOfUnassignedTraders(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        var unassignedTraders: Int = 0

        for loopUnitRef in gameModel.units(of: self) {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            if loopUnit.type == .trader && !loopUnit.isTrading() {
                unassignedTraders += 1
            }
        }

        return unassignedTraders
    }

    public func canEstablishTradeRoute() -> Bool {

        let tradingCapacity = self.tradingCapacityValue
        let numberOfTradeRoutes = self.numberOfTradeRoutes()

        if numberOfTradeRoutes >= tradingCapacity {
            return false
        }

        return true
    }

    public func possibleTradeRouteTargets(from originCityRef: AbstractCity?, in gameModel: GameModel?) -> [AbstractCity?] {

        guard let gameModel = gameModel else {
            fatalError("cat get gameModel")
        }

        guard let tradeRoutes = self.tradeRoutes else {
            fatalError("unit doesnt have a player")
        }

        guard let originCity = originCityRef else {
            fatalError("cat get origin city")
        }

        var cities: [AbstractCity?] = []

        for player in gameModel.players {
            for city in gameModel.cities(of: player) {

                guard let cityLocation = city?.location,
                    let cityTile = gameModel.tile(at: cityLocation) else {

                        continue
                }

                if originCity.location == cityLocation {
                    continue
                }

                if cityTile.isDiscovered(by: self) {

                    // check if is within reach
                    if tradeRoutes.canEstablishTradeRoute(from: originCity, to: city, in: gameModel) {

                        cities.append(city)
                    }
                }
            }
        }

        return cities
    }

    public func possibleTradeRoutes(from originCityRef: AbstractCity?, in gameModel: GameModel?) -> [TradeRoute] {

        guard let gameModel = gameModel else {
            fatalError("cat get gameModel")
        }

        var routes: [TradeRoute] = []

        let pathFinderDataSource = gameModel.unitAwarePathfinderDataSource(
            for: .walk,
            for: self,
            ignoreOwner: true,
            unitMapType: .civilian,
            canEmbark: false,
            canEnterOcean: false
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)

        guard let originCity = originCityRef else {
            return []
        }

        let cityTargets = self.possibleTradeRouteTargets(from: originCity, in: gameModel)

        for cityTargetRef in cityTargets {

            guard let cityTarget = cityTargetRef else {
                continue
            }

            if var path = pathFinder.shortestPath(fromTileCoord: originCity.location, toTileCoord: cityTarget.location) {

                path.prepend(point: originCity.location, cost: 0.0)

                if path.last?.0 != cityTarget.location {
                    path.append(point: cityTarget.location, cost: 0.0)
                }

                routes.append(TradeRoute(path: path))
            } else {
                print("Player.possibleTradeRoutes - cant get route from \(originCity.name) to \(cityTarget.name)")
            }
        }

        return routes
    }

    public func doEstablishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tradeRoutes = self.tradeRoutes else {
            fatalError("cant get tradeRoutes")
        }

        guard let targetCity = targetCity else {
            fatalError("cant get targetCity")
        }

        guard let targetLeader = targetCity.player?.leader else {
            fatalError("cant get target leader")
        }

        guard let tech = self.techs else {
            fatalError("cant get tech")
        }

        if targetLeader != self.leader {

            if !self.hasEverEstablishedTradingPost(with: targetLeader) {
                self.markEstablishedTradingPost(with: targetLeader)

                self.addMoment(of: .tradingPostEstablishedInNewCivilization(civilization: targetLeader.civilization()), in: gameModel)

                let possibleTradingPosts = (gameModel.players.filter { $0.isAlive() }.count - 1)
                if self.numEverEstablishedTradingPosts(in: gameModel) == possibleTradingPosts {
                    if gameModel.anyHasMoment(of: .firstTradingPostsInAllCivilizations) {
                        self.addMoment(of: .tradingPostsInAllCivilizations, in: gameModel)
                    } else {
                        self.addMoment(of: .firstTradingPostsInAllCivilizations, in: gameModel)
                    }
                }
            }

            // update access level
            if !self.isEqual(to: targetCity.player) {
                // if this is the first trade route with this player, incrase the access level
                if !tradeRoutes.hasTradeRoute(with: targetCity.player, in: gameModel) {
                    self.diplomacyAI?.increaseAccessLevel(towards: targetCity.player)
                }
            }
        }

        if !tech.eurekaTriggered(for: .currency) {
            tech.triggerEureka(for: .currency, in: gameModel)
        }

        // check quests
        for quest in self.ownQuests(in: gameModel) {

            if case .cityState(type: let cityStateType) = targetLeader {
                if quest.type == .sendTradeRoute && cityStateType == quest.cityState && quest.leader == self.leader {
                    targetCity.player?.fulfillQuest(by: self.leader, in: gameModel)
                }
            }
        }

        // no check ?

        return tradeRoutes.establishTradeRoute(from: originCity, to: targetCity, with: trader, in: gameModel)
    }

    public func doFinish(tradeRoute tradeRouteRef: TradeRoute?, in gameModel: GameModel?) {

        guard let tradeRoutes = self.tradeRoutes else {
            fatalError("cant get tradeRoutes")
        }

        guard let tradeRoute = tradeRouteRef else {
            print("cant get targetCity")
            return
        }

        guard let targetCity = gameModel?.city(at: tradeRoute.end) else {
            fatalError("cant get targetCity")
        }

        self.tradeRoutes?.finish(tradeRoute: tradeRouteRef)

        // update access level
        if !self.isEqual(to: targetCity.player) {
            // if this was the last trade route with this player, decrase the access level
            if !tradeRoutes.hasTradeRoute(with: targetCity.player, in: gameModel) {
                self.diplomacyAI?.decreaseAccessLevel(towards: targetCity.player)
            }
        }
    }

    public func cityDistancePathLength(of point: HexPoint, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var minDistance: Int = Int.max
        /*let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
            for: .walk,
            for: self,
            unitMapType: .civilian,
            canEmbark: true,
            canEnterOcean: self.canEnterOcean()
        )
        let pathFinder = AStarPathfinder(with: pathFinderDataSource)*/

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            let distance = point.distance(to: city.location)

            if distance < minDistance {
                minDistance = distance
            }
        }

        return minDistance
    }

    public func numberOfCities(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        return gameModel.cities(of: self).count
    }

    public func numUnits(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        return gameModel.units(of: self).count
    }

    public func countCitiesFeatureSurrounded(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        var features = 0

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            guard let cityCitizens = city.cityCitizens else {
                continue
            }

            for loopPoint in cityCitizens.workingTileLocations() {

                guard let loopPlot = gameModel.tile(at: loopPoint) else {
                    continue
                }

                guard self.isEqual(to: loopPlot.owner()) else {
                    continue
                }

                if loopPlot.hasAnyFeature() {
                    features += 1
                }
            }
        }

        return features
    }

    public func isEqual(to other: AbstractPlayer?) -> Bool {

        return self.leader == other?.leader
    }

    public func acquire(city oldCity: AbstractCity?, conquest: Bool, gift: Bool, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let oldCity = oldCity else {
            fatalError("cant get oldCity")
        }

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        guard let otherDiplomacyAI = oldCity.player?.diplomacyAI else {
            fatalError("cant get otherDiplomacyAI")
        }

        let units = gameModel.units(at: oldCity.location)

        for loopUnitRef in units {

            guard let loopUnit = loopUnitRef else {
                continue
            }

            if loopUnit.player?.leader != self.leader {

                if loopUnit.isImmobile() {
                    loopUnit.doKill(delayed: true, by: self, in: gameModel)
                    // DoUnitKilledCombat(pLoopUnit->getOwner(), pLoopUnit->getUnitType());
                }
            }
        }

        if conquest {

            /*CvNotifications* pNotifications = GET_PLAYER(pOldCity->getOwner()).GetNotifications();
            if (pNotifications)
            {
                Localization::String locString = Localization::Lookup("TXT_KEY_NOTIFICATION_CITY_LOST");
                locString << pOldCity->getNameKey() << getNameKey();
                Localization::String locSummary = Localization::Lookup("TXT_KEY_NOTIFICATION_SUMMARY_CITY_LOST");
                locSummary << pOldCity->getNameKey();
                pNotifications->Add(NOTIFICATION_CITY_LOST, locString.toUTF8(), locSummary.toUTF8(), pOldCity->getX(), pOldCity->getY(), -1);
            }*/

            if !self.isBarbarian() && !oldCity.isBarbarian() {

                let defaultCityValue = 150 /* WAR_DAMAGE_LEVEL_CITY_WEIGHT */

                // Notify Diplo AI that damage has been done
                var value = defaultCityValue
                value += oldCity.population() * 100 /* WAR_DAMAGE_LEVEL_INVOLVED_CITY_POP_MULTIPLIER */
                // My viewpoint
                diplomacyAI.changeOtherPlayerWarValueLost(from: oldCity.player, to: self, by: value)
                // Bad guy's viewpoint
                otherDiplomacyAI.changeWarValueLost(with: self, by: value)

                value = defaultCityValue
                value += oldCity.population() * 120 /* WAR_DAMAGE_LEVEL_UNINVOLVED_CITY_POP_MULTIPLIER */

                // Now update everyone else in the world, but use a different multiplier (since they don't have complete info on the situation - they don't know when Units are killed)
                for loopPlayer in gameModel.players {

                    // Not us and not the player we acquired City from
                    if !self.isEqual(to: loopPlayer) && !loopPlayer.isEqual(to: oldCity.player) {
                         loopPlayer.diplomacyAI?.changeOtherPlayerWarValueLost(from: oldCity.player, to: self, by: value)
                    }
                }
            }
        }

        if oldCity.originalLeader() == oldCity.player?.leader {
            gameModel.player(for: oldCity.originalLeader())?.changeCitiesLost(by: 1)
        } else if oldCity.originalLeader() == self.leader {
            self.changeCitiesLost(by: -1)
        }

        if conquest {
            if self.isEqual(to: gameModel.activePlayer()) {
                gameModel.userInterface?.showTooltip(
                    at: oldCity.location,
                    type: .capturedCity(cityName: oldCity.name),
                    delay: 3
                )
            }

            let message = "\(oldCity.name) was captured by the \(self.leader.civilization().name())!!!"
            gameModel.addReplayEvent(type: .major, message: message, at: oldCity.location)

            // inform other players, that a city was conquered or liberated
            if self.leader == oldCity.originalLeader() {
                gameModel.sendGossip(type: .cityLiberated(cityName: oldCity.name, originalOwner: oldCity.originalLeader()), of: self)
            } else {
                gameModel.sendGossip(type: .cityConquests(cityName: oldCity.name), of: self)
            }
        }

        var captureGold = 0

        if conquest {

            captureGold = 0

            captureGold += 200 // BASE_CAPTURE_GOLD
            captureGold += oldCity.population() * 40 // CAPTURE_GOLD_PER_POPULATION
            captureGold += Int.random(maximum: 40) // CAPTURE_GOLD_RAND1
            captureGold += Int.random(maximum: 20) // CAPTURE_GOLD_RAND2

            let foundedTurnsAgo = gameModel.currentTurn - oldCity.gameTurnFounded()
            captureGold *= foundedTurnsAgo.clamped(to: 0...500 /* CAPTURE_GOLD_MAX_TURNS */)
            captureGold /= 500 /* CAPTURE_GOLD_MAX_TURNS */

            // captureGold *= (100 + oldCity.capturePlunderModifier()) / 100
            // captureGold *= (100 + self.leader.traits().plunderModifier()) / 100
        }

        self.treasury?.changeGold(by: Double(captureGold))

        /*int iNumBuildingInfos = GC.getNumBuildingInfos();
        std::vector<int> paiNumRealBuilding(iNumBuildingInfos, 0);
        std::vector<int> paiBuildingOriginalOwner(iNumBuildingInfos, 0);
        std::vector<int> paiBuildingOriginalTime(iNumBuildingInfos, 0);*/

        guard let oldPlayer = gameModel.player(for: oldCity.leader) else {
            fatalError("cant get old player")
        }

        let oldCityLocation = oldCity.location
        let oldLeader = oldCity.leader
        let originalOwner = oldCity.originalLeader()
        let oldTurnFounded = oldCity.gameTurnFounded()
        var oldPopulation = oldCity.population()
        // iHighestPopulation = pOldCity->getHighestPopulation();
        let everCapital = oldCity.isEverCapital()
        let oldName = oldCity.name
        let oldCultureLevel = oldCity.cultureLevel()
        let hasMadeAttack = oldCity.isOutOfAttacks(in: gameModel)

        var oldBattleDamage = oldCity.damage()

        // Traded cities between humans don't heal (an exploit would be to trade a city back and forth between teammates to get an instant heal.)
        let oldPlayerHuman: Bool = gameModel.player(for: oldCity.leader)?.isHuman() ?? false
        if !gift || !self.isHuman() || !oldPlayerHuman {

            var battleDamageThreshold = 200 /* MAX_CITY_HIT_POINTS */ * 50 /*CITY_CAPTURE_DAMAGE_PERCENT */
            battleDamageThreshold /= 100

            if oldBattleDamage > battleDamageThreshold {
                oldBattleDamage = battleDamageThreshold
            }
        }

        /*for (iI = 0; iI < MAX_PLAYERS; iI++)
        {
            abEverOwned[iI] = pOldCity->isEverOwned((PlayerTypes)iI);
        }

        abEverOwned[GetID()] = true;*/

        var oldDistricts: [DistrictItem] = []
        for districtType in DistrictType.all {

            if oldCity.has(district: districtType) {
                if let oldLocation = oldCity.location(of: districtType) {
                    oldDistricts.append(DistrictItem(type: districtType, location: oldLocation))
                }
            }
        }

        var oldBuildings: [BuildingType] = []
        for buildingType in BuildingType.all {

            if oldCity.has(building: buildingType) {
                oldBuildings.append(buildingType)
            }
        }

        var oldWonders: [WonderType] = []
        for wonderType in WonderType.all {

            if oldCity.has(wonder: wonderType) {
                oldWonders.append(wonderType)
            }
        }

        let recapture = false

        let capital = oldCity.isCapital()

        oldCity.preKill(in: gameModel)

        gameModel.userInterface?.remove(city: oldCity)

        gameModel.delete(city: oldCity)
        // adapted from PostKill()

        // GC.getGame().addReplayMessage( REPLAY_MESSAGE_CITY_CAPTURED, m_eID, "", pCityPlot->getX(), pCityPlot->getY());

        // Update Proximity between this Player and all others
        for loopPlayer in gameModel.players {

            if !loopPlayer.isEqual(to: self) && loopPlayer.isAlive() && loopPlayer.hasMet(with: self) {

                self.doUpdateProximity(towards: loopPlayer, in: gameModel)
                loopPlayer.doUpdateProximity(towards: self, in: gameModel)
            }
        }

        for neighbor in oldCityLocation.areaWith(radius: 3) {

            let tile = gameModel.tile(at: neighbor)
            gameModel.userInterface?.refresh(tile: tile)
        }

        // Lost the capital!
        if capital {

            oldPlayer.set(hasLostCapital: true, to: self, in: gameModel)
            oldPlayer.findNewCapital(in: gameModel)
        }

        // GC.GetEngineUserInterface()->setDirty(NationalBorders_DIRTY_BIT, true);
        // end adapted from PostKill()

        let newCity = City(name: oldName, at: oldCityLocation, owner: self)
        newCity.initialize(in: gameModel)

        newCity.set(originalLeader: originalOwner)
        newCity.set(gameTurnFounded: oldTurnFounded)
        newCity.set(previousLeader: oldLeader)
        newCity.setEverCapital(to: everCapital)

        // Population change for capturing a city
        if !recapture && conquest {
            // Don't drop it if we're recapturing our own City
            oldPopulation = max(1, oldPopulation * 50 /* CITY_CAPTURE_POPULATION_PERCENT */ / 100)
        }

        newCity.set(population: oldPopulation, in: gameModel)
        // pNewCity->setHighestPopulation(iHighestPopulation);
        newCity.set(name: oldName)
        // pNewCity->setNeverLost(false);
        newCity.set(damage: oldBattleDamage)
        newCity.setMadeAttack(to: hasMadeAttack)
        /*

        for (iI = 0; iI < MAX_PLAYERS; iI++) {
            pNewCity->setEverOwned(((PlayerTypes)iI), abEverOwned[iI]);
        }*/

        newCity.changeCultureLevel(by: oldCultureLevel)

        for district in oldDistricts {
            do {
                try newCity.districts?.build(district: district.type, at: district.location)
            } catch {

            }
        }

        for building in oldBuildings {
            do {
                try newCity.buildings?.build(building: building)
            } catch {

            }
        }

        for wonder in oldWonders {
            do {
                try newCity.wonders?.build(wonder: wonder)
            } catch {

            }
        }

        // Did we re-acquire our Capital?
        if self.originalCapitalLocation() == oldCityLocation {

            self.set(hasLostCapital: false, to: nil, in: gameModel)
        }

        gameModel.add(city: newCity)

        // If the old owner is "killed," then notify everyone's Grand Strategy AI
        let numberOfCities = gameModel.cities(of: oldPlayer).count
        if numberOfCities == 0 {

            if !self.isCityState() && !self.isBarbarian() {

                for loopPlayer in gameModel.players {

                    if !self.isEqual(to: loopPlayer) && loopPlayer.isAlive() {
                        // Have I met the player who killed the guy?
                        if loopPlayer.hasMet(with: self) {
                            // loopPlayer.diplomacyAI.doPlayerKilledSomeone(self, oldPlayer)
                        }
                    }
                }
            }
        } else {
            // If not, old owner should look at city specializations
            oldPlayer.citySpecializationAI?.setSpecializationsDirty()
        }

        // Do the same for the new owner
        self.citySpecializationAI?.setSpecializationsDirty()
    }

    public func canRaze(city cityRef: AbstractCity?, ignoreCapitals: Bool = false, in gameModel: GameModel?) -> Bool {

        guard let city = cityRef else {
            fatalError("cant get city to raze")
        }

        // If we don't own this city right now then we can't raze it!
        if self.isEqual(to: city.player) {
            return false
        }

        // Can't raze a city that originally belonged to us
        if self.leader == city.originalLeader() {
            return false
        }

        guard let originalOwner = gameModel?.player(for: city.originalLeader()) else {
            fatalError("cant get original owner")
        }

        let originalCapital = city.location == originalOwner.originalCapitalLocation()

        // No razing of capitals
        if !ignoreCapitals && originalCapital {
            return false
        }

        // No razing of Holy Cities
        if city.isHolyCityOfAnyReligion(in: gameModel) {
            return false
        }

        return true
    }

    // raze city immediatelly
    public func doRaze(city cityRef: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let city = cityRef else {
            fatalError("cant get city to raze")
        }

        if !self.canRaze(city: city, in: gameModel) {
            return false
        }

        /*if(GetID() == GC.getGame().getActivePlayer()) {
            sprintf_s(szBuffer, lenBuffer, GetLocalizedText("TXT_KEY_MISC_DESTROYED_CITY", pCity->getNameKey()).GetCString());
            GC.GetEngineUserInterface()->AddCityMessage(0, pCity->GetIDInfo(), GetID(), true, GC.getEVENT_MESSAGE_TIME(), szBuffer);
        }*/

        // send gossip
        gameModel?.sendGossip(type: .cityRazed(cityName: city.name, originalOwner: city.originalLeader()), of: self)

        // sprintf_s(szBuffer, lenBuffer, GetLocalizedText("TXT_KEY_MISC_CITY_RAZED_BY", pCity->getNameKey(), getCivilizationShortDescriptionKey()).GetCString());
        // GC.getGame().addReplayMessage(REPLAY_MESSAGE_MAJOR_EVENT, GetID(), szBuffer, pCity->getX(), pCity->getY());

        // pCity->SetIgnoreCityForHappiness(false);

        // CalculateNetHappiness();

        /* if (pCity->IsNoWarmongerYet())
        {
            PlayerTypes eFormerOwner = pCity->getPreviousOwner();
            if (eFormerOwner != NO_PLAYER)
            {
                CvDiplomacyAIHelpers::ApplyWarmongerPenalties(pCity, GetID(), eFormerOwner);
                pCity->SetNoWarmonger(false);
            }
        }*/

        city.kill(in: gameModel)

        return true
    }

    public func canLiberate(city cityRef: AbstractCity?, in gameModel: GameModel?) -> Bool {

        guard let city = cityRef else {
            fatalError("cant get city")
        }

        guard city.originalLeader() != city.previousLeader() else {
            return false
        }

        guard city.originalLeader() != .none && city.originalLeader() != .barbar else {
            return false
        }

        return true
    }

    /// This player liberates city and gives it back to the original owner
    public func doLiberate(city cityRef: AbstractCity?, forced: Bool = false, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let city = cityRef else {
            fatalError("cant get city")
        }

        guard city.originalLeader() != city.previousLeader() else {
            return false
        }

        guard city.originalLeader() != .none && city.originalLeader() != .barbar else {
            return false
        }

        // ePlayer / eLiberatedTeam
        guard let newOwner = gameModel.player(for: city.originalLeader()) else {
            return false
        }

        let alive: Bool = newOwner.isAlive()

        // If they aren't alive, start the resurrection process
        if !alive {
            newOwner.set(beingResurrected: true)

            // Mark the liberators
            if !forced {
                newOwner.set(liberatedBy: self.leader)
            }

            // Put everyone at peace with this guy
            for loopPlayer in gameModel.players {

                guard loopPlayer.isMajorAI() else {
                    continue
                }

                if newOwner.leader != loopPlayer.leader {
                    newOwner.makePeace(with: loopPlayer, in: gameModel)
                    // GET_TEAM(eLiberatedTeam).makePeace((TeamTypes)iOtherTeamLoop, /*bBumpUnits*/false,
                    // /*bSuppressNotification*/true, GetID());
                }
            }
        }

        // Diplo bonus for returning the city
        if !forced {
            if newOwner.isMajorAI() || newOwner.isHuman() {

                // Liberated the capital - big diplo bonus!
                if city.location == newOwner.originalCapitalLocation() {
                    // pDiploAI->SetPlayerLiberatedCapital(m_eID, true);
                }

                // Liberated the Holy City - big bonus IF the Holy City status still remains
                /* if (GET_PLAYER(ePlayer).IsHasLostHolyCity() && pCity->getX() == GET_PLAYER(ePlayer).GetLostHolyCityX() && pCity->getY() == GET_PLAYER(ePlayer).GetLostHolyCityY())
                {
                    ReligionTypes eReligion = GC.getGame().GetGameReligions()->GetOriginalReligionCreatedByPlayer(ePlayer);

                    if (eReligion != NO_RELIGION && pCity->GetCityReligions()->IsHolyCityForReligion(eReligion))
                    {
                        pDiploAI->SetPlayerLiberatedHolyCity(m_eID, true);
                    }
                }*/

                // newOwner.diplomacyAI.changeNumCitiesLiberated(by: self.leader, 1)
            }
        }

        // Give the city back to the liberated player
        newOwner.acquire(city: city, conquest: false, gift: true, in: gameModel)

        guard let newCity = gameModel.city(at: city.location) else {
            return false
        }

        // Now verify that the player is alive
        newOwner.verifyAlive(in: gameModel)

        // Process other diplomatic consequences if a major was liberated
        if !forced && (newOwner.isMajorAI() || newOwner.isHuman()) {

            // Player was alive? Just notify that a city was liberated.
            if alive {
                if !newOwner.isHuman() && !self.isHuman() {
                    // "TXT_KEY_NOTIFICATION_CITY_LIBERATED"
                    gameModel.sendGossip(type: .cityLiberated(cityName: newCity.name, originalOwner: self.leader), of: newOwner)
                    // gameModel.humanPlayer()?.notifications()?.add(notification: .cityLiberated(cityName: newCity.name, originalOwner: self.leader))
                }
            } else { // Player was dead? Huge diplo bonuses!
                for loopPlayer in gameModel.players {

                    /* PlayerTypes eMyTeamPlayer = (PlayerTypes) iPlayerLoop;

                    if (GET_PLAYER(eMyTeamPlayer).getTeam() == getTeam() && !GET_PLAYER(ePlayer).GetDiplomacyAI()->IsResurrectorAttackedUs(eMyTeamPlayer))
                    {
                        pDiploAI->SetResurrectedBy(eMyTeamPlayer, true);

                        pDiploAI->SetLandDisputeLevel(eMyTeamPlayer, DISPUTE_LEVEL_NONE);
                        pDiploAI->SetWonderDisputeLevel(eMyTeamPlayer, DISPUTE_LEVEL_NONE);
                        pDiploAI->SetMinorCivDisputeLevel(eMyTeamPlayer, DISPUTE_LEVEL_NONE);
                        pDiploAI->SetVictoryDisputeLevel(eMyTeamPlayer, DISPUTE_LEVEL_NONE);
                        pDiploAI->SetVictoryBlockLevel(eMyTeamPlayer, BLOCK_LEVEL_NONE);
                        pDiploAI->SetTechBlockLevel(eMyTeamPlayer, BLOCK_LEVEL_NONE);
                        pDiploAI->SetPolicyBlockLevel(eMyTeamPlayer, BLOCK_LEVEL_NONE);

                        pDiploAI->SetWarmongerThreat(eMyTeamPlayer, THREAT_NONE);
                        pDiploAI->SetOtherPlayerWarmongerAmountTimes100(eMyTeamPlayer, 0);

                        pDiploAI->SetNumDemandsMade(eMyTeamPlayer, 0);

                        if (pDiploAI->GetCoopWarScore(eMyTeamPlayer) < 0)
                        {
                            pDiploAI->SetCoopWarScore(eMyTeamPlayer, 0);
                        }

                        if (GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->GetCoopWarScore(ePlayer) < 0)
                        {
                            pDiploAI->SetCoopWarScore(ePlayer, 0);
                        }

                        // Forget war history
                        pDiploAI->SetNumWarsDeclaredOnUs(eMyTeamPlayer, 0);
                        pDiploAI->SetNumCitiesCapturedBy(eMyTeamPlayer, 0);
                        pDiploAI->SetNumTradeRoutesPlundered(eMyTeamPlayer, 0);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetNumWarsDeclaredOnUs(ePlayer, 0);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetNumCitiesCapturedBy(ePlayer, 0);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetNumTradeRoutesPlundered(ePlayer, 0);

                        pDiploAI->SetNumArtifactsEverDugUp(eMyTeamPlayer, 0);
                        pDiploAI->SetEverConvertedCity(eMyTeamPlayer, false);

                        pDiploAI->SetNumTimesTheyPlottedAgainstUs(eMyTeamPlayer, 0);
                        pDiploAI->SetNumTimesTheyLoweredOurInfluence(eMyTeamPlayer, 0);
                        pDiploAI->SetNumTimesPerformedCoupAgainstUs(eMyTeamPlayer, 0);
                        pDiploAI->SetNumTimesCultureBombed(eMyTeamPlayer, 0);
                        pDiploAI->SetNegativeReligiousConversionPoints(eMyTeamPlayer, 0);
                        pDiploAI->SetNegativeArchaeologyPoints(eMyTeamPlayer, 0);
                        pDiploAI->SetNumTimesRobbedBy(eMyTeamPlayer, 0);

                        // Reset all promises
                        pDiploAI->SetPlayerMilitaryPromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerExpansionPromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerBorderPromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerBullyCityStatePromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerAttackCityStatePromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerSpyPromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerNoConvertPromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerNoDiggingPromiseState(eMyTeamPlayer, NO_PROMISE_STATE);
                        pDiploAI->SetPlayerBrokenCoopWarPromise(eMyTeamPlayer, false);

                        pDiploAI->SetOtherPlayerNumProtectedMinorsKilled(eMyTeamPlayer, 0);
                        pDiploAI->SetOtherPlayerNumProtectedMinorsAttacked(eMyTeamPlayer, 0);
                        pDiploAI->SetOtherPlayerNumProtectedMinorsBullied(eMyTeamPlayer, 0);
                        pDiploAI->SetOtherPlayerSidedWithProtectedMinorTurn(eMyTeamPlayer, -1);

                        pDiploAI->SetDoFBroken(eMyTeamPlayer, false, true);
                        pDiploAI->SetFriendDenouncedUs(eMyTeamPlayer, false); // clear backstabbing penalties
                        pDiploAI->SetFriendDeclaredWarOnUs(eMyTeamPlayer, false); // clear backstabbing penalties
                        pDiploAI->SetDenouncedPlayer(eMyTeamPlayer, false); // forget any denouncing
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetDenouncedPlayer(ePlayer, false); // forget any denouncing

                        pDiploAI->SetNumTimesNuked(eMyTeamPlayer, 0);

                        pDiploAI->SetWeDislikedTheirProposalTurn(eMyTeamPlayer, -1);
                        pDiploAI->SetTheyFoiledOurProposalTurn(eMyTeamPlayer, -1);

                        if (pDiploAI->GetLikedTheirProposalValue(eMyTeamPlayer) > 0)
                        {
                            pDiploAI->SetLikedTheirProposalValue(eMyTeamPlayer, 0);
                        }
                        if (pDiploAI->GetSupportedOurProposalValue(eMyTeamPlayer) > 0)
                        {
                            pDiploAI->SetSupportedOurProposalValue(eMyTeamPlayer, 0);
                        }

                        pDiploAI->SetVassalageForcefullyRevokedTurn(eMyTeamPlayer, -1);
                        pDiploAI->SetPlayerBrokenVassalAgreement(eMyTeamPlayer, false);

                        // Clear this player's backstabbing penalties
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetDoFBroken(ePlayer, false, true);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetFriendDenouncedUs(ePlayer, false);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetFriendDeclaredWarOnUs(ePlayer, false);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetVassalageForcefullyRevokedTurn(ePlayer, -1);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetPlayerBrokenVassalAgreement(ePlayer, false);

                        // Clear backstabbing mark
                        pDiploAI->SetBackstabbedBy(eMyTeamPlayer, false);
                        GET_PLAYER(eMyTeamPlayer).GetDiplomacyAI()->SetBackstabbedBy(ePlayer, false);
                    } */
                }

                // Resurrected civ becomes a vassal of the resurrector, if possible
                /* if (MOD_DIPLOMACY_CIV4_FEATURES && GET_TEAM(eLiberatedTeam).GetLiberatedByTeam() != eConquerorTeam && !IsVassalOfSomeone() && GC.getDIPLOAI_DISABLE_VOLUNTARY_VASSALAGE() == 0)
                {
                    if (!GET_TEAM(GET_PLAYER(ePlayer).getTeam()).IsVassal(getTeam()))
                    {
                        GET_TEAM(GET_PLAYER(ePlayer).getTeam()).SetNumTurnsIsVassal(-1);
                        GET_TEAM(GET_PLAYER(ePlayer).getTeam()).SetNumTurnsSinceVassalEnded(getTeam(), -1);
                        GET_TEAM(GET_PLAYER(ePlayer).getTeam()).DoBecomeVassal(getTeam(), true, GetID());
                    }
                } */

                // Add resurrection notification
                /* Localization::String strMessage;
                strMessage = Localization::Lookup("TXT_KEY_NOTIFICATION_CIV_RESURRECTED");
                strMessage << getCivilizationShortDescriptionKey(); // LIBERATING CIV NAME
                strMessage << pNewCity->getNameKey(); // CITY NAME
                strMessage << GET_PLAYER(ePlayer).getCivilizationAdjectiveKey(); // LIBERATED CIV NAME
                strMessage << GET_PLAYER(ePlayer).getCivilizationDescriptionKey();// LIBERATED CIV NAME
                Localization::String strSummary = Localization::Lookup("TXT_KEY_NOTIFICATION_CIV_RESURRECTED_SHORT");
                strSummary << GET_PLAYER(ePlayer).getNameKey();
                strSummary << GET_PLAYER(m_eID).getNameKey();

                for loopPlayer in gameModel.players {
                    CvPlayerAI& kOtherPlayer = GET_PLAYER((PlayerTypes)iI);
                    if (iI == m_eID)
                        continue;

                    if (!kOtherPlayer.isObserver())
                    {
                        if (!kOtherPlayer.isAlive())
                            continue;

                        if (!GET_TEAM(kOtherPlayer.getTeam()).isHasMet(getTeam()) && !GET_TEAM(kOtherPlayer.getTeam()).isHasMet(eLiberatedTeam))
                            continue;
                    }

                    if (kOtherPlayer.GetNotifications())
                        kOtherPlayer.GetNotifications()->Add(NOTIFICATION_RESURRECTED_MAJOR_CIV, strMessage.toUTF8(), strSummary.toUTF8(), pNewCity->getX(), pNewCity->getY(), -1);
                }*/

                // CvString temp = strMessage.toUTF8();
                // GC.getGame().addReplayMessage(REPLAY_MESSAGE_MAJOR_EVENT, m_eID, temp);
                gameModel.addReplayEvent(type: .major, message: "City was liberated", at: newCity.location)
            }
        }

        // Kick out all other players' units from the city plot
        let units = gameModel.units(at: newCity.location)
        if !units.isEmpty {

            // Get the current list of units because we will possibly be moving them out of the plot's list
            for loopUnitRef in units {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if !newOwner.isEqual(to: loopUnit.player) {
                    loopUnit.finishMoves()

                    if !loopUnit.jumpToNearestValidPlotWithin(range: 3, in: gameModel) {
                        loopUnit.doKill(delayed: false, by: nil, in: gameModel)
                    }
                }
            }
        }

        // If a City-State was liberated, adjust Influence levels and give the City-State a basic but state-of-the-art garrison
        if newOwner.isCityState() {
            if !forced {
                // GET_PLAYER(ePlayer).GetMinorCivAI()->DoLiberationByMajor(eOldOwner, eConquerorTeam);
            } else {
                // GET_PLAYER(ePlayer).GetMinorCivAI()->SetFriendshipWithMajor(GetID(), GC.getMINOR_FRIENDSHIP_AT_WAR());
            }

            /* UnitTypes eUnit = GC.getGame().GetCompetitiveSpawnUnitType(ePlayer, false, false, false, true, false);
            if (eUnit != NO_UNIT) {
                GET_PLAYER(ePlayer).initUnit(eUnit, pNewCity->getX(), pNewCity->getY());
            } */
        }

        if !forced {

            /* if (!pNewCity->isEverLiberated(GetID()))
            {
                pNewCity->setEverLiberated(GetID(), true);

                // Reduce liberator's warmongering penalties (if any), unless this is their own team's city
                if (getTeam() != GET_PLAYER(ePlayer).getTeam())
                    CvDiplomacyAIHelpers::ApplyLiberationBonuses(pNewCity, GetID(), ePlayer);

                // Reduce liberator's war weariness by 25%
                GetCulture()->SetWarWeariness(GetCulture()->GetWarWeariness() - (GetCulture()->GetWarWeariness() / 4));
            } */

            // gain yields for liberation
            /* int iPop = pNewCity->getPopulation();
            for (int iI = 0; iI < NUM_YIELD_TYPES; iI++)
            {
                YieldTypes eYield = (YieldTypes)iI;
                int iLiberationYield = getYieldForLiberation(eYield);
                if (iLiberationYield > 0)
                    doInstantYield(INSTANT_YIELD_TYPE_INSTANT, false, NO_GREATPERSON, NO_BUILDING, iLiberationYield * iPop, true, NO_PLAYER, NULL, false, getCapitalCity(), false, true, true, eYield);
            } */

            // liberator gets influence with all City-States?
            /* int iInfluence = getInfluenceForLiberation();
            if (iInfluence > 0)
            {
                for (int iMinorLoop = MAX_MAJOR_CIVS; iMinorLoop < MAX_CIV_PLAYERS; iMinorLoop++)
                {
                    PlayerTypes eMinorLoop = (PlayerTypes)iMinorLoop;
                    if (eMinorLoop != NO_PLAYER)
                    {
                        CvPlayer* pMinorLoop = &GET_PLAYER(eMinorLoop);
                        if (pMinorLoop->isMinorCiv() && pMinorLoop->isAlive())
                        {
                            if (GET_TEAM(pMinorLoop->getTeam()).isHasMet(getTeam()))
                            {
                                pMinorLoop->GetMinorCivAI()->ChangeFriendshipWithMajor(GetID(), iInfluence, false);
                            }
                        }
                    }
                }
            } */

            // liberator gets XP with all of their units?
            /* int iNumXP = getExperienceForLiberation();
            if (iNumXP > 0)
            {
                doInstantYield(INSTANT_YIELD_TYPE_INSTANT, false, NO_GREATPERSON, NO_BUILDING, iNumXP, false, NO_PLAYER, NULL, false, getCapitalCity(), false, true, false, YIELD_JFD_SOVEREIGNTY);
                int iLoop;
                for (CvUnit* pLoopUnit = firstUnit(&iLoop); NULL != pLoopUnit; pLoopUnit = nextUnit(&iLoop))
                {
                    if (pLoopUnit && pLoopUnit->IsCombatUnit())
                    {
                        pLoopUnit->changeExperienceTimes100(iNumXP * 100);
                    }
                }
            } */

            // liberated city gets a building?
            /* for (int iI = 0; iI < GC.getNumBuildingClassInfos(); iI++)
            {
                if ((BuildingClassTypes)iI != NO_BUILDINGCLASS && getNumBuildingClassInLiberatedCities((BuildingClassTypes)iI) > 0)
                {
                    CvBuildingClassInfo* pkBuildingClassInfo = GC.getBuildingClassInfo((BuildingClassTypes)iI);
                    if (pkBuildingClassInfo)
                    {
                        BuildingTypes eBuilding = ((BuildingTypes)(getCivilizationInfo().getCivilizationBuildings(pkBuildingClassInfo->GetID())));
                        if (eBuilding != NO_BUILDING)
                        {
                            pNewCity->GetCityBuildings()->SetNumRealBuilding(eBuilding, getNumBuildingClassInLiberatedCities((BuildingClassTypes)iI));
                        }
                    }
                }
            }*/

            // liberated city gets units?
            /* int iNumUnit = getUnitsInLiberatedCities();
            if (iNumUnit > 0)
            {
                for (int i = 0; i < iNumUnit; i++)
                {
                    UnitTypes eUnit = GC.getGame().GetCompetitiveSpawnUnitType(ePlayer, false, false, false, true, true);
                    if (eUnit != NO_UNIT)
                        GET_PLAYER(ePlayer).initUnit(eUnit, pNewCity->getX(), pNewCity->getY());
                }
            } */
        }

        // GET_PLAYER(ePlayer).GetDiplomacyAI()->DoUpdateConquestStats();

        // Update Proximity between the liberated player and all others
        for loopPlayer in gameModel.players {

            guard loopPlayer.isAlive() else {
                continue
            }

            guard !loopPlayer.isEqual(to: newOwner) else {
                continue
            }

            guard loopPlayer.hasMet(with: newOwner) else {
                continue
            }

            /* if (GET_PLAYER(eLoopPlayer).isMajorCiv()) {
                GET_PLAYER(eLoopPlayer).GetDiplomacyAI()->DoUpdateConquestStats();
            }*/

            newOwner.doUpdateProximity(towards: loopPlayer, in: gameModel)
            loopPlayer.doUpdateProximity(towards: newOwner, in: gameModel)
        }

        // Meet the team, if we haven't already
        if !self.hasMet(with: newOwner) {
            self.doFirstContact(with: newOwner, in: gameModel)
        }

        // Update diplo stuff
        /* if alive {
            vector<PlayerTypes> v = GET_TEAM(getTeam()).getPlayers();
            pDiploAI->DoReevaluatePlayers(v, false, false);
        } else {
            vector<PlayerTypes> v = GET_PLAYER(ePlayer).GetDiplomacyAI()->GetAllValidMajorCivs();
            pDiploAI->DoReevaluatePlayers(v, false, false, true);
        } */

        // vector<PlayerTypes> v = GET_TEAM(GET_PLAYER(ePlayer).getTeam()).getPlayers();
        // GetDiplomacyAI()->DoReevaluatePlayers(v, false, false);

        // Mark the resurrection process as complete
        newOwner.set(beingResurrected: false)

        return true
    }

    public func disband(city cityRef: AbstractCity?, in gameModel: GameModel?) {

        guard let city = cityRef else {
            fatalError("cant get city to raze")
        }

        /* if getNumCities() == 1 {
            setFoundedFirstCity(false);
        } */

        // GC.getGame().addDestroyedCityName(pCity->getNameKey());

        /* for(int eBuildingType = 0; eBuildingType < GC.getNumBuildingInfos(); eBuildingType++)
        {
            CvBuildingEntry* buildingInfo = GC.getBuildingInfo((BuildingTypes) eBuildingType);
            if(buildingInfo)
            {
                // if this building exists
                int iExists = pCity->GetCityBuildings()->GetNumRealBuilding((BuildingTypes) eBuildingType);
                int iPreferredPosition = buildingInfo->GetPreferredDisplayPosition();
                if(iPreferredPosition > 0)
                {
                    auto_ptr<ICvCity1> pDllCity(new CvDllCity(pCity));

                    if(iExists > 0)
                    {
                        // kill the wonder
                        GC.GetEngineUserInterface()->AddDeferredWonderCommand(WONDER_REMOVED, pDllCity.get(), (BuildingTypes) eBuildingType, 0);
                    }
                    else
                    {
                        // else if we are currently in the process of building this wonder
                        if(pCity->getProductionBuilding() == eBuildingType)
                        {
                            // kill the half built wonder
                            if(isWorldWonderClass(buildingInfo->GetBuildingClassInfo()))
                            {
                                GC.GetEngineUserInterface()->AddDeferredWonderCommand(WONDER_REMOVED, pDllCity.get(), (BuildingTypes) eBuildingType, 0);
                            }
                        }
                    }
                }
            }
        }*/

        gameModel?.userInterface?.remove(city: city)

        city.kill(in: gameModel)

        /* if(pPlot)
        {
            IDInfoVector currentUnits;
            if (pPlot->getUnits(&currentUnits) > 0)
            {
                for (IDInfoVector::const_iterator itr = currentUnits.begin(); itr != currentUnits.end(); ++itr)
                {
                    CvUnit* pUnit = ::GetPlayerUnit(*itr);

                    if(pUnit && !pUnit->canEndTurnAtPlot(pPlot))
                    {
                        if (!pUnit->jumpToNearestValidPlot())
                            pUnit->kill(false);
                    }
                }
            }
        }*/
    }

    public func delete(city: AbstractCity?, in gameModel: GameModel?) {

        gameModel?.remove(city: city)
    }

    public func numberOfCitiesFounded() -> Int {

        return self.citiesFoundValue
    }

    public func numberOfCitiesLost() -> Int {

        return self.citiesLostValue
    }

    /// Handle earning culture from combat wins
    public func reportCultureFromKills(at point: HexPoint, culture cultureVal: Int, wasBarbarian: Bool, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var culture: Int = cultureVal

        if culture > 0 {

            let cultureValue = 100 // GetPlayerTraits()->GetCultureFromKills();
            // iCultureValue += GetPlayerPolicies()->GetNumericModifier(POLICYMOD_CULTURE_FROM_KILLS);

            // Do we get it for barbarians?
            if wasBarbarian {
                // cultureValue += GetPlayerPolicies()->GetNumericModifier(POLICYMOD_CULTURE_FROM_BARBARIAN_KILLS);
            }

            culture = (cultureValue * culture) / 100
            if culture > 0 {

                self.cultureEarned += culture

                if self.isHuman() {
                    gameModel.userInterface?.showTooltip(
                        at: point,
                        type: .cultureFromKill(culture: culture),
                        delay: 3.0
                    )
                }
            }
        }
    }

    //    --------------------------------------------------------------------------------
    /// Handle earning culture from combat wins
    public func reportGoldFromKills(at point: HexPoint, gold goldVal: Int, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var gold = goldVal

        if gold > 0 {

            let goldValue = 100 // GetPlayerPolicies()->GetNumericModifier(POLICYMOD_GOLD_FROM_KILLS);

            gold = (goldValue * gold) / 100

            if gold > 0 {

                self.treasury?.changeGold(by: Double(gold))

                if self.isHuman() {
                    gameModel.userInterface?.showTooltip(
                        at: point,
                        type: .goldFromKill(gold: gold),
                        delay: 3.0
                    )
                }
            }
        }
    }

    public func doGoodyHut(at tile: AbstractTile?, by unit: AbstractUnit?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        if self.isBarbarian() {
            return
        }

        tile.removeImprovement()

        // moment
        self.addMoment(of: .tribalVillageContacted, in: gameModel)

        // Make a list of valid Goodies to pick randomly from
        var validGoodies: [GoodyType] = []
        var validGoodyCategories: [GoodyCategory] = []

        for goody in GoodyType.all {

            if self.canReceiveGoody(at: tile, goody: goody, unit: unit, in: gameModel) {
                validGoodies.append(goody)
                validGoodyCategories.append(goody.category())
            }
        }

        // Any valid Goodies categories?
        guard let goodyCategory = validGoodyCategories.randomElement() else {
            fatalError("no goody categories found")
        }

        validGoodies = validGoodies.filter({ $0.category() == goodyCategory }) // goodyCategory

        if validGoodies.count > 1 {
            let goodies = WeightedList<GoodyType>()

            for validGoody in validGoodies {
                goodies.add(weight: validGoody.probability(), for: validGoody)
            }

            let randValue = Int.random(number: Int(goodies.totalWeights()))

            guard let selectedValue = goodies.item(by: Double(randValue)) else {
                fatalError("no goody found")
            }

            self.receiveGoody(at: tile, goody: selectedValue, unit: unit, in: gameModel)

        } else {
            self.receiveGoody(at: tile, goody: validGoodies[0], unit: unit, in: gameModel)
        }
    }

    public func doClearBarbarianCamp(at tile: AbstractTile?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        if !self.isBarbarian() && !self.isFreeCity() {
            // See if we need to remove a temporary dominance zone
            self.tacticalAI?.deleteTemporaryZone(at: tile.point)

            let numGold = gameModel.handicap.barbarianCampGold()

            tile.set(improvement: .none)

            // check quests
            for quest in self.ownQuests(in: gameModel) {

                if case .destroyBarbarianOutput(location: let location) = quest.type {

                    if location == tile.point && self.leader == quest.leader {
                        let cityStatePlayer = gameModel.cityStatePlayer(for: quest.cityState)
                        cityStatePlayer?.fulfillQuest(by: self.leader, in: gameModel)
                    }
                }
            }

            gameModel.doBarbCampCleared(by: self.leader, at: tile.point)

            self.addMoment(of: .barbarianCampDestroyed, in: gameModel)

            if !civics.inspirationTriggered(for: .militaryTradition) {
                civics.triggerInspiration(for: .militaryTradition, in: gameModel)
            }

            // initiationRites - +50 [Faith] Faith for each Barbarian Outpost cleared. The unit that cleared the Barbarian Outpost heals +100 HP.
            if self.religion?.pantheon() == .initiationRites {
                self.faithEarned += 50
            }

            self.treasury?.changeGold(by: Double(numGold))

            // If it's the active player then show the popup
            if self.isEqual(to: gameModel.humanPlayer()) {

                gameModel.userInterface?.showTooltip(at: tile.point, type: .barbarianCampCleared(gold: numGold), delay: 3)
            }
        }
    }

    public func isBarbarianCampDiscovered(at point: HexPoint) -> Bool {

        return self.discoveredBarbarianCampLocationsValue.contains(where: { $0 == point })
    }

    public func discoverBarbarianCamp(at point: HexPoint) {

        self.discoveredBarbarianCampLocationsValue.append(point)

        self.notifications()?.add(notification: .barbarianCampDiscovered(location: point))
    }

    public func forgetDiscoverBarbarianCamp(at point: HexPoint) {

        self.discoveredBarbarianCampLocationsValue.removeAll(where: { $0 == point })
    }

    func slots(for slotType: GreatWorkSlotType, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var slotsForType = 0

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            slotsForType += city.slots(for: slotType)
        }

        return slotsForType
    }

    /// Is a Particular Goody ID a valid Goody for a certain plot?
    /// unit can be nil
    func canReceiveGoody(at tile: AbstractTile?, goody: GoodyType, unit: AbstractUnit?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let goodyHuts = self.goodyHuts else {
            fatalError("cant get goodyHuts")
        }

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        if !goodyHuts.canReceive(goody: goody) {
            return false
        }

        if goody.minimalTurn() > gameModel.currentTurn {
            return false
        }

        switch goody {

        case .none:
            return false

        case .goldMinorGift, .goldMediumGift, .goldMajorGift:
            return true

        case .civicMinorBoost:
            let possibleCivicsWithoutEureka = civics.possibleCivics()
                .filter { !civics.inspirationTriggered(for: $0)}
            return possibleCivicsWithoutEureka.count >= 1

        case .civicMajorBoost:
            let possibleCivicsWithoutEureka = civics.possibleCivics()
                .filter { !civics.inspirationTriggered(for: $0)}
            return possibleCivicsWithoutEureka.count >= 2

        case .relic:
            return self.slots(for: .relic, in: gameModel) > 0

        case .faithMinorGift, .faithMediumGift, .faithMajorGift:
            return true

        case .scienceMinorGift, .scienceMajorGift, .freeTech:
            return true

        case .freeEnvoy:
            // city states cant get envoys
            guard !self.isCityState() else {
                return false
            }

            // player needs to know at least one city state to get an envoy
            return !self.metCityStates(in: gameModel).isEmpty

        case .diplomacyMinorBoost, .diplomacyMajorBoost:
            return false

            // military
        case .freeScout:
            return true

        case .healing:
            if let unit = unit {
                return unit.healthPoints() < unit.maxHealthPoints()
            }

            return false

        case .freeResource:
            return false

        case .experienceBoost:
            return false

        case .unitUpgrade:
            if let upgradeType = unit?.upgradeType(), let unit = unit {
                return unit.canUpgrade(to: upgradeType, in: gameModel)
            }

            return false

        case .additionalPopulation:
            if gameModel.cities(of: self).isEmpty {
                return false
            }

            return true

        case .freeBuilder, .freeTrader, .freeSettler:
            return true
        }
    }

    func receiveGoody(at tile: AbstractTile?, goody goodyType: GoodyType, unit: AbstractUnit?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        switch goodyType {
        case .none:
            print("")

        case .goldMinorGift:
            self.treasury?.changeGold(by: 40.0)

        case .goldMediumGift:
            self.treasury?.changeGold(by: 75.0)

        case .goldMajorGift:
            self.treasury?.changeGold(by: 120.0)

        case .civicMinorBoost:
            let possibleCivicsWithoutEureka = civics.possibleCivics().filter({ !civics.inspirationTriggered(for: $0)})
            guard let civicToBoost = possibleCivicsWithoutEureka.randomElement() else {
                fatalError("cant get civic to boost")
            }
            civics.triggerInspiration(for: civicToBoost, in: gameModel)

        case .civicMajorBoost:
            var possibleCivicsWithoutEureka = civics.possibleCivics().filter({ !civics.inspirationTriggered(for: $0)})
            guard let civicToBoost1 = possibleCivicsWithoutEureka.randomElement() else {
                fatalError("cant get civic to boost")
            }
            civics.triggerInspiration(for: civicToBoost1, in: gameModel)

            possibleCivicsWithoutEureka = civics.possibleCivics().filter({ !civics.inspirationTriggered(for: $0)})
            guard let civicToBoost2 = possibleCivicsWithoutEureka.randomElement() else {
                fatalError("cant get civic to boost")
            }
            civics.triggerInspiration(for: civicToBoost2, in: gameModel)

        case .relic:
            // keep the great work in players card
            self.addGreatWork(of: .relic)

        case .faithMinorGift:
            self.religion?.change(faith: 20.0)

        case .faithMediumGift:
            self.religion?.change(faith: 60.0)

        case .faithMajorGift:
            self.religion?.change(faith: 100.0)

        case .scienceMinorGift:
            let possibleTechsWithoutEureka = techs.possibleTechs().filter({ !techs.eurekaTriggered(for: $0)})
            guard let techToBoost = possibleTechsWithoutEureka.randomElement() else {
                fatalError("cant get tech to boost")
            }
            techs.triggerEureka(for: techToBoost, in: gameModel)

        case .scienceMajorGift:
            var possibleTechsWithoutEureka = techs.possibleTechs().filter({ !techs.eurekaTriggered(for: $0)})
            guard let techToBoost1 = possibleTechsWithoutEureka.randomElement() else {
                fatalError("cant get tech to boost")
            }
            techs.triggerEureka(for: techToBoost1, in: gameModel)

            possibleTechsWithoutEureka = techs.possibleTechs().filter({ !techs.eurekaTriggered(for: $0)})
            guard let techToBoost2 = possibleTechsWithoutEureka.randomElement() else {
                fatalError("cant get tech to boost")
            }
            techs.triggerEureka(for: techToBoost2, in: gameModel)

        case .freeTech:
            guard let possibleTech = techs.possibleTechs().randomElement() else {
                fatalError("cant get tech to discover")
            }
            do {
                try techs.discover(tech: possibleTech, in: gameModel)
            } catch {}

            if self.isHuman() {
                gameModel.userInterface?.showPopup(popupType: .techDiscovered(tech: possibleTech))
            }

        case .diplomacyMinorBoost:
            print("Diplomatic favor")

        case .freeEnvoy:
            self.changeUnassignedEnvoys(by: 1)

        case .diplomacyMajorBoost:
            self.governors?.addTitle()

        case .freeScout:
            let scoutUnit = Unit(at: tile.point, type: .scout, owner: self)
            gameModel.add(unit: scoutUnit)
            scoutUnit.jumpToNearestValidPlotWithin(range: 2, in: gameModel)

            // make the unit visible
            gameModel.userInterface?.show(unit: scoutUnit, at: tile.point)

        case .healing:
            unit?.doHeal(in: gameModel)

        case .freeResource:
            print("free resource")

        case .experienceBoost:
            print("experience")

        case .unitUpgrade:
            guard let upgradeType = unit?.upgradeType() else {
                fatalError("cant get upgrade type")
            }

            unit?.doUpgrade(to: upgradeType, in: gameModel)

        case .additionalPopulation:
            var bestCityDistance = -1
            var bestCityRef: AbstractCity?

            // Find the closest City to us to add a Pop point to
            for cityRef in gameModel.cities(of: self) {

                guard let city = cityRef else {
                    continue
                }

                let distance = tile.point.distance(to: city.location)

                if bestCityDistance == -1 || distance < bestCityDistance {
                    bestCityDistance = distance
                    bestCityRef = cityRef
                }
            }

            guard let bestCity = bestCityRef else {
                fatalError("no city found for this player")
            }

            bestCity.change(population: 1, reassignCitizen: true, in: gameModel)

            // redraw the city banner
            gameModel.userInterface?.update(city: bestCity)

        case .freeBuilder:
            let builderUnit = Unit(at: tile.point, type: .builder, owner: self)
            gameModel.add(unit: builderUnit)
            builderUnit.jumpToNearestValidPlotWithin(range: 2, in: gameModel)

            // make the unit visible
            gameModel.userInterface?.show(unit: builderUnit, at: tile.point)

        case .freeTrader:
            var bestCityDistance = -1
            var bestCityRef: AbstractCity?

            // Find the closest City to us to add a Pop point to
            for cityRef in gameModel.cities(of: self) {

                guard let city = cityRef else {
                    continue
                }

                let distance = tile.point.distance(to: city.location)

                if bestCityDistance == -1 || distance < bestCityDistance {
                    bestCityDistance = distance
                    bestCityRef = cityRef
                }
            }

            guard let bestCity = bestCityRef else {
                fatalError("no city found for this player")
            }

            let traderUnit = Unit(at: tile.point, type: .trader, owner: self)
            traderUnit.origin = bestCity.location
            gameModel.add(unit: traderUnit)
            traderUnit.jumpToNearestValidPlotWithin(range: 2, in: gameModel)

            // make the unit visible
            gameModel.userInterface?.show(unit: traderUnit, at: tile.point)

        case .freeSettler:
            let settlerUnit = Unit(at: tile.point, type: .settler, owner: self)
            gameModel.add(unit: settlerUnit)
            settlerUnit.jumpToNearestValidPlotWithin(range: 2, in: gameModel)

            // make the unit visible
            gameModel.userInterface?.show(unit: settlerUnit, at: tile.point)
        }

        // If it's the active player then show the popup
        if self.isHuman() && self.isEqual(to: gameModel.activePlayer()) {

            // FIXME: should not happen - all goodies should be handled
            gameModel.userInterface?.showPopup(popupType: .goodyHutReward(goodyType: goodyType, location: tile.point))
        }
    }

    func addGreatWork(of greatWorkType: GreatWorkType) {

        print("TODO: handle add \(greatWorkType)")
    }

    //    --------------------------------------------------------------------------------
    public func canTrain(unitType: UnitType, continueFlag: Bool, testVisible: Bool, ignoreCost: Bool, ignoreUniqueUnitStatus: Bool) -> Bool {

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        /*if (GetPlayerTraits()->NoTrain(eUnitClass)) {
            return false;
        }*/

        // Should we check whether this Unit has been blocked out by the civ XML?
        if !ignoreUniqueUnitStatus {

            // If the player isn't allowed to train this Unit (via XML) then return false
            guard unitType.unitType(for: self.leader.civilization()) != nil else {
                return false
            }
        }

        if !ignoreCost {
            if unitType.productionCost() < 0 {
                return false
            }
        }

        // Policy Requirement
        if let civic = unitType.requiredCivic() {
            if !civics.has(civic: civic) {
                return false
            }
        }

        if !continueFlag {
            if !testVisible {
                // Builder Limit
                if unitType.workRate() > 0 && unitType.domain() == .land {
                    /*if(GetMaxNumBuilders() > -1 && GetNumBuilders() >= GetMaxNumBuilders())
                    {
                        return false;
                    }*/
                }
            }
        }

        // Tech requirements
        if let tech = unitType.requiredTech() {
            if !techs.has(tech: tech) {
                return false
            }
        }

        // Obsolete Tech
        if let obsoleteTech = unitType.obsoleteTech() {
            if techs.has(tech: obsoleteTech) {
                return false
            }
        }

        // Spaceship part we already have?
        /*ProjectTypes eProject = (ProjectTypes) pUnitInfo.GetSpaceshipProject();
        if(eProject != NO_PROJECT)
        {
            if(GET_TEAM(getTeam()).isProjectMaxedOut(eProject))
                return false;

            int iUnitAndProjectCount = GET_TEAM(getTeam()).getProjectCount(eProject) + getUnitClassCount(eUnitClass) + GET_TEAM(getTeam()).getUnitClassMaking(eUnitClass) + ((bContinue) ? -1 : 0);
            if(iUnitAndProjectCount >= pkUnitClassInfo->getMaxPlayerInstances())
            {
                return false;
            }
        }*/

        if !testVisible {
            // Settlers
            if unitType.canFound() {
                /*if(IsEmpireVeryUnhappy() && GC.getVERY_UNHAPPY_CANT_TRAIN_SETTLERS() == 1)
                {
                    GC.getGame().BuildCannotPerformActionHelpText(toolTipSink, "TXT_KEY_NO_ACTION_VERY_UNHAPPY_SETTLERS");
                    if(toolTipSink == NULL)
                        return false;
                }*/
            }

            // Project required?
            /*ProjectTypes ePrereqProject = (ProjectTypes) pUnitInfo.GetProjectPrereq();
            if(ePrereqProject != NO_PROJECT)
            {
                CvProjectEntry* pkProjectInfo = GC.getProjectInfo(ePrereqProject);
                if(pkProjectInfo)
                {
                    if(GET_TEAM(getTeam()).getProjectCount(ePrereqProject) == 0)
                    {
                        GC.getGame().BuildCannotPerformActionHelpText(toolTipSink, "TXT_KEY_NO_ACTION_UNIT_PROJECT_REQUIRED", pkProjectInfo->GetDescription());
                        if(toolTipSink == NULL)
                            return false;
                    }
                }
            }*/

            // Resource Requirements
            if let resource = unitType.requiredResource() {

                if self.numberOfAvailable(resource: resource) <= 0 {
                    return false
                }
            }

            /*if (pUnitInfo.IsTrade())
            {
                if (GetTrade()->GetNumTradeRoutesRemaining(bContinue) <= 0)
                {
                    GC.getGame().BuildCannotPerformActionHelpText(toolTipSink, "TXT_KEY_TRADE_UNIT_CONSTRUCTION_NO_EXTRA_SLOTS");
                    if (toolTipSink == NULL)
                        return false;
                }

                DomainTypes eDomain = (DomainTypes)pUnitInfo.GetDomainType();
                if (!GetTrade()->CanCreateTradeRoute(eDomain))
                {
                    if (eDomain == DOMAIN_LAND)
                    {
                        GC.getGame().BuildCannotPerformActionHelpText(toolTipSink, "TXT_KEY_TRADE_UNIT_CONSTRUCTION_NONE_OF_TYPE_LAND");
                    }
                    else if (eDomain == DOMAIN_SEA)
                    {
                        GC.getGame().BuildCannotPerformActionHelpText(toolTipSink, "TXT_KEY_TRADE_UNIT_CONSTRUCTION_NONE_OF_TYPE_SEA");
                    }
                    if (toolTipSink == NULL)
                        return false;
                }
            }*/
        }

        return true
    }

    public func canPurchaseInAnyCity(unit unitType: UnitType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.canPurchase(unit: unitType, with: yieldType, in: gameModel) {
                return true
            }
        }

        return false
    }

    public func canPurchaseInAnyCity(building buildingType: BuildingType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.canPurchase(building: buildingType, with: yieldType, in: gameModel) {
                return true
            }
        }

        return false
    }

    public func numberOfDistricts(of districtType: DistrictType, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var numberOfDistricts = 0

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.has(district: districtType) {
                numberOfDistricts += 1
            }
        }

        return numberOfDistricts
    }

    public func numberBuildings(of buildingType: BuildingType, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var numberOfBuildings = 0

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.has(building: buildingType) {
                numberOfBuildings += 1
            }
        }

        return numberOfBuildings
    }

    // MARK: religion methods

    public func faithPurchaseType() -> FaithPurchaseType {

        return self.faithPurchaseTypeVal
    }

    public func set(faithPurchaseType: FaithPurchaseType) {

        self.faithPurchaseTypeVal = faithPurchaseType
    }

    public func majorityOfCitiesFollows(religion: ReligionType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var numberOfCitiesFollowingReligion: Double = 0.0
        var numberOfCitiesAll: Double = 0.0
        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            numberOfCitiesAll += 1.0

            if city.religiousMajority() == religion {
                numberOfCitiesFollowingReligion += 1.0
            }
        }

        return numberOfCitiesFollowingReligion >= numberOfCitiesAll / 2.0
    }

    public func doFound(religion: ReligionType, at city: AbstractCity?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let civics = self.civics else {
            fatalError("cant get player civics")
        }

        guard let playerReligion = self.religion else {
            fatalError("cant get player religion")
        }

        playerReligion.found(religion: religion, at: city, in: gameModel)
        self.addMoment(of: .religionFounded(religion: religion), in: gameModel)

        if !civics.inspirationTriggered(for: .theology) {
            civics.triggerInspiration(for: .theology, in: gameModel)
        }

        // inform other players, that a pantheon was founded
        gameModel.sendGossip(type: .religionsFounded(religionName: religion.name()), of: self)
    }

    // MARK: discovery

    public func hasCapital(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if gameModel.capital(of: self) != nil {
            return true
        }

        return false
    }

    public func hasDiscoveredCapital(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        if let capital = gameModel.capital(of: otherPlayer) {

            guard let capitalTile = gameModel.tile(at: capital.location) else {
                return false
            }

            if capitalTile.isDiscovered(by: self) {
                return true
            }

            return false
        }

        // nothing to discover
        return false
    }

    public func discoverCapital(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }

        if let capital = gameModel.capital(of: otherPlayer) {

            gameModel.discover(at: capital.location, sight: 3, for: self)
        } else {
            fatalError("player has no capital - should not happen")
        }
    }

    public func capitalCity(in gameModel: GameModel?) -> AbstractCity? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        return gameModel.capital(of: self)
    }

    public func set(capitalCity newCapitalCity: AbstractCity?, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if let newCapitalCity = newCapitalCity {

            let currentCapitalCity = self.capitalCity(in: gameModel)

            if currentCapitalCity?.location != newCapitalCity.location || currentCapitalCity?.name != newCapitalCity.name {

                // Need to set our original capital x,y?
                if self.originalCapitalLocationValue == HexPoint.invalid {

                    self.originalCapitalLocationValue = newCapitalCity.location
                }

                newCapitalCity.setEverCapital(to: true)
            }
        } else {
            for cityRef in gameModel.cities(of: self) {
                cityRef?.setIsCapital(to: false)
            }
        }
    }

    public func originalCapitalLocation() -> HexPoint {

        return self.originalCapitalLocationValue
    }

    public func findNewCapital(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        var bestCity: AbstractCity?
        var bestValue = 0

        for loopCityRef in gameModel.cities(of: self) {

            guard let loopCity = loopCityRef else {
                continue
            }

            var value = loopCity.population() * 4

            var yieldValueTimes100: Int = Int(loopCity.foodPerTurn(in: gameModel)) * 100
            yieldValueTimes100 += Int(loopCity.productionPerTurn(in: gameModel)) * 100 * 3
            yieldValueTimes100 += Int(loopCity.goldPerTurn(in: gameModel)) * 100 * 2
            value += (yieldValueTimes100 / 100)

            if value > bestValue {
                bestValue = value
                bestCity = loopCityRef
            }
        }

        guard let newCapital = bestCity else {
            return
        }

        do {
            try newCapital.buildings?.build(building: .palace)
        } catch {

        }
        newCapital.setIsCapital(to: true)

        // update UI
        gameModel.userInterface?.update(city: newCapital)
        gameModel.userInterface?.refresh(tile: gameModel.tile(at: newCapital.location))
    }

    func population(in gameModel: GameModel?) -> Int {

        guard let cities = gameModel?.cities(of: self) else {
            return 0
        }

        var populationVal = 0

        for cityRef in cities {
            if let city = cityRef {
                populationVal += city.population()
            }
        }

        return populationVal
    }

    // MARK: government

    public func canChangeGovernment() -> Bool {

        return self.canChangeGovernmentValue
    }

    public func set(canChangeGovernment: Bool) {

        self.canChangeGovernmentValue = canChangeGovernment
    }

    public func scienceVictoryProgress(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        var scienceVictoryProgressValue: Int = 0

        for cityRef in gameModel.cities(of: self) {

            guard let city = cityRef else {
                continue
            }

            if city.has(project: .launchEarthSatellite) {
                scienceVictoryProgressValue += 1
            }

            if city.has(project: .launchMoonLanding) {
                scienceVictoryProgressValue += 1
            }

            if city.has(project: .launchMarsColony) {
                scienceVictoryProgressValue += 1
            }

            if city.has(project: .exoplanetExpedition) {
                scienceVictoryProgressValue += 1
            }
        }

        if self.boostExoplanetExpeditionValue >= 50 {
            scienceVictoryProgressValue += 1
        }

        return scienceVictoryProgressValue
    }

    public func hasScienceVictory(in gameModel: GameModel?) -> Bool {

        return self.scienceVictoryProgress(in: gameModel) >= 5
    }

    public func hasCulturalVictory(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        let visitingTourists: Int = self.visitingTourists(in: gameModel)
        var maxDomesticTourists: Int = 0

        for loopPlayer in gameModel.players {

            if loopPlayer.isBarbarian() || self.isEqual(to: loopPlayer) {
                continue
            }

            maxDomesticTourists = max(maxDomesticTourists, loopPlayer.domesticTourists())
        }

        return visitingTourists > maxDomesticTourists
    }

    public func hasReligiousVictory(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let playerReligion = self.religion else {
            fatalError("cant get player religion")
        }

        if playerReligion.currentReligion() == .none {
            return false
        }

        for loopPlayer in gameModel.players {

            if loopPlayer.isBarbarian() || self.isEqual(to: loopPlayer) {
                continue
            }

            if !loopPlayer.majorityOfCitiesFollows(religion: playerReligion.currentReligion(), in: gameModel) {
                return false
            }
        }

        return true
    }

    // MARK: tourism

    public func domesticTourists() -> Int {

        guard let playerTourism = self.tourism else {
            fatalError("cant get player tourism")
        }

        return playerTourism.domesticTourists()
    }

    public func visitingTourists(in gameModel: GameModel?) -> Int {

        guard let playerTourism = self.tourism else {
            fatalError("cant get player tourism")
        }

        return playerTourism.visitingTourists(in: gameModel)
    }

    public func currentTourism(in gameModel: GameModel?) -> Double {

        guard let playerTourism = self.tourism else {
            fatalError("cant get player tourism")
        }

        return playerTourism.currentTourism(in: gameModel)
    }

    /// At the player level, what is the modifier for tourism between these players?
    /// in percent / CvPlayerCulture::GetTourismModifierWith
    /// https://forums.civfanatics.com/threads/how-tourism-is-calculated-and-a-culture-victory-made.605199/
    public func tourismModifier(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Int {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get player diplomacyAI")
        }

        guard let tradeRoutes = self.tradeRoutes else {
            fatalError("cant get player tradeRoutes")
        }

        guard let otherTradeRoutes = otherPlayer?.tradeRoutes else {
            fatalError("cant get other player tradeRoutes")
        }

        let playerGovernmentType: GovernmentType = self.government?.currentGovernment() ?? .chiefdom
        let otherPlayerGovernmentType: GovernmentType = otherPlayer?.government?.currentGovernment() ?? .chiefdom

        var modifier: Int = 0

        // Open Borders
        if diplomacyAI.isOpenBorderAgreementActive(by: otherPlayer) {
            modifier += 25 // TOURISM_MODIFIER_OPEN_BORDERS
        }

        // Trade Route
        if tradeRoutes.hasTradeRoute(with: otherPlayer, in: gameModel) || otherTradeRoutes.hasTradeRoute(with: self, in: gameModel) {
            modifier += 25 // TOURISM_MODIFIER_TRADE_ROUTE

            // Civic Online Communities provides +50% tourism to civs you have a trade route with
        }

        // Different Religion
        // ...

        // Enlightenment
        // ...

        // Different Governments
        // (Gov1_factor + Gov2_factor) x Base Government tourist factor
        if playerGovernmentType != otherPlayerGovernmentType {
            let diffentGovFactor = (playerGovernmentType.tourismFactor() + otherPlayerGovernmentType.tourismFactor()) * 3
            modifier += diffentGovFactor
        }

        return modifier
    }

    // MARK: moments

    public func addMoment(of type: MomentType, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard type.minEra() <= self.currentEraVal && self.currentEraVal <= type.maxEra() else {
            return
        }

        self.momentsVal?.addMoment(of: type, in: gameModel.currentTurn)

        // also show a notification, when the moment brings era score
        if type.eraScore() > 0 {
            if self.isHuman() {
                self.notifications()?.add(notification: .momentAdded(type: type))
            }
        }
    }

    public func hasMoment(of type: MomentType) -> Bool {

        return self.momentsVal?.moments().contains(
            where: {
                return $0.type == type
            }
        ) ?? false
    }

    public func moments() -> [Moment] {

        return self.momentsVal?.moments() ?? []
    }

    public func hasDiscovered(naturalWonder: FeatureType) -> Bool {

        return self.discoveredNaturalWonders.contains(naturalWonder)
    }

    public func doDiscover(naturalWonder: FeatureType) {

        self.discoveredNaturalWonders.append(naturalWonder)
    }

    public func hasSettled(on continent: ContinentType) -> Bool {

        return self.settledContinents.contains(continent)
    }

    public func markSettled(on continent: ContinentType) {

        self.settledContinents.append(continent)
    }

    public func checkWorldCircumnavigated(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        if self.hasWorldCircumnavigatedVal {
            return
        }

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {

            var foundVisible = false

            for y in 0..<mapSize.height() {

                guard let tile = gameModel.tile(x: x, y: y) else {
                    continue
                }

                if tile.isDiscovered(by: self) {
                    foundVisible = true
                    break
                }
            }

            if !foundVisible {
                return
            }
        }

        self.set(worldCircumnavigated: true)

        if gameModel.anyHasMoment(of: .worldsFirstCircumnavigation) {
            self.addMoment(of: .worldCircumnavigated, in: gameModel)
        } else {
            self.addMoment(of: .worldsFirstCircumnavigation, in: gameModel)
        }
    }

    public func hasWorldCircumnavigated() -> Bool {

        return self.hasWorldCircumnavigatedVal
    }

    public func set(worldCircumnavigated: Bool) {

        self.hasWorldCircumnavigatedVal = worldCircumnavigated
    }

    public func hasEverEstablishedTradingPost(with leader: LeaderType) -> Bool {

        return self.establishedTradingPosts.contains(leader)
    }

    public func markEstablishedTradingPost(with leader: LeaderType) {

        if !self.hasEverEstablishedTradingPost(with: leader) {
            self.establishedTradingPosts.append(leader)
        }
    }

    public func numEverEstablishedTradingPosts(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        return self.establishedTradingPosts
            .filter { gameModel.player(for: $0)?.isAlive() ?? false  }
            .count
    }

    public func addMarker(type: MapMarkerType, name: String, at location: HexPoint, in gameModel: GameModel?) {

        let marker = MapMarker(location: location, name: name, type: type)
        self.markersValue.append(marker)

        let tile = gameModel?.tile(at: location)
        gameModel?.userInterface?.refresh(tile: tile)
    }

    public func removeMarker(at location: HexPoint, in gameModel: GameModel?) {

        self.markersValue.removeAll(where: { $0.location == location })

        let tile = gameModel?.tile(at: location)
        gameModel?.userInterface?.refresh(tile: tile)
    }

    public func marker(at location: HexPoint) -> MapMarker? {

        return self.markersValue.first(where: { $0.location == location })
    }

    public func markers() -> [MapMarker] {

        return self.markersValue
    }
}

extension Player: Equatable {

    public static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.leader == rhs.leader
    }
}
