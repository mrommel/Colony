//
//  GalleyUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Galley_(Civ6)
internal class GalleyUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Galley",
            baseType: .galley,
            domain: .sea,
            effects: [
                "Ancient era melee naval combat unit.",
                "Can only operate on coastal waters until Cartography is researched."
            ],
            abilities: [
                .oceanImpassable,
                    .canCapture
            ],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.exploreSea, .attackSea, .escortSea, .reserveSea],
            defaultTask: .attackSea,
            movementType: .swimShallow,
            productionCost: 65,
            purchaseCost: 260,
            faithCost: -1,
            maintenanceCost: 1,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .navalMelee,
            meleeAttack: 30,
            rangedAttack: 0,
            moves: 3,
            requiredTech: .sailing,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
