//
//  TrebuchetUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Trebuchet_(Civ6)
internal class TrebuchetUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_TREBUCHET_NAME",
            baseType: .trebuchet,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_TREBUCHET_EFFECT1",
                "TXT_KEY_UNIT_TREBUCHET_EFFECT2",
                "TXT_KEY_UNIT_TREBUCHET_EFFECT3"
            ],
            abilities: [],
            era: .classical,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.cityAttack],
            defaultTask: .cityAttack,
            movementType: .walk,
            productionCost: 200,
            purchaseCost: 800,
            faithCost: -1,
            maintenanceCost: 3,
            sight: 2,
            range: 2,
            supportDistance: 0,
            strength: 10,
            targetType: .siege,
            meleeAttack: 35,
            rangedAttack: 45,
            moves: 2,
            requiredTech: .militaryEngineering,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.catapult],
            flavours: [
                Flavor(type: .ranged, value: 8),
                Flavor(type: .offense, value: 2)
            ]
        )
    }
}
