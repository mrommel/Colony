//
//  TraderUnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Trader_(Civ6)
internal class TraderUnitType: UnitTypeData {

    init() {

        super.init(
            name: "TXT_KEY_UNIT_TRADER_NAME",
            baseType: .trader,
            domain: .land,
            effects: [
                "TXT_KEY_UNIT_TRADER_EFFECT1",
                "TXT_KEY_UNIT_TRADER_EFFECT2"
            ],
            abilities: [
                .canEstablishTradeRoute,
                .canMoveInRivalTerritory
            ],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [.trade],
            defaultTask: .trade,
            movementType: .walk,
            productionCost: 40,
            purchaseCost: 160,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 0,
            supportDistance: 0,
            strength: 10,
            targetType: .civilian,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 1,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: .foreignTrade,
            upgradesFrom: [],
            flavours: [
                Flavor(type: .gold, value: 10)
            ]
        )
    }
}
