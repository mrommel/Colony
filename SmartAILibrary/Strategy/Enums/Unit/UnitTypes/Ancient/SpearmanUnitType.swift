//
//  SpearmanUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Spearman_(Civ6)
internal class SpearmanUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Spearman",
            baseType: .spearman,
            domain: .land,
            effects: [
                "Ancient era melee unit that's effective against mounted units."
            ],
            abilities: [.canCapture],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .defense],
            defaultTask: .defense,
            movementType: .walk,
            productionCost: 65,
            purchaseCost: 260,
            faithCost: -1,
            maintenanceCost: 1,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .antiCavalry,
            meleeAttack: 25,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .bronzeWorking,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .defense, value: 4),
                Flavor(type: .recon, value: 2),
                Flavor(type: .offense, value: 2)
            ]
        )
    }
}
