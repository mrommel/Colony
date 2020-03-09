//
//  GrandStrategyAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

/// Information about the Grand Strategy of a single AI player
class GrandStrategyAI {

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
            return "GradStrategyAIDict:\n- conquest: \(self.conquestStrat.value)\n- culture: \(self.cultureStrat.value)\n- council: \(self.councilStrat.value)\n"
        }
    }
    
    class GrandStrategyAIPlayerGuesses {

        struct GrandStrategyAIPlayerGuess: CustomStringConvertible {

            let player: AbstractPlayer?
            var strategy: GrandStrategyAIType
            var confidence: GrandStrategyAIConfidence
            
            mutating func update(strategy: GrandStrategyAIType, confidence: GrandStrategyAIConfidence) {
                self.strategy = strategy
                self.confidence = confidence
            }
            
            public var description: String {
                return "GrandStrategyAIPlayerGuess:\n- player: \(self.player?.leader ?? LeaderType.alexander)\n- strategy: \(self.strategy)\n- confidence: \(self.confidence)\n"
            }
        }
        
        var guesses: [GrandStrategyAIPlayerGuess]
        
        init() {
            self.guesses = []
        }
        
        func guess(for player: AbstractPlayer) -> GrandStrategyAIPlayerGuess? {
        
            for guess in self.guesses {
                if guess.player?.leader == player.leader {
                    return guess
                }
            }
            
            return nil
        }
        
        func addOrUpdate(player: AbstractPlayer, strategy: GrandStrategyAIType, confidence: GrandStrategyAIConfidence) {
            
            if var guess = self.guess(for: player) {
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

    func turn(with gameModel: GameModel?) {

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

            // random
            dict.add(value: Int.random(number: 50), for: type)

            // make the current strategy most likely
            if type == self.activeStrategy {
                dict.add(value: 50, for: type)
            }
        }
        
        // print("dict: \(dict)")
        
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
        
            var numOfPlayersWithStrategy = 0
            for playerToCheck in gameModel.players {
            
                if self.guessedActiveStrategy(for: playerToCheck) == type {
                    numOfPlayersWithStrategy += 1
                }
            }
            
            guessedUserDict.add(value: numOfPlayersWithStrategy, for: type)
        }
        
        // Now modify our preferences based on how many people are going for stuff
        for type in GrandStrategyAIType.all {
            var tmp = dict.value(for: type) * 50
            tmp = tmp * guessedUserDict.value(for: type) / iNumPlayersAliveAndMet
            tmp /= 100
            
            dict.add(value: -tmp, for: type)
        }
        
        // Now see which Grand Strategy should be active, based on who has the highest Priority right now
        // Grand Strategy must be run for at least 10 turns
        if self.activeStrategy == .none || self.numTurnsSinceActiveStrategySet(turnsElapsed: gameModel.turnsElapsed) > 10 {
        
            var bestStrategy: GrandStrategyAIType = .none
            var bestPriority = -1
            
            for type in GrandStrategyAIType.all {
                
                if dict.value(for: type) > bestPriority {
                    bestStrategy = type
                    bestPriority = dict.value(for: type)
                }
            }
            
            if activeStrategy != bestStrategy {
                self.set(activeStrategy: bestStrategy, turnsElapsed: gameModel.turnsElapsed)
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

        var val = 0

        if let leader = self.player?.leader {
            for flavorType in FlavorType.all {
                val += type.flavor(for: flavorType) * leader.flavor(for: flavorType)
            }
        }

        return val
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
        var numOfPlayersAlive = 0.0
        
        for playerToCheck in gameModel.players {
            
            if playerToCheck.isAlive() {
                averageMilitaryStrength += gameModel.militaryStrength(for: playerToCheck)
                averageCultureStrength += gameModel.cultureStrength(for: playerToCheck)
                numOfPlayersAlive += 1.0
            }
        }
        
        averageMilitaryStrength /= numOfPlayersAlive
        averageCultureStrength /= numOfPlayersAlive
        
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
        if gameModel.turnsElapsed > 20 {
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
    
    private func cultureGameValue(with gameModel: GameModel?) -> Int {
        return 34 // FIXME
    }
    
    private func councilGameValue(with gameModel: GameModel?) -> Int {
        return 24 // FIXME
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
        if gameModel.turnsElapsed < 50 {
            followsCultureLikelyhood /= 2
        }
        
        return Int(followsCultureLikelyhood)
    }
}
