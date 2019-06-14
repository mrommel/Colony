//
//  GameConditionCheckManager.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class GameConditionCheck {

    var identifier: String {
        fatalError("any subclass must override")
    }

    weak var gameObjectManager: GameObjectManager?

    func isWon() -> GameConditionType? {
        fatalError("any subclass must override")
    }
    
    func isLost() -> GameConditionType? {
        fatalError("any subclass must override")
    }
}

class GameConditionCheckManager {

    static let shared = GameConditionCheckManager()

    private var gameConditionChecks: [String: GameConditionCheck] = [:]

    var gameConditionCheckIdentifiers: [String] {
        return Array(self.gameConditionChecks.keys)
    }
    
    private init() {
        let monsterCheck = MonsterCheck()
        gameConditionChecks[monsterCheck.identifier] = monsterCheck
    }
    
    func gameConditionCheckFor(identifier: String) -> GameConditionCheck? {
        return gameConditionChecks[identifier]
    }
}
