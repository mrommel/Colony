//
//  ArcherUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Archer_(Civ6)
internal class ArcherUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Archer",
            baseType: .archer,
            domain: .land,
            effects: [
                "First Ancient era ranged unit with Range of 2."
            ],
            abilities: [.canCapture],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.ranged],
            defaultTask: .ranged,
            movementType: .walk,
            productionCost: 60,
            purchaseCost: 240,
            faithCost: -1,
            maintenanceCost: 1,
            sight: 2,
            range: 2,
            supportDistance: 2,
            strength: 10,
            targetType: .ranged,
            meleeAttack: 15,
            rangedAttack: 25,
            moves: 2,
            requiredTech: .archery,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.slinger],
            flavours: [
                Flavor(type: .ranged, value: 6),
                Flavor(type: .recon, value: 3),
                Flavor(type: .offense, value: 1),
                Flavor(type: .defense, value: 2)
            ]
        )
    }
}
