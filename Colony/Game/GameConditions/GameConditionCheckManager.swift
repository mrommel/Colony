//
//  GameConditionCheckManager.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class GameConditionCheckManager {

    static let shared = GameConditionCheckManager()

    private var gameConditionChecks: [String: GameConditionCheck] = [:]

    var gameConditionCheckIdentifiers: [String] {
        return Array(self.gameConditionChecks.keys)
    }
    
    private init() {
        let monsterCheck = MonsterCheck()
        gameConditionChecks[monsterCheck.identifier] = monsterCheck
        
        let discoverCheck = DiscoverCheck()
        gameConditionChecks[discoverCheck.identifier] = discoverCheck
        
        let timerElapsedCheck = TimerElapsedCheck()
        gameConditionChecks[timerElapsedCheck.identifier] = timerElapsedCheck
    }
    
    func gameConditionCheckFor(identifier: String) -> GameConditionCheck? {
        return gameConditionChecks[identifier]
    }
}