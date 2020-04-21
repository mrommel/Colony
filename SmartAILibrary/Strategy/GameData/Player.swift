//
//  Player.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class ResourceInventory: WeightedList<ResourceType> {
    
    override func fill() {
        
        for resourceType in ResourceType.all {
            self.add(weight: 0.0, for: resourceType)
        }
    }
}

class ImprovementCountList: WeightedList<TileImprovementType> {
    
    override func fill() {
        
        for improvementType in TileImprovementType.all {
            self.add(weight: 0.0, for: improvementType)
        }
    }
}

public protocol AbstractPlayer: class {

    var leader: LeaderType { get }
    var techs: AbstractTechs? { get }
    var civics: AbstractCivics? { get }
    var government: AbstractGovernment? { get }
    var treasury: AbstractTreasury? { get }
    var religion: AbstractReligion? { get }

    var grandStrategyAI: GrandStrategyAI? { get }
    var diplomacyAI: DiplomaticAI? { get }
    var economicAI: EconomicAI? { get }
    var militaryAI: MilitaryAI? { get }
    var tacticalAI: TacticalAI? { get }
    var dangerPlotsAI: DangerPlotsAI? { get }
    var builderTaskingAI: BuilderTaskingAI? { get }
    var citySpecializationAI: CitySpecializationAI? { get }
    var wonderProductionAI: WonderProductionAI? { get }
    
    var cityConnections: CityConnections? { get }
    
    var plots: [AbstractTile?] { get }

    func initialize()
    
    func hasActiveDiplomacyRequests() -> Bool
    func canFinishTurn() -> Bool
    func finishTurnButtonPressed() -> Bool // TODO: rename to finishedTurn
    func finishTurn()
    
    func hasProcessedAutoMoves() -> Bool
    func setProcessedAutoMoves(value: Bool)
    func isAutoMoves() -> Bool
    func setAutoMoves(value: Bool)

    func doFirstContact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func doDefensivePact(with otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    func isDefensivePactActive(with otherPlayer: AbstractPlayer?) -> Bool

    func valueOfPersonalityFlavor(of flavor: FlavorType) -> Int
    func valueOfStrategyAndPersonalityFlavor(of flavor: FlavorType) -> Int
    func valueOfStrategyAndPersonalityApproach(of approach: PlayerApproachType) -> Int
    func personalAndGrandStrategyFlavor(for flavorType: FlavorType) -> Int

    func hasGoldenAge() -> Bool
    
    func prepareTurn(in gamemModel: GameModel?)
    func startTurn(in gameModel: GameModel?)
    func endTurn(in gameModel: GameModel?)
    func unitUpdate(in gameModel: GameModel?)
    func lastSliceMoved() -> Int
    func setLastSliceMoved(to value: Int)
    
    func isAlive() -> Bool
    func isActive() -> Bool
    func isTurnActive() -> Bool
    func isHuman() -> Bool
    func isBarbarian() -> Bool

    // diplomatics
    func hasMet(with otherPlayer: AbstractPlayer?) -> Bool
    func atWarCount() -> Int
    func doUpdateProximity(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?)
    
    // notification
    func updateNotifications(in gameModel: GameModel?)
    func set(blockingNotification: NotificationItem?)
    func blockingNotification() -> NotificationItem?

    // era
    func currentEra() -> EraType
    func set(era: EraType)

    // tech
    func has(tech: TechType) -> Bool
    func numberOfDiscoveredTechs() -> Int
    func canEmbark() -> Bool

    // civic
    func has(civic: CivicType) -> Bool

    // advisors
    func advisorMessages() -> [AdvisorMessage]

    // ???
    func militaryMight(in gameModel: GameModel?) -> Int
    func economicMight(in gameModel: GameModel?) -> Int

    // city methods
    func found(at location: HexPoint, named name: String?, in gameModel: GameModel?)
    func newCityName(in gameModel: GameModel?) -> String
    func cityStrengthModifier() -> Int
    func acquire(city oldCity: AbstractCity?, conquest: Bool, gift: Bool)

    // operation methods
    func operationsOf(type: UnitOperationType) -> [Operation]
    func hasOperationsOf(type: UnitOperationType) -> Bool
    func numberOfOperationsOf(type: UnitOperationType) -> Int
    func addOperation(of type: UnitOperationType, towards otherPlayer: AbstractPlayer?, target city: AbstractCity?, in area: HexArea?, in gameModel: GameModel?)

    // misc
    func bestSettleAreasWith(minimumSettleFertility minScore: Int, in gameModel: GameModel?) -> (Int, HexArea?, HexArea?)
    func bestSettlePlot(for firstSettler: AbstractUnit?, in gameModel: GameModel?, escorted: Bool, area: HexArea?) -> AbstractTile?
    func canFound(at location: HexPoint, in gameModel: GameModel?) -> Bool
    func canBuild(build: BuildType, at point: HexPoint, testVisible: Bool, testGold: Bool, in gameModel: GameModel?) -> Bool
    
    func updatePlots(in gameModel: GameModel?)
    
    @discardableResult
    func addPlot(tile: AbstractTile?) -> Bool
    func buyPlotCost() -> Int
    func changeNumPlotsBought(change: Int)
    
    func numAvailable(resource: ResourceType) -> Int
    func changeNumAvailable(resource: ResourceType, change: Int)
    
    func numUnitsNeededToBeBuilt() -> Int
    func countReadyUnits(in gameModel: GameModel?) -> Int
    func hasUnitsThatNeedAIUpdate(in gameModel: GameModel?) -> Bool
    func hasBusyUnitOrCity() -> Bool
    
    func changeImprovementCount(of improvement: TileImprovementType, change: Int)
    func changeTotalImprovementsBuilt(change: Int)
    
    func reportCultureFromKills(at point: HexPoint, culture cultureVal: Int, wasBarbarian: Bool, in gameModel: GameModel?)
    func reportGoldFromKills(at point: HexPoint, gold goldVal: Int, in gameModel: GameModel?)
    
    func doGoodyHut(at tile: AbstractTile?, by unit: AbstractUnit?, in gameModel: GameModel?)
    
    func score(for gameModel: GameModel?) -> Int
    
    func notifications() -> Notifications?
    
    func isEqual(to other: AbstractPlayer?) -> Bool
}

public class Player: AbstractPlayer {

    public var leader: LeaderType
    //internal let relations: PlayerRelationDict
    internal var isAliveVal: Bool
    internal let isHumanVal: Bool

    public var grandStrategyAI: GrandStrategyAI?
    public var diplomacyAI: DiplomaticAI?
    public var economicAI: EconomicAI?
    public var militaryAI: MilitaryAI?
    public var tacticalAI: TacticalAI?
    public var dangerPlotsAI: DangerPlotsAI?
    internal var homelandAI: HomelandAI?
    public var builderTaskingAI: BuilderTaskingAI?
    public var citySpecializationAI: CitySpecializationAI?
    public var wonderProductionAI: WonderProductionAI?
    
    public var cityConnections: CityConnections?
    private var goodyHuts: GoodyHuts?

    public var techs: AbstractTechs?
    public var civics: AbstractCivics?
    public var religion: AbstractReligion?
    public var treasury: AbstractTreasury?

    public var government: AbstractGovernment? = nil
    internal var currentEraVal: EraType = .ancient

    internal var operations: Operations? = nil
    internal var armies: Armies? = nil
    
    public var plots: [AbstractTile?]
    internal var numPlotsBoughtValue: Int
    
    internal var resourceInventory: ResourceInventory?
    internal var improvementCountList: ImprovementCountList
    
    private var turnActive: Bool = false
    private var finishTurnButtonPressedValue: Bool = false
    private var processedAutoMovesValue: Bool = false
    private var autoMovesValue: Bool = false
    private var lastSliceMovedValue: Int = 0
    
    private var cultureEarned: Int = 0
    
    private var notificationsValue: Notifications?
    private var blockingNotificationValue: NotificationItem? = nil

    // MARK: constructor

    public init(leader: LeaderType, isHuman: Bool = false) {

        self.leader = leader
        //self.relations = PlayerRelationDict()
        self.isAliveVal = true
        self.isHumanVal = isHuman
        
        self.plots = []
        
        self.numPlotsBoughtValue = 0
        
        self.improvementCountList = ImprovementCountList()
        self.improvementCountList.fill()
    }

    // public methods

    public func initialize() {

        self.grandStrategyAI = GrandStrategyAI(player: self)
        self.diplomacyAI = DiplomaticAI(player: self)
        self.economicAI = EconomicAI(player: self)
        self.militaryAI = MilitaryAI(player: self)
        self.tacticalAI = TacticalAI(player: self)
        self.dangerPlotsAI = DangerPlotsAI(player: self)
        self.homelandAI = HomelandAI(player: self)
        self.builderTaskingAI = BuilderTaskingAI(player: self)
        self.citySpecializationAI = CitySpecializationAI(player: self)
        self.wonderProductionAI = WonderProductionAI(player: self)
        
        self.cityConnections = CityConnections(player: self)
        self.goodyHuts = GoodyHuts(player: self)

        self.techs = Techs(player: self)
        self.civics = Civics(player: self)
        self.religion = Religion(player: self)
        self.treasury = Treasury(player: self)

        self.government = Government()

        self.operations = Operations()
        self.notificationsValue = Notifications(player: self)
        
        self.resourceInventory = ResourceInventory()
        self.resourceInventory?.fill()
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
        
        /*if !self.hasProcessedAutoMoves() {
            return false
        }*/
        
        if self.blockingNotification() != nil {
            return false
        }
        
        return true
    }
    
    public func finishTurnButtonPressed() -> Bool {
        
        return self.finishTurnButtonPressedValue
    }
    
    public func finishTurn() {
        
        self.finishTurnButtonPressedValue = true
    }
    
    public func lastSliceMoved() -> Int {
        
        return self.lastSliceMovedValue
    }

    public func setLastSliceMoved(to value: Int) {
        
        self.lastSliceMovedValue = value
    }
    
    // MARK: ----

