//
//  BatteringRamUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Battering_Ram_(Civ6)
internal class BatteringRamUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_BATTERING_RAM_NAME",
            baseType: .batteringRam,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_BATTERING_RAM_EFFECT1",
                "TXT_KEY_UNIT_BATTERING_RAM_EFFECT2"
            ],
            abilities: [],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.cityAttack],
            defaultTask: .cityAttack,
            movementType: .walk,
            productionCost: 65,
            purchaseCost: 260,
            faithCost: -1,
            maintenanceCost: 1,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .support,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .masonry,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .expansion, value: 3),
                Flavor(type: .offense, value: 7)
            ]
        )
    }
}
