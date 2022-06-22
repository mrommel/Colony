//
//  GrandStrategyAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

/// Information about the Grand Strategy of a single AI player
// swiftlint:disable type_body_length
public class GrandStrategyAI: Codable {

    enum CodingKeys: String, CodingKey {

        case activeStrategy
        case turnActiveStrategySet
        case otherPlayerGuesses
    }

    var activeStrategy: GrandStrategyAIType
    var player: Player?
    var turnActiveStrategySet: Int
    var otherPlayerGuesses: GrandStrategyAIPlayerGuesses

    // MARK: internal classes

    class GrandStrategyAIDict: CustomStringConvertible {

        struct GrandStrategyAIEntry {

            let activeStrategy: GrandStrategyAIType
            var value: Int
        }

        var conquestStrat: GrandStrategyAIEntry
        var cultureStrat: GrandStrategyAIEntry
        var councilStrat: GrandStrategyAIEntry

        init() {
            self.conquestStrat = GrandStrategyAIEntry(activeStrategy: .conquest, value: 0)
            self.cultureStrat = GrandStrategyAIEntry(activeStrategy: .culture, value: 0)
            self.councilStrat = GrandStrategyAIEntry(activeStrategy: .council, value: 0)
        }

        func add(value: Int, for strategy: GrandStrategyAIType) {

            switch strategy {

            case .none:
                // NOOP
                break
            case .conquest:
                self.conquestStrat.value += value
            case .culture:
                self.cultureStrat.value += value
            case .council:
                self.councilStrat.value += value
            }
        }

        func value(for strategy: GrandStrategyAIType) -> Int {

            switch strategy {

            case .none:
                return 0
            case .conquest:
                return self.conquestStrat.value
            case .culture:
                return self.cultureStrat.value
            case .council:
                return self.councilStrat.value
            }
        }

        func maximum() -> GrandStrategyAIEntry {

            var bestStrategy: GrandStrategyAIType = .none
            var bestValue: Int = -1000

            for type in GrandStrategyAIType.all {
                if self.value(for: type) > bestValue {
                    bestValue = self.value(for: type)
                    bestStrategy = type
                }
            }

            return GrandStrategyAIEntry(activeStrategy: bestStrategy, value: bestValue)
        }

        public var description: String {
            return "GradStrategyAIDict:\n- conquest: \(self.conquestStrat.value)\n" +
                "- culture: \(self.cultureStrat.value)\n- council: \(self.councilStrat.value)\n"
        }
    }

    class GrandStrategyAIPlayerGuesses: Codable {

        enum CodingKeys: CodingKey {

            case guesses
        }

        class GrandStrategyAIPlayerGuess: Codable, CustomStringConvertible {

            enum CodingKeys: CodingKey {

                case strategy
                case confidence
            }

            let player: AbstractPlayer?
            var strategy: GrandStrategyAIType
            var confidence: GrandStrategyAIConfidence

            init(player: AbstractPlayer?, strategy: GrandStrategyAIType, confidence: GrandStrategyAIConfidence) {

                self.player = player
                self.strategy = strategy
                self.confidence = confidence
            }

            public required init(from decoder: Decoder) throws {

                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.player = nil
                self.strategy = try container.decode(GrandStrategyAIType.self, forKey: .strategy)
                self.confidence = try container.decode(GrandStrategyAIConfidence.self, forKey: .confidence)
            }

            public func encode(to encoder: Encoder) throws {

                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.strategy, forKey: .strategy)
                try container.encode(self.confidence, forKey: .confidence)
            }

            func update(strategy: GrandStrategyAIType, confidence: GrandStrategyAIConfidence) {

                self.strategy = strategy
                self.confidence = confidence
            }

            public var description: String {

                return "GrandStrategyAIPlayerGuess:\n" +
                    "- player: \(self.player?.leader ?? LeaderType.alexander)\n" +
                    "- strategy: \(self.strategy)\n" +
                    "- confidence: \(self.confidence)\n"
            }
        }

        var guesses: [GrandStrategyAIPlayerGuess]

        init() {
            self.guesses = []
        }

