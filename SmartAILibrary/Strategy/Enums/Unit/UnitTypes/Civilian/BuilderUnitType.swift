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
            name: "Builder",
            baseType: .builder,
            domain: .land,
            effects: [
                "May create tile improvements or remove features like Woods or Rainforest. " +
                "Build charges number can be increased through policies or wonders like the Pyramids.",
                "Production cost is progressive." // #
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
                Flavor(type: .happiness, value: 7),
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
