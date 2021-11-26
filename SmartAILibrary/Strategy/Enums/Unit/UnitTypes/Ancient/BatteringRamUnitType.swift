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
            name: "Battering Ram",
            baseType: .batteringRam,
            domain: .land,
            effects: [
                "When this unit is adjacent to a District with Defenses, all melee units and " +
                "anti-cavalry units (including naval melee) attacking it do full damage to the District walls.",
                "Only effective against Ancient Walls."
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
