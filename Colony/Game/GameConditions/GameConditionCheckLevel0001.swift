//
//  MonsterCheck.swift
//  Colony
//
//  Created by Michael Rommel on 13.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum GameConditionTypeLevel0001: GameConditionType {
    
    case cityReachedFirst
    case cityReachedLast
    
    var summary: String {
        switch self {
            
        case .cityReachedFirst:
            return "You have reached the city as first."
        case .cityReachedLast:
            return "An enemy was faster."
        }
    }
}

class GameConditionCheckLevel0001: GameConditionCheck {

    let positionOfLondon = HexPoint(x: 20, y: 13)
    
    override var identifier: String {
        return "Level0001Check"
    }

    override init() {
    }
    
    override func isWon() -> GameConditionType? {
        
        guard let playerUnits = self.game?.getAllUnitsOfUser() else {
            return nil
        }
        
        if let ship = playerUnits.filter({ $0?.unitType == .caravel }).first {

            if let shipPosition = ship?.position {
                if shipPosition.distance(to: positionOfLondon) == 1 {
                    return GameConditionTypeLevel0001.cityReachedFirst
                }
            }
        }
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        guard let aiUnits = self.game?.getAllUnitsOfAI() else {
            return nil
        }
        
        if let aiShip = aiUnits.filter({ $0?.unitType == .caravel }).first {
            if let aiShipPosition = aiShip?.position {
                if aiShipPosition.distance(to: positionOfLondon) == 1 {
                    return GameConditionTypeLevel0001.cityReachedLast
                }
            }
        }
        
        return nil
    }
}
