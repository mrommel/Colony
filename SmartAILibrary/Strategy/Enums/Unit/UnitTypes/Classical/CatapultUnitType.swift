//
//  CatapultUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Catapult_(Civ6)
internal class CatapultUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_CATAPULT_NAME",
            baseType: .catapult,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_CATAPULT_EFFECT1",
                "TXT_KEY_UNIT_CATAPULT_EFFECT2",
                "TXT_KEY_UNIT_CATAPULT_EFFECT3"
            ],
            abilities: [.canCapture],
            era: .classical,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .ranged, .cityBombard],
            defaultTask: .ranged,
            movementType: .walk,
            productionCost: 120,
            purchaseCost: 480,
            faithCost: -1,
            maintenanceCost: 2,
            sight: 2,
            range: 2,
            supportDistance: 2,
            strength: 10,
            targetType: .ranged,
            meleeAttack: 25,
            rangedAttack: 35,
            moves: 2,
            requiredTech: .engineering,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .ranged, value: 8),
                Flavor(type: .offense, value: 2)
            ]
        )
    }
}
