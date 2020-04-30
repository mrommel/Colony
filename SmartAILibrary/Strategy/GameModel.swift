//
//  GameModel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum GameStateType {
    
    case on
    case over
    case extended
}

public class GameModel {

    let victoryTypes: [VictoryType]
    let handicap: HandicapType
    var turnsElapsed: Int
    var turnSliceValue: Int = 0
    public let players: [AbstractPlayer]
    
    static let turnFrequency = 25 /* PROGRESS_POPUP_TURN_FREQUENCY */

    private let map: MapModel
    private let tacticalAnalysisMapVal: TacticalAnalysisMap
    public weak var userInterface: UserInterfaceProtocol?
    private var waitDiploPlayer: AbstractPlayer? = nil
    private var wondersBuilt: AbstractWonders? = nil
    
    private var gameStateValue: GameStateType
    
    public var rankingData: RankingData

    public init(victoryTypes: [VictoryType], handicap: HandicapType, turnsElapsed: Int, players: [AbstractPlayer], on map: MapModel) {
        
        self.victoryTypes = victoryTypes
        self.handicap = handicap
        self.turnsElapsed = turnsElapsed
        self.players = players
        self.map = map

        self.tacticalAnalysisMapVal = TacticalAnalysisMap(with: self.map.size)
        self.map.analyze()
        
        self.gameStateValue = .on
        
        self.wondersBuilt = Wonders(city: nil)
        
        self.rankingData = RankingData(players: players)
    }
    
    public func update() {
        
        guard let userInterface = self.userInterface else {
            fatalError("no UI")
        }
        
        if self.isWaitingForBlockingInput() {
            if userInterface.isDiplomaticScreenActive() {
                // when diplomatic screen is visible - we can't update
                return
            } else {
                //self.waitDiploPlayer?.doTurnPostDiplomacy()
                self.setWaitingForBlockingInput(of: nil)
            }
        }
        
        // if the game is single player, it's ok to block all processing until
        // the user selects an extended match or quits.
        if self.gameState() == .over {
            //self.testExtendedGame()
        }
        
        //self.sendPlayerOptions()

        if self.turnSlice() == 0 && !isPaused() {
            // gDLL->AutoSave(true);
        }

        // If there are no active players, move on to the AI
        if self.numGameTurnActive() == 0 {
            self.doTurn()
        }

        // Check for paused again, the doTurn call might have called something that paused the game and we don't want an update to sneak through
        if !self.isPaused()  {

            //self.updateWar()

            self.updateMoves()

            // And again, the player can change after the automoves and that can pause the game
            if !isPaused() {
                
                //self.updateTimers()

                self.updatePlayers(in: self) // slewis added!

                //self.testAlive()

                if let humanPlayer = self.humanPlayer() {
                    if !humanPlayer.isAlive() {
                        self.set(gameState: .over)
                    }
                }

                // next player ???
                self.checkPlayerTurnDeactivate()

                self.changeTurnSlice(by: 1)

                //gDLL->FlushTurnReminders();
            }
        }

        /*PlayerTypes activePlayerID = getActivePlayer();
        const CvPlayer & activePlayer = GET_PLAYER(activePlayerID);
        if (NO_PLAYER != activePlayerID && activePlayer.getAdvancedStartPoints() >= 0 && !GC.GetEngineUserInterface()->isInAdvancedStart())
        {
            GC.GetEngineUserInterface()->setInAdvancedStart(true);
        }*/
    }
    
    func activePlayer() -> AbstractPlayer? {
    
        for player in self.players {
        
            if player.isAlive() && player.isActive() {
                return player
            }
        }
        
        return nil
    }
    
    func updatePlayers(in gameModel: GameModel?) {
    
        for player in self.players {
        
            if player.isAlive() && player.isActive() {
                player.updateNotifications(in: gameModel)
            }
        }
    }
    
    func turnSlice() -> Int {
        
        return self.turnSliceValue
    }
    
    func setTurnSlice(to value: Int) {
        
        self.turnSliceValue = value
    }
    
    func changeTurnSlice(by delta: Int) {
        
        self.turnSliceValue += delta
    }
    
