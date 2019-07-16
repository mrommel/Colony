//
//  MonsterCheck.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum MonsterGameConditionType: GameConditionType {
    
    case cityReached
    case monsterCaughtShip
    
    var summary: String {
        switch self {
            
        case .cityReached:
            return "You have reached the city."
        case .monsterCaughtShip:
            return "Oh. The Monster caught you."
        }
    }
}

class MonsterCheck: GameConditionCheck {

    override var identifier: String {
        return "MonsterCheck"
    }

    override init() {
    }
    
    override func isWon() -> GameConditionType? {
        
        guard let playerUnits = self.game?.level?.gameObjectManager.unitsOf(tribe: .player) else {
            fatalError("no player units")
        }
        
        guard playerUnits.count == 2 else {
            return nil
        }
        
        if let position0 = playerUnits[0]?.position, let position1 = playerUnits[1]?.position {
            
            if position0.distance(to: position1) == 1 {
                return MonsterGameConditionType.cityReached
            }
        }
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        guard let enemyUnits = self.game?.level?.gameObjectManager.unitsOf(tribe: .enemy) else {
            fatalError("no enemy units")
        }
        
        guard let playerUnits = self.game?.level?.gameObjectManager.unitsOf(tribe: .player) else {
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