        public required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.guesses = try container.decode([GrandStrategyAIPlayerGuess].self, forKey: .guesses)
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.guesses, forKey: .guesses)
        }

        func guess(for player: AbstractPlayer) -> GrandStrategyAIPlayerGuess? {

            for guess in self.guesses where guess.player?.leader == player.leader {

                return guess
            }

            return nil
        }

        func addOrUpdate(player: AbstractPlayer, strategy: GrandStrategyAIType, confidence: GrandStrategyAIConfidence) {

            if let guess = self.guess(for: player) {
                guess.update(strategy: strategy, confidence: confidence)
            } else {
                self.guesses.append(GrandStrategyAIPlayerGuess(player: player, strategy: strategy, confidence: confidence))
            }
        }
    }

    // MARK: constructors

    init(player: Player?) {

        self.player = player
        self.activeStrategy = .none
        self.turnActiveStrategySet = 0
        self.otherPlayerGuesses = GrandStrategyAIPlayerGuesses()
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.player = nil
        self.activeStrategy = try container.decode(GrandStrategyAIType.self, forKey: .activeStrategy)
        self.turnActiveStrategySet = try container.decode(Int.self, forKey: .turnActiveStrategySet)
        self.otherPlayerGuesses = try container.decode(GrandStrategyAIPlayerGuesses.self, forKey: .otherPlayerGuesses)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.activeStrategy, forKey: .activeStrategy)
        try container.encode(self.turnActiveStrategySet, forKey: .turnActiveStrategySet)
        try container.encode(self.otherPlayerGuesses, forKey: .otherPlayerGuesses)
    }

    func doTurn(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError()
        }

        guard let player = self.player else {
            fatalError()
        }

        self.updatedGuessedActiveStrategy(with: gameModel)

        // hold the score for each strategy
        let dict = GrandStrategyAIDict()

        for type in GrandStrategyAIType.all {

            // Base Priority looks at Personality Flavors (0 - 10) and multiplies * the Flavors attached to a Grand Strategy (0-10),
            // so expect a number between 0 and 100 back from this
            dict.add(value: self.priority(for: type), for: type)

            // real value, based on current game state
            switch type {

            case .none:
                // NOOP
                break
            case .conquest:
                dict.add(value: self.conquestGameValue(with: gameModel), for: .conquest)
            case .culture:
                dict.add(value: self.cultureGameValue(with: gameModel), for: .culture)
            case .council:
                dict.add(value: self.councilGameValue(with: gameModel), for: .council)
            }

            if !Thread.current.isRunningXCTest {

                // random
                dict.add(value: Int.random(number: 50), for: type)
            }

            // make the current strategy most likely
            if type == self.activeStrategy {
                dict.add(value: 50, for: type)
            }
        }

        // Now look at what we think the other players in the game are up to - we might have an opportunity to capitalize somewhere
        var iNumPlayersAliveAndMet = 1

        for playerToCheck in gameModel.players {

            if playerToCheck.isAlive() && playerToCheck.leader != player.leader {
                if player.hasMet(with: playerToCheck) {
                    iNumPlayersAliveAndMet += 1
                }
            }
        }

        // stores the number of player also using this strategy
        let guessedUserDict = GrandStrategyAIDict()

        // Tally up how many players, we think are pusuing each Grand Strategy
        for type in GrandStrategyAIType.all {

            var numberOfPlayersWithStrategy = 0
            for playerToCheck in gameModel.players {

                if self.guessedActiveStrategy(for: playerToCheck) == type {
                    numberOfPlayersWithStrategy += 1
                }
            }

            guessedUserDict.add(value: numberOfPlayersWithStrategy, for: type)
        }

        // Now modify our preferences based on how many people are going for stuff
        for type in GrandStrategyAIType.all {

            var temp = dict.value(for: type) * 50
            temp = temp * guessedUserDict.value(for: type) / iNumPlayersAliveAndMet
            temp /= 100

            dict.add(value: -temp, for: type)
        }

        // print("guessedUserDict: \(guessedUserDict)")
        // print("dict: \(dict)")

        // Now see which Grand Strategy should be active, based on who has the highest Priority right now
        // Grand Strategy must be run for at least 10 turns
        if self.activeStrategy == .none || self.numTurnsSinceActiveStrategySet(turnsElapsed: gameModel.currentTurn) > 10 {

            var bestStrategy: GrandStrategyAIType = .none
            var bestPriority = -1

            for type in GrandStrategyAIType.all {

                if dict.value(for: type) > bestPriority {
                    bestStrategy = type
                    bestPriority = dict.value(for: type)
                }
            }

            if activeStrategy != bestStrategy {
                self.set(activeStrategy: bestStrategy, turnsElapsed: gameModel.currentTurn)
                // inform about change
            }
        }
    }

    // MARK: private methods

    private func set(activeStrategy: GrandStrategyAIType, turnsElapsed: Int) {

        self.turnActiveStrategySet = turnsElapsed
        self.activeStrategy = activeStrategy
    }

    private func numTurnsSinceActiveStrategySet(turnsElapsed: Int) -> Int {

        return turnsElapsed - self.turnActiveStrategySet
    }

    private func priority(for type: GrandStrategyAIType) -> Int {

        var value = 0

        if let leader = self.player?.leader {
            for flavorType in FlavorType.all {
                value += type.flavor(for: flavorType) * leader.flavor(for: flavorType)
            }
        }

        return value
    }

    private func updatedGuessedActiveStrategy(with gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError()
        }

        guard let player = self.player else {
            fatalError()
        }

        var averageMilitaryStrength = 0.0
        var averageCultureStrength = 0.0
        var numberOfPlayersAlive = 0.0

        for playerToCheck in gameModel.players {

            if playerToCheck.isAlive() {
                averageMilitaryStrength += gameModel.militaryStrength(for: playerToCheck)
                averageCultureStrength += gameModel.cultureStrength(for: playerToCheck)
                numberOfPlayersAlive += 1.0
            }
        }

        averageMilitaryStrength /= numberOfPlayersAlive
        averageCultureStrength /= numberOfPlayersAlive

        for playerToCheck in gameModel.players {

            if playerToCheck.leader != player.leader && playerToCheck.isAlive() && player.hasMet(with: playerToCheck) {

                // store the likelyhood of each strategy for this player
                let likeliyDict = GrandStrategyAIDict()

                for type in GrandStrategyAIType.all {

                    var value = 0
                    switch type {
                    case .none:
                        value = 40 // no clue
                    case .conquest:
                        value = self.guessFollowsConquestStrategy(for: playerToCheck, in: gameModel, with: averageMilitaryStrength)
                    case .culture:
                        value = self.guessFollowsCultureStrategy(for: playerToCheck, in: gameModel, with: averageCultureStrength)
                    case .council:
                        value = 23
                    }

                    likeliyDict.add(value: value, for: type)
                }

                let bestStrategyEntry: GrandStrategyAIDict.GrandStrategyAIEntry = likeliyDict.maximum()
                var confidence: GrandStrategyAIConfidence = .none

                if bestStrategyEntry.activeStrategy != .none {
                    if bestStrategyEntry.value >= 120 {
                        confidence = .positive
                    } else if bestStrategyEntry.value >= 70 {
                        confidence = .likely
                    } else {
                        confidence = .unsure
                    }
                }

                self.otherPlayerGuesses.addOrUpdate(player: playerToCheck, strategy: bestStrategyEntry.activeStrategy, confidence: confidence)
            }
        }
    }

    private func guessedActiveStrategy(for player: AbstractPlayer) -> GrandStrategyAIType {

        if let guess = self.otherPlayerGuesses.guess(for: player) {
            return guess.strategy
        }

        return .none
    }

    private func conquestGameValue(with gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError()
        }

        guard let player = self.player else {
            fatalError()
        }

        if !gameModel.victoryTypes.contains(.domination) {
            return -100
        }

        var priority = 0

        priority += player.leader.trait(for: .boldness) * 10

        // How many turns must have passed before we test for having met nobody?
        if gameModel.currentTurn > 20 {
            var metAnybody = false

            for otherPlayer in gameModel.players {

                if otherPlayer.leader == player.leader {
                    continue
                }

                if player.hasMet(with: otherPlayer) {
                    metAnybody = true
                }
            }

            if !metAnybody {
                priority += -50
            }
        }

        // How many turns must have passed before we test for us having a weak military?
        /*if gameModel.turnsElapsed > 60 {
            
            let militaryStrength = gameModel.militaryStrength(for: player)
        }*/

        // If we're at war, then boost the weight a bit
        if player.isAtWar() {
            priority += 10
        }

        return priority
    }

    /// Returns Priority for Culture Grand Strategy
    private func cultureGameValue(with gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError()
        }

        guard let player = self.player else {
            fatalError()
        }

        var priority = 0

        // If Culture Victory isn't even available then don't bother with anything
        if !gameModel.victoryTypes.contains(.cultural) {
            return -100
        }

        // Before tourism kicks in, add weight based on flavor
        let flavorCulture = player.valueOfStrategyAndPersonalityFlavor(of: .culture)
        priority += (10 - player.currentEraVal.rawValue) * flavorCulture * 200 / 100

        // Loop through Players to see how we are doing on Tourism and Culture
        let ourCulture = player.culture(in: gameModel, consume: false)
        let ourTourism = 0 // player->GetCulture()->GetTourism();
        var numCivsBehindCulture = 0
        var numCivsAheadCulture = 0
        var numCivsBehindTourism = 0
        var numCivsAheadTourism = 0
        var numCivsAlive = 0

        for otherPlayer in gameModel.players {

            if otherPlayer.isAlive() /*&& !kPlayer.isMinorCiv()*/ && !otherPlayer.isBarbarian() && otherPlayer.leader != player.leader {

                if ourCulture > otherPlayer.culture(in: gameModel, consume: false) {
                    numCivsAheadCulture += 1
                } else {
                    numCivsBehindCulture += 1
                }

                if ourTourism > 0 /*otherPlayer.GetCulture()->GetTourism()*/ {
                    numCivsAheadTourism += 1
                } else {
                    numCivsBehindTourism += 1
                }

                numCivsAlive += 1
            }
        }

        if numCivsAlive > 0 && numCivsAheadCulture > numCivsBehindCulture {
            priority += (30 /* AI_GS_CULTURE_AHEAD_WEIGHT */ * (numCivsAheadCulture - numCivsBehindCulture) / numCivsAlive)
        }

        if numCivsAlive > 0 && numCivsAheadTourism > numCivsBehindTourism {
            priority += (100 /* AI_GS_CULTURE_TOURISM_AHEAD_WEIGHT */ * (numCivsAheadTourism - numCivsBehindTourism) / numCivsAlive)
        }

        // for every civ we are Influential over increase this
        let numInfluential = 0 // m_pPlayer->GetCulture()->GetNumCivsInfluentialOn();
        priority += numInfluential * 30 /* AI_GS_CULTURE_INFLUENTIAL_CIV_MOD */

        return priority
    }

    /// Returns Priority for United Nations Grand Strategy
    private func councilGameValue(with gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var priority = 0

        // If UN Victory isn't even available then don't bother with anything
        if !gameModel.victoryTypes.contains(.diplomatic) {
            return -100
        }

        // int iNumMinorsAttacked = GET_TEAM(GetPlayer()->getTeam()).GetNumMinorCivsAttacked();
        // iPriority += (iNumMinorsAttacked* /*-30*/ GC.getAI_GRAND_STRATEGY_UN_EACH_MINOR_ATTACKED_WEIGHT());

        let votesNeededToWin = gameModel.votesNeededForDiplomaticVictory()

        let votesControlled = 0
        let votesControlledDelta = 0
        let unalliedCityStates = 0

        // if (GC.getGame().GetGameLeagues()->GetNumActiveLeagues() == 0) {
            // Before leagues kick in, add weight based on flavor
        let flavorDiplo = player.valueOfStrategyAndPersonalityFlavor(of: .diplomacy)
        priority += (10 - player.currentEraVal.rawValue) * flavorDiplo * 150 / 100
        /*} else {
            CvLeague* pLeague = GC.getGame().GetGameLeagues()->GetActiveLeague();
            CvAssert(pLeague != NULL);
            if (pLeague != NULL)
            {
                // Votes we control
                iVotesControlled += pLeague->CalculateStartingVotesForMember(ePlayer);

                // Votes other players control
                int iHighestOtherPlayerVotes = 0;
                for (int iPlayerLoop = 0; iPlayerLoop < MAX_CIV_PLAYERS; iPlayerLoop++)
                {
                    PlayerTypes eLoopPlayer = (PlayerTypes) iPlayerLoop;

                    if(eLoopPlayer != ePlayer && GET_PLAYER(eLoopPlayer).isAlive())
                    {
                        if (GET_PLAYER(eLoopPlayer).isMinorCiv())
                        {
                            if (GET_PLAYER(eLoopPlayer).GetMinorCivAI()->GetAlly() == NO_PLAYER)
                            {
                                iUnalliedCityStates++;
                            }
                        }
                        else
                        {
                            int iOtherPlayerVotes = pLeague->CalculateStartingVotesForMember(eLoopPlayer);
                            if (iOtherPlayerVotes > iHighestOtherPlayerVotes)
                            {
                                iHighestOtherPlayerVotes = iOtherPlayerVotes;
                            }
                        }
                    }
                }

                // How we compare
                iVotesControlledDelta = iVotesControlled - iHighestOtherPlayerVotes;
            }
        }*/

        // Are we close to winning?
        if votesControlled >= votesNeededToWin {
            return 1000
        } else if votesControlled >= ((votesNeededToWin * 3) / 4) {
            priority += 40
        }

        // We have the most votes
        if votesControlledDelta > 0 {
            priority += max(40, votesControlledDelta * 5)
        } else { // We are equal or behind in votes
            // Could we make up the difference with currently unallied city-states?
            let potentialCityStateVotes = unalliedCityStates * 2
            let potentialVotesDelta = potentialCityStateVotes + votesControlledDelta

            if potentialVotesDelta > 0 {
                priority += max(20, potentialVotesDelta * 5)
            } else if potentialVotesDelta < 0 {
                priority += min(-40, potentialVotesDelta * -5)
            }
        }

        // factor in some traits that could be useful (or harmful)
        // priority += player.leader.trait(for: .cityStateFriendshipModifier)
        // priority += player.leader.trait(for: .cityStateBonusModifier)
        // priority -= player.leader.trait(for: .cityStateCombatModifier)

        return priority
    }

    private func guessFollowsConquestStrategy(for player: AbstractPlayer, in gameModel: GameModel?, with averageMilitaryStrength: Double) -> Int {

        guard let gameModel = gameModel else {
            fatalError()
        }

        var followsConquestLikelyhood = 0.0

        // Compare their Military to the world average; Possible range is 100 to -100 (but will typically be around -20 to 20)
        if averageMilitaryStrength > 0.0 {
            followsConquestLikelyhood += (Double(gameModel.militaryStrength(for: player)) - averageMilitaryStrength) * 100.0 / averageMilitaryStrength
        }

        return Int(followsConquestLikelyhood)
    }

    private func guessFollowsCultureStrategy(for player: AbstractPlayer, in gameModel: GameModel?, with averageCultureStrength: Double) -> Int {

        guard let gameModel = gameModel else {
            fatalError()
        }

        if !gameModel.victoryTypes.contains(.cultural) {
            return -100
        }

        var followsCultureLikelyhood = 0.0

        // Compare their Culture to the world average; Possible range is 150 to -150
        if averageCultureStrength > 0.0 {
            followsCultureLikelyhood += (Double(gameModel.cultureStrength(for: player)) - averageCultureStrength) * 150.0 / averageCultureStrength
        }

        // If we're early in the game, reduce the priority
        if gameModel.currentTurn < 50 {
            followsCultureLikelyhood /= 2
        }

        return Int(followsCultureLikelyhood)
    }
}