    public func valueOfPersonalityFlavor(of flavor: FlavorType) -> Int {

        return self.leader.flavor(for: flavor)
    }

    public func valueOfStrategyAndPersonalityFlavor(of flavor: FlavorType) -> Int {

        guard let activeStrategy = self.grandStrategyAI?.activeStrategy else {
            fatalError("cant get active strategy")
        }

        if activeStrategy == .none {
            return self.leader.flavor(for: flavor)
        }

        return self.leader.flavor(for: flavor) + activeStrategy.flavor(for: flavor)
    }

    public func valueOfStrategyAndPersonalityApproach(of approach: PlayerApproachType) -> Int {

        return self.leader.approachBias(for: approach)
    }
    
    public func isBarbarian() -> Bool {
        
        return self.leader == .barbar
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
        
        // update eureka
        if !techs.eurekaTriggered(for: .writing) {
            techs.triggerEureka(for: .writing)
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

    /// is player at war with a specific player/leader?
    func isAtWar(with otherPlayer: AbstractPlayer?) -> Bool {

        return self.diplomacyAI?.approach(towards: otherPlayer) == .war
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
    
    public func notifications() -> Notifications? {
        
        return self.notificationsValue
    }
    
    public func updateNotifications(in gameModel: GameModel?) {
        
        if let notifications = self.notifications() {
            notifications.update(in: gameModel)
        }

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
    
    public func doUpdateProximity(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?) {
        
        self.diplomacyAI?.updateProximity(to: otherPlayer, in: gameModel)
    }

    public func hasMet(with otherPlayer: AbstractPlayer?) -> Bool {

        guard let diplomacyAI = self.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        return diplomacyAI.hasMet(with: otherPlayer)
    }

    func isForcePeace(with otherPlayer: AbstractPlayer?) -> Bool {

        //return self.diplomacyAI?.
        return false
    }

    public func isAlive() -> Bool {

        return self.isAliveVal
    }
    
    public func isActive() -> Bool {
        
        return self.turnActive
    }

    public func isHuman() -> Bool {

        return self.isHumanVal
    }
    
    public func hasGoldenAge() -> Bool {
        
        return false
    }
    
    func hasActiveDiploRequestWithHuman() -> Bool {
        
        return false
    }
    
    public func isTurnActive() -> Bool {
        
        return self.turnActive
    }
    
    public func prepareTurn(in gamemModel: GameModel?) {
        
        // Barbarians get all Techs that 3/4 of alive players get
        if isBarbarian() {
            // self.doBarbarianTech()
        } else {
            // War counter
            /*TeamTypes eTeam;
            int iTeamLoop;
            for (iTeamLoop = 0; iTeamLoop < MAX_CIV_TEAMS; iTeamLoop++)
            {
                eTeam = (TeamTypes) iTeamLoop;

                if (!GET_TEAM(eTeam).isBarbarian())
                {
                    if (isAtWar(eTeam))
                        ChangeNumTurnsAtWar(eTeam, 1);
                    else
                        SetNumTurnsAtWar(eTeam, 0);
                }

                if (GetNumTurnsLockedIntoWar(eTeam) > 0)
                    ChangeNumTurnsLockedIntoWar(eTeam, -1);
            }*/
        }

        /*for (iI = 0; iI < GC.getNumTechInfos(); iI++)  {
            GetTeamTechs()->SetNoTradeTech(((TechTypes)iI), false);
        }

        DoTestWarmongerReminder();

        DoTestSmallAwards();

        testCircumnavigated();*/
    }
    
    public func startTurn(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard isTurnActive() == false else {
            fatalError("try to start already active turn")
        }
            
        print("--- start turn for \(self.isHuman() ? "HUMAN": "AI") player \(self.leader) ---")

        self.turnActive = true
        //self.setTurnEnd(false)
        self.setAutoMoves(value: false)
        self.finishTurnButtonPressedValue = false
        
        /////////////////////////////////////////////
        // TURN IS BEGINNING
        /////////////////////////////////////////////
        
        // self.doUnitAttrition()
        
        self.setAllUnitsUnprocessed(in: gameModel)

        gameModel.updateTacticalAnalysisMap(for: self)

        //
        //
        self.updateTimers(in: gameModel)
        //self.diplomacyAI?.update(in: gameModel) // extracted from updateTimers
        
        // This block all has things which might change based on city connections changing
        self.cityConnections?.turn(with: gameModel)
        //self.treasury.doUpdateCityConnectionGold()
        //self.doUpdateHappiness()
        self.builderTaskingAI?.update(in: gameModel)
        
        if gameModel.turnsElapsed > 0 {
            
            if self.isAlive() {
                /*if (GetDiplomacyRequests())
                {
                    GetDiplomacyRequests()->BeginTurn();
                }*/

                self.doTurn(in: gameModel)

                self.doTurnUnits(in: gameModel)
            }
        }
        
        // self.doWarnings()
    }
    
    public func endTurn(in gameModel: GameModel?) {
        
        guard isTurnActive() == true else {
            fatalError("try to end an inactive turn")
        }
        
        print("--- end turn for \(self.isHuman() ? "HUMAN": "AI") player \(self.leader) ---")
        
        self.turnActive = false
        
        /////////////////////////////////////////////
        // TURN IS ENDING
        /////////////////////////////////////////////
        
        self.doUnitReset(in: gameModel)

        if !self.isHuman() {
            //self.respositionInvalidUnits()
        }

        /*if (GetNotifications())
        {
            GetNotifications()->EndOfTurnCleanup();
        }*/

        /*if (GetDiplomacyRequests())
        {
            GetDiplomacyRequests()->EndTurn();
        }*/
    }

    internal func doTurn(in gameModel: GameModel?) {

        var hasActiveDiploRequest = false
        if self.isAlive() {

            if !self.isBarbarian() {

                self.grandStrategyAI?.turn(with: gameModel)
                
                // Do diplomacy for toward everyone
                self.diplomacyAI?.turn(in: gameModel)
                
                if !self.isHuman() {
                    hasActiveDiploRequest = self.hasActiveDiploRequestWithHuman()
                }
            }
        }
        
        if hasActiveDiploRequest {
            
        } else {
            self.doTurnPostDiplomacy(in: gameModel)
        }
    }
    
    private func doTurnPostDiplomacy(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gamemodel")
        }
        
        if self.isAlive() {
            if !self.isBarbarian() {
                self.economicAI?.turn(in: gameModel)
                self.militaryAI?.turn(in: gameModel)
                self.citySpecializationAI?.turn(in: gameModel)
            }
        }

        // Attack bonus turns
        /*if GetAttackBonusTurns() > 0 {
            ChangeAttackBonusTurns(-1);
        }*/

        // Golden Age
        // self.doProcessGoldenAge();

        // Great People gifts from Allied City States (if we have that policy)
        // self.doGreatPeopleSpawnTurn();

        // Do turn for all Cities
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                fatalError("cant get city")
            }
            
            city.turn(in: gameModel)
        }

        // Gold GetTreasury()->DoGold();
        self.treasury?.turn(in: gameModel)
        
        // Culture / Civics
        self.doCivics(in: gameModel)
        
        // Science / Techs
        self.doTechs(in: gameModel) // doResearch

        // Anarchy counter
        //if (GetAnarchyNumTurns() > 0)
        //    ChangeAnarchyNumTurns(-1);

        // DoIncomingUnits();

        //const int iGameTurn = kGame.getGameTurn();
        //GatherPerTurnReplayStats(iGameTurn);

        // GC.GetEngineUserInterface()->setDirty(CityInfo_DIRTY_BIT, true);

        self.doTurnPost()
    }
    
    func doCivics(in gameModel: GameModel?) {
        
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
    
    // GetScienceTimes100()
    func science(in gameModel: GameModel?) -> Double {
        
        var value = 0.0

        // Science from our Cities
        value += self.scienceFromCities(in: gameModel)

        // Science from other players!
        // value += GetScienceFromOtherPlayersTimes100();

        // Happiness converted to Science? (Policies, etc.)
        // value += GetScienceFromHappinessTimes100();

        // Research Agreement bonuses
        // value += GetScienceFromResearchAgreementsTimes100();

        // If we have a negative Treasury + GPT then it gets removed from Science
        // value += GetScienceFromBudgetDeficitTimes100();

        return max(value, 0)
    }
    
    private func scienceFromCities(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var scienceVal = 0.0
        
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                continue
            }
            
            scienceVal += city.sciencePerTurn(in: gameModel)
        }
        
        return scienceVal
    }
    
    func culture(in gameModel: GameModel?) -> Double {
        
        var value = 0.0

        // culture from our Cities
        value += self.cultureFromCities(in: gameModel)
        
        // ....
        
        return value
    }
    
    private func cultureFromCities(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var cultureVal = 0.0
        
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                continue
            }
            
            cultureVal += city.culturePerTurn(in: gameModel)
        }
        
        return cultureVal
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

