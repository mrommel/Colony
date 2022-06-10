//
//  SiegeTowerUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 26.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Siege_Tower_(Civ6)
internal class SiegeTowerUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_SIEGE_TOWER_NAME",
            baseType: .siegeTower,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_SIEGE_TOWER_EFFECT1",
                "TXT_KEY_UNIT_SIEGE_TOWER_EFFECT2"
            ],
            abilities: [],
            era: .classical,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.cityAttack],
            defaultTask: .cityAttack,
            movementType: .walk,
            productionCost: 100,
            purchaseCost: 400,
            faithCost: -1,
            maintenanceCost: 2,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .support,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .construction,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.batteringRam],
            flavours: []
        )
    }
}
