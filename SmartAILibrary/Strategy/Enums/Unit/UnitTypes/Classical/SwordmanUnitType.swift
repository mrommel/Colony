//
//  SwordmanUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Swordsman_(Civ6)
internal class SwordmanUnitType: UnitTypeData {

    init() {

        super.init(
            name: "Swordman",
            baseType: .swordman,
            domain: .land,
            effects: [
                "+5 Combat Strength vs. anti-cavalry units."
            ],
            abilities: [.canCapture],
            era: .classical,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.attack, .defense, .explore],
            defaultTask: .attack,
            movementType: .walk,
            productionCost: 90,
            purchaseCost: 360,
            faithCost: -1,
            maintenanceCost: 2,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .melee,
            meleeAttack: 35,
            rangedAttack: 0,
            moves: 2,
            requiredTech: .ironWorking,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [.warrior],
            flavours: []
        )
    }
}
