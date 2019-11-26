//
//  TacticalStateMachine.swift
//  Colony
//
//  Created by Michael Rommel on 06.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum TacticalAIState {

    case waitingForOrders // initial state
    case wait
    
    // movement states
    case findPath
    case followMission
    case returnToPost
}

class TacticalStateMachine: FiniteStateMachine<TacticalAIState> {

    let ai: TacticalAI?

    init(ai: TacticalAI?) {

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
        case .findPath:
            let target = arg as! HexPoint
            self.ai?.doFindPath(towards: target)
        case .followMission:
            let mission = arg as? Mission
            self.ai?.doFollow(mission: mission)
        case .wait:
            let turns = arg as! Int
            self.ai?.doWait(for: turns)
        case .returnToPost:
            self.ai?.doReturnToPost()
        }
    }
}
