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
            name: "Trader",
            baseType: .trader,
            domain: .land,
            effects: [
                "May make and maintain a single [TradeRoute] Trade Route. Automatically creates Roads as it travels.",
                "Production cost is progressive."
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
