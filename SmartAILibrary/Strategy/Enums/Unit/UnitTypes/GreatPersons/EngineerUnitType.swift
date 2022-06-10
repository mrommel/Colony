//
//  EngineerUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Great_Engineer_(Civ6)
internal class EngineerUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_ENGINEER_NAME",
            baseType: .engineer,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_ENGINEER_EFFECT1"
            ],
            abilities: [],
            era: .none,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [],
            defaultTask: .unknown,
            movementType: .walk,
            productionCost: -1,
            purchaseCost: -1,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 0,
            targetType: .civilian,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 3,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
