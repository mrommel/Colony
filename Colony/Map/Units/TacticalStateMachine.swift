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
    
    // battle states
    
    /*case AUTO_ATTACK
    case MOVE
    case STOP
    case ATTACK
    case RETURN_POST
    case ATTACK_BACK
    case MOVE_ATTACK
    case HOLD
    case SUPPORT*/
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
            let seconds = arg as! TimeInterval
            self.ai?.doWait(for: seconds)
        case .returnToPost:
            self.ai?.doReturnToPost()
        /*case .AUTO_ATTACK:
            let enemies = arg as! [Unit]
            self.ai?.doAutoAttack(enemies: enemies)
        case .MOVE:
            self.ai?.doMove()
        case .STOP:
            self.ai?.doStop()
        case .ATTACK:
            let target = arg as? Unit
            self.ai?.doAttack(unit: target)
        case .RETURN_POST:
            self.ai?.doReturnPost()
        case .ATTACK_BACK:
            self.ai?.doAttackBack()
        case .WAIT:
            let seconds = arg as! TimeInterval
            self.ai?.doWait(for: seconds)
        case .MOVE_ATTACK:
            self.ai?.doMoveAttack()
        case .HOLD:
            self.ai?.doHold()*/
        }
    }
}
