//
//  HorsemanUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Horseman_(Civ6)
internal class HorsemanUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_HORSEMAN_NAME",
            baseType: .horseman,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_HORSEMAN_EFFECT1",
                "TXT_KEY_UNIT_HORSEMAN_EFFECT2"
            ],
            abilities: [
                .canCapture,
                .canIgnoreZoneOfControl
            ],
            era: .classical,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 80,
            purchaseCost: 320,
            faithCost: -1,
            maintenanceCost: 2,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .lightCavalry,
            meleeAttack: 36,
            rangedAttack: 0,
            moves: 4,
            requiredTech: .horsebackRiding,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
