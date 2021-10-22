//
//  QuadriremeUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Quadrireme_(Civ6)
internal class QuadriremeUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Quadrireme",
            baseType: .quadrireme,
            domain: .sea,
            effects: [
                "Has a ranged attack with Range 1.",
                "Can only operate on coastal waters until Cartography is researched."
            ],
            abilities: [.oceanImpassable],
            era: .classical,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attackSea, .escortSea, .reserveSea],
            defaultTask: .attackSea,
            movementType: .swimShallow,
            productionCost: 120,
            purchaseCost: 480,
            faithCost: -1,
            maintenanceCost: 2,
            sight: 2,
            range: 1,
            supportDistance: 1,
            strength: 10,
            targetType: .navalRanged,
            meleeAttack: 20,
            rangedAttack: 25,
            moves: 3,
            requiredTech: .shipBuilding,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
