//
//  CityStatePlayer.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

class CityStatePlayer: AbstractPlayer {

    enum CodingKeys: CodingKey {

        case leader
        case alive
        // case personalityFlavor

        case area
        case armies
        case numPlotsBought
        case improvementCountList
        case totalImprovementsBuilt

        case techs
        case civics
        case religion
        case treasury
        case greatPeople
        case government
        case tourism
        case moments

        case currentEra

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

        case operations
        case notifications
        case resourceProduction
        case resourceStockpile
        case resourceMaxStockpile

        case conqueror

        case canChangeGovernment
        case happiness

        case faithPurchaseType
        case boostExoplanetExpedition
        case discoveredNaturalWonders
        case settledContinents
        case hasWorldCircumnavigated
        case establishedTradingPosts
    }

    var leader: LeaderType
    internal var isAliveVal: Bool

    var techs: AbstractTechs?
    var civics: AbstractCivics?
    var government: AbstractGovernment?
    var treasury: AbstractTreasury?
    var religion: AbstractPlayerReligion?
    var greatPeople: AbstractGreatPeople?
    var tradeRoutes: AbstractTradeRoutes?
    var governors: AbstractPlayerGovernors?
    var tourism: AbstractPlayerTourism?
    var grandStrategyAI: GrandStrategyAI?
    var diplomacyAI: DiplomaticAI?
    var diplomacyRequests: DiplomacyRequests?
    var diplomacyDealAI: DiplomaticDealAI?
    var economicAI: EconomicAI?
    var militaryAI: MilitaryAI?
    var tacticalAI: TacticalAI?
    var homelandAI: HomelandAI?
    var dangerPlotsAI: DangerPlotsAI?
    var builderTaskingAI: BuilderTaskingAI?
    var citySpecializationAI: CitySpecializationAI?
    var wonderProductionAI: WonderProductionAI?
    var religionAI: ReligionAI?
    var cityConnections: CityConnections?

    var area: HexArea
    internal var numPlotsBoughtValue: Int

    internal var resourceProduction: ResourceInventory?
    internal var resourceStockpile: ResourceInventory?
    internal var resourceMaxStockpile: ResourceInventory?
    
    var armies: Armies?
    internal var operations: Operations?

    internal var currentEraVal: EraType = .ancient

    internal var improvementCountList: ImprovementCountList
    internal var totalImprovementsBuilt: Int

    private var conquerorValue: LeaderType?

