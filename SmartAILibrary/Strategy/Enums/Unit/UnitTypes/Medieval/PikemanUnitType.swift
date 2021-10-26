//
//  PikemanUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Pikeman_(Civ6)
internal class PikemanUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Pikeman",
            baseType: .pikeman,
            domain: .land,
            effects: [
                "+10 Combat Strength vs. light, heavy, and ranged cavalry units."
            ],
            abilities: [.canCapture],
            era: .medieval,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .defense, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 180,
            purchaseCost: 720,
            faithCost: -1,
            maintenanceCost: 2,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .antiCavalry,
            meleeAttack: 45,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .militaryTactics,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.spearman],
            flavours: [
                Flavor(type: .recon, value: 1),
                Flavor(type: .offense, value: 3),
                Flavor(type: .defense, value: 6),
            ]
        )
    }
}
