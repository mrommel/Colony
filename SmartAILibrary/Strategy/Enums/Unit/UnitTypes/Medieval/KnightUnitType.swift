//
//  KnightUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Knight_(Civ6)
internal class KnightUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_KNIGHT_NAME",
            baseType: .knight,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_KNIGHT_EFFECT1"
            ],
            abilities: [.canCapture],
            era: .medieval,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .defense, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 220,
            purchaseCost: 880,
            faithCost: -1,
            maintenanceCost: 4,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .heavyCavalry,
            meleeAttack: 50,
            rangedAttack: 0,
            moves: 4,
            requiredTech: .stirrups,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.heavyChariot],
            flavours: [
                Flavor(type: .recon, value: 1),
                Flavor(type: .offense, value: 9)
            ]
        )
    }
}
