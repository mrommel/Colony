//
//  ManAtArmsUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Man-At-Arms_(Civ6)
internal class ManAtArmsUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_MAN_AT_ARMS_NAME",
            baseType: .manAtArms,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_MAN_AT_ARMS_EFFECT1"
            ],
            abilities: [.canCapture],
            era: .medieval,
            requiredResource: .iron,
            civilization: nil,
            unitTasks: [.attack, .defense, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 160,
            purchaseCost: 640,
            faithCost: -1,
            maintenanceCost: 3,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .melee,
            meleeAttack: 45,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .apprenticeship,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.swordman],
            flavours: [
                Flavor(type: .recon, value: 1),
                Flavor(type: .offense, value: 8),
                Flavor(type: .defense, value: 1)
            ]
        )
    }
}
