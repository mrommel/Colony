//
//  Timer30SecondsCheck.swift
//  Colony
//
//  Created by Michael Rommel on 15.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum TimerGameConditionType: GameConditionType {
    
    case timeWentOut
    
    var summary: String {
        switch self {
            
        case .timeWentOut:
            return "Time is out."
        }
    }
}

class TimerElapsedCheck: GameConditionCheck {
    
    override var identifier: String {
        return "TimerElapsedCheck"
    }
    
    override init() {
    }
    
    override func isWon() -> GameConditionType? {
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        guard let timeElapsedInSeconds = self.game?.timeRemainingInSeconds() else {
            fatalError("can't get time elapsed")
        }
        
        if timeElapsedInSeconds < 0 {
            return TimerGameConditionType.timeWentOut
        }
        
        return nil
    }
}
