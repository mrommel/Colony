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
    func isHuman() -> Bool
    func isBarbarian() -> Bool

    // diplomatics
    func hasMet(with otherPlayer: AbstractPlayer?) -> Bool
    func atWarCount() -> Int
    func updateNotifications()
    func doUpdateProximity(towards otherPlayer: AbstractPlayer?, in gameModel: GameModel?)

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
    func cityStrengthModifier() -> Int

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

        self.techs = Techs(player: self)
        self.civics = Civics(player: self)
        self.religion = Religion(player: self)
        self.treasury = Treasury(player: self)

        self.government = Government()

        self.operations = Operations()
        
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
    
    public func updateNotifications() {
        
        /*if (GetNotifications())
        {
            GetNotifications()->Update();
        }

        if (GetDiplomacyRequests())
        {
            GetDiplomacyRequests()->Update();
        }*/
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
    
    func isTurnActive() -> Bool {
        
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
    
    func scienceFromCities(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var scienceVal = 0.0
        
        for cityRef in gameModel.cities(of: self) {
            
            guard let city = cityRef else {
                continue
            }
            
            scienceVal += city.yields(in: gameModel).science
        }
        
        return scienceVal
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
            
            //loopUnit.promote
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

    func score(for gameModel: GameModel?) -> Int {

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
}

extension Player: Equatable {

    public static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.leader == rhs.leader
    }
}
