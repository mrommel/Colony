//
//  CrossbowmanUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Crossbowman_(Civ6)
internal class CrossbowmanUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Crossbowman",
            baseType: .crossbowman,
            domain: .land,
            effects: [
                "Has a ranged attack with Range 2.",
                "-17 Ranged Strength against District defenses and Naval units."
            ],
            abilities: [.canCapture],
            era: .medieval,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.ranged],
            defaultTask: .ranged,
            movementType: .walk,
            productionCost: 180,
            purchaseCost: 720,
            faithCost: -1,
            maintenanceCost: 3,
            sight: 2,
            range: 2,
            supportDistance: 0,
            strength: 10,
            targetType: .ranged,
            meleeAttack: 30,
            rangedAttack: 40,
            moves: 2,
            requiredTech: .machinery,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.archer],
            flavours: [
                Flavor(type: .recon, value: 1),
                Flavor(type: .offense, value: 7),
                Flavor(type: .defense, value: 2),
            ]
        )
    }
}
