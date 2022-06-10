//
//  SettlerUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Settler_(Civ6)
internal class SettlerUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_SETTLER_NAME",
            baseType: .settler,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_SETTLER_EFFECT1",
                "TXT_KEY_UNIT_SETTLER_EFFECT2"
            ],
            abilities: [.canFound],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.settle],
            defaultTask: .settle,
            movementType: .walk,
            productionCost: 80,
            purchaseCost: 320,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 3,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .civilian,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 2,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .expansion, value: 9)
            ]
        )
    }
}
