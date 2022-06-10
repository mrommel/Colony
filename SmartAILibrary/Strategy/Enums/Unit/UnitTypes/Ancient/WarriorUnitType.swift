//
//  WarriorUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Warrior_(Civ6)
internal class WarriorUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_WARRIOR_NAME",
            baseType: .warrior,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_WARRIOR_EFFECT1"
            ],
            abilities: [.canCapture],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .defense, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 40,
            purchaseCost: 160,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .melee,
            meleeAttack: 20,
            rangedAttack: 0,
            moves: 2,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .offense, value: 3),
                Flavor(type: .recon, value: 3),
                Flavor(type: .defense, value: 3)
            ]
        )
    }
}