    init() {
        self.leader = .none
        self.isAliveVal = true
        // self.personalityFlavor = Flavors()

        self.area = HexArea(points: [])
        self.armies = Armies()

        self.numPlotsBoughtValue = 0

        self.improvementCountList = ImprovementCountList()
        self.improvementCountList.fill()

        self.totalImprovementsBuilt = 0
        self.conquerorValue = nil
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.leader = try container.decode(LeaderType.self, forKey: .leader)
        self.isAliveVal = try container.decode(Bool.self, forKey: .alive)
        // self.personalityFlavor = try container.decodeIfPresent(Flavors.self, forKey: .personalityFlavor) ?? Flavors()

        self.area = try container.decode(HexArea.self, forKey: .area)
        self.armies = try container.decode(Armies.self, forKey: .armies)

        self.numPlotsBoughtValue = 0
        self.improvementCountList = ImprovementCountList()
        self.improvementCountList.fill()

        self.totalImprovementsBuilt = try container.decode(Int.self, forKey: .totalImprovementsBuilt)

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

        self.religionAI = ReligionAI(player: self)

        self.cityConnections = try container.decode(CityConnections.self, forKey: .cityConnections)
        self.goodyHuts = try container.decode(GoodyHuts.self, forKey: .goodyHuts)
        self.tradeRoutes = try container.decode(TradeRoutes.self, forKey: .tradeRoutes)

        self.techs = try container.decode(Techs.self, forKey: .techs)
        self.civics = try container.decode(Civics.self, forKey: .civics)
        self.religion = try container.decode(PlayerReligion.self, forKey: .religion)
        self.treasury = try container.decode(Treasury.self, forKey: .treasury)
        self.greatPeople = try container.decode(GreatPeople.self, forKey: .greatPeople)
        self.government = try container.decode(Government.self, forKey: .government)

        self.currentEraVal = try container.decode(EraType.self, forKey: .currentEra)

        self.operations = try container.decode(Operations.self, forKey: .operations)

        self.resourceProduction = try container.decode(ResourceInventory.self, forKey: .resourceProduction)
        self.resourceStockpile = try container.decode(ResourceInventory.self, forKey: .resourceStockpile)
        self.resourceMaxStockpile = try container.decode(ResourceInventory.self, forKey: .resourceMaxStockpile)

        self.conquerorValue = try container.decodeIfPresent(LeaderType.self, forKey: .conqueror)

        /*self.canChangeGovernmentValue = try container.decode(Bool.self, forKey: .canChangeGovernment)
        self.happinessValue = try container.decodeIfPresent(Int.self, forKey: .happiness) ?? 0
        self.faithPurchaseTypeVal = try container.decode(FaithPurchaseType.self, forKey: .faithPurchaseType)
        self.boostExoplanetExpeditionValue = try container.decode(Int.self, forKey: .boostExoplanetExpedition)
        self.discoveredNaturalWonders = try container.decode([FeatureType].self, forKey: .discoveredNaturalWonders)
        self.settledContinents = try container.decode([ContinentType].self, forKey: .settledContinents)
        self.hasWorldCircumnavigatedVal = try container.decode(Bool.self, forKey: .hasWorldCircumnavigated)
        self.establishedTradingPosts = try container.decode([LeaderType].self, forKey: .establishedTradingPosts)

        self.crampedValue = try container.decode(Bool.self, forKey: .cramped)
        self.combatThisTurnValue = try container.decodeIfPresent(Bool.self, forKey: .combatThisTurn) ?? false*/

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
    }

