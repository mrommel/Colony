//
//  GameModel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import CoreGraphics

class EraHistogram: WeightedList<EraType> {

    override func fill() {

        for era in EraType.all {
            self.add(weight: 0, for: era)
        }
    }
}

enum GameStateType: Int, Codable {

    case on
    case over
    case extended
}

// swiftlint:disable type_body_length
open class GameModel: Codable {

    enum CodingKeys: CodingKey {

        case victoryTypes
        case handicap
        case currentTurn
        case turnSliceValue
        case numProphetsSpawned
        case players
        case religions

        case map
        case wondersBuilt
        case greatPersons

        case gameStateValue
        case rankingData

        case barbarianAI
    }

    let victoryTypes: [VictoryType]
    let handicap: HandicapType
    var currentTurn: Int
    var turnSliceValue: Int = 0
    var numProphetsSpawnedValue: Int = 0
    public let players: [AbstractPlayer]

    static let turnInterimRankingFrequency = 25 /* PROGRESS_POPUP_TURN_FREQUENCY */

    private let map: MapModel
    private let tacticalAnalysisMapVal: TacticalAnalysisMap
    public weak var userInterface: UserInterfaceDelegate?
    private var waitDiploPlayer: AbstractPlayer?
    private var wondersBuilt: AbstractWonders?
    private var religionsVal: AbstractGameReligions?
    private var greatPersons: GreatPersons?

    private var gameStateValue: GameStateType

    public var rankingData: RankingData

    private var barbarianAI: BarbarianAI?

    public init(victoryTypes: [VictoryType], handicap: HandicapType, turnsElapsed: Int, players: [AbstractPlayer], on map: MapModel) {

        self.victoryTypes = victoryTypes
        self.handicap = handicap
        self.currentTurn = turnsElapsed
        self.numProphetsSpawnedValue = 0
        self.players = players
        self.religionsVal = GameReligions()
        self.map = map

        self.tacticalAnalysisMapVal = TacticalAnalysisMap(with: self.map.size)
        self.gameStateValue = .on

        self.wondersBuilt = Wonders(city: nil)
        self.greatPersons = GreatPersons()

        self.rankingData = RankingData(players: players)

        self.map.analyze()

        self.barbarianAI = BarbarianAI(with: self)
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.victoryTypes = try container.decode([VictoryType].self, forKey: .victoryTypes)
        self.handicap = try container.decode(HandicapType.self, forKey: .handicap)
        self.currentTurn = try container.decode(Int.self, forKey: .currentTurn)
        self.turnSliceValue = try container.decode(Int.self, forKey: .turnSliceValue)
        self.numProphetsSpawnedValue = try container.decode(Int.self, forKey: .numProphetsSpawned)
        self.players = try container.decode([Player].self, forKey: .players)
        self.religionsVal = try container.decode(GameReligions.self, forKey: .religions)

        self.map = try container.decode(MapModel.self, forKey: .map)
        self.wondersBuilt = try container.decode(Wonders.self, forKey: .wondersBuilt)
        self.greatPersons = try container.decode(GreatPersons.self, forKey: .greatPersons)

        self.gameStateValue = try container.decode(GameStateType.self, forKey: .gameStateValue)
        self.rankingData = try container.decode(RankingData.self, forKey: .rankingData)

        self.barbarianAI = try container.decode(BarbarianAI.self, forKey: .barbarianAI)

        // setup
        self.tacticalAnalysisMapVal = TacticalAnalysisMap(with: self.map.size)

        self.map.analyze()

        // self.wondersBuilt.player = self

        // init some classes
        for player in self.players {

            for cityRef in map.cities(of: player.leader) {

                guard let city = cityRef else {
                    continue
                }

                guard let cityPlayer = self.player(for: city.leader) else {
                    fatalError("cant get city player: \(city.leader)")
                }

                cityRef?.player = cityPlayer
            }

            for unitRef in map.units(for: player.leader) {

                guard let unit = unitRef else {
                    continue
                }

                guard let unitPlayer = self.player(for: unit.leader) else {
                    fatalError("cant get city player: \(unit.leader)")
                }

                unitRef?.player = unitPlayer
            }
        }

        // set tile ownership
        for x in 0..<self.mapSize().width() {

            for y in 0..<self.mapSize().height() {

                if let tile = self.tile(x: x, y: y) {

                    if tile.ownerLeader() != .none {

                        try tile.set(owner: self.player(for: tile.ownerLeader()))
                    }
                }
            }
        }
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.victoryTypes, forKey: .victoryTypes)
        try container.encode(self.handicap, forKey: .handicap)
        try container.encode(self.currentTurn, forKey: .currentTurn)
        try container.encode(self.turnSliceValue, forKey: .turnSliceValue)
        try container.encode(self.numProphetsSpawnedValue, forKey: .numProphetsSpawned)