        //ProcessGreatPeople();
    }
    
    public func unitUpdate(in gameModel: GameModel?) {
        
        // Now its the homeland AI's turn.
        if self.isHuman() {
            // The homeland AI goes first.
            self.homelandAI?.findAutomatedUnits(in: gameModel)
            self.homelandAI?.turn(in: gameModel)
        } else {

            // Update tactical AI
            self.tacticalAI?.commandeerUnits(in: gameModel)
            
            // Now let the tactical AI run.  Putting it after the operations update allows units who have
            // just been handed off to the tactical AI to get a move in the same turn they switch between
            // AI subsystems
            self.tacticalAI?.turn(in: gameModel)
            
            // Skip homeland AI processing if a barbarian
            if !self.isBarbarian() {
                // Now its the homeland AI's turn.
                self.homelandAI?.recruitUnits(in: gameModel)
                self.homelandAI?.turn(in: gameModel)
            }
        }
    }
    
    func doTurnUnits(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // doTurnUnitsPre(); // AI_doTurnUnitsPre

        // Start: TACTICAL AI UNIT PROCESSING
        self.tacticalAI?.turn(in: gameModel)
        
        // Start: OPERATIONAL AI UNIT PROCESSING
        self.operations?.doDelayedDeath()
        self.armies?.doDelayedDeath()
        
        for unitRef in gameModel.units(of: self) {
            unitRef?.doDelayedDeath(in: gameModel)
        }
        
        self.operations?.turn(in: gameModel)
        
        self.operations?.doDelayedDeath()
        
        self.armies?.turn(in: gameModel)
        
        // Homeland AI
        // self.homelandAI?.turn(in: gameModel) is empty
        
        // Start: old unit AI processing
        for pass in 0..<4 {
            
            for loopUnitRef in gameModel.units(of: self) {
                
                guard let loopUnit = loopUnitRef else {
                    continue
                }
                
                switch loopUnit.domain() {
                case .air:
                    if pass == 1 {
                        loopUnit.turn(in: gameModel)
                    }
                case .sea:
                    if pass == 2 {
                        loopUnit.turn(in: gameModel)
                    }
                case .land:
                    if pass == 3 {
                        loopUnit.turn(in: gameModel)
                    }
                case .immobile:
                    if pass == 0 {
                        loopUnit.turn(in: gameModel)
                    }
                case .none:
                    fatalError("Unit with no Domain")
                default:
                    if pass == 3 {
                        loopUnit.turn(in: gameModel)
                    }
                }
            }
        }

        /*if (GetID() == GC.getGame().getActivePlayer())
        {
            GC.GetEngineUserInterface()->setDirty(Waypoints_DIRTY_BIT, true);
            GC.GetEngineUserInterface()->setDirty(SelectionButtons_DIRTY_BIT, true);
        }*/

        //GC.GetEngineUserInterface()->setDirty(UnitInfo_DIRTY_BIT, true);

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
            
            //loopUnit.promot
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

            //int iCitadelDamage;
            /*if (pLoopUnit->IsNearEnemyCitadel(iCitadelDamage))
            {
                pLoopUnit->changeDamage(iCitadelDamage, NO_PLAYER, /*fAdditionalTextDelay*/ 0.5f);
            }*/

            // Finally (now that healing is done), restore movement points
            loopUnit.resetMoves(in: gameModel)
            //pLoopUnit->SetIgnoreDangerWakeup(false);
            //pLoopUnit->setMadeAttack(false);
            //pLoopUnit->setMadeInterception(false);

            if !self.isHuman() {
                
                if let mission = loopUnit.peekMission() {
                    if mission.type == .rangedAttack {
                        //CvAssertMsg(0, "An AI unit has a combat mission queued at the end of its turn.");
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
    
    func updateTimers(in gameModel: GameModel?) {
        
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

    }

    public func score(for gameModel: GameModel?) -> Int {

        if !self.isAliveVal {
            // no need to update, the player died
            return 0
        }

        var scoreVal = 0

        scoreVal += self.scoreFromCities(for: gameModel)
        scoreVal += self.scoreFromPopulation(for: gameModel)
        scoreVal += self.scoreFromLand(for: gameModel)
        scoreVal += self.scoreFromWonder(for: gameModel)
        scoreVal += self.scoreFromTech(for: gameModel)

        return scoreVal
    }

    private func scoreFromCities(for gameModel: GameModel?) -> Int {

        if let cities = gameModel?.cities(of: self),
            let mapSizeModifier = gameModel?.mapSizeModifier() {

            var score = cities.count * 10

            // weight with map size
            score *= 100
            score /= mapSizeModifier

            return score
        }

        return 0
    }

    private func scoreFromPopulation(for gameModel: GameModel?) -> Int {

        if let cities = gameModel?.cities(of: self),
            let mapSizeModifier = gameModel?.mapSizeModifier() {

            var score = 0

            for cityRef in cities {
                if let city = cityRef {
                    score += city.population() * 4
                }
            }

            // weight with map size
            score *= 100
            score /= mapSizeModifier

            return score
        }

        return 0
    }

    private func scoreFromLand(for gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var score = self.plots.count * 1 /*SCORE_LAND_MULTIPLIER */

        // weight with map size
        let mapSizeModifier = gameModel.mapSizeModifier()
        score *= 100
        score /= mapSizeModifier

        return score
    }
    
    // Score from world wonders: 40 per
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
        
        let score = number * 40 /* SCORE_WONDER_MULTIPLIER */
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

    public func personalAndGrandStrategyFlavor(for flavorType: FlavorType) -> Int {

        guard let grandStrategyAI = self.grandStrategyAI else {
            fatalError("grandStrategyAI not initialized")
        }

        if grandStrategyAI.activeStrategy == .none {
            return self.leader.flavor(for: flavorType)
        }

        let value = self.leader.flavor(for: flavorType) + grandStrategyAI.activeStrategy.flavorModifier(for: flavorType)

        if value < 0 {
            return 0
        }

        return value
    }

    public func currentEra() -> EraType {

        return self.currentEraVal
    }

    public func set(era: EraType) {

        // FIXME: should not be older era
        
        self.currentEraVal = era
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

        return self.has(tech: .sailing)
    }

    public func has(civic civicType: CivicType) -> Bool {

        if let civics = self.civics {
            return civics.has(civic: civicType)
        }

        return false
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

        //Simplistic increase based on player's gold
        //500 gold will increase might by 22%, 2000 by 45%, 8000 gold by 90%
        var goldMultiplier = 1.0 + sqrt(self.treasury!.value()) / 100.0
        if goldMultiplier > 2.0 { goldMultiplier = 2.0 }

        might = might * goldMultiplier

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
        
        guard let techs = self.techs else {
            fatalError("cant get techs")
        }
        
        guard let civics = self.civics else {
            fatalError("cant get civics")
        }
        
        let cityName = name ?? self.newCityName(in: gameModel)
        let isCapital = gameModel.cities(of: self).count == 0
        
        let city = City(name: cityName, at: location, capital: isCapital, owner: self)
        city.initialize(in: gameModel)
        
        gameModel.add(city: city)
        
        if self.isHuman() {
            
            // Human player is prompted to choose production BEFORE the AI runs for the turn.
            // So we'll force the AI strategies on the city now, just after it is founded.
            // And if the very first turn, we haven't even run player strategies once yet, so do that too.
            if gameModel.turnsElapsed == 0 {
                self.economicAI?.turn(in: gameModel)
                self.militaryAI?.turn(in: gameModel)
            }
            
            city.cityStrategy?.turn(with: gameModel)
            
            if self.isActive() {
                let isOrAre = self.leader.civilization().isPlural() ? "are" : "is"
                let message = "\(self.leader.civilization()) \(isOrAre) ready for a new construction project."
                self.notifications()?.add(type: .production, for: self, message: message, summary: message, at: location)
            }
            
            city.doFoundMessage()

            // If this is the first city (or we still aren't getting tech for some other reason) notify the player
            if techs.needToChooseTech() && self.science(in: gameModel) > 0.0 {
                
                if self.isActive() {
                    self.notifications()?.add(type: .tech, for: self, message: "You may select a new research project.", summary: "Choose Research", at: HexPoint.zero)
                }
            }
            
            // If this is the first city (or ..) notify the player
            if civics.needToChooseCivic() && self.culture(in: gameModel) > 0.0 {
                
                if self.isActive() {
                    self.notifications()?.add(type: .civic, for: self, message: "You may select a new civic project.", summary: "Choose Civic", at: HexPoint.zero)
                }
            }
            
        } else {
            city.doFoundMessage()

            // AI civ, may need to redo city specializations
            self.citySpecializationAI?.setSpecializationsDirty()
        }
    }
    
    public func newCityName(in gameModel: GameModel?) -> String {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var possibleNames = self.leader.civilization().cityNames()
        
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                continue
            }
            
            possibleNames.removeAll(where: { $0 == city.name })
        }
        
        if let firstName = possibleNames.first {
            return firstName
        }
        
        return "TXT_KEY_CITY"
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

        return operations.operationsOf(type: type).count > 0
    }

    public func numberOfOperationsOf(type: UnitOperationType) -> Int {

        guard let operations = self.operations else {
            fatalError("cant get operations")
        }

        return operations.operationsOf(type: type).count
    }

    public func addOperation(of type: UnitOperationType, towards otherPlayer: AbstractPlayer?, target city: AbstractCity?, in area: HexArea?, in gameModel: GameModel?) {

        switch type {

        case .foundCity:
            let operation = FoundCityOperation(in: area)
            operation.initialize(for: self, enemy: otherPlayer, area: area, target: city, in: gameModel)
            self.operations?.add(operation: operation)
        case .cityCloseDefense:
            fatalError("not implemented yet")
            break
        case .basicCityAttack:
            fatalError("not implemented yet")
            break
        case .pillageEnemy:
            fatalError("not implemented yet")
            break
        case .rapidResponse:
            fatalError("not implemented yet")
            break
        case .destroyBarbarianCamp:
            fatalError("not implemented yet")
            break
        case .navalAttack:
            fatalError("not implemented yet")
            break
        case .navalSuperiority:
            fatalError("not implemented yet")
            break
        case .navalBombard:
            fatalError("not implemented yet")
            break
        case .colonize:
            fatalError("not implemented yet")
            break
        case .notSoQuickColonize:
            fatalError("not implemented yet")
            break
        case .sneackAttack:
            fatalError("not implemented yet")
            break
        case .basicAttack:
            fatalError("not implemented yet")
            break
        case .showOfForce:
            fatalError("not implemented yet")
            break
        }

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
        var bestFoundPlot: AbstractTile? = nil

        var evalDistance = 12 /*SETTLER_EVALUATION_DISTANCE */
        let distanceDropoffMod = 99 /*SETTLER_DISTANCE_DROPOFF_MODIFIER */

        evalDistance += (gameModel.turnsElapsed * 5) / 100

        // scale this based on world size
        let defaultNumTiles = MapSize.standard.numberOfTiles()
        let defaultEvalDistance = evalDistance
        evalDistance = (evalDistance * gameModel.mapSize().numberOfTiles()) / defaultNumTiles
        evalDistance = max(defaultEvalDistance, evalDistance)

        if (escorted /* && GC.getMap().GetAIMapHint() & 1*/) //  is this primarily a naval map
        {
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
    public func canBuild(build: BuildType, at point: HexPoint, testVisible: Bool, testGold: Bool, in gameModel: GameModel?) -> Bool {
        
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
            // NOOP
        }

        if !testVisible {
            
            // IsBuildBlockedByFeature
            if tile.hasAnyFeature() {
                
                for feature in FeatureType.all {
                    
                    if tile.has(feature: feature) {
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
        var bestArea: HexArea? = nil
        var secondBestScore = -1
        var secondBestArea: HexArea? = nil

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

        // FIXME: check cost

        return true
    }
    
    func bestRoute(at tile: AbstractTile? = nil) -> RouteType {
        
        for buildType in BuildType.all {
            
            if let routeType = buildType.route() {
                if self.canBuild(buildType: buildType, at: tile) {
                    return routeType
                }
            }
        }
        
        return .none
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

        let pathfinder = AStarPathfinder()
        pathfinder.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: .walk, for: self)
        
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
        self.plots = []
        
        let mapSize = gameModel.mapSize()
        self.plots.reserveCapacity(mapSize.numberOfTiles())
        
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                
                if let tile = gameModel.tile(at: HexPoint(x: x, y: y)) {

                    if self.isEqual(to: tile.owner()) {
                        self.plots.append(tile)
                    }
                }
            }
        }
    }
    
    @discardableResult
    public func addPlot(tile: AbstractTile?) -> Bool {
        
        if self.isEqual(to: tile?.owner()) {
            self.plots.append(tile)
            return true
        }
        
        return false
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
    
    public func numAvailable(resource: ResourceType) -> Int {
        
        if let resourceInventory = self.resourceInventory {
            return Int(resourceInventory.weight(of: resource))
        }
        
        return 0
    }
    
    public func changeNumAvailable(resource: ResourceType, change: Int) {
        
        guard let resourceInventory = self.resourceInventory else {
            fatalError("cant get resourceInventory")
        }
        
        resourceInventory.add(weight: change, for: resource)
    }
    
    public func numUnitsNeededToBeBuilt() -> Int {

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
            
            if !loopUnit.processedInTurn() && (loopUnit.isAutomated() && loopUnit.task != .unknown && loopUnit.canMove()) {
                return true
            }
        }

        return false
    }
    
    public func hasBusyUnitOrCity() -> Bool {
        
        // FIXME
        return false
    }
    
    public func isAutoMoves() -> Bool {
        
        return self.autoMovesValue
    }
    
    public func setAutoMoves(value: Bool) {
        
        if self.autoMovesValue != value {
            self.autoMovesValue = value
            self.processedAutoMovesValue = false
        }
    }
    
    public func hasProcessedAutoMoves() -> Bool {
        
        return self.processedAutoMovesValue
    }
    
    public func setProcessedAutoMoves(value: Bool) {
        
        self.processedAutoMovesValue = value
    }
    
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
    
    // buildings + policies
    func specialistExtraYield(for specialistType: SpecialistType, and yieldType: YieldType) -> Int {
        
        return 0
    }
    
    public func changeImprovementCount(of improvement: TileImprovementType, change: Int) {
        
        self.improvementCountList.add(weight: change, for: improvement)
    }
    
    public func changeTotalImprovementsBuilt(change: Int) {
        
        fatalError("niy")
    }
    
    public func isEqual(to other: AbstractPlayer?) -> Bool {
        
        return self.leader == other?.leader
    }
    
    public func acquire(city oldCity: AbstractCity?, conquest: Bool, gift: Bool) {
        
        guard let oldCity = oldCity else {
            fatalError("cant get oldCity")
        }

        fatalError("niy")
        
        /*IDInfo* pUnitNode;
        CvCity* pNewCity;
        CvUnit* pLoopUnit;
        CvPlot* pCityPlot;

        CvString strBuffer;
        CvString strName;
        bool abEverOwned[MAX_PLAYERS];
        PlayerTypes eOldOwner;
        PlayerTypes eOriginalOwner;
        BuildingTypes eBuilding;
        bool bRecapture;
        int iCaptureGold;
        int iGameTurnFounded;
        int iPopulation;
        int iHighestPopulation;
        int iBattleDamage;
        int iI;
        FFastSmallFixedList<IDInfo, 25, true, c_eCiv5GameplayDLL > oldUnits;

        pCityPlot = pOldCity->plot();

        pUnitNode = pCityPlot->headUnitNode();

        while (pUnitNode != NULL)
        {
            oldUnits.insertAtEnd(pUnitNode);
            pUnitNode = pCityPlot->nextUnitNode((IDInfo*)pUnitNode);
        }

        pUnitNode = oldUnits.head();

        while (pUnitNode != NULL)
        {
            pLoopUnit = ::getUnit(*pUnitNode);
            pUnitNode = oldUnits.next(pUnitNode);

            if (pLoopUnit && pLoopUnit->getTeam() != getTeam())
            {
                if (pLoopUnit->IsImmobile())
                {
                    pLoopUnit->kill(false, GetID());
                    DoUnitKilledCombat(pLoopUnit->getOwner(), pLoopUnit->getUnitType());
                }
            }
        }

        if (bConquest)
        {
            CvNotifications* pNotifications = GET_PLAYER(pOldCity->getOwner()).GetNotifications();
            if (pNotifications)
            {
                Localization::String locString = Localization::Lookup("TXT_KEY_NOTIFICATION_CITY_LOST");
                locString << pOldCity->getNameKey() << getNameKey();
                Localization::String locSummary = Localization::Lookup("TXT_KEY_NOTIFICATION_SUMMARY_CITY_LOST");
                locSummary << pOldCity->getNameKey();
                pNotifications->Add(NOTIFICATION_CITY_LOST, locString.toUTF8(), locSummary.toUTF8(), pOldCity->getX(), pOldCity->getY(), -1);
            }

            if (!isBarbarian() && !pOldCity->isBarbarian())
            {
                int iDefaultCityValue = 150 /* WAR_DAMAGE_LEVEL_CITY_WEIGHT */

                // Notify Diplo AI that damage has been done
                int iValue = iDefaultCityValue;
                iValue += pOldCity->getPopulation() * /*100*/ GC.getWAR_DAMAGE_LEVEL_INVOLVED_CITY_POP_MULTIPLIER();
                // My viewpoint
                GetDiplomacyAI()->ChangeOtherPlayerWarValueLost(pOldCity->getOwner(), GetID(), iValue);
                // Bad guy's viewpoint
                GET_PLAYER(pOldCity->getOwner()).GetDiplomacyAI()->ChangeWarValueLost(GetID(), iValue);

                PlayerTypes ePlayer;

                iValue = iDefaultCityValue;
                iValue += pOldCity->getPopulation() * /*120*/ GC.getWAR_DAMAGE_LEVEL_UNINVOLVED_CITY_POP_MULTIPLIER();

                // Now update everyone else in the world, but use a different multiplier (since they don't have complete info on the situation - they don't know when Units are killed)
                for (int iPlayerLoop = 0; iPlayerLoop < MAX_CIV_PLAYERS; iPlayerLoop++)
                {
                    ePlayer = (PlayerTypes) iPlayerLoop;

                    // Not us and not the player we acquired City from
                    if (ePlayer != GetID() && ePlayer != pOldCity->getOwner())
                    {
                        GET_PLAYER(ePlayer).GetDiplomacyAI()->ChangeOtherPlayerWarValueLost(pOldCity->getOwner(), GetID(), iValue);
                    }
                }
            }
        }

        if (pOldCity->getOriginalOwner() == pOldCity->getOwner())
        {
            GET_PLAYER(pOldCity->getOriginalOwner()).changeCitiesLost(1);
        }
        else if (pOldCity->getOriginalOwner() == GetID())
        {
            GET_PLAYER(pOldCity->getOriginalOwner()).changeCitiesLost(-1);
        }

        if (bConquest)
        {
            if (GetID() == GC.getGame().getActivePlayer())
            {
                strBuffer = GetLocalizedText("TXT_KEY_MISC_CAPTURED_CITY", pOldCity->getNameKey()).GetCString();
                GC.GetEngineUserInterface()->AddCityMessage(0, pOldCity->GetIDInfo(), GetID(), true, GC.getEVENT_MESSAGE_TIME(), strBuffer/*, "AS2D_CITYCAPTURE", MESSAGE_TYPE_MAJOR_EVENT, NULL, (ColorTypes)GC.getInfoTypeForString("COLOR_GREEN"), pOldCity->getX(), pOldCity->getY(), true, true*/);
            }

            strName.Format("%s (%s)", pOldCity->getName().GetCString(), GET_PLAYER(pOldCity->getOwner()).getName());

            for (iI = 0; iI < MAX_PLAYERS; iI++)
            {
                if ((PlayerTypes)iI == GC.getGame().getActivePlayer())
                {
                    if (GET_PLAYER((PlayerTypes)iI).isAlive())
                    {
                        if (iI != GetID())
                        {
                            if (pOldCity->isRevealed(GET_PLAYER((PlayerTypes)iI).getTeam(), false))
                            {
                                strBuffer = GetLocalizedText("TXT_KEY_MISC_CITY_CAPTURED_BY", strName.GetCString(), getCivilizationShortDescriptionKey());
                                GC.GetEngineUserInterface()->AddCityMessage(0, pOldCity->GetIDInfo(), ((PlayerTypes)iI), false, GC.getEVENT_MESSAGE_TIME(), strBuffer/*, "AS2D_CITYCAPTURED", MESSAGE_TYPE_MAJOR_EVENT, NULL, (ColorTypes)GC.getInfoTypeForString("COLOR_RED"), pOldCity->getX(), pOldCity->getY(), true, true*/);
                            }
                        }
                    }
                }
            }

            strBuffer = GetLocalizedText("TXT_KEY_MISC_CITY_WAS_CAPTURED_BY", strName.GetCString(), getCivilizationShortDescriptionKey());
            GC.getGame().addReplayMessage(REPLAY_MESSAGE_MAJOR_EVENT, GetID(), strBuffer, pOldCity->getX(), pOldCity->getY());

    #ifndef FINAL_RELEASE
            OutputDebugString("\n"); OutputDebugString(strBuffer); OutputDebugString("\n\n");
    #endif
        }

        iCaptureGold = 0;

        if (bConquest)
        {
            // TODO: add scripting support for "doCityCaptureGold"
            iCaptureGold = 0;

            iCaptureGold += GC.getBASE_CAPTURE_GOLD();
            iCaptureGold += (pOldCity->getPopulation() * GC.getCAPTURE_GOLD_PER_POPULATION());
            iCaptureGold += GC.getGame().getJonRandNum(GC.getCAPTURE_GOLD_RAND1(), "Capture Gold 1");
            iCaptureGold += GC.getGame().getJonRandNum(GC.getCAPTURE_GOLD_RAND2(), "Capture Gold 2");

            if (GC.getCAPTURE_GOLD_MAX_TURNS() > 0)
            {
                iCaptureGold *= range((GC.getGame().getGameTurn() - pOldCity->getGameTurnAcquired()), 0, GC.getCAPTURE_GOLD_MAX_TURNS());
                iCaptureGold /= GC.getCAPTURE_GOLD_MAX_TURNS();
            }

            iCaptureGold *= (100 + pOldCity->getCapturePlunderModifier()) / 100;
            iCaptureGold *= (100 + GetPlayerTraits()->GetPlunderModifier()) / 100;
        }

        GetTreasury()->ChangeGold(iCaptureGold);

        int iNumBuildingInfos = GC.getNumBuildingInfos();
        std::vector<int> paiNumRealBuilding(iNumBuildingInfos, 0);
        std::vector<int> paiBuildingOriginalOwner(iNumBuildingInfos, 0);
        std::vector<int> paiBuildingOriginalTime(iNumBuildingInfos, 0);

        int iOldCityX = pOldCity->getX();
        int iOldCityY = pOldCity->getY();
        eOldOwner = pOldCity->getOwner();
        eOriginalOwner = pOldCity->getOriginalOwner();
        iGameTurnFounded = pOldCity->getGameTurnFounded();
        iPopulation = pOldCity->getPopulation();
        iHighestPopulation = pOldCity->getHighestPopulation();
        bool bEverCapital = pOldCity->IsEverCapital();
        strName = pOldCity->getNameKey();
        int iOldCultureLevel = pOldCity->GetJONSCultureLevel();
        bool bHasMadeAttack = pOldCity->isMadeAttack();

        iBattleDamage = pOldCity->getDamage();
        // Traded cities between humans don't heal (an exploit would be to trade a city back and forth between teammates to get an instant heal.)
        if (!bGift || !isHuman() || !GET_PLAYER(pOldCity->getOwner()).isHuman())
        {
            int iBattleDamgeThreshold = GC.getMAX_CITY_HIT_POINTS() * /*50*/ GC.getCITY_CAPTURE_DAMAGE_PERCENT();
            iBattleDamgeThreshold /= 100;

            if (iBattleDamage > iBattleDamgeThreshold)
            {
                iBattleDamage = iBattleDamgeThreshold;
            }
        }

        for (iI = 0; iI < MAX_PLAYERS; iI++)
        {
            abEverOwned[iI] = pOldCity->isEverOwned((PlayerTypes)iI);
        }

        abEverOwned[GetID()] = true;

        for (iI = 0; iI < GC.getNumBuildingInfos(); iI++)
        {
            paiNumRealBuilding[iI] = pOldCity->GetCityBuildings()->GetNumRealBuilding((BuildingTypes)iI);
            paiBuildingOriginalOwner[iI] = pOldCity->GetCityBuildings()->GetBuildingOriginalOwner((BuildingTypes)iI);
            paiBuildingOriginalTime[iI] = pOldCity->GetCityBuildings()->GetBuildingOriginalTime((BuildingTypes)iI);
        }

        std::vector<BuildingYieldChange> aBuildingYieldChange;
        for (iI = 0; iI < GC.getNumBuildingClassInfos(); ++iI)
        {
            CvBuildingClassInfo* pkBuildingClassInfo = GC.getBuildingClassInfo((BuildingClassTypes)iI);
            if (!pkBuildingClassInfo)
            {
                continue;
            }

            for (int iYield = 0; iYield < NUM_YIELD_TYPES; ++iYield)
            {
                BuildingYieldChange kChange;
                kChange.eBuildingClass = (BuildingClassTypes)iI;
                kChange.eYield = (YieldTypes)iYield;
                kChange.iChange = pOldCity->GetCityBuildings()->GetBuildingYieldChange((BuildingClassTypes)iI, (YieldTypes)iYield);
                if (0 != kChange.iChange)
                {
                    aBuildingYieldChange.push_back(kChange);
                }
            }
        }

        bRecapture = false;

        bool bCapital = pOldCity->isCapital();

        // find the plot
        FStaticVector<int, 121, true, c_eCiv5GameplayDLL, 0> aiPurchasedPlotX;
        FStaticVector<int, 121, true, c_eCiv5GameplayDLL, 0> aiPurchasedPlotY;
        const int iMaxRange = /*5*/ GC.getMAXIMUM_ACQUIRE_PLOT_DISTANCE();

        for (int iPlotLoop = 0; iPlotLoop < GC.getMap().numPlots(); iPlotLoop++)
        {
            CvPlot* pLoopPlot = GC.getMap().plotByIndexUnchecked(iPlotLoop);
            if (pLoopPlot && pLoopPlot->GetCityPurchaseOwner() == eOldOwner && pLoopPlot->GetCityPurchaseID() == pOldCity->GetID())
            {
                aiPurchasedPlotX.push_back(pLoopPlot->getX());
                aiPurchasedPlotY.push_back(pLoopPlot->getY());
                pLoopPlot->ClearCityPurchaseInfo();
            }
        }

        pOldCity->PreKill();

        {
            auto_ptr<ICvCity1> pkDllOldCity(new CvDllCity(pOldCity));
            gDLL->GameplayCityCaptured(pkDllOldCity.get(), GetID());
        }

        GET_PLAYER(eOldOwner).deleteCity(pOldCity->GetID());
        // adapted from PostKill()

        GC.getGame().addReplayMessage( REPLAY_MESSAGE_CITY_CAPTURED, m_eID, "", pCityPlot->getX(), pCityPlot->getY());

        PlayerTypes ePlayer;
        // Update Proximity between this Player and all others
        for (int iPlayerLoop = 0; iPlayerLoop < MAX_CIV_PLAYERS; iPlayerLoop++)
        {
            ePlayer = (PlayerTypes) iPlayerLoop;

            if (ePlayer != m_eID)
            {
                if (GET_PLAYER(ePlayer).isAlive())
                {
                    GET_PLAYER(m_eID).DoUpdateProximityToPlayer(ePlayer);
                    GET_PLAYER(ePlayer).DoUpdateProximityToPlayer(m_eID);
                }
            }
        }

        GC.getMap().updateWorkingCity(pCityPlot,NUM_CITY_RINGS*2);

        // Lost the capital!
        if (bCapital)
        {
            GET_PLAYER(eOldOwner).SetHasLostCapital(true, GetID());

            GET_PLAYER(eOldOwner).findNewCapital();

            GET_TEAM(getTeam()).resetVictoryProgress();
        }

        GC.GetEngineUserInterface()->setDirty(NationalBorders_DIRTY_BIT, true);
        // end adapted from PostKill()

        pNewCity = initCity(pCityPlot->getX(), pCityPlot->getY(), !bConquest);

        CvAssertMsg(pNewCity != NULL, "NewCity is not assigned a valid value");

    #ifdef _MSC_VER
    #pragma warning ( push )
    #pragma warning ( disable : 6011 )
    #endif
        pNewCity->setPreviousOwner(eOldOwner);
        pNewCity->setOriginalOwner(eOriginalOwner);
        pNewCity->setGameTurnFounded(iGameTurnFounded);
        pNewCity->SetEverCapital(bEverCapital);

        // Population change for capturing a city
        if (!bRecapture && bConquest)    // Don't drop it if we're recapturing our own City
        {
            iPopulation = max(1, iPopulation * /*50*/ GC.getCITY_CAPTURE_POPULATION_PERCENT() / 100);
        }

        pNewCity->setPopulation(iPopulation);
        pNewCity->setHighestPopulation(iHighestPopulation);
        pNewCity->setName(strName);
        pNewCity->setNeverLost(false);
        pNewCity->setDamage(iBattleDamage,true);
        pNewCity->setMadeAttack(bHasMadeAttack);

        for (iI = 0; iI < MAX_PLAYERS; iI++)
        {
            pNewCity->setEverOwned(((PlayerTypes)iI), abEverOwned[iI]);
        }

        pNewCity->SetJONSCultureLevel(iOldCultureLevel);

        CvCivilizationInfo& playerCivilizationInfo = getCivilizationInfo();
        for (iI = 0; iI < GC.getNumBuildingInfos(); iI++)
        {
            const BuildingTypes eLoopBuilding = static_cast<BuildingTypes>(iI);
            CvBuildingEntry* pkLoopBuildingInfo = GC.getBuildingInfo(eLoopBuilding);
            if(pkLoopBuildingInfo)
            {
                const CvBuildingClassInfo& kLoopBuildingClassInfo = pkLoopBuildingInfo->GetBuildingClassInfo();

                int iNum = 0;
                if (paiNumRealBuilding[iI] > 0)
                {
                    const BuildingClassTypes eBuildingClass = (BuildingClassTypes)pkLoopBuildingInfo->GetBuildingClassType();
                    if (::isWorldWonderClass(kLoopBuildingClassInfo))
                    {
                        eBuilding = eLoopBuilding;
                    }
                    else
                    {
                        eBuilding = (BuildingTypes)playerCivilizationInfo.getCivilizationBuildings(eBuildingClass);
                    }

                    if (eBuilding != NO_BUILDING)
                    {
                        CvBuildingEntry* pkBuildingInfo = GC.getBuildingInfo(eBuilding);
                        if(pkBuildingInfo)
                        {
                            if (!pkLoopBuildingInfo->IsNeverCapture())
                            {
                                if (!isProductionMaxedBuildingClass(((BuildingClassTypes)(pkBuildingInfo->GetBuildingClassType())), true))
                                {
                                    // here would be a good place to put additional checks (for example, influence)
                                    if (!bConquest || bRecapture || GC.getGame().getJonRandNum(100, "Capture Probability") < pkLoopBuildingInfo->GetConquestProbability())
                                    {
                                        iNum += paiNumRealBuilding[iI];
                                    }
                                }
                            }

                            // Check for Tomb Raider Achievement
                            if (bConquest && !GC.getGame().isGameMultiPlayer() && pkLoopBuildingInfo->GetType() && _stricmp(pkLoopBuildingInfo->GetType(), "BUILDING_BURIAL_TOMB") == 0 && isHuman() )
                            {
                                if (iCaptureGold > 0) //Need to actually pillage something from the 'tomb'
                                {
                                    gDLL->UnlockAchievement( ACHIEVEMENT_SPECIAL_TOMBRAIDER );
                                }
                            }

                            // Check for Rome conquering Statue of Zeus Achievement
                            if (bConquest && !GC.getGame().isGameMultiPlayer() && pkLoopBuildingInfo->GetType() && _stricmp(pkLoopBuildingInfo->GetType(), "BUILDING_STATUE_ZEUS") == 0 && isHuman() )
                            {
                                const char* pkCivKey = getCivilizationTypeKey();
                                if (pkCivKey && strcmp(pkCivKey, "CIVILIZATION_ROME") == 0)
                                {
                                    gDLL->UnlockAchievement( ACHIEVEMENT_SPECIAL_ROME_GETS_ZEUS );
                                }
                            }


                            pNewCity->GetCityBuildings()->SetNumRealBuildingTimed(eBuilding, iNum, false, ((PlayerTypes)(paiBuildingOriginalOwner[iI])), paiBuildingOriginalTime[iI]);
                        }
                    }
                }
            }
        }

        for (std::vector<BuildingYieldChange>::iterator it = aBuildingYieldChange.begin(); it != aBuildingYieldChange.end(); ++it)
        {
            pNewCity->GetCityBuildings()->SetBuildingYieldChange((*it).eBuildingClass, (*it).eYield, (*it).iChange);
        }

        // Did we re-acquire our Capital?
        if (pCityPlot->getX() == GetOriginalCapitalX() && pCityPlot->getY() == GetOriginalCapitalY())
        {
            SetHasLostCapital(false, NO_PLAYER);

            const BuildingTypes eCapitalBuilding = (BuildingTypes) (getCivilizationInfo().getCivilizationBuildings(GC.getCAPITAL_BUILDINGCLASS()));
            if (eCapitalBuilding != NO_BUILDING)
            {
                if (getCapitalCity() != NULL)
                {
                    getCapitalCity()->GetCityBuildings()->SetNumRealBuilding(eCapitalBuilding, 0);
                }
                CvAssertMsg(!(pNewCity->GetCityBuildings()->GetNumRealBuilding(eCapitalBuilding)), "(pBestCity->getNumRealBuilding(eCapitalBuilding)) did not return false as expected");
                pNewCity->GetCityBuildings()->SetNumRealBuilding(eCapitalBuilding, 1);
            }
        }

        GC.getMap().updateWorkingCity(pCityPlot,NUM_CITY_RINGS*2);

        if (bConquest)
        {
            for (int iDX = -iMaxRange; iDX <= iMaxRange; iDX++)
            {
                for (int iDY = -iMaxRange; iDY <= iMaxRange; iDY++)
                {
                    CvPlot* pLoopPlot = plotXYWithRangeCheck(iOldCityX, iOldCityY, iDX, iDY, iMaxRange);
                    if (pLoopPlot)
                    {
                        pLoopPlot->verifyUnitValidPlot();
                    }
                }
            }

            // Check for Askia Achievement
            if( isHuman() && !CvPreGame::isNetworkMultiplayerGame() )
            {
                const char* pkLeaderKey = getLeaderTypeKey();
                if (pkLeaderKey && strcmp(pkLeaderKey, "LEADER_ASKIA") == 0)
                {
                    CvCity *pkCaptialCity = getCapitalCity();
                    if (pkCaptialCity != NULL)    // Shouldn't be NULL, but...
                    {
                        CvPlot *pkCapitalPlot = pkCaptialCity->plot();
                        CvPlot *pkNewCityPlot = pNewCity->plot();
                        if (pkCapitalPlot && pkNewCityPlot)
                        {
                            // Get the area each plot is located in.
                            CvArea* pkCapitalArea = pkCapitalPlot->area();
                            CvArea* pkNewCityArea = pkNewCityPlot->area();

                            if (pkCapitalArea && pkNewCityArea)
                            {
                                // The area the new city is locate on has to be of a certain size to qualify so that tiny islands are not included
                                #define ACHIEVEMENT_MIN_CONTINENT_SIZE    8
                                if (pkNewCityArea->GetID() != pkCapitalArea->GetID() && pkNewCityArea->getNumTiles() >= ACHIEVEMENT_MIN_CONTINENT_SIZE)
                                {
                                    gDLL->UnlockAchievement( ACHIEVEMENT_SPECIAL_WARCANOE );
                                }
                            }
                        }
                    }
                }
            }
        }

        pCityPlot->setRevealed(GET_PLAYER(eOldOwner).getTeam(), true);

        // If the old owner is "killed," then notify everyone's Grand Strategy AI
        if (GET_PLAYER(eOldOwner).getNumCities() == 0 && !GET_PLAYER(eOldOwner).GetPlayerTraits()->IsStaysAliveZeroCities())
        {
            if (!isMinorCiv() && !isBarbarian())
            {
                for (int iMajorLoop = 0; iMajorLoop < MAX_MAJOR_CIVS; iMajorLoop++)
                {
                    if (GetID() != iMajorLoop && GET_PLAYER((PlayerTypes) iMajorLoop).isAlive())
                    {
                        // Have I met the player who killed the guy?
                        if (GET_TEAM(GET_PLAYER((PlayerTypes) iMajorLoop).getTeam()).isHasMet(getTeam()))
                        {
                            GET_PLAYER((PlayerTypes) iMajorLoop).GetDiplomacyAI()->DoPlayerKilledSomeone(GetID(), eOldOwner);
                        }
                    }
                }
            }
        }
        // If not, old owner should look at city specializations
        else
        {
            GET_PLAYER(eOldOwner).GetCitySpecializationAI()->SetSpecializationsDirty(SPECIALIZATION_UPDATE_MY_CITY_CAPTURED);
        }

        // Do the same for the new owner
        GetCitySpecializationAI()->SetSpecializationsDirty(SPECIALIZATION_UPDATE_ENEMY_CITY_CAPTURED);

        bool bDisbanded = false;

        // In OCC games, all captured cities are toast
        if (GC.getGame().isOption(GAMEOPTION_ONE_CITY_CHALLENGE) && isHuman())
        {
            bDisbanded = true;
            disband(pNewCity);
        }
        else //if (bConquest)
        {
            // Is this City being Occupied?
            if (pNewCity->getOriginalOwner() != GetID())
            {
                pNewCity->SetOccupied(true);

                pNewCity->ChangeResistanceTurns(pNewCity->getPopulation());
            }

            long lResult = 0;

            if (lResult == 0)
            {
                PlayerTypes eLiberatedPlayer = NO_PLAYER;

                // Captured someone's city that didn't originally belong to us - Liberate a player?
                if (pNewCity->getOriginalOwner() != eOldOwner && pNewCity->getOriginalOwner() != GetID())
                {
                    eLiberatedPlayer = pNewCity->getOriginalOwner();
                    if (!CanLiberatePlayer(eLiberatedPlayer))
                    {
                        eLiberatedPlayer = NO_PLAYER;
                    }
                }

                // AI decides what to do with a City
                if (!isHuman())
                {
                    AI_conquerCity(pNewCity, eOldOwner); // could delete the pointer...
                }

                // Human decides what to do with a City
                else if (!GC.getGame().isOption(GAMEOPTION_NO_HAPPINESS))
                {
                    // Used to display info for annex/puppet/raze popup - turned off in DoPuppet and DoAnnex
                    pNewCity->SetIgnoreCityForHappiness(true);

                    // If this city wasn't originally ours, give the human the choice to annex or puppet it
                    if (pNewCity->getOriginalOwner() != GetID())
                    {
                        if (GC.getGame().getActivePlayer() == GetID())
                        {
                            CvPopupInfo kPopupInfo(BUTTONPOPUP_CITY_CAPTURED, pNewCity->GetID(), iCaptureGold, eLiberatedPlayer);
                            GC.GetEngineUserInterface()->AddPopup(kPopupInfo);
                            // We are adding a popup that the player must make a choice in, make sure they are not in the end-turn phase.
                            CancelActivePlayerEndTurn();
                        }
                    }
                }

                // No choice but to capture it, tell about pillage gold (if any)
                else if (iCaptureGold > 0)
                {
                    strBuffer = GetLocalizedText("TXT_KEY_POPUP_GOLD_CITY_CAPTURE", iCaptureGold, pNewCity->getNameKey());
                    GC.GetEngineUserInterface()->AddCityMessage(0, pNewCity->GetIDInfo(), GetID(), true, GC.getEVENT_MESSAGE_TIME(), strBuffer);
                }
            }
        }

        // Cache whether the player is human or not.  If the player is killed, the CvPreGame::slotStatus is changed to SS_CLOSED
        // but the slot status is used to determine if the player is human or not, so it looks like it is an AI!
        // This should be fixed, but might have unforeseen ramifications so...
        CvPlayer& kOldOwner = GET_PLAYER(eOldOwner);
        bool bOldOwnerIsHuman = kOldOwner.isHuman();
        // This may 'kill' the player if it is deemed that he does not have the proper units to stay alive
        kOldOwner.verifyAlive();

        // You... you killed him!
        if (!kOldOwner.isAlive())
        {
            GET_TEAM(kOldOwner.getTeam()).SetKilledByTeam(getTeam());
            kOldOwner.SetEverConqueredBy(m_eID, true);

            // Leader pops up and whines
            if (!CvPreGame::isNetworkMultiplayerGame())        // Not in MP
            {
                if (!bOldOwnerIsHuman && !kOldOwner.isMinorCiv() && !kOldOwner.isBarbarian())
                    kOldOwner.GetDiplomacyAI()->DoKilledByPlayer(GetID());
            }
        }

        // grant the new owner any of the plots that were purchased by the prior owner
        for (uint ui = 0; ui < aiPurchasedPlotX.size(); ui++)
        {
            CvPlot* pPlot = GC.getMap().plot(aiPurchasedPlotX[ui], aiPurchasedPlotY[ui]);
            if (!bDisbanded)
            {
                if (pPlot->getOwner() != pNewCity->getOwner())
                    pPlot->setOwner(pNewCity->getOwner(), /*iAcquireCityID*/ pNewCity->GetID(), /*bCheckUnits*/ true, /*bUpdateResources*/ true);
            }
            else
            {
                pPlot->setOwner(NO_PLAYER, -1, /*bCheckUnits*/ true, /*bUpdateResources*/ true);
            }
        }

        if (GC.getGame().getActiveTeam() == GET_PLAYER(eOldOwner).getTeam())
        {
            CvMap& theMap = GC.getMap();
            theMap.updateDeferredFog();
        }

        ICvEngineScriptSystem1* pkScriptSystem = gDLL->GetScriptSystem();
        if(pkScriptSystem)
        {
            CvLuaArgsHandle args;
            args->Push(eOldOwner);
            args->Push(bCapital);
            args->Push(pNewCity->getX());
            args->Push(pNewCity->getY());
            args->Push(GetID());

            bool bResult;
            LuaSupport::CallHook(pkScriptSystem, "CityCaptureComplete", args.get(), bResult);
        }
    #ifdef _MSC_VER
    #pragma warning ( pop ) // restore warning level suppressed for pNewCity null check
    #endif// _MSC_VER*/
    }
    
    /// Handle earning culture from combat wins
    public func reportCultureFromKills(at point: HexPoint, culture cultureVal: Int, wasBarbarian: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var culture: Int = cultureVal
        
        if culture > 0 {
            
            let cultureValue = 100 // GetPlayerTraits()->GetCultureFromKills();
            //iCultureValue += GetPlayerPolicies()->GetNumericModifier(POLICYMOD_CULTURE_FROM_KILLS);

            // Do we get it for barbarians?
            if wasBarbarian {
                // cultureValue += GetPlayerPolicies()->GetNumericModifier(POLICYMOD_CULTURE_FROM_BARBARIAN_KILLS);
            }

            culture = (cultureValue * culture) / 100
            if culture > 0 {
                
                self.cultureEarned += culture

                if self.isHuman() {
                    gameModel.userInterface?.showTooltip(at: point, text: "\(culture)", delay: 3.0)
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
                
                self.treasury?.add(gold: Double(gold))

                if self.isHuman() {
                    gameModel.userInterface?.showTooltip(at: point, text: "\(gold)", delay: 2.0)
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

        if !self.isBarbarian() {
            
            tile.removeImprovement()
            
            // Make a list of valid Goodies to pick randomly from
            var validGoodies: [GoodyType] = []

            for goody in GoodyType.all {
                
                if !gameModel.handicap.validGoodies().contains(goody) {
                    continue
                }
                
                if self.canReceiveGoody(at: tile, goody: goody, unit: unit, in: gameModel) {
                    validGoodies.append(goody)
                }
            }
                
            // Any valid Goodies?
            if !validGoodies.isEmpty {
                let goody = validGoodies.randomItem()
                self.receiveGoody(at: tile, goody: goody, unit: unit, in: gameModel)
            }
        }
    }
    
    /// Is a Particular Goody ID a valid Goody for a certain plot?
    func canReceiveGoody(at tile: AbstractTile?, goody: GoodyType, unit: AbstractUnit?, in gameModel: GameModel?) -> Bool {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let goodyHuts = self.goodyHuts else {
            fatalError("cant get goodyHuts")
        }
        
        guard let techs = self.techs else {
            fatalError("cant get techs")
        }
        
        if !goodyHuts.canReceive(goody: goody) {
            return false
        }

        // No XP in first 10 turns
        if goody == .experience {
            if unit == nil || gameModel.turnsElapsed < 10 {
                return false
            }
        }

        // Population
        if goody == .population {
            if gameModel.cities(of: self).count == 0 {
                return false
            }

            // Don't give more Population if we're already over our Pop limit
            /*if (IsEmpireUnhappy())
            {
                return false;
            }*/
        }

        // Reveal Nearby Barbs
        if goody == .revealNearbyBarbarians {

            var numCampsFound = 0

            // Look at nearby Plots to make sure another camp isn't too close
            for point in tile.point.areaWith(radius: 10) {
                
                guard let pointTile = gameModel.tile(at: point) else {
                    continue
                }
                
                if pointTile.has(improvement: .barbarianCamp) {
                    numCampsFound += 1
                }
            }

            // Needs to be at least 2 nearby Camps
            if numCampsFound < 2 {
                return false
            }
        }

        // Unit Upgrade
        if goody == .upgradeUnit {
         
            guard let unit = unit else {
                return false
            }

            /*if (pUnit->IsHasBeenPromotedFromGoody())
            {
                return false;
            }*/

            /*UnitClassTypes eUpgradeUnitClass = (UnitClassTypes) GC.getUnitInfo(pUnit->getUnitType())->GetGoodyHutUpgradeUnitClass();

            if (eUpgradeUnitClass == NO_UNITCLASS)
            {
                return false;
            }

            UnitTypes eUpgradeUnit = (UnitTypes) getCivilizationInfo().getCivilizationUnits(eUpgradeUnitClass);

            if (eUpgradeUnit == NO_UNIT)
            {
                return false;
            }*/
            
            return false
        }

        // Tech
        if goody == .tech {
            
            var techFound = false

            let possibleTechs = techs.possibleTechs()
            for tech in TechType.all {
                
                if !tech.isGoodyTech() {
                    continue
                }
                
                if possibleTechs.contains(tech) {
                    techFound = true
                    break
                }
            }

            if !techFound {
                return false
            }
        }

        ///////////////////////////////////////
        ///////////////////////////////////////
        // Bad Goodies follow beneath this line
        ///////////////////////////////////////
        ///////////////////////////////////////


        if let unitType = goody.unitType() {

            // No combat units in MP in the first 20 turns
            if unitType.meleeStrength() > 0 {
                if gameModel.turnsElapsed < 20 {
                    return false
                }
            }
        }

        return true
    }
    
    func receiveGoody(at tile: AbstractTile?, goody: GoodyType, unit: AbstractUnit?, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        // Gold
        let gold = goody.gold() + goody.numGoldRandRolls() * Int.random(maximum: goody.goldRandAmount())

        if gold != 0 {
            self.treasury?.add(gold: Double(gold))

            //strBuffer += GetLocalizedText("TXT_KEY_MISC_RECEIVED_GOLD", iGold);
        }

        // Population
        if goody == .population {
            
            var bestCityDistance = -1
            var bestCity: AbstractCity? = nil
            
            // Find the closest City to us to add a Pop point to
            for cityRef in gameModel.cities(of: self) {
                
                guard let city = cityRef else {
                    continue
                }
                
                let distance = tile.point.distance(to: city.location)

                if bestCityDistance == -1 || distance < bestCityDistance {
                    bestCityDistance = distance
                    bestCity = cityRef
                }
            }

            if bestCity != nil {
                bestCity?.change(population: goody.population(), reassignCitizen: true, in: gameModel)
            }
        }
        
        fatalError("niy")
/*
        // Culture
        int iCulture = kGoodyInfo.getCulture();
        if (iCulture > 0)
        {
            // Game Speed Mod
            iCulture *= GC.getGame().getGameSpeedInfo().getCulturePercent();
            iCulture /= 100;

            changeJONSCulture(iCulture);
        }

        // Reveal Nearby Barbs
        if (kGoodyInfo.getRevealNearbyBarbariansRange() > 0)
        {
            // Look at nearby Plots to make sure another camp isn't too close
            const int iBarbCampDistance = kGoodyInfo.getRevealNearbyBarbariansRange();
            for (iDX = -(iBarbCampDistance); iDX <= iBarbCampDistance; iDX++)
            {
                for (iDY = -(iBarbCampDistance); iDY <= iBarbCampDistance; iDY++)
                {
                    CvPlot* pNearbyBarbarianPlot = plotXY(pPlot->getX(), pPlot->getY(), iDX, iDY);
                    if (pNearbyBarbarianPlot != NULL)
                    {
                        if (plotDistance(pNearbyBarbarianPlot->getX(), pNearbyBarbarianPlot->getY(), pPlot->getX(), pPlot->getY()) <= iBarbCampDistance)
                        {
                            if (pNearbyBarbarianPlot->getImprovementType() == GC.getBARBARIAN_CAMP_IMPROVEMENT())
                            {
                                // Reveal Plot
                                pNearbyBarbarianPlot->setRevealed(getTeam(), true);
                                // Reveal Barb Camp here
                                pNearbyBarbarianPlot->setRevealedImprovementType(getTeam(), pNearbyBarbarianPlot->getImprovementType());
                            }
                        }
                    }
                }
            }
        }

        // Map
        iRange = kGoodyInfo.getMapRange();

        if (iRange > 0)
        {
            iOffset = kGoodyInfo.getMapOffset();

            if (iOffset > 0)
            {
                iBestValue = 0;
                pBestPlot = NULL;

                int iRandLimit;

                for (iDX = -(iOffset); iDX <= iOffset; iDX++)
                {
                    for (iDY = -(iOffset); iDY <= iOffset; iDY++)
                    {
                        pLoopPlot = plotXYWithRangeCheck(pPlot->getX(), pPlot->getY(), iDX, iDY, iOffset);

                        if (pLoopPlot != NULL)
                        {
                            if (!(pLoopPlot->isRevealed(getTeam())))
                            {
                                // Avoid water plots!
                                if (pPlot->isWater())
                                    iRandLimit = 10;
                                else
                                    iRandLimit = 10000;

                                iValue = (1 + GC.getGame().getJonRandNum(iRandLimit, "Goody Map"));

                                iValue *= plotDistance(pPlot->getX(), pPlot->getY(), pLoopPlot->getX(), pLoopPlot->getY());

                                if (iValue > iBestValue)
                                {
                                    iBestValue = iValue;
                                    pBestPlot = pLoopPlot;
                                }
                            }
                        }
                    }
                }
            }

            if (pBestPlot == NULL)
            {
                pBestPlot = pPlot;
            }

            for (iDX = -(iRange); iDX <= iRange; iDX++)
            {
                for (iDY = -(iRange); iDY <= iRange; iDY++)
                {
                    pLoopPlot = plotXY(pBestPlot->getX(), pBestPlot->getY(), iDX, iDY);

                    if (pLoopPlot != NULL)
                    {
                        if (plotDistance(pBestPlot->getX(), pBestPlot->getY(), pLoopPlot->getX(), pLoopPlot->getY()) <= iRange)
                        {
                            if (GC.getGame().getJonRandNum(100, "Goody Map") < kGoodyInfo.getMapProb())
                            {
                                pLoopPlot->setRevealed(getTeam(), true);
                            }
                        }
                    }
                }
            }
        }

        // Experience
        if (pUnit != NULL)
        {
            pUnit->changeExperience(kGoodyInfo.getExperience());
        }

        // Unit Heal
        if (pUnit != NULL)
        {
            pUnit->changeDamage(-(kGoodyInfo.getHealing()));
        }
        
        // Unit Upgrade
        if (kGoodyInfo.isUpgradeUnit())
        {
            UnitTypes eUpgradeUnit = NO_UNIT;

            if(pUnit != NULL)
            {
                UnitClassTypes eUpgradeUnitClass = (UnitClassTypes) pUnit->getUnitInfo().GetGoodyHutUpgradeUnitClass();
                eUpgradeUnit = (UnitTypes) getCivilizationInfo().getCivilizationUnits(eUpgradeUnitClass);
            }

            if (eUpgradeUnit != NO_UNIT)
            {
                // Add new upgrade Unit
                CvUnit* pNewUnit = initUnit(eUpgradeUnit, pPlot->getX(), pPlot->getY(), pUnit->AI_getUnitAIType(), NO_DIRECTION, false, false);
                pUnit->finishMoves();
                pUnit->SetBeenPromotedFromGoody(true);
                if (pNewUnit != NULL)
                {
                    pNewUnit->convert(pUnit);
                    pNewUnit->setupGraphical();
                }
                else
                    pUnit->kill(false);

                // Since the old unit died, it will block the goody reward popup unless we call this
                GC.GetEngineUserInterface()->SetDontShowPopups(false);
            }
        }

        // Tech
        if (kGoodyInfo.isTech())
        {
            iBestValue = 0;
            eBestTech = NO_TECH;

            for (iI = 0; iI < GC.getNumTechInfos(); iI++)
            {
                CvTechEntry* pkTech = GC.getTechInfo((TechTypes) iI);
                if (pkTech != NULL && pkTech->IsGoodyTech())
                {
                    if (GetPlayerTechs()->CanResearch((TechTypes)iI))
                    {
                        iValue = (1 + GC.getGame().getJonRandNum(10000, "Goody Tech"));

                        if (iValue > iBestValue)
                        {
                            iBestValue = iValue;
                            eBestTech = ((TechTypes)iI);
                        }
                    }
                }
            }

            CvAssertMsg(eBestTech != NO_TECH, "BestTech is not assigned a valid value");

            GET_TEAM(getTeam()).setHasTech(eBestTech, true, GetID(), true, true);
            GET_TEAM(getTeam()).GetTeamTechs()->SetNoTradeTech(eBestTech, true);
        }

        // Units
        if (kGoodyInfo.getUnitClassType() != NO_UNITCLASS)
        {
            eUnit = (UnitTypes)getCivilizationInfo().getCivilizationUnits(kGoodyInfo.getUnitClassType());

            if (eUnit != NO_UNIT)
            {
                CvUnit* pNewUnit = initUnit(eUnit, pPlot->getX(), pPlot->getY());
                // see if there is an open spot to put him - no over-stacking allowed!
                if (pNewUnit && pUnit && pUnit->AreUnitsOfSameType(*pNewUnit)) // pUnit isn't in this plot yet (if it even exists) so we can't check on if we are over-stacked directly
                {
                    pBestPlot = NULL;
                    iBestValue = INT_MAX;
                    const int iPopRange = 2;
                    for (iDX = -(iPopRange); iDX <= iPopRange; iDX++)
                    {
                        for (iDY = -(iPopRange); iDY <= iPopRange; iDY++)
                        {
                            pLoopPlot    = plotXYWithRangeCheck(pPlot->getX(), pPlot->getY(), iDX, iDY, iPopRange);
                            if (pLoopPlot != NULL)
                            {
                                if (pLoopPlot->isValidDomainForLocation(*pNewUnit))
                                {
                                    if (pNewUnit->canMoveInto(*pLoopPlot))
                                    {
                                        if (pLoopPlot->getNumFriendlyUnitsOfType(pUnit) < GC.getPLOT_UNIT_LIMIT())
                                        {
                                            if (pNewUnit->canEnterTerritory(pLoopPlot->getTeam()) && !pNewUnit->isEnemy(pLoopPlot->getTeam(), pLoopPlot))
                                            {
                                                if ((pNewUnit->getDomainType() != DOMAIN_AIR) || pLoopPlot->isFriendlyCity(*pNewUnit, true))
                                                {
                                                    if (pLoopPlot->isRevealed(getTeam()))
                                                    {
                                                        iValue = 1 + GC.getGame().getJonRandNum(6, "spawn goody unit that would over-stack"); // okay, I'll admit it, not a great heuristic

                                                        if (plotDistance(pPlot->getX(),pPlot->getY(),pLoopPlot->getX(),pLoopPlot->getY()) > 1)
                                                        {
                                                            iValue += 12;
                                                        }

                                                        if (pLoopPlot->area() != pPlot->area()) // jumped to a different land mass, cool
                                                        {
                                                            iValue *= 10;
                                                        }

                                                        if (iValue < iBestValue)
                                                        {
                                                            iBestValue = iValue;
                                                            pBestPlot = pLoopPlot;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (pBestPlot != NULL)
                    {
                        bool bVis = pBestPlot->isVisibleToWatchingHuman();
                        pNewUnit->setXY(pBestPlot->getX(), pBestPlot->getY(), false, true, true && bVis, true);
                        pNewUnit->SetPosition(pBestPlot);    // Need this to put the unit in the right spot graphically
                        pNewUnit->finishMoves();
                    }
                    else
                    {
                        pNewUnit->kill(false);
                    }
                }
            }
        }

        // Barbarians
        if (kGoodyInfo.getBarbarianUnitClass() != NO_UNITCLASS)
        {
            iBarbCount = 0;

            eUnit = (UnitTypes)GET_PLAYER(BARBARIAN_PLAYER).getCivilizationInfo().getCivilizationUnits(kGoodyInfo.getBarbarianUnitClass());

            if (eUnit != NO_UNIT)
            {
                for (iPass = 0; iPass < 10; iPass++)
                {
                    if (iBarbCount < kGoodyInfo.getMinBarbarians())
                    {
                        for (iI = 0; iI < NUM_DIRECTION_TYPES; iI++)
                        {
                            pLoopPlot = plotDirection(pPlot->getX(), pPlot->getY(), ((DirectionTypes)iI));

                            if (pLoopPlot != NULL)
                            {
                                if (pLoopPlot->getArea() == pPlot->getArea())
                                {
                                    if (!(pLoopPlot->isImpassable()) && !(pLoopPlot->getPlotCity()))
                                    {
                                        if (pLoopPlot->getNumUnits() == 0)
                                        {
                                            if ((iPass > 0) || (GC.getGame().getJonRandNum(100, "Goody Barbs") < kGoodyInfo.getBarbarianUnitProb()))
                                            {
                                                GET_PLAYER(BARBARIAN_PLAYER).initUnit(eUnit, pLoopPlot->getX(), pLoopPlot->getY(), ((pLoopPlot->isWater()) ? UNITAI_ATTACK_SEA : UNITAI_ATTACK));
                                                iBarbCount++;

                                                if ((iPass > 0) && (iBarbCount == kGoodyInfo.getMinBarbarians()))
                                                {
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        if (!strBuffer.empty() && GC.getGame().getActivePlayer() == GetID())
        {
            GC.GetEngineUserInterface()->AddPlotMessage(0, pPlot->GetPlotIndex(), GetID(), true, GC.getEVENT_MESSAGE_TIME(), strBuffer);
        }

        // If it's the active player then show the popup
        if (GetID() == GC.getGame().getActivePlayer())
        {
            GC.getMap().updateDeferredFog();

            bool bDontShowRewardPopup = GC.GetEngineUserInterface()->IsOptionNoRewardPopups();

            // Don't show in MP, or if the player has turned it off
            if (!GC.getGame().isNetworkMultiPlayer() && !bDontShowRewardPopup)    // KWG: Candidate for !GC.getGame().isOption(GAMEOPTION_SIMULTANEOUS_TURNS)
            {
                int iSpecialValue = 0;

                if (iGold > 0)
                    iSpecialValue = iGold;
                else if (iCulture > 0)
                    iSpecialValue = iCulture;

                CvPopupInfo kPopupInfo(BUTTONPOPUP_GOODY_HUT_REWARD, eGoody, iSpecialValue);
                GC.GetEngineUserInterface()->AddPopup(kPopupInfo);
                // We are adding a popup that the player must make a choice in, make sure they are not in the end-turn phase.
                CancelActivePlayerEndTurn();
            }
        }*/
    }
}

extension Player: Equatable {

    public static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.leader == rhs.leader
    }
}
