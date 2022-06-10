//
//  HeavyChariotUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Heavy_Chariot_(Civ6)
internal class HeavyChariotUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_HEAVY_CHARIOT_NAME",
            baseType: .heavyChariot,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_HEAVY_CHARIOT_EFFECT1",
                "TXT_KEY_UNIT_HEAVY_CHARIOT_EFFECT2"
            ],
            abilities: [.canCapture],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .defense, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 65,
            purchaseCost: 260,
            faithCost: -1,
            maintenanceCost: 1,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .lightCavalry,
            meleeAttack: 28,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .wheel,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .recon, value: 9),
                Flavor(type: .ranged, value: 5),
                Flavor(type: .mobile, value: 10),
                Flavor(type: .offense, value: 3),
                Flavor(type: .defense, value: 6)
            ]
        )
    }
}