        try container.encode(self.players as! [Player], forKey: .players)
        try container.encode(self.religionsVal as! GameReligions, forKey: .religions)

        try container.encode(self.map, forKey: .map)
        try container.encode(self.wondersBuilt as! Wonders, forKey: .wondersBuilt)
        try container.encode(self.greatPersons, forKey: .greatPersons)

        try container.encode(self.gameStateValue, forKey: .gameStateValue)
        try container.encode(self.rankingData, forKey: .rankingData)

        try container.encode(self.barbarianAI, forKey: .barbarianAI)
    }

    public func update() {

        guard let userInterface = self.userInterface else {
            fatalError("no UI")
        }

        if self.isWaitingForBlockingInput() {
            if !userInterface.isShown(screen: .diplomatic) {
                // when diplomatic screen is visible - we can't update
                self.waitDiploPlayer?.doTurnPostDiplomacy(in: self)
                self.setWaitingForBlockingInput(of: nil)
            } else {
                return
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
        if !self.isPaused() {

            //self.updateWar()

            self.updateMoves()

            // And again, the player can change after the automoves and that can pause the game
            if !isPaused() {

                self.updateTimers()

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
            }
        }
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

                            // Activate the next player
                            // This is not done if simultaneous turns is enabled (Networked MP).
                            // In that case, the local human is (should be) the player we just deactivated the turn for
                            // and the AI players will be activated all at once in CvGame::doTurn, once we have received
                            // all the moves from the other human players
                            if !userInterface.isShown(screen: .diplomatic) {

                                player.endTurn(in: self)

                                // If it is a hotseat game and the player is human and is dead, don't advance the player,
                                // we want them to get the defeat screen
                                if player.isAlive() || !player.isHuman() {

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
                                print("Because the diplo screen is blocking, I am bumping this up for player \(player.leader)")
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
                        }

                        let readyUnitsNow = player.countReadyUnits(in: self)

                        // Was a move completed, if so save off which turn slice this was
                        if readyUnitsNow < readyUnitsBeforeMoves {
                            player.setLastSliceMoved(to: self.turnSlice())
                        }

                        if !player.isHuman() && !player.hasBusyUnitOrCity() {

                            if readyUnitsNow == 0 {
                                player.setAutoMoves(to: true)
                            } else {

                                if player.hasReadyUnit(in: self) /*&& !player.GetTacticalAI()->IsInQueuedAttack(pReadyUnit))*/ {
                                    let waitTime = 10

                                    if self.turnSlice() - player.lastSliceMoved() > waitTime {
                                        print("GAME HANG - Please show and send save. Stuck units will have their turn ended so game can advance.")
                                        player.endTurnsForReadyUnits(in: self)
                                    }
                                }
                            }
                        }
                    }

                    if player.isAutoMoves() && (!player.isHuman() || processPlayerAutoMoves) {

                        var repeatAutomoves = false
                        var repeatPassCount = 2 // Prevent getting stuck in a loop

                        repeat {

                            for loopUnitRef in self.units(of: player) {

                                guard let loopUnit = loopUnitRef else {
                                    continue
                                }

                                loopUnit.autoMission(in: self)

                                // Does the unit still have movement points left over?
                                if player.isHuman() && loopUnit.hasCompletedMoveMission(in: self) && loopUnit.canMove() /*&& !loopUnit.isDoingPartialMove()*/ && !loopUnit.isAutomated() {

                                    if player.finishTurnButtonPressed() {

                                        repeatAutomoves = true // Do another pass.

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
                    if !player.finishTurnButtonPressed() && player.isHuman() {

                        if !player.hasBusyUnitOrCity() {

                            player.setEndTurn(to: true, in: self)

                            if player.isEndTurn() {
                                //If the player's turn ended, indicate it in the log.  We only do so when the end turn state has changed to prevent useless log spamming in multiplayer.
                                //NET_MESSAGE_DEBUG_OSTR_ALWAYS("UpdateMoves() : player.setEndTurn(true) called for player " << player.GetID() << " " << player.getName())
                            }
                        } else {
                            // if !player.hasBusyUnitUpdatesRemaining() {
                                // NET_MESSAGE_DEBUG_OSTR_ALWAYS("Received turn complete for player " << player.GetID() << " " << player.getName() << " but there is a busy unit. Forcing the turn to advance")
                                player.setEndTurn(to: true, in: self)
                            // }
                        }
                    }
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
        print("::: TURN \(self.currentTurn + 1) starts now :::")
        print()

        self.barbarianAI?.doTurn(in: self)
        self.religionsVal?.doTurn(in: self)

        //doUpdateCacheOnTurn();

        //DoUpdateCachedWorldReligionTechProgress();

        self.updateScore()

        //m_kGameDeals.DoTurn();

        for player in self.players {
            player.prepareTurn(in: self)
        }

        //map.doTurn()

        //GC.GetEngineUserInterface()->doTurn();

        self.barbarianAI?.doCamps(in: self)

        self.barbarianAI?.doUnits(in: self)

        // incrementGameTurn();
        self.currentTurn += 1

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

                if self.currentTurn % GameModel.turnInterimRankingFrequency == 0 {
                    // This popup is the sync rand, so beware
                    self.userInterface?.showScreen(screenType: .interimRanking, city: nil, other: nil, data: nil)
                }
            }
        }
    }

    func updateTimers() {

        guard self.activePlayer()?.isHuman() ?? false else {
            return
        }

        for player in self.players {

            if player.isAlive() {
                player.updateTimers(in: self)
            }
        }
    }

    // https://gaming.stackexchange.com/questions/51233/what-is-the-turn-length-in-civilization
    public func turnYear() -> String {

        if self.currentTurn <= 250 {

            // 4000 BC - 1000 AD: 20 years per turn (total of 250 turns)
            let year = -4000 + (self.currentTurn * 20)
            if year < 0 {
                return "\(-year) BC"
            } else if year == 0 {
                return "0 BC"
            } else {
                return "\(year) AD"
            }

        } else if self.currentTurn <= 300 {

            // 1000 AD - 1500 AD: 10 years per turn (total of 50 turns)
            let year = 1000 + (self.currentTurn - 250) * 10
            return "\(year) AD"
        } else if self.currentTurn <= 350 {

            // 1500 AD - 1750 AD: 5 years per turn (total of 50 turns)
            let year = 1500 + (self.currentTurn - 300) * 5
            return "\(year) AD"
        } else if self.currentTurn <= 400 {

            // 1750 AD - 1850 AD: 2 years per turn (total of 50 turns)
            let year = 1750 + (self.currentTurn - 350) * 2
            return "\(year) AD"
        } else {
            // 1850 AD - End of game: 1 year per turn (total of 170 to 250 turns)
            let year = 1850 + (self.currentTurn - 400) * 1
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

                var blockingNotification: NotificationItem?

                // check notifications
                if let notifications = activePlayer.notifications() {

                    blockingNotification = notifications.endTurnBlockingNotification()
                }

                if blockingNotification == nil {

                    // No notifications are blocking, check units/cities

                    if activePlayer.hasPromotableUnit(in: self) {
                        // handle promotions
                        if let unit = activePlayer.firstPromotableUnit(in: self) {
                            blockingNotification = NotificationItem(type: .unitPromotion(location: unit.location))
                        }

                    } else if activePlayer.hasReadyUnit(in: self) {
                        // handle units
                        if let unit = activePlayer.firstReadyUnit(in: self) {
                            if !unit.canHold(at: unit.location, in: self) {
                                blockingNotification = NotificationItem(type: .unitNeedsOrders(location: unit.location))
                            } else {
                                blockingNotification = NotificationItem(type: .unitNeedsOrders(location: unit.location))
                            }
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

        self.map.add(city: city, in: self)
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
                techs.triggerEureka(for: .sailing, in: self)
            }
        }
    }

    public func cities(of player: AbstractPlayer) -> [AbstractCity?] {

        return self.map.cities(of: player)
    }

    public func cities(of player: AbstractPlayer, in area: HexArea) -> [AbstractCity?] {

        return self.map.cities(of: player, in: area)
    }

    public func cities(in area: HexArea) -> [AbstractCity?] {

        return self.map.cities(in: area)
    }

    public func city(at location: HexPoint) -> AbstractCity? {

        return self.map.city(at: location)
    }

    public func capital(of player: AbstractPlayer) -> AbstractCity? {

        if let cap = self.map.cities(of: player).first(where: { $0?.isCapital() == true }) {
            return cap
        }

        return nil
    }

    public func findCity(of player: AbstractPlayer, closestTo location: HexPoint) -> AbstractCity? {

        var bestCity: AbstractCity?
        var bestDistance: Int = Int(INT_MAX)

        for cityRef in self.map.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            let distance = location.distance(to: city.location)

            if distance < bestDistance {

                bestDistance = distance
                bestCity = cityRef
            }
        }

        return bestCity
    }

    func area(of location: HexPoint) -> HexArea? {

        return self.map.area(of: location)
    }

    // MARK: unit methods

    public func add(unit: AbstractUnit?) {

        // add some special values
        guard let player = unit?.player else {
            fatalError("cant get player of unit")
        }

        // pyramids
        if player.has(wonder: .pyramids, in: self) && unit?.type == .builder {
            unit?.changeBuildCharges(change: 1)
        }

        self.map.add(unit: unit, in: self)
    }

    public func units(at point: HexPoint) -> [AbstractUnit?] {

        return self.map.units(at: point)
    }

    public func units(with type: UnitType) -> [AbstractUnit?] {

        return self.map.units(with: type)
    }

    public func units(of player: AbstractPlayer) -> [AbstractUnit?] {

        return self.map.units(of: player)
    }

    public func units(of player: AbstractPlayer, at point: HexPoint) -> [AbstractUnit?] {

        return self.map.units(of: player, at: point)
    }

    public func unit(at point: HexPoint, of mapType: UnitMapType) -> AbstractUnit? {

        return self.map.unit(at: point, of: mapType)
    }

    func areUnits(at point: HexPoint) -> Bool {

        return !self.map.units(at: point).isEmpty
    }

    public func numFriendlyUnits(at point: HexPoint, player: AbstractPlayer?, of unitMapType: UnitMapType) -> Int {

        if let unit = self.map.unit(at: point, of: unitMapType) {

            var playerMatches = true

            // FIXME allies
            if let player = player {
                playerMatches = player.isEqual(to: unit.player)
            }

            if playerMatches {
                return 1
            }
        }

        return 0
    }

    func isPrimarilyNaval() -> Bool {

        return false
    }

    func remove(unit: AbstractUnit?) {

        self.map.remove(unit: unit)
    }

    // MARK: tile methods

    public func points() -> [HexPoint] {

        var pointList: [HexPoint] = []
        let mapWidth = self.mapSize().width()
        let mapHeight = self.mapSize().height()

        pointList.reserveCapacity(mapWidth * mapHeight)

        for x in 0..<mapWidth {
            for y in 0..<mapHeight {
                pointList.append(HexPoint(x: x, y: y))
            }
        }

        return pointList
    }

    public func randomLocation() -> HexPoint {

        let x = Int.random(number: self.mapSize().width())
        let y = Int.random(number: self.mapSize().height())
        return HexPoint(x: x, y: y)
    }

    public func valid(point: HexPoint) -> Bool {

        return self.map.valid(point: point)
    }

    public func wrap(point: HexPoint) -> HexPoint {

        return self.map.wrap(point: point)
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

        return self.map.isCoastal(at: point)
    }

    // return a shore / ocean next to this land plot
    func coastalPlotAdjacent(to point: HexPoint) -> AbstractTile? {

        guard let tile = self.map.tile(at: point) else {
            fatalError("cant get tile")
        }

        if tile.isWater() {
            return nil
        }

        let neighbors = point.neighbors().shuffled
        for neighbor in neighbors {

            guard let neighborTile = self.map.tile(at: neighbor) else {
                continue
            }

            if neighborTile.isWater() {
                return neighborTile
            }
        }

        return nil
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

    public func barbarianPlayer() -> AbstractPlayer? {

        return self.players.first(where: { $0.leader == .barbar })
    }

    public func player(for leader: LeaderType) -> AbstractPlayer? {

        return self.players.first(where: { $0.leader == leader })
    }

    func enter(era: EraType, for player: AbstractPlayer?) {

        // https://civilization.fandom.com/wiki/Era_(Civ6)
        // Roads will upgrade when you enter the Classical Era, again when you enter the Industrial Era, and again on entering the Modern Era.
        // not implemented

        // Many policy cards only work for specific eras. When you progress to a more advanced era, you may find that the policies you were using are no longer working, or have indeed been replaced altogether!
        guard let government = player?.government else {
            fatalError("cant get government")
        }

        government.verify(in: self)

        // The price of buying tiles will go up with Individual Eras.
        // not implemented
    }

    // https://forums.civfanatics.com/resources/the-mechanism-of-great-people.26276/
    // World Era= An era that More than 50% (current existing) Civs have entered
    func worldEra() -> EraType {

        let eraHistogram: EraHistogram = EraHistogram()
        eraHistogram.fill()
        var playerCount: Double = 0.0

        for player in self.players {

            if player.isBarbarian() {
                continue
            }

            playerCount += 1.0

            for era in EraType.all {

                if era <= player.currentEra() {
                    eraHistogram.add(weight: 1, for: era)
                }
            }
        }

        var bestEra: EraType = .ancient

        for era in EraType.all {

            if eraHistogram.weight(of: era) >= (playerCount * 0.5) {
                bestEra = era
            }
        }

        return bestEra
    }

    func areas() -> [HexArea] {

        return self.map.areas
    }

    func tiles(in area: HexArea) -> [AbstractTile?] {

        return area.map({ self.map.tile(at: $0) })
    }

    func citySiteEvaluator() -> CitySiteEvaluator {

        return CitySiteEvaluator(map: self.map)
    }

    func isEnemyVisible(at location: HexPoint, for player: AbstractPlayer?, of unitMapType: UnitMapType = .combat) -> Bool {

        return self.visibleEnemy(at: location, for: player, of: unitMapType) != nil
    }

    func visibleEnemy(at location: HexPoint, for player: AbstractPlayer?, of unitMapType: UnitMapType = .combat) -> AbstractUnit? {

        guard let diplomacyAI = player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if let tile = self.tile(at: location) {
            if tile.isVisible(to: player) {
                if let enemyUnit = self.unit(at: location, of: unitMapType) {
                    if diplomacyAI.isAtWar(with: enemyUnit.player) {
                        return enemyUnit
                    }
                }
            }
        }

        return nil
    }

    func visibleEnemyCity(at location: HexPoint, for player: AbstractPlayer?) -> AbstractCity? {

        guard let diplomacyAI = player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if let tile = self.tile(at: location) {
            if tile.isVisible(to: player) {
                if let enemyCity = self.city(at: location) {
                    if diplomacyAI.isAtWar(with: enemyCity.player) {
                        return enemyCity
                    }
                }
            }
        }

        return nil
    }

    func tacticalAnalysisMap() -> TacticalAnalysisMap {

        return self.tacticalAnalysisMapVal
    }

    public func ignoreUnitsPathfinderDataSource(for movementType: UnitMovementType, for player: AbstractPlayer?, unitMapType: UnitMapType, canEmbark: Bool) -> PathfinderDataSource {

        return MoveTypeIgnoreUnitsPathfinderDataSource(in: self.map, for: movementType, for: player, options: MoveTypeIgnoreUnitsOptions(unitMapType: unitMapType, canEmbark: canEmbark))
    }

    public func unitAwarePathfinderDataSource(for movementType: UnitMovementType, for player: AbstractPlayer?, ignoreOwner: Bool = false, unitMapType: UnitMapType, canEmbark: Bool) -> PathfinderDataSource {

        let options = MoveTypeUnitAwareOptions(ignoreSight: true, ignoreOwner: ignoreOwner, unitMapType: unitMapType, canEmbark: canEmbark)

        return MoveTypeUnitAwarePathfinderDataSource(in: self, for: movementType, for: player, options: options)
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

    /// returns true. if one of the adjacent tiles of point is owned by different player than player
    func isAdjacentOwned(of point: HexPoint, otherThan player: AbstractPlayer?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        for neighbor in point.neighbors() {

            guard let tile = self.map.tile(at: neighbor) else {
                continue
            }

            if tile.hasOwner() && !player.isEqual(to: tile.owner()) {
                return true
            }
        }

        return false
    }

    public func isFreshWater(at point: HexPoint) -> Bool {

        return self.map.isFreshWater(at: point)
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

    func build(wonder wonderType: WonderType) {

        guard let wondersBuilt = self.wondersBuilt else {
            fatalError("cant get wondersBuilt")
        }

        do {
            try wondersBuilt.build(wonder: wonderType)
        } catch {
            fatalError("cant get build wonder")
        }
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

    public func sight(at location: HexPoint, sight: Int, for player: AbstractPlayer?) {

        for pt in location.areaWith(radius: sight) {

            if let tile = self.tile(at: pt) {
                tile.sight(by: player)
                tile.discover(by: player, in: self)
                self.userInterface?.refresh(tile: tile)
            }
        }
    }

    func discover(at location: HexPoint, sight: Int, for player: AbstractPlayer?) {

        for pt in location.areaWith(radius: sight) {

            if let tile = self.tile(at: pt) {
                tile.discover(by: player, in: self)
                self.userInterface?.refresh(tile: tile)
            }
        }
    }

    func numTradeRoutes(at point: HexPoint) -> Int {

        // FIXME
        return 0
    }

    func citiesHaveTradeConnection(from fromCityRef: AbstractCity?, to toCityRef: AbstractCity?) -> Bool {

        // FIXME
        return false
    }

    func cost(of greatPersonType: GreatPersonType, for player: AbstractPlayer?) -> Int {

        guard let player = player else {
            fatalError("cant get player")
        }

        // find possible person (with correct type)
        if let greatPersonOfType = self.greatPersons?.current.first(where: { $0.type() == greatPersonType }) {

            // check if there are enough great person points
            if player.currentEra() < greatPersonOfType.era() {
                // If the world's average era is below of the first GP of a new era of a certain type, there's a fixed increase +30% in price
                return greatPersonOfType.cost() * 130 / 100
            } else {
                return greatPersonOfType.cost()
            }
        }

        return -1
    }

    func greatPerson(of greatPersonType: GreatPersonType, points greatPersonPoints: Int, for player: AbstractPlayer?) -> GreatPerson? {

        // find possible person (with correct type)
        if let greatPersonOfType = self.greatPersons?.current.first(where: { $0.type() == greatPersonType }) {

            // check if there are enough great person points
            if self.cost(of: greatPersonType, for: player) <= greatPersonPoints {
                return greatPersonOfType
            }
        }

        return nil
    }

    func invalidate(greatPerson: GreatPerson) {

        self.greatPersons?.invalidate(greatPerson: greatPerson, in: self)
    }

    // MARK: religion methods

    func foundPantheon(for player: AbstractPlayer?, with pantheonType: PantheonType) {

        self.religionsVal?.foundPantheon(for: player, with: pantheonType, in: self)
    }

    func religions() -> [AbstractPlayerReligion?] {

        guard let religions = self.religionsVal else {
            fatalError("cant get religions")
        }

        return religions.religions(in: self)
    }

    func religion(of religionType: ReligionType) -> AbstractPlayerReligion? {

        for player in self.players {

            guard let playerReligion = player.religion else {
                continue
            }

            if playerReligion.currentReligion() == religionType {
                return playerReligion
            }
        }

        return nil
    }

    func numPantheonsCreated() -> Int {

        guard let religions = self.religionsVal else {
            fatalError("cant get religions")
        }

        return religions.numPantheonsCreated(in: self)
    }

    func numReligionFounded() -> Int {

        guard let religions = self.religionsVal else {
            fatalError("cant get religions")
        }

        return religions.religions(in: self).filter({ $0?.currentReligion() != ReligionType.none }).count
    }

    func maxActiveReligions() -> Int {

        return self.mapSize().maxActiveReligions()
    }

    public func availablePantheons() -> [PantheonType] {

        guard let religions = self.religionsVal else {
            fatalError("cant get religions")
        }

        return religions.availablePantheons(in: self)
    }

    /// how much dies the next great prophet cost?
    func costOfNextProphet(includeDiscounts: Bool) -> Int {

        return self.faith(for: self.numProphetsSpawned() + 1)
    }

    /// How much does this prophet cost (recursive)
    private func faith(for greatProphet: Int) -> Int {

        var rtnValue = 0

        if greatProphet >= 1 {
            if greatProphet == 1 {
                rtnValue = 300 /* RELIGION_MIN_FAITH_FIRST_PROPHET */
            } else {
                rtnValue = (25 /*RELIGION_FAITH_DELTA_NEXT_PROPHET */ * (greatProphet - 1)) + self.faith(for: greatProphet - 1)
            }
        }

        return rtnValue
    }

    func numProphetsSpawned() -> Int {

        return self.numProphetsSpawnedValue
    }

    func set(numProphetsSpawned: Int) {

        self.numProphetsSpawnedValue = numProphetsSpawned
    }

    func numReligionsStillToFound() -> Int {

        return self.maxActiveReligions() - self.numReligionFounded()
    }
}

extension GameModel {

    public func contentSize() -> CGSize {

        return self.map.contentSize()
    }

    private func earliestBarbarianReleaseTurn() -> Int {

        return self.handicap.earliestBarbarianReleaseTurn()
    }

    func areBarbariansReleased() -> Bool {

        return self.earliestBarbarianReleaseTurn() <= self.currentTurn
    }

    func doCampAttacked(at point: HexPoint) {

        self.barbarianAI?.doCampAttacked(at: point)
    }

    func doBarbCampCleared(at point: HexPoint) {

        self.barbarianAI?.doBarbCampCleared(at: point)
    }

    // MARK: Statistics

    func numberOfLandPlots() -> Int {

        return self.map.numberOfLandPlots()
    }

    func numberOfWaterPlots() -> Int {

        return self.map.numberOfWaterPlots()
    }

    func loggingEnabled() -> Bool {

        return true
    }

    func aiLoggingEnabled() -> Bool {

        return true
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension GameModel: Equatable {

    public static func == (lhs: GameModel, rhs: GameModel) -> Bool {

        if !lhs.victoryTypes.containsSameElements(as: rhs.victoryTypes) {
            return false
        }

        if lhs.handicap != rhs.handicap {
            return false
        }

        if lhs.currentTurn != rhs.currentTurn {
            return false
        }

        if lhs.map != rhs.map {
            return false
        }

        return true
    }
}
