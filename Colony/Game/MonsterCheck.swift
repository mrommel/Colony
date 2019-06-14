//
//  MonsterCheck.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum MonsterGameConditionType: GameConditionType {
    
    case villageReached
    case monsterCaughtShip
}

class MonsterCheck: GameConditionCheck {

    override var identifier: String {
        return "MonsterCheck"
    }

    override init() {
    }
    
    override func isWon() -> GameConditionType? {
        
        guard let playerUnits = self.gameObjectManager?.unitsOf(tribe: .player) else {
            fatalError("no player units")
        }
        
        guard playerUnits.count == 2 else {
            return nil
        }
        
        if let position0 = playerUnits[0]?.position, let position1 = playerUnits[1]?.position {
            
            if position0.distance(to: position1) == 1 {
                return MonsterGameConditionType.villageReached
            }
        }
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        guard let enemyUnits = self.gameObjectManager?.unitsOf(tribe: .enemy) else {
            fatalError("no enemy units")
        }
        
        guard let playerUnits = self.gameObjectManager?.unitsOf(tribe: .player) else {
            fatalError("no player units")
        }
        
        for enemyUnit in enemyUnits {
            for playerUnit in playerUnits {
                if enemyUnit?.position == playerUnit?.position {
                    return MonsterGameConditionType.monsterCaughtShip
                }
            }
        }
        
        return nil
    }
}
