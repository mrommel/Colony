//
//  BarbarianArcherUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

internal class BarbarianArcherUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Barbarian Archer",
            baseType: .archer,
            domain: .land,
            effects: [],
            abilities: [.canCapture],
            era: .none,
            requiredResource: nil,
            civilization: .barbarian,
            unitTasks: [.ranged],
            defaultTask: .ranged,
            movementType: .walk,
            productionCost: -1,
            purchaseCost: -1,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 1,
            supportDistance: 2,
            strength: 10,
            targetType: .ranged,
            meleeAttack: 15,
            rangedAttack: 20,
            moves: 2,
            requiredTech: .archery,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
