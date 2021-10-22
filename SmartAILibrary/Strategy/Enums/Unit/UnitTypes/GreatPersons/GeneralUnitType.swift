//
//  GeneralUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Great_General_(Civ6)
internal class GeneralUnitType: UnitTypeData {

    init() {

        super.init(
            name: "General",
            baseType: .general,
            domain: .land,
            effects: [
                "Boosts combat strength and mobility of nearby land units. Can \"Retire\" to expend it once no longer useful."
            ],
            abilities: [],
            era: .none,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [],
            defaultTask: .unknown,
            movementType: .walk,
            productionCost: -1,
            purchaseCost: -1,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 0,
            targetType: .civilian,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 3,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
