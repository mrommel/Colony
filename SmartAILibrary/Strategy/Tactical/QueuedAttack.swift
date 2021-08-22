//
//  QueuedAttack.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvQueuedAttack
//!  \brief        A planned attack waiting to execute
//
//!  Key Attributes:
//!  - Arises during processing of CvTacticalAI::ExecuteAttacks() or ProcessUnit()
//!  - Created by calling QueueFirstAttack() or QueueSubsequentAttack()
//!  - Combat animation system calls back into tactical AI when animation completes with call CombatResolved()
//!  - This callback signals it is time to execute the next attack
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class QueuedAttack {

    var attackerUnit: AbstractUnit?
    var attackerCity: AbstractCity?
    var target: TacticalTarget?
    var ranged: Bool
    var cityAttack: Bool
    var seriesId: Int

    init() {
        self.attackerUnit = nil
        self.attackerCity = nil
        self.target = nil
        self.ranged = false
        self.cityAttack = false
        self.seriesId = -1
    }
}
