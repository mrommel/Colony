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

class TimerElapsedCheck: GameConditionCheck {
    
    var elapsed: Bool = false
    
    override var identifier: String {
        return "TimerElapsedCheck"
    }
    
    override init() {
        
        super.init()
        
        self.game?.timer?.didStop = { isFinished in
            self.elapsed = isFinished
        }
    }
    
    override func isWon() -> GameConditionType? {
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        if self.elapsed {
            return TimerElapsedConditionType.timeWentOut
        }
        
        return nil
    }
}