    //    Check to see if the player's turn should be deactivated.
    //    This occurs when the player has set its EndTurn and its AutoMoves to true
    //    and all activity has been completed.
    func checkPlayerTurnDeactivate() {
        
        guard let userInterface = self.userInterface else {
            fatalError("no UI")
        }
        
        for player in self.players {

            if player.isAlive() && player.isActive() {
                
                // For some reason, AI players don't set EndTurn, why not?
                if player.finishTurnButtonPressed() || (!player.isHuman() && !player.hasActiveDiplomacyRequests()) {
                    
                    if player.hasProcessedAutoMoves() {
                        
                        var autoMovesComplete = false
                        if !player.hasBusyUnitOrCity() {
                            autoMovesComplete = true

                            //NET_MESSAGE_DEBUG_OSTR_ALWAYS( "CheckPlayerTurnDeactivate() : auto-moves complete for " << kPlayer.getName());
                        } else {
                            /*if ( gDLL->HasReceivedTurnComplete( player.GetID() ) )
                            {
                                autoMovesComplete = true
                            }*/
                        }

                        if autoMovesComplete {
                            
                            player.endTurn(in: self)

                            // Activate the next player
                            // This is not done if simultaneous turns is enabled (Networked MP).
                            // In that case, the local human is (should be) the player we just deactivated the turn for
                            // and the AI players will be activated all at once in CvGame::doTurn, once we have received
                            // all the moves from the other human players
                            if !userInterface.isDiplomaticScreenActive() {
                                
                                if player.isAlive() || !player.isHuman() {        // If it is a hotseat game and the player is human and is dead, don't advance the player, we want them to get the defeat screen
                                
                                    var hasReachedCurrentPlayer = false
                                    for nextPlayer in self.players {
                                        
                                        if nextPlayer.leader == player.leader {
                                            hasReachedCurrentPlayer = true
                                            continue
                                        }
                                        
                                        if !hasReachedCurrentPlayer {
                                            continue
                                        }
                                    
                                        if nextPlayer.isAlive() {
                                            //the player is alive and also running sequential turns.  they're up!
                                            nextPlayer.startTurn(in: self)
                                            //self.resetTurnTimer(false)
                                            
                                            break
                                        }
                                    }
                                }
                            } else {
                                // KWG: This doesn't actually do anything other than print to the debug log
                                print("Because the diplo screen is blocking I am bumping this up for player \(player.leader)")
                                //changeNumGameTurnActive(1, std::string("Because the diplo screen is blocking I am bumping this up for player ") + getName());
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateMoves() {
        
        var playersToProcess: [AbstractPlayer?] = []
        var processPlayerAutoMoves = false
        
        for player in self.players {
            
            if player.isAlive() && player.isActive() && !player.isHuman() {
                playersToProcess.append(player)
                processPlayerAutoMoves = false
                
                // Notice the break.  Even if there is more than one AI with an active turn, we do them sequentially.
                break
            }
        }
        
        // If no AI with an active turn, check humans.
        if playersToProcess.isEmpty {
    
            processPlayerAutoMoves = true
            
            for player in self.players {

                //player.checkInitialTurnAIProcessed()
                if player.isActive() && player.isHuman() {
                    playersToProcess.append(player)
                }
            }
        }
        
        if let player = playersToProcess.first! {
            
            let readyUnitsBeforeMoves = player.countReadyUnits(in: self)

            if player.isAlive() {
                
                let needsAIUpdate = player.hasUnitsThatNeedAIUpdate(in: self)
                if player.isActive() || needsAIUpdate {
                    
                    if !player.isAutoMoves() || needsAIUpdate {
                        
                        if needsAIUpdate || !player.isHuman() {
                            player.unitUpdate(in: self)

                            //print("UpdateMoves() : player.unitUpdate() called for player \(player.leader)");
                        }

                        let readyUnitsNow = player.countReadyUnits(in: self)
                        
                        // Was a move completed, if so save off which turn slice this was
                        if readyUnitsNow < readyUnitsBeforeMoves {
                            player.setLastSliceMoved(to: self.turnSlice())
                        }
                        
                        if !player.isHuman() && !player.hasBusyUnitOrCity() {
                            
                            if readyUnitsNow == 0 {
                                player.setAutoMoves(value: true)
                                // print("UpdateMoves() : player.setAutoMoves(true) called for player \(player.leader)")
                            } else {
                                fatalError("buh")
                                /*const CvUnit *pReadyUnit = player.GetFirstReadyUnit();
                                
                                if (pReadyUnit && !player.GetTacticalAI()->IsInQueuedAttack(pReadyUnit))
                                {
                                    let waitTime = 10
                                    
                                    if self.turnSlice - player.GetLastSliceMoved() > waitTime {
                                        print("GAME HANG - Please show and send save. Stuck units will have their turn ended so game can advance.")
                                        player.endTurnsForReadyUnits()
                                    }
                                }*/
                            }
                        }
                    }
                    
                    if player.isAutoMoves() && (!player.isHuman() || processPlayerAutoMoves) {
                        
                        var repeatAutomoves = false
                        var repeatPassCount = 2    // Prevent getting stuck in a loop
                        
                        repeat {
                            
                            for loopUnitRef in self.units(of: player) {
                                
                                guard let loopUnit = loopUnitRef else {
                                    continue
                                }
                                
                                /*CvString tempString;
                                getMissionAIString(tempString, pLoopUnit->GetMissionAIType());
                                NET_MESSAGE_DEBUG_OSTR_ALWAYS("UpdateMoves() : player " << player.GetID() << " " << player.getName()
                                                                                                << " running AutoMission (" << tempString << ") on "
                                                                                                << pLoopUnit->getName() << " id=" << pLoopUnit->GetID());*/

                                loopUnit.autoMission(in: self)

                                // Does the unit still have movement points left over?
                                if player.isHuman() && loopUnit.hasCompletedMoveMission(in: self) && loopUnit.canMove() /*&& !loopUnit.isDoingPartialMove()*/ && !loopUnit.isAutomated() {
                                    
                                    if player.finishTurnButtonPressed() {
                                        
                                        repeatAutomoves = true    // Do another pass.
                                        /*NET_MESSAGE_DEBUG_OSTR_ALWAYS("UpdateMoves() : player " << player.GetID() << " " << player.getName()
                                                                                                        << " AutoMission did not use up all movement points for "
                                                                                                        << pLoopUnit->getName() << " id=" << pLoopUnit->GetID());*/

                                        /*if player.isLocalPlayer() && gDLL->sendTurnUnready())
                                            player.setEndTurn(false);*/
                                    }
                                }

                                // This is a short-term solution to a problem where a unit with an auto-mission (a queued, multi-turn) move order cannot reach its destination, but
                                //  does not re-enter the "need order" list because this code is processed at the end of turns. The result is that the player could easily "miss" moving
                                //  the unit this turn because it displays "next turn" rather than "skip unit turn" and the unit is not added to the "needs orders" list.
                                // To correctly fix this problem, we would need some way to determine if any of the auto-missions are invalid before the player can end the turn and
                                //  activate the units that have a problem.
                                // The problem with evaluating this is that, with one unit per tile, we don't know what is a valid move until other units have moved.
                                // (For example, if one unit was to follow another, we would want the unit in the lead to move first and then have the following unit move, in order
                                //  to prevent the following unit from constantly waking up because it can't move into the next tile. This is currently not supported.)

                                // This short-term solution will reactivate a unit after the player clicks "next turn". It will appear strange, because the player will be asked to move
                                // a unit after they clicked "next turn", but it is to give the player a chance to move all of their units.

                                // jrandall sez: In MP matches, let's not OOS or stall the game.
                            }
                            repeatPassCount -= 1
                            
                        } while repeatAutomoves && repeatPassCount > 0

                        // check if the (for now human) player is overstacked and move the units
                        //if (player.isHuman())

                        // slewis - I changed this to only be the AI because human players should have the tools to deal with this now
                        if !player.isHuman() {
                            
                            for loopUnit in self.units(of: player) {
                                
                                //var moveMe  = false
                                //var numTurnsFortified = loopUnit.fortifyTurns()
                                
                                /*IDInfo* pUnitNodeInner;
                                pUnitNodeInner = pLoopUnit->plot()->headUnitNode();
                                while (pUnitNodeInner != NULL && !moveMe)
                                {
                                    CvUnit* pLoopUnitInner = ::getUnit(*pUnitNodeInner);
                                    if (pLoopUnitInner && pLoopUnit != pLoopUnitInner)
                                    {
                                        if (pLoopUnit->getOwner() == pLoopUnitInner->getOwner())    // Could be a dying Unit from another player here
                                        {
                                            if (pLoopUnit->AreUnitsOfSameType(*pLoopUnitInner))
                                            {
                                                if loopUnitInner->getFortifyTurns() >= iNumTurnsFortified {
                                                    moveMe = true
                                                }
                                            }
                                        }
                                    }
                                    pUnitNodeInner = pLoopUnit->plot()->nextUnitNode(pUnitNodeInner);
                                }
                                
                                if moveMe {
                                    if (!pLoopUnit->jumpToNearestValidPlotWithinRange(1)) {
                                        loopUnit.kill(false)    // Can't find a valid spot.
                                    }
                                    break
                                }*/
                                
                                loopUnit?.doDelayedDeath(in: self)
                            }
                        }

                        // If we completed the processing of the auto-moves, flag it.
                        if player.finishTurnButtonPressed() || !player.isHuman() {
                            player.setProcessedAutoMoves(value: true)
                        }
                    }

                    // KWG: This code should go into CheckPlayerTurnDeactivate
                    /*if !player.finishTurnButtonPressed() && gDLL->HasReceivedTurnComplete( player.GetID() ) && player.isHuman() /* && (isNetworkMultiPlayer() || (!isNetworkMultiPlayer() && player.GetID() != getActivePlayer())) */)
                    {
                        if(!player.hasBusyUnitOrCity())
                        {
                            player.setEndTurn(true);
                            if(player.isEndTurn())
                            {
                                //If the player's turn ended, indicate it in the log.  We only do so when the end turn state has changed to prevent useless log spamming in multiplayer.
                                NET_MESSAGE_DEBUG_OSTR_ALWAYS("UpdateMoves() : player.setEndTurn(true) called for player " << player.GetID() << " " << player.getName());
                            }
                        }
                        else
                        {
                            if(!player.hasBusyUnitUpdatesRemaining())
                            {
                                NET_MESSAGE_DEBUG_OSTR_ALWAYS("Received turn complete for player "  << player.GetID() << " " << player.getName() << " but there is a busy unit. Forcing the turn to advance");
                                player.setEndTurn(true);
                            }
                        }
                    }*/
                }
            }
        }
    }
    
    func isPaused() -> Bool {
        
        return false
    }
    
    func gameState() -> GameStateType {
        
        return self.gameStateValue
    }
    
    func set(gameState: GameStateType) {
        
        self.gameStateValue = gameState
    }
    
    func numGameTurnActive() -> Int {
        
        var numActive = 0
        for player in self.players {
            
            if player.isAlive() && player.isActive() {
                numActive += 1
            }
        }
        return numActive
    }
    
    func isWaitingForBlockingInput() -> Bool {
        
        return self.waitDiploPlayer != nil
    }
    
    func setWaitingForBlockingInput(of player: AbstractPlayer?) {
        
        self.waitDiploPlayer = player
    }

    private func doTurn() {

        print()
        print("::: TURN \(self.turnsElapsed+1) starts now :::")
        print()
        //CvBarbarians::BeginTurn();

        //doUpdateCacheOnTurn();

        //DoUpdateCachedWorldReligionTechProgress();

        self.updateScore()

        //m_kGameDeals.DoTurn();

        for player in self.players {
            player.prepareTurn(in: self)
        }

        //map.doTurn()

        //GC.GetEngineUserInterface()->doTurn();

        //CvBarbarians::DoCamps();

        //CvBarbarians::DoUnits();
        
        // incrementGameTurn();
        self.turnsElapsed += 1
        
        // Configure turn active status for the beginning of the new turn.
        /*for player in self.players {

            if player.isAlive() && !player.isHuman() {
                print("--- start turn for AI player \(player.leader) ---")
                player.startTurn(in: self)
                
            }
        }*/
        
        // Sequential turns.
        // Activate the <<FIRST>> player we find from the start, human or AI, who wants a sequential turn.
        for player in self.players {

            if player.isAlive() {

                player.startTurn(in: self)
                
                // show stacked messages
                /*if player.isHuman() {
                    self.showMessages()
                }*/
                break
            }
        }
        
        //self.doUnitedNationsCountdown();

        // Victory stuff
        // self.testVictory();

        // Who's Winning every 25 turns (to be un-hardcoded later)
        if let human = self.humanPlayer() {
            
            if human.isAlive() {
            
                if self.turnsElapsed % GameModel.turnFrequency == 0 {
                    // This popup his the sync rand, so beware
                    self.userInterface?.showScreen(screenType: .interimRanking, city: nil)
                }
            }
        }
    }
    
    // https://gaming.stackexchange.com/questions/51233/what-is-the-turn-length-in-civilization
    public func turnYear() -> String {
        
        if self.turnsElapsed <= 250 {
            
            // 4000 BC - 1000 AD: 20 years per turn (total of 250 turns)
            let year = -4000 + (self.turnsElapsed * 20)
            if year < 0 {
                return "\(-year) BC"
            } else if year == 0 {
                return "0 BC"
            } else {
                return "\(year) AD"
            }
            
        } else if self.turnsElapsed <= 300 {
            
            // 1000 AD - 1500 AD: 10 years per turn (total of 50 turns)
            let year = 1000 + (self.turnsElapsed - 250) * 10
            return "\(year) AD"
        } else if self.turnsElapsed <= 350 {
            
            // 1500 AD - 1750 AD: 5 years per turn (total of 50 turns)
            let year = 1500 + (self.turnsElapsed - 300) * 5
            return "\(year) AD"
        } else if self.turnsElapsed <= 400 {
            
            // 1750 AD - 1850 AD: 2 years per turn (total of 50 turns)
            let year = 1750 + (self.turnsElapsed - 350) * 2
            return "\(year) AD"
        } else {
            // 1850 AD - End of game: 1 year per turn (total of 170 to 250 turns)
            let year = 1850 + (self.turnsElapsed - 400) * 1
            return "\(year) AD"
        }
    }
    
    // https://gaming.stackexchange.com/questions/51233/what-is-the-turn-length-in-civilization
    public func totalTurns() -> Int {
        
        /*Chieftan - 2100 AD (total of 650 turns)
        Warlord - 2080 AD (total of 630 turns)
        Prince - 2060 AD (total of 610 turns)
        King - 2040 AD (total of 590 turns)
        Emperor - 2020 AD (total of 570 turns)*/
        switch self.handicap {
            
        case .settler: return 700
        case .chieftain: return 650
        case .warlord: return 630
        case .prince: return 610
        case .king: return 590
        case .emperor: return 570
        case .immortal: return 550
        case .deity: return 530
        }
    }
    
    public func updateTestEndTurn() {
        
        if let activePlayer = self.activePlayer() {
            
            if activePlayer.isTurnActive() {
                
                var blockingNotification: NotificationItem? = nil
                
                // check notifications
                if let notifications = activePlayer.notifications() {
                    
                    blockingNotification = notifications.endTurnBlockingNotification()
                }
                
                if blockingNotification == nil {
                    
                    // No notifications are blocking, check units/cities
                    
                    // promotions
                    
                    for unitRef in self.units(of: activePlayer) {
                    
                        guard let unit = unitRef else {
                            continue
                        }
                        
                        if unit.movesLeft() > 0 {
                            blockingNotification = NotificationItem(type: .unitNeedsOrders, for: activePlayer, message: "Unit needs orders", summary: "Orders needed", at: unit.location)
                        }
                    }
                }
                
                activePlayer.set(blockingNotification: blockingNotification)
            }
        }
    }
    
    func updateTacticalAnalysisMap(for player: AbstractPlayer?) {
        
        self.tacticalAnalysisMapVal.refresh(for: player, in: self)
    }
    
    func updateScore() {
        
        for player in self.players {
            let score = player.score(for: self)
            
            self.rankingData.add(score: score, for: player.leader)
        }
    }

    // MARK: getter

    func militaryStrength(for player: AbstractPlayer) -> Double {

        return Double(player.leader.flavor(for: .offense)) * 27.0 + Double.random(minimum: 0.0, maximum: 5.0) // FIXME
    }

    func cultureStrength(for player: AbstractPlayer) -> Double {

        return Double(player.leader.flavor(for: .culture)) * 14.0 + Double.random(minimum: 0.0, maximum: 5.0) // FIXME
    }
    
    // MARK: city methods
    
    // check if a city (of player or not) is in neighborhood
    public func nearestCity(at pt: HexPoint, of player: AbstractPlayer?) -> AbstractCity? {
        
        return self.map.nearestCity(at: pt, of: player)
    }
    
    public func add(city: AbstractCity?) {

        guard let city = city else {
            fatalError("cant get player techs")
        }
        
        guard let tile = self.tile(at: city.location) else {
            fatalError("cant get tile")
        }
        
        guard let techs = city.player?.techs else {
            fatalError("cant get player techs")
        }
        
        // check feature removal
        var featureRemovalSurplus = 0
        featureRemovalSurplus += tile.productionFromFeatureRemoval(by: .removeForest)
        featureRemovalSurplus += tile.productionFromFeatureRemoval(by: .removeRainforest)
        featureRemovalSurplus += tile.productionFromFeatureRemoval(by: .removeMarsh)
        
        city.changeFeatureProduction(change: Double(featureRemovalSurplus))
        
        tile.set(feature: .none)
        
        self.map.add(city: city)
        self.userInterface?.show(city: city)
        
        // update area around the city
        for pt in city.location.areaWith(radius: 3) {
            if let neighborTile = self.tile(at: pt) {
                self.userInterface?.refresh(tile: neighborTile)
            }
        }
        
        // update eureka
        if !techs.eurekaTriggered(for: .sailing) {
            if self.isCoastal(at: city.location) {
                techs.triggerEureka(for: .sailing)
            }
        }
    }

    public func cities(of player: AbstractPlayer) -> [AbstractCity?] {

        return self.map.cities(for: player)
    }
    
    public func city(at location: HexPoint) -> AbstractCity? {

        return self.map.city(at: location)
    }

    func capital(of player: AbstractPlayer) -> AbstractCity? {

        if let cap = self.map.cities(for: player).first(where: { $0?.isCapital() == true }) {
            return cap
        }

        return nil
    }

    func area(of location: HexPoint) -> HexArea? {

        return self.map.area(of: location)
    }

    // MARK: unit methods

    public func add(unit: AbstractUnit?) {

        self.map.add(unit: unit)
    }

    public func units(of player: AbstractPlayer) -> [AbstractUnit?] {

        return self.map.units(for: player)
    }

    public func unit(at point: HexPoint) -> AbstractUnit? {

        return self.map.unit(at: point)
    }
    
    func remove(unit: AbstractUnit?) {
        
        self.map.remove(unit: unit)
    }

    // MARK: tile methods

    public func valid(point: HexPoint) -> Bool {

        return self.map.valid(point: point)
    }

    public func tile(at point: HexPoint) -> AbstractTile? {

        return self.map.tile(at: point)
    }
    
    public func tile(x: Int, y: Int) -> AbstractTile? {

        return self.map.tile(x: x, y: y)
    }
    
    func terrain(at point: HexPoint) -> TerrainType? {

        return self.map.tile(at: point)?.terrain()
    }

    func river(at point: HexPoint) -> Bool {

        return self.map.river(at: point)
    }

    func homeFront(at point: HexPoint, for player: AbstractPlayer) -> Bool {

        // if plot is not valid, no home front
        if !self.valid(point: point) {
            return false
        }

        // check ownership
        if let tile = self.map.tile(at: point) {
            if tile.owner()?.leader == player.leader {
                return true
            }
        }

        for cityRef in self.cities(of: player) {

            if let city = cityRef {
                if point.distance(to: city.location) < 5 { // AI_DIPLO_PLOT_RANGE_FROM_CITY_HOME_FRONT
                    return true
                }
            }
        }

        return false
    }

    func isCoastal(at point: HexPoint) -> Bool {

        return map.isCoastal(at: point)
    }

    // percentage of size compared standard map
    func mapSizeModifier() -> Int {

        let numberOfTilesStandard = MapSize.standard.numberOfTiles()
        let numberOfTilesMap = self.map.size.numberOfTiles()

        return 100 * numberOfTilesMap / numberOfTilesStandard
    }

    public func mapSize() -> MapSize {

        return self.map.size
    }
    
    public func humanPlayer() -> AbstractPlayer? {
        
        return self.players.first(where: { $0.isHuman() })
    }

    func barbarianPlayer() -> AbstractPlayer? {

        return self.players.first(where: { $0.leader == .barbar })
    }

    func enter(era: EraType, for player: AbstractPlayer?) {
        
        fatalError("niy")
    }
    
    func areas() -> [HexArea] {

        return self.map.areas
    }
    
    func tiles(in area: HexArea) -> [AbstractTile?] {
        
        return area.map({ self.map.tile(at: $0 ) })
    }

    func citySiteEvaluator() -> CitySiteEvaluator {

        return CitySiteEvaluator(map: self.map)
    }

    func isEnemyVisible(at location: HexPoint, for player: AbstractPlayer?) -> Bool {

        return self.visibleEnemy(at: location, for: player) != nil
    }
    
    func visibleEnemy(at location: HexPoint, for player: AbstractPlayer?) -> AbstractUnit? {

        guard let diplomacyAI = player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if let tile = self.tile(at: location) {
            if tile.isVisible(to: player) {
                if let enemyUnit = self.unit(at: location) {
                    if diplomacyAI.isAtWar(with: enemyUnit.player) {
                        return enemyUnit
                    }
                }
            }
        }

        return nil
    }

    func tacticalAnalysisMap() -> TacticalAnalysisMap {
        
        return self.tacticalAnalysisMapVal
    }
    
    public func ignoreUnitsPathfinderDataSource(for movementType: UnitMovementType, for player: AbstractPlayer?) -> PathfinderDataSource {

        return MoveTypeIgnoreUnitsPathfinderDataSource(in: self.map, for: movementType, for: player)
    }
    
    func friendlyCityAdjacent(to point: HexPoint, for player: AbstractPlayer?) -> AbstractCity? {
        
        guard let diplomacyAI = player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        for neighbor in point.neighbors() {
            
            if let city = self.city(at: neighbor) {
            
                if !diplomacyAI.isAtWar(with: city.player) {
                    
                    return city
                }
            }
        }
        
        return nil
    }
    
    func isAdjacentDiscovered(of point: HexPoint, for player: AbstractPlayer?) -> Bool {
        
        for neighbor in point.neighbors() {
            guard let tile = self.map.tile(at: neighbor) else {
                continue
            }
            
            if tile.isDiscovered(by: player) {
                return true
            }
        }
        
        return false
    }
    
    
    func isWithinCityRadius(plot: AbstractTile?, of player: AbstractPlayer?) -> Bool {
        
        guard let player = player else {
            fatalError("cant get player")
        }
        
        guard let plot = plot else {
            fatalError("cant get plot")
        }
        
        let playerCities = self.cities(of: player)
        
        for cityRef in playerCities {
            
            guard let city = cityRef else {
                continue
            }
            
            if plot.point.distance(to: city.location) < City.workRadius {
                return true
            }
        }
        
        return false
    }
    
    func adjacentToLand(point: HexPoint) -> Bool {
        
        if let tile = self.map.tile(at: point) {
            if tile.terrain().isLand() {
                return false
            }
        }
        
        for neighbor in point.neighbors() {
            
            if let neighborTile = self.map.tile(at: neighbor) {
                if neighborTile.terrain().isWater() {
                    return true
                }
            }
        }
        
        return false
    }
    
    func alreadyBuilt(wonder wonderType: WonderType) -> Bool {
    
        guard let wondersBuilt = self.wondersBuilt else {
            fatalError("cant get wondersBuilt")
        }
        
        return wondersBuilt.has(wonder: wonderType)
    }
    
    func calculateInfluenceDistance(from cityLocation: HexPoint, to targetDestination: HexPoint, limit: Int, abc: Bool) -> Int {
    
        let influencePathfinder = AStarPathfinder()
        influencePathfinder.dataSource = InfluencePathfinderDataSource(in: self.map, cityLoction: cityLocation)
        
        if let path = influencePathfinder.shortestPath(fromTileCoord: cityLocation, toTileCoord: targetDestination) {
            return Int(path.cost)
        }
        
        return 0
    }
    
    func conceal(at location: HexPoint, sight: Int, for player: AbstractPlayer?) {
        
        for pt in location.areaWith(radius: sight) {
            
            if let tile = self.tile(at: pt) {
                tile.conceal(to: player)
                self.userInterface?.refresh(tile: tile)
            }
        }
    }
    
    func sight(at location: HexPoint, sight: Int, for player: AbstractPlayer?) {
        
        for pt in location.areaWith(radius: sight) {
            
            if let tile = self.tile(at: pt) {
                tile.sight(by: player)
                tile.discover(by: player)
                self.userInterface?.refresh(tile: tile)
            }
        }
    }
}
