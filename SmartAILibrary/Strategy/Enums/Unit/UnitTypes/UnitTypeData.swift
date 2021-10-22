//
//  UnitTypeData.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

internal class UnitTypeData {

    let name: String
    let baseType: UnitType?
    let domain: UnitDomainType
    let effects: [String]
    let abilities: [UnitAbilityType]

    let era: EraType
    let requiredResource: ResourceType?
    let civilization: CivilizationType?
    let unitTasks: [UnitTaskType]
    let defaultTask: UnitTaskType
    let movementType: UnitMovementType

    let productionCost: Int
    let purchaseCost: Int
    let faithCost: Int
    let maintenanceCost: Int

    let sight: Int
    let range: Int
    let supportDistance: Int
    let strength: Int //
    let targetType: UnitClassType
    let flags: BitArray

    // attack values
    let meleeAttack: Int
    let rangedAttack: Int

    // movement
    let moves: Int

    // techs / civics
    let requiredTech: TechType?
    let obsoleteTech: TechType?
    let requiredCivic: CivicType?
    let upgradesFrom: [UnitType]

    // AI
    let flavours: [Flavor]

    init(
        name: String,
        baseType: UnitType?,
        domain: UnitDomainType,
        effects: [String],
        abilities: [UnitAbilityType],
        era: EraType,
        requiredResource: ResourceType?,
        civilization: CivilizationType?,
        unitTasks: [UnitTaskType],
        defaultTask: UnitTaskType,
        movementType: UnitMovementType,
        productionCost: Int,
        purchaseCost: Int,
        faithCost: Int,
        maintenanceCost: Int,
        sight: Int,
        range: Int,
        supportDistance: Int,
        strength: Int,
        targetType: UnitClassType,
        flags: BitArray = BitArray(count: 4),
        meleeAttack: Int,
        rangedAttack: Int,
        moves: Int,
        requiredTech: TechType?,
        obsoleteTech: TechType?,
        requiredCivic: CivicType?,
        upgradesFrom: [UnitType],
        flavours: [Flavor]) {

            self.name = name
            self.baseType = baseType
            self.domain = domain
            self.effects = effects
            self.abilities = abilities
            self.era = era
            self.requiredResource = requiredResource
            self.civilization = civilization
            self.unitTasks = unitTasks
            self.defaultTask = defaultTask
            self.movementType = movementType
            self.productionCost = productionCost
            self.purchaseCost = purchaseCost
            self.faithCost = faithCost
            self.maintenanceCost = maintenanceCost
            self.sight = sight
            self.range = range
            self.supportDistance = supportDistance
            self.strength = strength
            self.targetType = targetType
            self.flags = flags
            self.meleeAttack = meleeAttack
            self.rangedAttack = rangedAttack
            self.moves = moves
            self.requiredTech = requiredTech
            self.obsoleteTech = obsoleteTech
            self.requiredCivic = requiredCivic
            self.upgradesFrom = upgradesFrom
            self.flavours = flavours
    }

    convenience init() {

        self.init(
            name: "None",
            baseType: UnitType.none,
            domain: .land,
            effects: [],
            abilities: [],
            era: .ancient,
            requiredResource: nil,
            civilization: nil,
            unitTasks: [],
            defaultTask: .none,
            movementType: .walk,
            productionCost: -1,
            purchaseCost: -1,
            faithCost: -1,
            maintenanceCost: 0,
            sight: 2,
            range: 2,
            supportDistance: 0,
            strength: 0,
            targetType: .city,
            meleeAttack: 0,
            rangedAttack: 0,
            moves: 0,
            requiredTech: nil,
            obsoleteTech: nil,
            requiredCivic: nil,
            upgradesFrom: [],
            flavours: []
        )
    }
}
