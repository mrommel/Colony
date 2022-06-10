//
//  ScoutUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Scout_(Civ6)
internal class ScoutUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_SCOUT_NAME",
            baseType: .scout,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_SCOUT_EFFECT1"
            ],
            abilities: [.experienceFromTribal],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.explore],
            defaultTask: .explore,
            movementType: .walk,
            productionCost: 30,
            purchaseCost: 120,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .recon,
            meleeAttack: 10,
            rangedAttack: 0,
            moves: 3,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .recon, value: 8),
                Flavor(type: .defense, value: 2)
            ]
        )
    }
}
