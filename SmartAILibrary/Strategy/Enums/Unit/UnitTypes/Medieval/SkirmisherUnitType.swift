//
//  SkirmisherUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Skirmisher_(Civ6)
internal class SkirmisherUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Skirmisher",
            baseType: .skirmisher,
            domain: .land,
            effects: [
                "Has a ranged attack with Range 1.",
                "-17 Ranged Strength against District defenses and Naval units."
            ],
            abilities: [.canCapture],
            era: .medieval,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .defense, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 150,
            purchaseCost: 600,
            faithCost: -1,
            maintenanceCost: 2,
            sight: 2,
            range: 1,
            supportDistance: 0,
            strength: 10,
            targetType: .recon,
            meleeAttack: 20,
            rangedAttack: 30,
            moves: 3,
            requiredTech: .machinery,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.scout],
            flavours: [
                Flavor(type: .recon, value: 8),
                Flavor(type: .offense, value: 1),
                Flavor(type: .defense, value: 1)
            ]
        )
    }
}
