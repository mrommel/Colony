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

class Timer30SecondsCheck: GameConditionCheck {
    
    override var identifier: String {
        return "Timer30SecondsCheck"
    }
    
    override init() {
    }
    
    override func isWon() -> GameConditionType? {
        
        return nil
    }
    
    override func isLost() -> GameConditionType? {
        
        guard let timeElapsedInSeconds = self.game?.timeElapsedInSeconds() else {
            fatalError("can't get time elapsed")
        }
        
        if timeElapsedInSeconds > 30 {
            return TimerGameConditionType.timeWentOut
        }
        
        return nil
    }
}
