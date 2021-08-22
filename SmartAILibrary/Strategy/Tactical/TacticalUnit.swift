//
//  TacticalUnit.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// Object stored in the list of current move units (currentMoveUnits)
class TacticalUnit: Comparable {

    var attackStrength: Int
    var healthPercent: Int
    var movesToTarget: Int
    var expectedTargetDamage: Int
    var expectedSelfDamage: Int
    var unit: AbstractUnit?

    init(unit: AbstractUnit? = nil, attackStrength: Int = 0, healthPercent: Int = 0) {

        self.attackStrength = attackStrength
        self.healthPercent = healthPercent
        self.movesToTarget = 0
        self.expectedTargetDamage = 0
        self.expectedSelfDamage = 0
        self.unit = unit
    }

    // Derived
    func attackPriority() -> Int {

        return self.attackStrength * self.healthPercent
    }

    static func < (lhs: TacticalUnit, rhs: TacticalUnit) -> Bool {

        return lhs.attackStrength > rhs.attackStrength
    }

    static func == (lhs: TacticalUnit, rhs: TacticalUnit) -> Bool {

        return false
    }
}
