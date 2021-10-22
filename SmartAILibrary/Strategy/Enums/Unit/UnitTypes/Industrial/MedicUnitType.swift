//
//  MedicUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Medic_(Civ6)
internal class MedicUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Medic",
            baseType: .medic,
            domain: .land,
            effects: [
                "Industrial era support unit.",
                "Can heal adjacent units."
            ],
            abilities: [.canHeal],
            era: .industrial,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [],
            defaultTask: .unknown,
            movementType: .walk,
            productionCost: 370,
            purchaseCost: 1480,
            faithCost: -1,
            maintenanceCost: 5,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .support,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .sanitation,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
