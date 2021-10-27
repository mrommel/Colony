//
//  BarbarianWarriorUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

internal class BarbarianWarriorUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Barbarian Warrior",
            baseType: .warrior,
            domain: .land,
            effects: [],
            abilities: [.canCapture],
            era: .none,
            requiredResource: nil,
            civilization: .barbarian,
            unitTasks: [.attack],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: -1,
            purchaseCost: -1,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .melee,
            meleeAttack: 15,
            rangedAttack: 0,
            moves: 2,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
