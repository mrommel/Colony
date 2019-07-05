//
//  Game.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol GameUpdateDelegate {
    func update(time: TimeInterval)
    func update(coins: Int)
}

class Game {

    let level: Level?

    var startTime: TimeInterval = 0.0
    var timer: Timer? = nil
    
    var coins: Int = 0
    
    let gameUsecase: GameUsecase?

    // game condition
    private var conditionChecks: [GameConditionCheck] = []
    var conditionCheckIdentifiers: [String] {
        return self.conditionChecks.map { $0.identifier }
    }

    var conditionDelegate: GameConditionDelegate?
    var gameUpdateDelegate: GameUpdateDelegate?

    init(with level: Level?) {

        self.level = level
        self.gameUsecase = GameUsecase()

        if let gameConditionCheckIdentifiers = self.level?.gameConditionCheckIdentifiers {
            for identifier in gameConditionCheckIdentifiers {
                if let gameConditionCheck = GameConditionCheckManager.shared.gameConditionCheckFor(identifier: identifier) {
                    self.add(conditionCheck: gameConditionCheck)
                    print("- added \(gameConditionCheck.identifier)")
                }
            }
        }
        
        self.level?.gameObjectManager.gameObservationDelegate = self
    }

    deinit {
        self.cancelTimer()
    }

    func start() {
        print("start timer")

        // save start time
        self.startTime = Date().timeIntervalSince1970

        // start timer to check for conditions ever 1 seconds
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            self.gameUpdateDelegate?.update(time: self.timeElapsedInSeconds())
            self.checkCondition()
            
            //
            self.level?.gameObjectManager.update(in: self)
        }
        
        self.level?.gameObjectManager.setup()
    }
    
    func cancelTimer() {
        if let timer = self.timer {
            timer.invalidate()
        }
    }

    func timeElapsedInSeconds() -> TimeInterval {
        let current = Date().timeIntervalSince1970
        return current - self.startTime
    }

    func add(conditionCheck: GameConditionCheck) {

        conditionCheck.game = self
        conditionChecks.append(conditionCheck)
    }

    func checkCondition() {

        for conditionCheck in self.conditionChecks {
            if let type = conditionCheck.isWon() {
                self.conditionDelegate?.won(with: type)
                self.cancelTimer()
            }

            if let type = conditionCheck.isLost() {
                self.conditionDelegate?.lost(with: type)
                self.cancelTimer()
            }
        }
    }
    
    func saveScore() {
        
        guard let level = self.level else {
            return
        }
        
        let score = self.coins
        let levelScore = level.score(for: score)
        
        self.gameUsecase?.set(score: Int32(score), levelScore: levelScore, for: Int32(level.number))
    }
}

extension Game: GameObservationDelegate {
    
    func updated() {
        self.checkCondition()
    }
    
    func coinConsumed() {
        self.coins += 1
        
        self.gameUpdateDelegate?.update(coins: self.coins)
    }
}