    // swiftlint:disable force_cast
    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.leader, forKey: .leader)
        try container.encode(self.isAliveVal, forKey: .alive)
        // try container.encode(self.personalityFlavor, forKey: .personalityFlavor)

        try container.encode(self.area, forKey: .area)
        try container.encode(self.armies, forKey: .armies)
        try container.encode(self.numPlotsBoughtValue, forKey: .numPlotsBought)
        try container.encode(self.improvementCountList, forKey: .improvementCountList)
        try container.encode(self.totalImprovementsBuilt, forKey: .totalImprovementsBuilt)

        try container.encode(self.grandStrategyAI, forKey: .grandStrategyAI)
        try container.encode(self.diplomacyAI, forKey: .diplomacyAI)
        try container.encode(self.diplomacyRequests, forKey: .diplomacyRequests)
        try container.encode(self.diplomacyDealAI, forKey: .diplomacyDealAI)
        try container.encode(self.economicAI, forKey: .economicAI)
        try container.encode(self.militaryAI, forKey: .militaryAI)
        try container.encode(self.tacticalAI, forKey: .tacticalAI)
        try container.encode(self.dangerPlotsAI, forKey: .dangerPlotsAI)
        //try container.encode(self.homelandAI, forKey: .homelandAI)
        //try container.encode(self.builderTaskingAI, forKey: .builderTaskingAI)
        //try container.encode(self.citySpecializationAI, forKey: .citySpecializationAI)
        //try container.encode(self.wonderProductionAI, forKey: .wonderProductionAI)

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
        try container.encode(self.government as! Government, forKey: .government)

        try container.encode(self.currentEraVal, forKey: .currentEra)

        try container.encode(self.operations, forKey: .operations)
        try container.encode(self.notificationsValue, forKey: .notifications)
        try container.encode(self.resourceProduction, forKey: .resourceProduction)
        try container.encode(self.resourceStockpile, forKey: .resourceStockpile)
        try container.encode(self.resourceMaxStockpile, forKey: .resourceMaxStockpile)

        try container.encodeIfPresent(self.conquerorValue, forKey: .conqueror)

        try container.encode(self.canChangeGovernmentValue, forKey: .canChangeGovernment)
        try container.encode(self.happinessValue, forKey: .happiness)
        try container.encode(self.faithPurchaseTypeVal, forKey: .faithPurchaseType)
        try container.encode(self.boostExoplanetExpeditionValue, forKey: .boostExoplanetExpedition)
        try container.encode(self.discoveredNaturalWonders, forKey: .discoveredNaturalWonders)
        try container.encode(self.settledContinents, forKey: .settledContinents)
        try container.encode(self.hasWorldCircumnavigatedVal, forKey: .hasWorldCircumnavigated)
        try container.encode(self.establishedTradingPosts, forKey: .establishedTradingPosts)

        try container.encode(self.crampedValue, forKey: .cramped)
        try container.encode(self.combatThisTurnValue, forKey: .combatThisTurn)
    }
    // swiftlint:enable force_cast

    // public methods

    public func initialize() {

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
            self.resourceMaxStockpile?.add(weight: 50, for: resource)
        }
    }

    func hasActiveDiplomacyRequests() -> Bool {

        return false
    }

    func canFinishTurn() -> Bool {
        <#code#>
    }

    func turnFinished() -> Bool {
        <#code#>
    }

    func doTurnPostDiplomacy(in gameModel: GameModel?) {
        <#code#>
    }

    func finishTurn() {
        <#code#>
    }

    func resetFinishTurnButtonPressed() {
        <#code#>
    }

    func updateTimers(in gameModel: GameModel?) {
        <#code#>
    }

    func isEndTurn() -> Bool {
        <#code#>
    }

    func setEndTurn(to value: Bool, in gameModel: GameModel?) {
        <#code#>
    }

    func hasProcessedAutoMoves() -> Bool {
        <#code#>
    }

    func setProcessedAutoMoves(value: Bool) {
        <#code#>
    }

    func isAutoMoves() -> Bool {
        <#code#>
    }

    func setAutoMoves(to value: Bool) {
        <#code#>
    }

    func doFirstContact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {

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

        // update eurekas
        if !techs.eurekaTriggered(for: .writing) {
            techs.triggerEureka(for: .writing, in: gameModel)
        }
    }

    func doDefensivePact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {
        <#code#>
    }

    func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool {
        <#code#>
    }

    func isOpenBordersTradingAllowed() -> Bool {
        <#code#>
    }

    func hasEmbassy(with otherPlayer: AbstractPlayer?) -> Bool {

        return false
    }

    func isAllowsOpenBorders(with otherPlayer: AbstractPlayer?) -> Bool {
        <#code#>
    }

    func isAllowEmbassyTradingAllowed() -> Bool {

        return false
    }

    func valueOfPersonalityFlavor(of flavor: FlavorType) -> Int {
        <#code#>
    }

    func valueOfPersonalityIndividualFlavor(of flavor: FlavorType) -> Int {
        <#code#>
    }

    func valueOfStrategyAndPersonalityFlavor(of flavor: FlavorType) -> Int {
        <#code#>
    }

    func valueOfStrategyAndPersonalityApproach(of approach: PlayerApproachType) -> Int {
        <#code#>
    }

    func personalAndGrandStrategyFlavor(for flavorType: FlavorType) -> Int {
        <#code#>
    }

    func calculateGoldPerTurn(in gamemModel: GameModel?) -> Double {
        <#code#>
    }

    func currentAge() -> AgeType {

        return .normal
    }

    func currentDedications() -> [DedicationType] {

        return []
    }

    func has(dedication: DedicationType) -> Bool {

        return false
    }

    func select(dedications: [DedicationType]) {

        return
    }

    func prepareTurn(in gamemModel: GameModel?) {
        <#code#>
    }

    func startTurn(in gameModel: GameModel?) {
        <#code#>
    }

    func endTurn(in gameModel: GameModel?) {
        <#code#>
    }

    func unitUpdate(in gameModel: GameModel?) {
        <#code#>
    }

    func lastSliceMoved() -> Int {
        <#code#>
    }

    func setLastSliceMoved(to value: Int) {
        <#code#>
    }

    func isAlive() -> Bool {

        return self.isAliveVal
    }

    func isEverAlive() -> Bool {

        return true
    }

    func isActive() -> Bool {
        <#code#>
    }

    func isTurnActive() -> Bool {
        <#code#>
    }

    func isHuman() -> Bool {

        return false
    }

    func isBarbarian() -> Bool {

        return false
    }

    func isFreeCity() -> Bool {

        return false
    }

    func hasMet(with otherPlayer: AbstractPlayer?) -> Bool {
        <#code#>
    }

    func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool {
        <#code#>
    }

    func atWarCount() -> Int {
        <#code#>
    }

    func canDeclareWar(to otherPlayer: AbstractPlayer?) -> Bool {
        <#code#>
    }

    func doDeclareWar(to otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {
        <#code#>
    }

    func doEstablishPeaceTreaty(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {
        <#code#>
    }

    func warWeariness(with otherPlayer: AbstractPlayer?) -> Int {
        <#code#>
    }

    func updateWarWeariness(against otherPlayer: AbstractPlayer?, at point: HexPoint, killed: Bool, in gameModel: GameModel?) {
        <#code#>
    }

    func doUpdateProximity(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {
        <#code#>
    }

    func proximity(to otherPlayer: AbstractPlayer?) -> PlayerProximityType {
        <#code#>
    }

    func hasHasLostCapital() -> Bool {

        return false
    }

    func capitalConqueror() -> LeaderType? {

        return self.conquerorValue
    }

    func set(hasLostCapital value: Bool, to conqueror: AbstractPlayer?, in gameModel: GameModel?) {

        return
    }

    func updateNotifications(in gameModel: GameModel?) {

        return
    }

    func set(blockingNotification: NotificationItem?) {

        return
    }

    func blockingNotification() -> NotificationItem? {

        return nil
    }

    func hasReadyUnit(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func firstReadyUnit(in gameModel: GameModel?) -> AbstractUnit? {
        <#code#>
    }

    func endTurnsForReadyUnits(in gameModel: GameModel?) {
        <#code#>
    }

    func hasPromotableUnit(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func firstPromotableUnit(in gameModel: GameModel?) -> AbstractUnit? {
        <#code#>
    }

    func currentEra() -> EraType {

        return self.currentEraVal
    }

    func set(era: EraType, in gameModel: GameModel?) {
        <#code#>
    }

    func eraScore() -> Int {

        return 0
    }

    func ageThresholds(in gameModel: GameModel?) -> AgeThresholds {

        return AgeThresholds(lower: 0, upper: 0)
    }

    func estimateNextAge(in gameModel: GameModel?) -> AgeType {

        return .normal
    }

    func has(tech: TechType) -> Bool {

        return self.techs?.has(tech: tech) ?? false
    }

    func numberOfDiscoveredTechs() -> Int {
        <#code#>
    }

    func canEmbark() -> Bool {
        <#code#>
    }

    func canEnterOcean() -> Bool {
        <#code#>
    }

    func has(civic: CivicType) -> Bool {

        return self.civics?.has(civic: civic) ?? false
    }

    func addGovernorTitle() {

        return
    }

    func has(wonder: WonderType, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func city(with wonder: WonderType, in gameModel: GameModel?) -> AbstractCity? {
        <#code#>
    }

    func advisorMessages() -> [AdvisorMessage] {
        <#code#>
    }

    func militaryMight(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func economicMight(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func found(at location: HexPoint, named name: String?, in gameModel: GameModel?) {
        <#code#>
    }

    func newCityName(in gameModel: GameModel?) -> String {
        <#code#>
    }

    func registerBuild(cityName: String) {
        <#code#>
    }

    func cityStrengthModifier() -> Int {
        <#code#>
    }

    func acquire(city oldCity: AbstractCity?, conquest: Bool, gift: Bool, in gameModel: GameModel?) {
        <#code#>
    }

    func numOfCitiesFounded() -> Int {

        return 0
    }

    func numOfCitiesLost() -> Int {

        return 0
    }

    func capitalCity(in gameModel: GameModel?) -> AbstractCity? {
        <#code#>
    }

    func set(capitalCity newCapitalCity: AbstractCity?, in gameModel: GameModel?) {
        <#code#>
    }

    func science(in gameModel: GameModel?) -> Double {
        <#code#>
    }

    func scienceFromCities(in gameModel: GameModel?) -> Double {
        <#code#>
    }

    func culture(in gameModel: GameModel?) -> Double {
        <#code#>
    }

    func cultureFromCities(in gameModel: GameModel?) -> Double {
        <#code#>
    }

    func faith(in gameModel: GameModel?) -> Double {
        <#code#>
    }

    func faithFromCities(in gameModel: GameModel?) -> Double {
        <#code#>
    }

    func operationsOf(type: UnitOperationType) -> [Operation] {
        <#code#>
    }

    func hasOperationsOf(type: UnitOperationType) -> Bool {
        <#code#>
    }

    func delete(operation: Operation) {
        <#code#>
    }

    func numberOfOperationsOf(type: UnitOperationType) -> Int {
        <#code#>
    }

    func isCityAlreadyTargeted(city: AbstractCity?, via domain: UnitDomainType, percentToTarget: Int, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func addOperation(of type: UnitOperationType, towards otherPlayer: AbstractPlayer?, target targetCity: AbstractCity?, in area: HexArea?, muster musterCity: AbstractCity?, in gameModel: GameModel?) -> Operation {
        <#code#>
    }

    func bestSettleAreasWith(minimumSettleFertility minScore: Int, in gameModel: GameModel?) -> (Int, HexArea?, HexArea?) {
        <#code#>
    }

    func bestSettlePlot(for firstSettler: AbstractUnit?, in gameModel: GameModel?, escorted: Bool, area: HexArea?) -> AbstractTile? {
        <#code#>
    }

    func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func canBuild(build: BuildType, at point: HexPoint, testGold: Bool, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func updatePlots(in gameModel: GameModel?) {
        <#code#>
    }

    func plots() -> HexArea {
        <#code#>
    }

    func addPlot(at point: HexPoint) {
        <#code#>
    }

    func buyPlotCost() -> Int {
        <#code#>
    }

    func changeNumPlotsBought(change: Int) {
        <#code#>
    }

    func numAvailable(resource: ResourceType) -> Int {
        <#code#>
    }

    func changeNumAvailable(resource: ResourceType, change: Int) {
        <#code#>
    }

    func numStockpile(of resource: ResourceType) -> Int {
        <#code#>
    }

    func numMaxStockpile(of resource: ResourceType) -> Int {
        <#code#>
    }

    func canTrain(unitType: UnitType, continueFlag: Bool, testVisible: Bool, ignoreCost: Bool, ignoreUniqueUnitStatus: Bool) -> Bool {
        <#code#>
    }

    func canPurchaseInAnyCity(unit: UnitType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func numUnitsNeededToBeBuilt() -> Int {
        <#code#>
    }

    func countReadyUnits(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func hasUnitsThatNeedAIUpdate(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func countUnitsWith(defaultTask: UnitTaskType, in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func hasBusyUnitOrCity() -> Bool {
        <#code#>
    }

    func canPurchaseInAnyCity(building: BuildingType, with yieldType: YieldType, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func numberOfDistricts(of districtType: DistrictType, in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func faithPurchaseType() -> FaithPurchaseType {
        <#code#>
    }

    func set(faithPurchaseType: FaithPurchaseType) {
        <#code#>
    }

    func majorityOfCitiesFollows(religion: ReligionType, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func doFound(religion: ReligionType, at city: AbstractCity?, in gameModel: GameModel?) {
        <#code#>
    }

    func hasCapital(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func hasDiscoveredCapital(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func discoverCapital(of otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {
        <#code#>
    }

    func findNewCapital(in gameModel: GameModel?) {
        <#code#>
    }

    func changeImprovementCount(of improvement: ImprovementType, change: Int) {
        <#code#>
    }

    func changeTotalImprovementsBuilt(change: Int) {
        <#code#>
    }

    func changeCitiesLost(by delta: Int) {
        <#code#>
    }

    func bestRoute(at tile: AbstractTile?) -> RouteType {
        <#code#>
    }

    func reportCultureFromKills(at point: HexPoint, culture cultureVal: Int, wasBarbarian: Bool, in gameModel: GameModel?) {
        <#code#>
    }

    func reportGoldFromKills(at point: HexPoint, gold goldVal: Int, in gameModel: GameModel?) {
        <#code#>
    }

    func doGoodyHut(at tile: AbstractTile?, by unit: AbstractUnit?, in gameModel: GameModel?) {
        <#code#>
    }

    func doClearBarbarianCamp(at tile: AbstractTile?, in gameModel: GameModel?) {
        <#code#>
    }

    func score(for gameModel: GameModel?) -> Int {
        <#code#>
    }

    func notifications() -> Notifications? {
        <#code#>
    }

    func originalCapitalLocation() -> HexPoint {
        <#code#>
    }

    func isCramped() -> Bool {
        <#code#>
    }

    func canChangeGovernment() -> Bool {
        <#code#>
    }

    func set(canChangeGovernment: Bool) {
        <#code#>
    }

    func tradingCapacity(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func numberOfTradeRoutes() -> Int {
        <#code#>
    }

    func canEstablishTradeRoute(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func doEstablishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func canRecruitGreatPerson(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func recruit(greatPerson: GreatPerson, in gameModel: GameModel?) {
        <#code#>
    }

    func retire(greatPerson: GreatPerson) {
        <#code#>
    }

    func hasRetired(greatPerson: GreatPerson) -> Bool {
        <#code#>
    }

    func cityDistancePathLength(of point: HexPoint, in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func numCities(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func countCitiesFeatureSurrounded(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func scienceVictoryProgress(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func hasScienceVictory(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func hasCulturalVictory(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func hasReligiousVictory(in gameModel: GameModel?) -> Bool {
        <#code#>
    }

    func domesticTourists() -> Int {
        <#code#>
    }

    func visitingTourists(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func currentTourism(in gameModel: GameModel?) -> Double {
        <#code#>
    }

    func tourismModifier(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func addMoment(of type: MomentType, in gameModel: GameModel?) {
        <#code#>
    }

    func hasMoment(of type: MomentType) -> Bool {
        <#code#>
    }

    func moments() -> [Moment] {
        <#code#>
    }

    func hasDiscovered(naturalWonder: FeatureType) -> Bool {
        <#code#>
    }

    func doDiscover(naturalWonder: FeatureType) {
        <#code#>
    }

    func hasSettled(on continent: ContinentType) -> Bool {
        <#code#>
    }

    func markSettled(on continent: ContinentType) {
        <#code#>
    }

    func checkWorldCircumnavigated(in gameModel: GameModel?) {
        <#code#>
    }

    func hasWorldCircumnavigated() -> Bool {
        <#code#>
    }

    func set(worldCircumnavigated: Bool) {
        <#code#>
    }

    func hasEverEstablishedTradingPost(with leader: LeaderType) -> Bool {
        <#code#>
    }

    func markEstablishedTradingPost(with leader: LeaderType) {
        <#code#>
    }

    func numEverEstablishedTradingPosts(in gameModel: GameModel?) -> Int {
        <#code#>
    }

    func isEqual(to other: AbstractPlayer?) -> Bool {

        return self.leader == other?.leader
    }
}
