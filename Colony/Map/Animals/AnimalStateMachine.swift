//
//  AnimalStateMachine.swift
//  Colony
//
//  Created by Michael Rommel on 08.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum AnimalAIState {

    case waitingForOrders // initial state
    
    case wait
    case findPath
    case followPath
}

class AnimalStateMachine: FiniteStateMachine<AnimalAIState> {

    let ai: AnimalAI?

    init(ai: AnimalAI?) {

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
        case .followPath:
            self.ai?.doFollowPath()
        case .wait:
            let seconds = arg as! TimeInterval
            self.ai?.doWait(for: seconds)
        }
    }
}
