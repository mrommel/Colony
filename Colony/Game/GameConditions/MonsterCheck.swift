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
        
        guard let playerUnits = self.game?.getAllUnitsOfUser() else {
            fatalError("no player units")
        }
        
        guard let playerCities = self.game?.getAllCitiesOfUser() else {
            fatalError("no player cities")
        }
        
        guard playerUnits.count > 1 else {
            return nil
        }
        
        if let ship = playerUnits.filter({ $0?.unitType == .caravel }).first, let city = playerCities.first {

            if let shipPosition = ship?.position, let cityPosition = city?.position {
                if shipPosition.distance(to: cityPosition) == 1 {
                    return MonsterGameConditionType.cityReached
                }
            }
        }
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        /*guard let enemyUnits = self.game?.getUnitsBy(type: .monster) else {
            fatalError("no monster units")
        }
        
        guard let playerUnits = self.game?.getAllUnitsOfUser() else {
            fatalError("no player units")
        }
        
        if let ship = playerUnits.filter({ $0?.type == .caravel }).first, let monster = enemyUnits.first {
            if let shipPosition = ship?.position, let monsterPosition = monster?.position {
                if shipPosition == monsterPosition {
                    return MonsterGameConditionType.monsterCaughtShip
                }
            }
        }*/
        
        return nil
    }
}
