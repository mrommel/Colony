//
//  StrategicStateMachine.swift
//  Colony
//
//  Created by Michael Rommel on 09.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum StrategicAIState {

    case waitingForOrders // initial state
    
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

        guard let (state, arg) = self.peek() else {
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
