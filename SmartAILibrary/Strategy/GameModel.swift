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

public enum GameStateType: Int, Codable {

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
        case discoveredContinents
        case wondersBuilt
        case greatPersons

        case gameStateValue
        case gameWinLeaderValue
        case gameWinVictoryValue

        case rankingData
        case replayData

        case barbarianAI

        case spawnedArchaeologySites
        case worldEra

        case showTutorialInfos
    }

    public let victoryTypes: [VictoryType]
    public let handicap: HandicapType
    var currentTurn: Int
    var turnSliceValue: Int = 0
    var numProphetsSpawnedValue: Int = 0
    public let players: [AbstractPlayer]

    static let turnInterimRankingFrequency = 25 /* PROGRESS_POPUP_TURN_FREQUENCY */

    private let map: MapModel
    private var discoveredContinents: [ContinentType] = []
    private let tacticalAnalysisMapVal: TacticalAnalysisMap
    public weak var userInterface: UserInterfaceDelegate?
    private var waitDiploPlayer: AbstractPlayer?
    private var wondersBuilt: AbstractWonders?
    private var religionsVal: AbstractGameReligions?
    private var greatPersons: GreatPersons?

    private var gameStateValue: GameStateType
    private var gameWinLeaderValue: LeaderType?
    private var gameWinVictoryValue: VictoryType?
    private var votesNeededForDiplomaticVictoryValue: Int = 0

    public var rankingData: RankingData
    public var replayData: GameReplay

    private var barbarianAI: BarbarianAI?
    private var spawnedArchaeologySites: Bool
    private var worldEraValue: EraType = .ancient

    private var showTutorialInfosValue: Bool = false

    public init(victoryTypes: [VictoryType], handicap: HandicapType, turnsElapsed: Int, players: [AbstractPlayer], on map: MapModel) {

        // verify input
        guard players.count > 1 else {
            fatalError("at least two players must be part of the game")
        }

        guard let firstPlayer = players.first, firstPlayer.isBarbarian() else {
            fatalError("the first player must be barbarian")
        }

        guard players.count(where: { $0.isBarbarian() }) == 1 else {
            fatalError("only one barbarian player is allowed")
        }

        guard let lastPlayer = players.last, lastPlayer.isHuman() else {
            fatalError("the last player must be human")
        }

        let freeCityPlayer = Player(leader: .freeCities)
        freeCityPlayer.initialize()

        self.victoryTypes = victoryTypes
        self.handicap = handicap
        self.currentTurn = turnsElapsed
        self.numProphetsSpawnedValue = 0
        self.players = [freeCityPlayer] + players
        self.religionsVal = GameReligions()
        self.map = map
        self.discoveredContinents = []

        self.tacticalAnalysisMapVal = TacticalAnalysisMap(with: self.map.size)
        self.gameStateValue = .on
        self.gameWinLeaderValue = nil
        self.gameWinVictoryValue = nil

        self.wondersBuilt = Wonders(city: nil)
        self.greatPersons = GreatPersons()

        self.rankingData = RankingData(players: players)
        self.replayData = GameReplay()
        self.spawnedArchaeologySites = false

        self.map.analyze()

        self.barbarianAI = BarbarianAI(with: self)

        self.doUpdateDiplomaticVictory()

        AStarPathfinderCache.shared.reset()
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
        self.discoveredContinents = try container.decode([ContinentType].self, forKey: .discoveredContinents)
        self.wondersBuilt = try container.decode(Wonders.self, forKey: .wondersBuilt)
        self.greatPersons = try container.decode(GreatPersons.self, forKey: .greatPersons)

        self.gameStateValue = try container.decode(GameStateType.self, forKey: .gameStateValue)
        self.gameWinLeaderValue = try container.decodeIfPresent(LeaderType.self, forKey: .gameWinLeaderValue)
        self.gameWinVictoryValue = try container.decodeIfPresent(VictoryType.self, forKey: .gameWinVictoryValue)

        self.rankingData = try container.decode(RankingData.self, forKey: .rankingData)
        self.replayData = try container.decode(GameReplay.self, forKey: .replayData)

        self.barbarianAI = try container.decode(BarbarianAI.self, forKey: .barbarianAI)

        self.spawnedArchaeologySites = try container.decodeIfPresent(Bool.self, forKey: .spawnedArchaeologySites) ?? false
        self.worldEraValue = try container.decode(EraType.self, forKey: .worldEra)

        self.showTutorialInfosValue = try container.decode(Bool.self, forKey: .showTutorialInfos)

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

        self.doUpdateDiplomaticVictory()

        // sight for embassies & delegations
        for player in self.players {

            for loopPlayer in self.players {

                guard !player.isEqual(to: loopPlayer) else {
                    continue
                }

                guard player.hasMet(with: loopPlayer) else {
                    continue
                }

                if player.hasEmbassy(with: loopPlayer) || player.hasSentDelegation(to: loopPlayer) {

                    guard let capital = self.capital(of: loopPlayer) else {
                        print("cant get capital of other player")
                        continue
                    }
                    self.sight(at: capital.location, sight: 3, for: player)
                }
            }
        }

        AStarPathfinderCache.shared.reset()
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
        try container.encode(self.discoveredContinents, forKey: .discoveredContinents)
        try container.encode(self.wondersBuilt as! Wonders, forKey: .wondersBuilt)
        try container.encode(self.greatPersons, forKey: .greatPersons)

        try container.encode(self.gameStateValue, forKey: .gameStateValue)
        try container.encodeIfPresent(self.gameWinLeaderValue, forKey: .gameWinLeaderValue)
        try container.encodeIfPresent(self.gameWinVictoryValue, forKey: .gameWinVictoryValue)

        try container.encode(self.rankingData, forKey: .rankingData)
        try container.encode(self.replayData, forKey: .replayData)

        try container.encode(self.barbarianAI, forKey: .barbarianAI)

        try container.encode(self.spawnedArchaeologySites, forKey: .spawnedArchaeologySites)
        try container.encode(self.worldEraValue, forKey: .worldEra)

        try container.encode(self.showTutorialInfosValue, forKey: .showTutorialInfos)
    }

    public func seed() -> Int {

        return self.map.seed()
    }

    public func enableTutorials() {

        self.showTutorialInfosValue = true
    }

    public func showTutorialInfos() -> Bool {

        return self.showTutorialInfosValue
    }

    public func update() {

        guard let userInterface = self.userInterface else {
            print("no UI")
            return
        }

        if Thread.isMainThread && !Thread.current.isRunningXCTest {
            print("Warning: GameModel.update() is executed on main thread")
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
            // self.testExtendedGame()
            return
        }

        // self.sendPlayerOptions()

        if self.turnSlice() == 0 && !isPaused() {
            // gDLL->AutoSave(true);
        }

        // If there are no active players, move on to the AI
        if self.numGameTurnActive() == 0 {
            self.doTurn()
        }

        // Check for paused again, the doTurn call might have called something that paused the game and we don't want an update to sneak through
        if !self.isPaused() {

            // self.updateWar()

            self.updateMoves()
        }

        // And again, the player can change after the automoves and that can pause the game
        if !isPaused() {

            self.updateTimers()

            self.updatePlayers(in: self) // slewis added!

            // self.testAlive()

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

    public func activePlayer() -> AbstractPlayer? {

        for player in self.players where player.isAlive() && player.isActive() {
            return player
        }

        return nil
    }

    func updatePlayers(in gameModel: GameModel?) {

        for player in self.players where player.isAlive() && player.isActive() {
            player.updateNotifications(in: gameModel)
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
                if player.turnFinished() || (!player.isHuman() && !player.hasActiveDiplomacyRequests()) {

                    if player.hasProcessedAutoMoves() {

                        var autoMovesComplete = false
                        if !player.hasBusyUnitOrCity() {
                            autoMovesComplete = true

                            // print("+++ GameModel - CheckPlayerTurnDeactivate() : auto-moves complete for \(player.leader.name())")
                        } else {
                            /*if ( gDLL->HasReceivedTurnComplete( player.GetID() ) )
                            {
                                autoMovesComplete = true
                            }*/
                        }

                        if autoMovesComplete {

                            // Activate the next player
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
                                            // the player is alive and also running sequential turns.  they're up!
                                            nextPlayer.startTurn(in: self)
                                            // self.resetTurnTimer(false)

                                            break
                                        }
                                    }
                                }
                            } else {
                                // KWG: This doesn't actually do anything other than print to the debug log
                                print("Because the diplo screen is blocking, I am bumping this up for player \(player.leader)")
                                // changeNumGameTurnActive(1, std::string("Because the diplo screen is blocking I am bumping this up for player ") + getName());
                            }
                        }
                    }
                }
            }
        }
    }

    func updateMoves() {

        var playersToProcess: [AbstractPlayer] = []
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

                // player.checkInitialTurnAIProcessed()
                if player.isActive() && player.isHuman() {
                    playersToProcess.append(player)
                }
            }
        }

        if let player = playersToProcess.first {

            let readyUnitsBeforeMoves = player.countReadyUnits(in: self)

            if player.isAlive() {

                let needsAIUpdate = player.hasUnitsThatNeedAIUpdate(in: self)
                if player.isActive() || needsAIUpdate {

                    if !player.isAutoMoves() || needsAIUpdate {

                        if needsAIUpdate || !player.isHuman() {
                            // ------- this is where the important stuff happens! --------------
                            player.unitUpdate(in: self)
                            // print("updateMoves() : player.unitUpdate() called for player \(player.leader.name())")
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
                                    let waitTime = 5

                                    if self.turnSlice() - player.lastSliceMoved() > waitTime {
                                        print("GAME HANG - Please show and send save. Stuck units will have their turn ended so game can advance.")
                                        // debug
                                        for unitRef in self.units(of: player) {

                                            guard let unit = unitRef else {
                                                continue
                                            }

                                            guard unit.readyToMove() else {
                                                continue
                                            }

                                            print("GAME HANG - unit of \(player.leader.name()) has no orders: \(unit.name()) at \(unit.location)")
                                        }
                                        // debug
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

                                    if player.turnFinished() {

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
                        // if (player.isHuman())

                        // slewis - I changed this to only be the AI because human players should have the tools to deal with this now
                        if !player.isHuman() {

                            for loopUnit in self.units(of: player) {

                                // var moveMe  = false
                                // var numTurnsFortified = loopUnit.fortifyTurns()

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
                        if player.turnFinished() || !player.isHuman() {
                            player.setProcessedAutoMoves(value: true)
                        }
                    }

                    // KWG: This code should go into CheckPlayerTurnDeactivate
                    if !player.turnFinished() && player.isHuman() {

                        if !player.hasBusyUnitOrCity() {

                            player.setEndTurn(to: true, in: self)

                            if player.isEndTurn() {
                                // If the player's turn ended, indicate it in the log.  We only do so when the end turn state has changed to prevent useless log spamming in multiplayer.
                                // NET_MESSAGE_DEBUG_OSTR_ALWAYS("UpdateMoves() : player.setEndTurn(true) called for player " << player.GetID() << " " << player.getName())
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

    public func gameState() -> GameStateType {

        return self.gameStateValue
    }

    func set(gameState: GameStateType) {

        if self.gameStateValue != gameState {

            self.gameStateValue = gameState
            self.userInterface?.update(gameState: gameState)
        }
    }

    public func winnerLeader() -> LeaderType? {

        return self.gameWinLeaderValue
    }

    public func winnerVictory() -> VictoryType? {

        return self.gameWinVictoryValue
    }

#if DEBUG
    public func set(winner: LeaderType, for victoryType: VictoryType) {

        self.gameWinLeaderValue = winner
        self.gameWinVictoryValue = victoryType
    }
#else
    func set(winner: LeaderType, for victoryType: VictoryType) {

        self.gameWinLeaderValue = winner
        self.gameWinVictoryValue = victoryType
    }
#endif

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

        self.humanPlayer()?.resetFinishTurnButtonPressed()

        self.barbarianAI?.doTurn(in: self)
        self.religionsVal?.doTurn(in: self)

        // doUpdateCacheOnTurn();

        // DoUpdateCachedWorldReligionTechProgress();

        self.updateScore()

        // m_kGameDeals.DoTurn();

        for player in self.players {
            player.prepareTurn(in: self)
        }

        // map.doTurn()

        // GC.GetEngineUserInterface()->doTurn();

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

        // self.doUnitedNationsCountdown();

        self.doWorldEra()

        // Victory stuff
        self.doTestVictory()

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

    func updateWorldEra() {

        let eraHistogram: EraHistogram = EraHistogram()
        eraHistogram.fill()
        var playerCount: Double = 0.0

        for player in self.players {

            if player.isBarbarian() || player.isFreeCity() || player.isCityState() {
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

        self.worldEraValue = bestEra
    }

    func doWorldEra() {

        let previousWorldEra = self.worldEraValue

        self.updateWorldEra()

        if previousWorldEra != self.worldEraValue {

            // world era has changed
            // ???

            // invalidate all city state quests
            for player in self.players {

                guard player.isCityState() else {
                    continue
                }

                player.resetQuests(in: self)
            }
        }
    }

    func doTestVictory() {

        if self.winnerVictory() != nil {
            return
        }

        self.doTestScienceVictory()
        self.doTestCultureVictory()
        self.doTestDominationVictory()
        self.doTestReligiousVictory()
        // self.doTestDiplomaticVictory()

        self.doTestScoreVictory()
        self.doTestConquestVictory()
    }

    func doTestScienceVictory() {

        if !self.victoryTypes.contains(.science) {
            return
        }

        if self.winnerVictory() != nil {
            return
        }

        for player in self.players {

            guard player.isMajorAI() || player.isHuman() else {
                continue
            }

            if player.hasScienceVictory(in: self) {

                self.set(winner: player.leader, for: .science)
                self.set(gameState: .over)

                DispatchQueue.main.async {
                    self.userInterface?.showScreen(screenType: .victory, city: nil, other: nil, data: nil)
                }
            }
        }
    }

    // https://forums.civfanatics.com/threads/how-tourism-is-calculated-and-a-culture-victory-made.605199/
    func doTestCultureVictory() {

        if !self.victoryTypes.contains(.cultural) {
            return
        }

        if self.winnerVictory() != nil {
            return
        }

        for player in self.players {

            guard player.isMajorAI() || player.isHuman() else {
                continue
            }

            if player.hasCulturalVictory(in: self) {

                self.set(winner: player.leader, for: .cultural)
                self.set(gameState: .over)

                self.userInterface?.showScreen(screenType: .victory, city: nil, other: nil, data: nil)
            }
        }
    }

    func doTestDominationVictory() {

        if !self.victoryTypes.contains(.domination) {
            return
        }

        if self.winnerVictory() != nil {
            return
        }

        // Calculate who owns the most original capitals by iterating through all civs
        // and finding out who owns their original capital now.
        var numOriginalCapitals: [LeaderType: Int] = [:]
        let playerNum: Int = self.players.filter { $0.isMajorAI() || $0.isHuman() }.count

        for player in self.players {

            guard player.isMajorAI() || player.isHuman() else {
                continue
            }

            if player.originalCapitalLocation() != HexPoint.invalid {

                if let capitalCity = self.city(at: player.originalCapitalLocation()), let capitalOwner = capitalCity.player {

                    // is the current owner the original owner?
                    if !player.isEqual(to: capitalOwner) {

                        numOriginalCapitals[capitalOwner.leader] = (numOriginalCapitals[capitalOwner.leader] ?? 0) + 1
                    }
                }
            }
        }

        for leaderKey in numOriginalCapitals.keys {

            guard let numConqueredCapitals = numOriginalCapitals[leaderKey] else {
                continue
            }

            // own capital cant be conquered
            if numConqueredCapitals + 1 >= playerNum {

                let winnerKey: LeaderType = leaderKey

                self.set(winner: winnerKey, for: .domination)
                self.set(gameState: .over)

                DispatchQueue.main.async {
                    self.userInterface?.showScreen(screenType: .victory, city: nil, other: nil, data: nil)
                }
            }
        }
    }

    func doTestReligiousVictory() {

        if !self.victoryTypes.contains(.religious) {
            return
        }

        if self.winnerVictory() != nil {
            return
        }

        for player in self.players {

            guard player.isMajorAI() || player.isHuman() else {
                continue
            }

            if player.hasReligiousVictory(in: self) {

                self.set(winner: player.leader, for: .religious)
                self.set(gameState: .over)

                self.userInterface?.showScreen(screenType: .victory, city: nil, other: nil, data: nil)
            }
        }
    }

    func doTestScoreVictory() {

        if self.winnerVictory() != nil {
            return
        }

        // game has reached last turn
        if self.currentTurn >= 500 {

            var playerScore: [LeaderType: Int] = [:]

            for player in self.players {

                guard player.isMajorAI() || player.isHuman() else {
                    continue
                }

                playerScore[player.leader] = player.score(for: self)
            }

            // the winner is the player with the highest score
            let winnerKey: LeaderType = playerScore.sortedByValue.reversed()[0].0

            self.set(winner: winnerKey, for: .score)
            self.set(gameState: .over)

            DispatchQueue.main.async {
                self.userInterface?.showScreen(screenType: .victory, city: nil, other: nil, data: nil)
            }
        }
    }

    /// test if only on human or ai player is alive
    func doTestConquestVictory() {

        if self.winnerVictory() != nil {
            return
        }

        var numAlivePlayers: Int = 0
        var winner: LeaderType = .none

        // loop thru all players
        for player in self.players {

            guard player.isMajorAI() || player.isHuman() else {
                continue
            }

            if !player.isAlive() {
                continue
            }

            numAlivePlayers += 1
            winner = player.leader
        }

        // if only one (or none) player is alive - this is defeat
        if numAlivePlayers <= 1 {

            self.set(winner: winner, for: .conquest)
            self.set(gameState: .over)

            DispatchQueue.main.async {
                self.userInterface?.showScreen(screenType: .victory, city: nil, other: nil, data: nil)
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
    public static func yearText(for turn: Int) -> String {

        if turn <= 250 {

            // 4000 BC - 1000 AD: 20 years per turn (total of 250 turns)
            let year = -4000 + (turn * 20)
            if year < 0 {
                return "\(-year) BC"
            } else if year == 0 {
                return "0 BC"
            } else {
                return "\(year) AD"
            }

        } else if turn <= 300 {

            // 1000 AD - 1500 AD: 10 years per turn (total of 50 turns)
            let year = 1000 + (turn - 250) * 10
            return "\(year) AD"
        } else if turn <= 350 {

            // 1500 AD - 1750 AD: 5 years per turn (total of 50 turns)
            let year = 1500 + (turn - 300) * 5
            return "\(year) AD"
        } else if turn <= 400 {

            // 1750 AD - 1850 AD: 2 years per turn (total of 50 turns)
            let year = 1750 + (turn - 350) * 2
            return "\(year) AD"
        } else {
            // 1850 AD - End of game: 1 year per turn (total of 170 to 250 turns)
            let year = 1850 + (turn - 400) * 1
            return "\(year) AD"
        }
    }

    public func turnYear() -> String {

        return GameModel.yearText(for: self.currentTurn)
    }

    public func isStartTurn() -> Bool {

        return self.currentTurn == 0
    }

    public func set(currentTurn: Int) {

        self.currentTurn = currentTurn
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

            if player.isBarbarian() || player.isFreeCity() {
                continue
            }

            let culturePerTurn = player.culture(in: self, consume: false)
            self.rankingData.add(culturePerTurn: culturePerTurn, for: player.leader)

            let goldBalance = player.treasury?.value() ?? 0
            self.rankingData.add(goldBalance: goldBalance, for: player.leader)

            let totalCities = self.cities(of: player).count
            self.rankingData.add(totalCities: totalCities, for: player.leader)

            let totalCitiesFounded = player.numberOfCitiesFounded()
            self.rankingData.add(totalCitiesFounded: totalCitiesFounded, for: player.leader)

            let totalCitiesLost = player.numberOfCitiesLost()
            self.rankingData.add(totalCitiesLost: totalCitiesLost, for: player.leader)

            let totalDistrictsConstructed = self.cities(of: player)
                .map { $0?.districts?.numberOfBuiltDistricts() ?? 0 }
                .reduce(0, +)
            self.rankingData.add(totalDistrictsConstructed: totalDistrictsConstructed, for: player.leader)

            let totalWondersConstructed = self.cities(of: player)
                .map { $0?.wonders?.numberOfBuiltWonders() ?? 0 }
                .reduce(0, +)
            self.rankingData.add(totalWondersConstructed: totalWondersConstructed, for: player.leader)

            let totalBuildingsConstructed = self.cities(of: player)
                .map { $0?.buildings?.numberOfBuildings() ?? 0 }
                .reduce(0, +)
            self.rankingData.add(totalBuildingsConstructed: totalBuildingsConstructed, for: player.leader)

            // ...

            let totalScore = player.score(for: self)
            self.rankingData.add(totalScore: totalScore, for: player.leader)

            let sciencePerTurn = player.science(in: self)
            self.rankingData.add(sciencePerTurn: sciencePerTurn, for: player.leader)

            let faithPerTurn = player.faith(in: self)
            self.rankingData.add(faithPerTurn: faithPerTurn, for: player.leader)

            let totalReligionsFounded = player.religion?.currentReligion() == Optional<ReligionType>.none ? 0 : 1
            self.rankingData.add(totalReligionsFounded: totalReligionsFounded, for: player.leader)

            let totalGreatPeopleEarned = player.greatPeople?.numberOfSpawnedGreatPersons() ?? 0
            self.rankingData.add(totalGreatPeopleEarned: totalGreatPeopleEarned, for: player.leader)

            let totalWarDeclarationsReceived = player.diplomacyAI?.atWarCount() ?? 0
            self.rankingData.add(totalWarDeclarationsReceived: totalWarDeclarationsReceived, for: player.leader)

            let totalPantheonsFounded = player.religion?.pantheon() == Optional<PantheonType>.none ? 0 : 1
            self.rankingData.add(totalPantheonsFounded: totalPantheonsFounded, for: player.leader)
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
    public func nearestCity(at pt: HexPoint, of player: AbstractPlayer?, onSameContinent: Bool = false) -> AbstractCity? {

        return self.map.nearestCity(at: pt, of: player, onSameContinent: onSameContinent)
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

    public func sight(city: AbstractCity?) {

        self.map.sight(city: city, in: self)
    }

    public func conceal(city: AbstractCity?) {

        self.map.conceal(city: city, in: self)
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

    public func city(at x: Int, and y: Int) -> AbstractCity? {

        return self.map.city(at: x, and: y)
    }

    func delete(city: AbstractCity?) {

        self.map.delete(city: city)
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

    func population(of player: AbstractPlayer) -> Int {

        var population = 0

        for cityRef in self.map.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            population += city.population()
        }

        return population
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

    public func units(of player: AbstractPlayer, in area: HexArea) -> [AbstractUnit?] {

        return self.map.units(of: player, in: area)
    }

    public func unit(at point: HexPoint, of mapType: UnitMapType) -> AbstractUnit? {

        return self.map.unit(at: point, of: mapType)
    }

    public func unit(at x: Int, and y: Int, of mapType: UnitMapType) -> AbstractUnit? {

        return self.map.unit(at: x, and: y, of: mapType)
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

    func remove(city: AbstractCity?) {

        self.map.remove(city: city)
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

    public func wrappedX() -> Bool {

        return self.map.wrapX
    }

    public func tile(at point: HexPoint) -> AbstractTile? {

        return self.map.tile(at: point)
    }

    public func tile(x: Int, y: Int) -> AbstractTile? {

        return self.map.tile(x: x, y: y)
    }

    public func tile(at index: Int) -> AbstractTile? {

        return self.map.tile(at: index)
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

    public func freeCityPlayer() -> AbstractPlayer? {

        return self.players.first(where: { $0.leader == .freeCities })
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

        return self.worldEraValue
    }

    func areas() -> [HexArea] {

        return self.map.areas
    }

    func tiles(in area: HexArea) -> [AbstractTile?] {

        return area.map({ self.map.tile(at: $0) })
    }

    public func citySiteEvaluator() -> CitySiteEvaluator {

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

    public func ignoreUnitsPathfinderDataSource(for movementType: UnitMovementType, for player: AbstractPlayer?, unitMapType: UnitMapType, canEmbark: Bool, canEnterOcean: Bool) -> PathfinderDataSource {

        let options = MoveTypeIgnoreUnitsOptions(
            unitMapType: unitMapType,
            canEmbark: canEmbark,
            canEnterOcean: canEnterOcean,
            wrapX: self.map.wrapX
        )
        return MoveTypeIgnoreUnitsPathfinderDataSource(in: self.map, for: movementType, for: player, options: options)
    }

    public func unitAwarePathfinderDataSource(for movementType: UnitMovementType, for player: AbstractPlayer?, ignoreOwner: Bool = false, unitMapType: UnitMapType, canEmbark: Bool, canEnterOcean: Bool) -> PathfinderDataSource {

        let options = MoveTypeUnitAwareOptions(
            ignoreSight: true,
            ignoreOwner: ignoreOwner,
            unitMapType: unitMapType,
            canEmbark: canEmbark,
            canEnterOcean: canEnterOcean,
            wrapX: self.map.wrapX
        )
        return MoveTypeUnitAwarePathfinderDataSource(for: nil, in: self, for: movementType, for: player, options: options)
    }

    public func unitAwarePathfinderDataSource(for unitRef: AbstractUnit?) -> PathfinderDataSource {

        guard let unit = unitRef else {
            fatalError()
        }

        let options = MoveTypeUnitAwareOptions(
            ignoreSight: true,
            ignoreOwner: unit.type.canMoveInRivalTerritory(),
            unitMapType: unit.unitMapType(),
            canEmbark: unit.canEverEmbark(),
            canEnterOcean: unit.player!.canEnterOcean(),
            wrapX: self.map.wrapX
        )

        return MoveTypeUnitAwarePathfinderDataSource(
            for: unit,
            in: self,
            for: unit.movementType(),
            for: unit.player,
            options: options
        )
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

        if cityLocation == targetDestination {
            return 0
        }

        let influencePathfinderDataSource = InfluencePathfinderDataSource(in: self.map, cityLoction: cityLocation)
        let influencePathfinder = AStarPathfinder(with: influencePathfinderDataSource)

        if let path = influencePathfinder.shortestPath(fromTileCoord: cityLocation, toTileCoord: targetDestination) {
            return Int(path.cost)
        }

        return 0
    }

    func conceal(at location: HexPoint, sight: Int, by unitRef: AbstractUnit? = nil, for playerRef: AbstractPlayer?) {

        guard let currentTile = self.tile(at: location) else {
            fatalError("cant get current location")
        }

        let hasSentry: Bool = unitRef?.has(promotion: .sentry) ?? false

        for loopPoint in location.areaWith(radius: sight) {

            if let loopTile = self.tile(at: loopPoint) {

                guard loopTile.canSee(tile: currentTile, for: playerRef, range: sight, hasSentry: hasSentry, in: self) else {
                    continue
                }

                loopTile.conceal(to: playerRef)
                self.userInterface?.refresh(tile: loopTile)
            }
        }
    }

    public func sight(at location: HexPoint, sight: Int, by unitRef: AbstractUnit? = nil, for playerRef: AbstractPlayer?) {

        guard let player = playerRef else {
            fatalError("cant get player")
        }

        guard let currentTile = self.tile(at: location) else {
            fatalError("cant get current location")
        }

        let hasSentry: Bool = unitRef?.has(promotion: .sentry) ?? false

        for areaPoint in location.areaWith(radius: sight) {

            if let tile = self.tile(at: areaPoint) {

                guard tile.canSee(tile: currentTile, for: playerRef, range: sight, hasSentry: hasSentry, in: self) else {
                    continue
                }

                // inform the player about a goody hut
                if tile.has(improvement: .goodyHut) && !tile.isDiscovered(by: player) {

                    player.notifications()?.add(notification: .goodyHutDiscovered(location: areaPoint))
                }

                // inform the player about a barbarian camp
                if tile.has(improvement: .barbarianCamp) && !player.isBarbarianCampDiscovered(at: areaPoint) {

                    player.discoverBarbarianCamp(at: areaPoint)
                }

                // check if tile is on another continent than the (original) capital
                guard let civics = player.civics else {
                    fatalError("cant get civics")
                }

                if let tileContinent: ContinentType = self.continent(at: areaPoint)?.type() {
                    let capitalLocation = player.originalCapitalLocation()
                    if capitalLocation != HexPoint.invalid {
                        if let capitalContinent = self.continent(at: capitalLocation) {
                            if tileContinent != capitalContinent.type() &&
                                capitalContinent.type() != .none &&
                                tileContinent != .none {

                                if !civics.inspirationTriggered(for: .foreignTrade) {
                                    civics.triggerInspiration(for: .foreignTrade, in: self)
                                }
                            }
                        }
                    }
                }

                // found Natural wonder
                let feature = tile.feature()
                if feature.isNaturalWonder() {

                    guard let techs = player.techs else {
                        fatalError("cant get techs")
                    }

                    // check if wonder is discovered by player already
                    if !player.hasDiscovered(naturalWonder: feature) {
                        player.doDiscover(naturalWonder: feature)
                        player.addMoment(of: .discoveryOfANaturalWonder(naturalWonder: feature), in: self)

                        if let unit = unitRef {
                            if unit.type.has(ability: .experienceFromTribal) {
                                // Gains XP when activating Tribal Villages (+5 XP) and discovering Natural Wonders (+10 XP)
                                unit.changeExperience(by: 10, in: self)
                            }
                        }

                        if player.isHuman() {
                            player.notifications()?.add(notification: .naturalWonderDiscovered(location: areaPoint))
                        }
                    }

                    if !techs.eurekaTriggered(for: .astrology) {
                        techs.triggerEureka(for: .astrology, in: self)
                    }
                }

                tile.sight(by: player)
                tile.discover(by: player, in: self)
                player.checkWorldCircumnavigated(in: self)
                self.checkDiscovered(continent: self.continent(at: areaPoint)?.type() ?? ContinentType.none, at: areaPoint, for: player)
                self.userInterface?.refresh(tile: tile)
            }
        }
    }

    func discover(at location: HexPoint, sight: Int, for player: AbstractPlayer?) {

        for pt in location.areaWith(radius: sight) {

            if let tile = self.tile(at: pt) {
                tile.discover(by: player, in: self)
                player?.checkWorldCircumnavigated(in: self)
                self.checkDiscovered(continent: self.continent(at: pt)?.type() ?? ContinentType.none, at: pt, for: player)
                self.userInterface?.refresh(tile: tile)
            }
        }
    }

    /// method to trigger the firstDiscoveryOfANewContinent moment, when player has discovered a new continent before everybody else
    ///
    /// - Parameters:
    ///   - continent: continent to check
    ///   - player: player to trigger the moment for
    public func checkDiscovered(continent continentType: ContinentType, at location: HexPoint, for player: AbstractPlayer?) {

        guard let player = player else {
            fatalError("cant get player")
        }

        if !self.hasDiscovered(continent: continentType) {

            self.markDiscovered(continent: continentType)

            if let continent = self.map.continent(by: continentType) {

                // only trigger discovery of new continent, if player has at least one city
                // this prevents first city triggering this
                if continent.points.count > 8 && !self.cities(of: player).isEmpty {
                    player.addMoment(of: .firstDiscoveryOfANewContinent, in: self)

                    if player.isHuman() {
                        player.notifications()?.add(notification: .continentDiscovered(location: location, continentName: continentType.name()))
                    }
                }
            }
        }
    }

    public func hasDiscovered(continent continentType: ContinentType) -> Bool {

        return self.discoveredContinents.contains(continentType)
    }

    public func markDiscovered(continent continentType: ContinentType) {

        self.discoveredContinents.append(continentType)
    }

    public func resendGoodyHutAndBarbarianCampNotifications() {

        // add barbarian camp / goody hut notifications
        for point in self.points() {

            guard let tile = self.tile(at: point) else {
                continue
            }

            if tile.isVisible(to: self.humanPlayer()) {

                if tile.has(improvement: .barbarianCamp) {

                    self.humanPlayer()?.notifications()?.add(notification: .barbarianCampDiscovered(location: tile.point))

                } else if tile.has(improvement: .goodyHut) {

                    self.humanPlayer()?.notifications()?.add(notification: .goodyHutDiscovered(location: tile.point))
                }
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

    public func cost(of greatPersonType: GreatPersonType, for player: AbstractPlayer?) -> Int {

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

    public func greatPerson(of greatPersonType: GreatPersonType) -> GreatPerson? {

        return self.greatPersons?.current.first(where: { $0.type() == greatPersonType })
    }

    public func greatPerson(of greatPersonType: GreatPersonType, points greatPersonPoints: Int, for player: AbstractPlayer?) -> GreatPerson? {

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

    func isGreatGeneral(type: GreatPerson, of player: AbstractPlayer?, at location: HexPoint, inRange range: Int) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        for unitRef in self.units(of: player) {

            guard let unit = unitRef else {
                continue
            }

            if unit.location.distance(to: location) <= range {
                if unit.greatPerson == type {
                    return true
                }
            }
        }

        return false
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

    public func availableReligions() -> [ReligionType] {

        guard let religions = self.religionsVal else {
            fatalError("cant get religions")
        }

        return religions.availableReligions(in: self)
    }

    public func religionsInUse() -> [ReligionType] {

        guard let religions = self.religionsVal else {
            fatalError("cant get religions")
        }

        return religions.religions(in: self)
            .map { $0?.currentReligion() ?? .none }
            .filter { $0 != .none }
    }

    public func continents() -> [Continent] {

        return self.map.continents
    }

    public func continent(at point: HexPoint) -> Continent? {

        guard let tile = self.tile(at: point) else {
            fatalError("cant get tile at \(point)")
        }

        if let identifier = tile.continentIdentifier() {
            return self.map.continent(by: identifier)
        }

        return nil
    }

    /// check if moment worldsLargestCivilization should trigger
    ///
    /// - Parameter civilization: civilization to check
    /// - Returns:  has the civilization at least 3 more cities than the next biggest civilization
    public func isLargest(player: AbstractPlayer) -> Bool {

        let numPlayerCities = self.cities(of: player).count
        let numAllOtherCities = self.players
            .filter { $0.leader != player.leader }
            .map { self.cities(of: $0).count }
        let numNextBestPlayersCities = numAllOtherCities.max() ?? 0

        return numPlayerCities >= (numNextBestPlayersCities + 3)
    }

    func findStartPlot(of player: AbstractPlayer?) -> HexPoint {

        return self.map.findStartPlot(of: player)
    }

    public func anyHasMoment(of moment: MomentType) -> Bool {

        for player in self.players {
            if player.hasMoment(of: moment) {
                return true
            }
        }

        return false
    }
}

// MARK: 

extension GameModel {

    /// Update diplo victory parameters, such as how many votes are needed to win
    func doUpdateDiplomaticVictory() {

        let votesForHost = 1
        let votesPerCiv = 1
        let votesPerCityState = 1

        /*for (int i = 0; i < GC.getNumLeagueSpecialSessionInfos(); i++)
        {
            LeagueSpecialSessionTypes e = (LeagueSpecialSessionTypes)i;
            CvLeagueSpecialSessionEntry* pInfo = GC.getLeagueSpecialSessionInfo(e);
            CvAssert(pInfo != NULL);
            if (pInfo != NULL)
            {
                if (pInfo->IsUnitedNations())
                {
                    iVotesForHost = pInfo->GetHostDelegates();
                    iVotesPerCiv = pInfo->GetCivDelegates();
                    iVotesPerCityState = pInfo->GetCityStateDelegates();
                }
            }
        }*/

        var civsToCount = 0.0
        let cityStatesToCount = 0.0

        for player in self.players {

            if player.isAlive() {

                /*if (pPlayer->isMinorCiv()) { // Minor civ
                    // Bought out does not count (they are no longer in the pool of teams, cannot be liberated, etc.)
                    if (!pPlayer->GetMinorCivAI()->IsBoughtOut())
                    {
                        if (pPlayer->isAlive())
                        {
                            fCityStatesToCount += 1.0f;
                        }
                        else
                        {
                            fCityStatesToCount += 0.5f;
                        }
                    }
                } else { // Major civ */
                if player.isAlive() {
                    civsToCount += 1.0
                } else {
                    civsToCount += 0.5
                }
                // }
            }
        }

        // Number of delegates needed to win increases the more civs and city-states there are in the game,
        // but these two scale differently since civs' delegates are harder to secure. These functions
        // are based on a logarithmic regression.
        var civVotesPortion = ( 1.443 * log(civsToCount)) + 7.000
        if civVotesPortion < 0.0 {
            civVotesPortion = 0.0
        }

        var cityStateVotesPortion = ( 16.023 * log(cityStatesToCount)) + -13.758
        if cityStateVotesPortion < 0.0 {
            cityStateVotesPortion = 0.0
        }

        var votesToWin: Int = Int(floor(civVotesPortion + cityStateVotesPortion))
        votesToWin = max(votesForHost + votesPerCiv + 1, votesToWin)
        votesToWin = min(votesForHost + (votesPerCiv * Int(civsToCount)) + (votesPerCityState * Int(cityStatesToCount)), votesToWin)

        self.set(votesNeededForDiploVictory: votesToWin)
    }

    /// How many votes are needed to win?
    func set(votesNeededForDiploVictory: Int) {

        if votesNeededForDiploVictory != self.votesNeededForDiplomaticVictory() {

            self.votesNeededForDiplomaticVictoryValue = votesNeededForDiploVictory
        }
    }

    /// How many votes are needed to win?
    func votesNeededForDiplomaticVictory() -> Int {

        return self.votesNeededForDiplomaticVictoryValue
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

    func doBarbCampCleared(by leader: LeaderType, at point: HexPoint) {

        self.barbarianAI?.doBarbCampCleared(by: leader, at: point, in: self)

        // check quests - is there still a camp
        for cityStatePlayer in self.players {

            guard cityStatePlayer.isCityState() else {
                continue
            }

            for loopPlayer in self.players {

                guard !loopPlayer.isBarbarian() && !loopPlayer.isFreeCity() && !loopPlayer.isCityState() else {
                    continue
                }

                if let quest = cityStatePlayer.quest(for: loopPlayer.leader) {
                    if case .destroyBarbarianOutput(location: let location) = quest.type {

                        if location == point && loopPlayer.leader == quest.leader {
                            let cityStatePlayer = self.cityStatePlayer(for: quest.cityState)
                            cityStatePlayer?.obsoleteQuest(by: loopPlayer.leader, in: self)
                        }
                    }
                }
            }
        }

        // reset discovered barbarian camps
        for player in self.players {
            player.forgetDiscoverBarbarianCamp(at: point)
        }
    }

    func countMajorCivilizationsEverAlive() -> Int {

        return self.players.count(where: { $0.isEverAlive() })
    }

    func checkArchaeologySites() {

        if !self.spawnedArchaeologySites {

            self.spawnArchaeologySites()
            self.spawnedArchaeologySites = true
        }
    }

    func spawnArchaeologySites() {

        // we should now have a map of the dig sites
        // turn this map into set of RESOURCE_ARTIFACTS
        let randomLandArtifacts: [ArtifactType] = [
            .ancientRuin,
            .ancientRuin,
            .razedCity,
            .barbarianCamp,
            .barbarianCamp,
            .battleMelee,
            .battleRanged
        ]

        let randomSeaArtifacts: [ArtifactType] = [
            .battleSeaMelee,
            .battleSeaRanged
        ]

        // find how many dig sites we need to create
        let numMajorCivs = self.countMajorCivilizationsEverAlive()
        let minDigSites = 5 /* MIN_DIG_SITES_PER_MAJOR_CIV */ * numMajorCivs
        let maxDigSites = 8 /* MAX_DIG_SITES_PER_MAJOR_CIV */ * numMajorCivs
        let idealNumDigSites = Int.random(minimum: minDigSites, maximum: maxDigSites)

        // 80% land / 20% sea
        let idealNumLandDigSites = idealNumDigSites * 4 / 5
        let idealNumSeaDigSites = idealNumDigSites * 1 / 5

        // find the highest era any player has gotten to
        var highestEra: EraType = .none
        for loopPlayer in self.players {

            // Player not ever alive
            if !loopPlayer.isEverAlive() {
                continue
            }

            if loopPlayer.currentEra() > highestEra {
                highestEra = loopPlayer.currentEra()
            }
        }

        let eraWeights = WeightedList<EraType>()
        var maxEraWeight = 0

        for loopEra in EraType.all {

            if loopEra > highestEra {
                continue
            }

            let weight: Int = highestEra.rawValue - loopEra.rawValue
            eraWeights.add(weight: weight, for: loopEra)
            maxEraWeight += weight
        }

        // find out how many dig sites we have now
        var howManyChosenLandDigSites = 0
        var howManyChosenSeaDigSites = 0

        // fill the historical buffer with the archaeological data
        let gridSize = self.map.numberOfTiles()
        assert(gridSize > 0, "gridSize is zero")
        var historicalDigSites: [ArchaeologicalRecord] = [ArchaeologicalRecord](repeating: ArchaeologicalRecord(), count: gridSize)
        var scratchDigSites: [ArchaeologicalRecord] = [ArchaeologicalRecord](repeating: ArchaeologicalRecord(), count: gridSize)

        for index in 0..<gridSize {

            guard let plot = self.tile(at: index) else {
                continue
            }

            let resource = plot.resource(for: nil)

            if plot.isLand() {

                if plot.isImpassable(for: .walk) {

                    historicalDigSites[index].artifactType = .none
                    historicalDigSites[index].era = .none
                    historicalDigSites[index].leader1 = .none
                    historicalDigSites[index].leader2 = .none

                    // Cannot be an antiquity site if we cannot generate an artifact.
                    if resource == .antiquitySite {
                        plot.set(resource: .none)
                    }
                } else {
                    // If this plot is already marked as an antiquity site, ensure it's populated.
                    if resource == .antiquitySite {

                        if plot.archaeologicalRecord().artifactType == .none {

                            // pick an era before this one
                            let era = eraWeights.chooseFromTopChoices() ?? EraType.ancient

                            // pick a type of artifact
                            let artifact = randomLandArtifacts.randomItem()
                            self.populateDigSite(on: plot, era: era, artifact: artifact)

                            // Record in scratch space for weights.
                            scratchDigSites[index] = plot.archaeologicalRecord()
                        }

                        howManyChosenLandDigSites += 1
                    }

                    historicalDigSites[index] = plot.archaeologicalRecord()
                }
            } else {
                if plot.isImpassable(for: .swim) {

                    historicalDigSites[index].artifactType = .none
                    historicalDigSites[index].era = .none
                    historicalDigSites[index].leader1 = .none
                    historicalDigSites[index].leader2 = .none

                    // Cannot be an antiquity site if we cannot generate an artifact.
                    if resource == .shipwreck {
                        plot.set(resource: .none)
                    }
                } else {
                    // If this plot is already marked as an antiquity site, ensure it's populated.
                    if resource == .shipwreck {

                        if plot.archaeologicalRecord().artifactType == .none {

                            // pick an era before this one
                            let era = eraWeights.chooseFromTopChoices() ?? EraType.ancient

                            // pick a type of artifact
                            let artifact = randomSeaArtifacts.randomItem()
                            self.populateDigSite(on: plot, era: era, artifact: artifact)

                            // Record in scratch space for weights.
                            scratchDigSites[index] = plot.archaeologicalRecord()
                        }

                        howManyChosenLandDigSites += 1
                    }

                    historicalDigSites[index] = plot.archaeologicalRecord()
                }
            }
        }

        // calculate initial weights
        var digSiteWeights: [Int] = [Int](repeating: 0, count: gridSize)
        self.calculateDigSiteWeights(
            gridSize: gridSize,
            historicalDigSites: historicalDigSites,
            scratchDigSites: scratchDigSites,
            digSiteWeights: &digSiteWeights
        )

        // build a weight vector
        let aDigSiteWeights: WeightedList<Int> = WeightedList<Int>()
        var iteration = 0

        // while we are not in the proper range of number of dig sites
        while (howManyChosenLandDigSites < idealNumLandDigSites || howManyChosenSeaDigSites < idealNumSeaDigSites) &&
                iteration < 2 * (idealNumLandDigSites + idealNumSeaDigSites) {

            // populate a weight vector
            aDigSiteWeights.items.removeAll()

            for index in 0..<gridSize where digSiteWeights[index] > 0 {
                aDigSiteWeights.add(weight: digSiteWeights[index], for: index)
            }

            // add the best dig site
            let bestSite: Int = aDigSiteWeights.chooseLargest() ?? 0
            guard let plot = self.map.tile(at: bestSite) else {
                continue
            }

            if plot.isLand() && howManyChosenLandDigSites < idealNumLandDigSites {
                plot.set(resource: .antiquitySite)
                howManyChosenLandDigSites += 1
            } else if plot.isWater() && howManyChosenSeaDigSites < idealNumSeaDigSites {
                plot.set(resource: .shipwreck)
                howManyChosenSeaDigSites += 1
            }

            // if this is not a historical dig site
            if scratchDigSites[bestSite].artifactType == .none {
                // fake the historical data
                // pick an era before this one
                let era = eraWeights.chooseFromTopChoices() ?? EraType.ancient

                // pick a type of artifact
                let artifact = randomLandArtifacts.randomItem()
                self.populateDigSite(on: plot, era: era, artifact: artifact)
            }

            scratchDigSites[bestSite] = plot.archaeologicalRecord()

            // recalculate weights near the chosen dig site (the rest of the world should still be fine)
            let plotPoint: HexPoint = self.map.point(for: bestSite)
            for loopPoint in plotPoint.areaWith(radius: 3) {

                guard self.valid(point: loopPoint) else {
                    continue
                }

                let index = self.map.index(for: loopPoint)
                digSiteWeights[index] = self.calculateDigSiteWeight(
                    at: index,
                    historicalDigSites: historicalDigSites,
                    scratchDigSites: scratchDigSites
                )
            }

            iteration += 1
        }
    }

    private func calculateDigSiteWeights(gridSize: Int, historicalDigSites: [ArchaeologicalRecord], scratchDigSites: [ArchaeologicalRecord], digSiteWeights: inout [Int]) {

        for index in 0..<gridSize {
            digSiteWeights[index] = self.calculateDigSiteWeight(
                at: index,
                historicalDigSites: historicalDigSites,
                scratchDigSites: scratchDigSites
            )
        }
    }

    private func calculateDigSiteWeight(at index: Int, historicalDigSites: [ArchaeologicalRecord], scratchDigSites: [ArchaeologicalRecord]) -> Int {

        var baseWeight = 0

        // if we have not already chosen this spot for a dig site
        if scratchDigSites[index].artifactType == .none {

            baseWeight = historicalDigSites[index].artifactType.rawValue + 1
            baseWeight *= (10 - historicalDigSites[index].era.rawValue)

            guard let plot = self.tile(at: index) else {
                return 0
            }

            // zero this value if this plot has a resource, ice, mountain, or natural wonder
            if plot.resource(for: nil) != .none ||
                (plot.isImpassable(for: .walk) && plot.isImpassable(for: .swim)) ||
                plot.feature().isNaturalWonder() {

                baseWeight = 0
            }

            // if this tile cannot be improved, zero it out
            if baseWeight > 0 && plot.feature() != .none {

                if plot.feature().isNoImprovement() {
                    baseWeight = 0
                }
            }

            // if this tile has a great person improvement, zero it out
            /* if baseWeight > 0 && plot.improvement() != .none {

                if plot.improvement().isCreatedByGreatPerson() {
                    baseWeight = 0
                }
            } */

            if baseWeight > 0 {

                // add a small random factor
                baseWeight += 10 + Int.random(maximum: 10)

                // increase the value if unowned
                baseWeight *= plot.hasOwner() ? 9 : 8
                baseWeight /= 8

                // lower the value if owned by a major
                baseWeight *= /*(pPlot->getOwner() > NO_PLAYER && pPlot->getOwner() < MAX_MAJOR_CIVS) ? 11 : 12;*/ 11
                baseWeight /= 12

                // lower the value if tile has been improved
                baseWeight *= plot.improvement() != .none ? 7 : 8
                baseWeight /= 8

                // lower the value if tile has a city
                baseWeight *= plot.isCity() ? 1 : 5
                baseWeight /= 5

                // increase the value if in thematic terrain (desert, jungle, or small island)
                baseWeight *= plot.terrain() == .desert ? 3 : 2
                baseWeight *= plot.feature() == .rainforest ? 3 : 2
                let area = self.area(of: plot.point)
                baseWeight *= area?.size ?? 0 <= 4 ? 3 : 2

                // lower the value by number of neighbors
                var divisor = 1

                // lower the value if there is at least one nearby site (say, 3 tiles distance)
                for loopPoint in plot.point.areaWith(radius: 3) {

                    guard self.valid(point: loopPoint) else {
                        continue
                    }

                    if scratchDigSites[self.map.index(for: loopPoint)].artifactType != .none {
                        divisor += 1
                    }
                }

                for loopPoint in plot.point.areaWith(radius: 2) {

                    guard self.valid(point: loopPoint) else {
                        continue
                    }

                    if scratchDigSites[self.map.index(for: loopPoint)].artifactType != .none {
                        divisor += 1
                    }
                }

                for loopPoint in plot.point.areaWith(radius: 1) {

                    guard self.valid(point: loopPoint) else {
                        continue
                    }

                    if scratchDigSites[self.map.index(for: loopPoint)].artifactType != .none {
                        divisor += 1
                    }
                }

                baseWeight /= divisor
            }
        }

        return baseWeight
    }

    private func populateDigSite(on tile: AbstractTile, era: EraType, artifact: ArtifactType) {

        let digSite: ArchaeologicalRecord = ArchaeologicalRecord()

        digSite.artifactType = artifact
        digSite.era = era

        // find nearest city (preferably on same area)
        var nearestCity: AbstractCity? = self.nearestCity(at: tile.point, of: nil, onSameContinent: true)

        if nearestCity == nil {
            nearestCity = self.nearestCity(at: tile.point, of: nil, onSameContinent: false)
        }

        // expand search if we need to
        if let city = nearestCity {

            digSite.leader1 = city.originalLeader()
        } else {
            //  we can't find a nearby city (likely a late era start)

            digSite.leader1 = self.players.map { $0.leader }.randomItem()
            // look for nearby units
            /*CvUnit* pUnit = theMap.findUnit(iPlotX, iPlotY);
            if (pUnit)
            {
                digSite.m_ePlayer1 = pUnit->GetOriginalOwner();
            }
            else
            {
                // look for the start location if it exists
                PlayerTypes thisPlayer;
                if (theMap.findNearestStartPlot(iPlotX, iPlotY, thisPlayer))
                {
                    digSite.m_ePlayer1 = thisPlayer;
                }
                else // just make something up
                {
                    PlayerTypes ePlayer2 = GetRandomMajorPlayer(&kPlot);
                    digSite.m_ePlayer1 = ePlayer2 == NO_PLAYER ? BARBARIAN_PLAYER : ePlayer2;
                }
            }*/
        }

        if artifact == .battleMelee || artifact == .battleRanged || artifact == .razedCity {

            digSite.leader2 = self.players.map { $0.leader }.randomItem()
        }

        tile.addArchaeologicalRecord(
            with: digSite.artifactType,
            era: digSite.era,
            leader1: digSite.leader1,
            leader2: digSite.leader2
        )
    }

    // MARK: envoys

    /// get player for `cityState`
    ///
    /// - Parameter cityState: city state to get the player for
    /// - Returns: player for `cityState`
    public func cityStatePlayer(for cityState: CityStateType) -> AbstractPlayer? {

        return self.players.first(where: { player in
            if case .cityState(type: let cityStateType) = player.leader {
                return cityStateType == cityState
            }

            return false
        })
    }

    /// number of major players / civilization the have met a certain `cityState`
    ///
    /// - Parameter cityState: city state to get the number of 
    /// - Returns: number of major players that have met the `cityState`
    public func countMajorCivilizationsMet(with cityState: CityStateType) -> Int {

        var numCivs = 0

        guard let cityStatePlayer = self.cityStatePlayer(for: cityState) else {
            fatalError("cant get player for city state: \(cityState)")
        }

        for player in self.players {

            guard !player.isBarbarian() && !player.isFreeCity() && !player.isCityState() else {
                continue
            }

            if player.hasMet(with: cityStatePlayer) {
                numCivs += 1
            }
        }

        return numCivs
    }

    /// get the player that has the most envoy for a given `cityState`
    ///
    /// - Parameter cityState: city state to get the player with the most envoys for
    /// - Returns: player with the most envoys or nil if two have the same amount of envoys
    func playerWithMostEnvoys(in cityState: CityStateType) -> AbstractPlayer? {

        var bestPlayer: AbstractPlayer?
        var bestEnvoys: Int = 0

        for player in self.players {

            let envoys = player.envoysAssigned(to: cityState)
            if envoys > bestEnvoys {
                bestPlayer = player
                bestEnvoys = envoys
            } else if envoys == bestEnvoys {
                // when more than one player have the same amount of envoys in a city state - no one is suzerain
                bestPlayer = nil
            }
        }

        return bestPlayer
    }

    // MARK: gossip

    func sendGossip(type: GossipItemType, of player: AbstractPlayer?) {

        guard let humanPlayer = self.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let humanPlayerDiplomacyAI = humanPlayer.diplomacyAI else {
            fatalError("cant get human player diplomacyAI")
        }

        // when the gossip event is triggered by human, dont send
        guard !humanPlayer.isEqual(to: player) else {
            return
        }

        // only send gossip to human player, if he has met player
        guard humanPlayer.hasMet(with: player) else {
            return
        }

        let accessLevel: AccessLevel = humanPlayerDiplomacyAI.accessLevel(towards: player)

        // check that this information is accessible to the human player
        guard type.accessLevel() <= accessLevel else {
            return
        }

        let gossipSource: GossipSourceType = .spy // todo: humanPlayer.gossipSource(of: player)

        let gossipItem = GossipItem(
            type: type,
            turn: self.currentTurn,
            source: gossipSource
        )

        humanPlayerDiplomacyAI.addGossip(item: gossipItem, for: player)
    }

    // MARK: Statistics

    /// number of land tiles
    ///
    /// - Returns: number of land tiles
    func numberOfLandPlots() -> Int {

        return self.map.numberOfLandPlots()
    }

    /// number of water / ocean tiles
    ///
    /// - Returns: number of water / ocean tiles
    func numberOfWaterPlots() -> Int {

        return self.map.numberOfWaterPlots()
    }

    /// number of tiles that fullfils the `condition`
    ///
    /// - Parameter condition: condition that is checked for every tile
    /// - Returns: number of tiles that fulls the `condition`
    func numberOfPlots(where condition: (AbstractTile?) -> Bool) -> Int {

        return self.map.points()
            .map { self.tile(at: $0) }
            .count(where: condition)
    }

    func loggingEnabled() -> Bool {

        return true
    }

    func aiLoggingEnabled() -> Bool {

        return false
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

extension GameModel {

    func addReplayEvent(type: GameReplayEventType, message: String, at point: HexPoint) {

        self.replayData.addReplayEvent(
            type: type,
            message: message,
            at: point,
            turn: self.currentTurn
        )
    }
}
