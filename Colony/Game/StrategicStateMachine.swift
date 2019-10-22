//
//  StrategicStateMachine.swift
//  Colony
//
//  Created by Michael Rommel on 09.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

/*
 https://forums.civfanatics.com/threads/real-strategy-ai.640452/
 
 - Ancient - spread, food
 - Classical - more culture, science and food
 - Medieval - more faith, food, prod, less science, more wars
 - Renaissance - less faith and food, more culture and science, less wars, more naval for exploration
 - Industrial - more production, more wars, less faith, less settlers
 - Modern - more gold and culture, bigger armies, more wars, less settlers
 - Atomic - more sci and prod, more air units, less settlers
 - Information - shrink armies, less wars, more gold, less food, less settlers, more air units
 */

enum StrategicAIState {

    case waitingForOrders // initial state
    
    // found colony
    // fight natives
    // take over other civilization
    
    // global
    //case expansion
    
    //case send
    /*case found
    case explore
    case expand*/
}

class StrategicStateMachine: FiniteStateMachine<StrategicAIState> {

    let ai: StrategicAI?

    init(ai: StrategicAI?) {

        self.ai = ai
    }

    override func update() {

        if (self.isEmpty) {
            fatalError("no state")
        }

        guard let (state, _) = self.peek() else {
            fatalError("no state")
        }

        switch (state) {
        case .waitingForOrders:
            self.ai?.doWaitOrders()
            
        /*case .found:
            let target = arg as! HexPoint
            self.ai?.doFound(at: target)
        case .explore:
            //self.ai?.doFollowPath()
        case .expand:
            //let seconds = arg as! TimeInterval
            //self.ai?.doWait(for: seconds)*/
        }
    }
}
