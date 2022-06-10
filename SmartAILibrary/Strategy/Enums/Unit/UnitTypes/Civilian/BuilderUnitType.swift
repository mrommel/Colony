//
//  BuilderUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Builder_(Civ6)
internal class BuilderUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_BUILDER_NAME",
            baseType: .builder,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_BUILDER_EFFECT1",
                "TXT_KEY_UNIT_BUILDER_EFFECT2"
            ],
            abilities: [.canImprove],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.work],
            defaultTask: .work,
            movementType: .walk,
            productionCost: 50,
            purchaseCost: 200,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .civilian,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 2,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .tileImprovement, value: 10),
                Flavor(type: .amenities, value: 7),
                Flavor(type: .expansion, value: 4),
                Flavor(type: .growth, value: 4),
                Flavor(type: .gold, value: 4),
                Flavor(type: .production, value: 4),
                Flavor(type: .science, value: 2),
                Flavor(type: .offense, value: 1),
                Flavor(type: .defense, value: 1)
            ]
        )
    }
}
