//
//  SlingerUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Slinger_(Civ6)
internal class SlingerUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_SLINGER_NAME",
            baseType: .slinger,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_SLINGER_EFFECT1"
            ],
            abilities: [.canCapture],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.ranged],
            defaultTask: .ranged,
            movementType: .walk,
            productionCost: 35,
            purchaseCost: 140,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 1,
            supportDistance: 1,
            strength: 10,
            targetType: .ranged,
            meleeAttack: 5,
            rangedAttack: 15,
            moves: 2,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .ranged, value: 8),
                Flavor(type: .recon, value: 10),
                Flavor(type: .offense, value: 3),
                Flavor(type: .defense, value: 4)
            ]
        )
    }
}
