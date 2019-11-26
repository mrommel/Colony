//
//  Timer30SecondsCheck.swift
//  Colony
//
//  Created by Michael Rommel on 15.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum TimerElapsedConditionType: GameConditionType {
    
    case timeWentOut
    
    var summary: String {
        switch self {
            
        case .timeWentOut:
            return "Time is out."
        }
    }
}

class TurnsElapsedCheck: GameConditionCheck {
    
    var elapsed: Bool = false
    
    override var identifier: String {
        return "TurnsElapsedCheck"
    }
    
    override func isWon() -> GameConditionType? {
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        guard let game = self.game else {
            fatalError("Can't get game")
        }
        
        if game.currentTurn!.currentTurn >= game.maxTurns {
            return TimerElapsedConditionType.timeWentOut
        }
        
        return nil
    }
}
