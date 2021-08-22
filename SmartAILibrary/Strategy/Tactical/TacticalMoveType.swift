//
//  TacticalMoveType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum TacticalMoveType: Int, Codable {

    case none

    case unassigned // TACTICAL_UNASSIGNED
    case moveNoncombatantsToSafety // TACTICAL_MOVE_NONCOMBATANTS_TO_SAFETY
    case captureCity // TACTICAL_CAPTURE_CITY
    case damageCity // TACTICAL_DAMAGE_CITY
    case destroyHighUnit // TACTICAL_DESTROY_HIGH_UNIT
    case destroyMediumUnit // TACTICAL_DESTROY_MEDIUM_UNIT
    case destroyLowUnit // TACTICAL_DESTROY_LOW_UNIT
    case toSafety // TACTICAL_TO_SAFETY
    case attritHighUnit // TACTICAL_ATTRIT_HIGH_UNIT
    case attritMediumUnit // TACTICAL_ATTRIT_MEDIUM_UNIT
    case attritLowUnit // TACTICAL_ATTRIT_LOW_UNIT
    case reposition // TACTICAL_REPOSITION
    case barbarianCamp // TACTICAL_BARBARIAN_CAMP
    case pillage // TACTICAL_PILLAGE
    case civilianAttack // TACTICAL_CIVILIAN_ATTACK
    case safeBombards // TACTICAL_SAFE_BOMBARDS
    case heal // TACTICAL_HEAL
    case ancientRuins // TACTICAL_ANCIENT_RUINS
    case garrisonToAllowBombards // TACTICAL_GARRISON_TO_ALLOW_BOMBARD
    case bastionAlreadyThere // TACTICAL_BASTION_ALREADY_THERE
    case garrisonAlreadyThere // TACTICAL_GARRISON_ALREADY_THERE
    case guardImprovementAlreadyThere // TACTICAL_GUARD_IMPROVEMENT_ALREADY_THERE
    case bastionOneTurn // TACTICAL_BASTION_1_TURN
    case garrisonOneTurn // TACTICAL_GARRISON_1_TURN
    case guardImprovementOneTurn // TACTICAL_GUARD_IMPROVEMENT_1_TURN
    case airSweep // TACTICAL_AIR_SWEEP
    case airIntercept // TACTICAL_AIR_INTERCEPT
    case airRebase // TACTICAL_AIR_REBASE
    case closeOnTarget // TACTICAL_CLOSE_ON_TARGET
    case moveOperation // TACTICAL_MOVE_OPERATIONS
    case emergencyPurchases // TACTICAL_EMERGENCY_PURCHASES

    /// postures ///////////////////

    case postureWithdraw // TACTICAL_POSTURE_WITHDRAW
    case postureSitAndBombard // TACTICAL_POSTURE_SIT_AND_BOMBARD
    case postureAttritFromRange // TACTICAL_POSTURE_ATTRIT_FROM_RANGE
    case postureExploitFlanks // TACTICAL_POSTURE_EXPLOIT_FLANKS
    case postureSteamroll // TACTICAL_POSTURE_STEAMROLL
    case postureSurgicalCityStrike // TACTICAL_POSTURE_SURGICAL_CITY_STRIKE
    case postureHedgehog // TACTICAL_POSTURE_HEDGEHOG
    case postureCounterAttack // TACTICAL_POSTURE_COUNTERATTACK
    case postureShoreBombardment // TACTICAL_POSTURE_SHORE_BOMBARDMENT

    /// barbarian ///////////////////

    case barbarianCaptureCity // AI_TACTICAL_BARBARIAN_CAPTURE_CITY,
    case barbarianDamageCity // AI_TACTICAL_BARBARIAN_DAMAGE_CITY,
    case barbarianDestroyHighPriorityUnit // AI_TACTICAL_BARBARIAN_DESTROY_HIGH_PRIORITY_UNIT,
    case barbarianDestroyMediumPriorityUnit // AI_TACTICAL_BARBARIAN_DESTROY_MEDIUM_PRIORITY_UNIT,
    case barbarianDestroyLowPriorityUnit // AI_TACTICAL_BARBARIAN_DESTROY_LOW_PRIORITY_UNIT,
    case barbarianMoveToSafety // AI_TACTICAL_BARBARIAN_MOVE_TO_SAFETY,
    case barbarianAttritHighPriorityUnit // AI_TACTICAL_BARBARIAN_ATTRIT_HIGH_PRIORITY_UNIT,
    case barbarianAttritMediumPriorityUnit // AI_TACTICAL_BARBARIAN_ATTRIT_MEDIUM_PRIORITY_UNIT,
    case barbarianAttritLowPriorityUnit // AI_TACTICAL_BARBARIAN_ATTRIT_LOW_PRIORITY_UNIT,
    case barbarianPillage // AI_TACTICAL_BARBARIAN_PILLAGE,
    case barbarianBlockadeResource // AI_TACTICAL_BARBARIAN_PRIORITY_BLOCKADE_RESOURCE,
    case barbarianCivilianAttack // AI_TACTICAL_BARBARIAN_CIVILIAN_ATTACK,
    case barbarianAggressiveMove // AI_TACTICAL_BARBARIAN_AGGRESSIVE_MOVE,
    case barbarianPassiveMove // AI_TACTICAL_BARBARIAN_PASSIVE_MOVE,
    case barbarianCampDefense // AI_TACTICAL_BARBARIAN_CAMP_DEFENSE,
    case barbarianGuardCamp
    case barbarianDesperateAttack // AI_TACTICAL_BARBARIAN_DESPERATE_ATTACK,
    case barbarianEscortCivilian // AI_TACTICAL_BARBARIAN_ESCORT_CIVILIAN,
    case barbarianPlunderTradeUnit // AI_TACTICAL_BARBARIAN_PLUNDER_TRADE_UNIT,
    case barbarianPillageCitadel // AI_TACTICAL_BARBARIAN_PILLAGE_CITADEL,
    case barbarianPillageNextTurn // AI_TACTICAL_BARBARIAN_PILLAGE_NEXT_TURN

    static var allBarbarianMoves: [TacticalMoveType] {

        return [
            .barbarianCaptureCity, .barbarianDamageCity, .barbarianDestroyHighPriorityUnit,
            .barbarianDestroyMediumPriorityUnit, .barbarianDestroyLowPriorityUnit, .barbarianMoveToSafety,
            .barbarianAttritHighPriorityUnit, .barbarianAttritMediumPriorityUnit, .barbarianAttritLowPriorityUnit,
            .barbarianPillage, .barbarianBlockadeResource, .barbarianCivilianAttack, .barbarianAggressiveMove,
            .barbarianPassiveMove, .barbarianCampDefense, .barbarianDesperateAttack, .barbarianEscortCivilian,
            .barbarianPlunderTradeUnit, .barbarianPillageCitadel, .barbarianPillageNextTurn, .barbarianGuardCamp
        ]
    }

    static var allPlayerMoves: [TacticalMoveType] {

        return [
            .moveNoncombatantsToSafety, .captureCity, .damageCity, .destroyHighUnit, .destroyMediumUnit,
            .destroyLowUnit, .toSafety, .attritHighUnit, .attritMediumUnit, .attritLowUnit, .reposition,
            .barbarianCamp, .pillage, .civilianAttack, .safeBombards, .heal, .ancientRuins, .garrisonToAllowBombards,
            .bastionAlreadyThere, .garrisonAlreadyThere, .guardImprovementAlreadyThere, .bastionOneTurn, .garrisonOneTurn,
            .guardImprovementOneTurn, .airSweep, .airIntercept, .airRebase, .closeOnTarget, .moveOperation,
            .emergencyPurchases
        ]
    }

    struct TacticalMoveTypeData {

        let operationsCanRecruit: Bool
        let dominanceZoneMove: Bool
        let offenseFlavorWeight: Int
        let defenseFlavorWeight: Int
        let priority: Int
    }

    func priority() -> Int {

        return self.data().priority
    }

    func dominanceZoneMove() -> Bool {

        return self.data().dominanceZoneMove
    }

    func canRecruitForOperations() -> Bool {

        return self.data().operationsCanRecruit
    }

    // MARK: private methods

    private func data() -> TacticalMoveTypeData {

        switch self {

        case .none: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: -1)

        case .barbarianGuardCamp: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 200)
        case .unassigned: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: -1)
        case .moveNoncombatantsToSafety: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 0)
        case .captureCity: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 100, defenseFlavorWeight: 0, priority: 150)
        case .damageCity: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 100, defenseFlavorWeight: 0, priority: 15)
        case .destroyHighUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 140)
        case .destroyMediumUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 120)
        case .destroyLowUnit: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 110)
        case .closeOnTarget: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 45)
        case .toSafety: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 11)
        case .attritHighUnit: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 17)
        case .attritMediumUnit: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 15)
        case .attritLowUnit: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 12)
        case .reposition: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 50, defenseFlavorWeight: 50, priority: 1)
        case .barbarianCamp: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 100, defenseFlavorWeight: 0, priority: 10)
        case .pillage: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 100, defenseFlavorWeight: 0, priority: 40)
        case .civilianAttack: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 100, defenseFlavorWeight: 0, priority: 65)
        case .safeBombards: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 100, defenseFlavorWeight: 0, priority: 60)
        case .heal: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 8)
        case .ancientRuins: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 50, defenseFlavorWeight: 50, priority: 25)
        case .garrisonToAllowBombards: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 20)
        case .bastionAlreadyThere: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 7)
        case .garrisonAlreadyThere: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 6)
        case .guardImprovementAlreadyThere: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 5)
        case .bastionOneTurn: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 4)
        case .garrisonOneTurn: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 3)
        case .guardImprovementOneTurn: return TacticalMoveTypeData(operationsCanRecruit: true, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 2)
        case .airSweep: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 100, defenseFlavorWeight: 0, priority: 10)
        case .airIntercept: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 20)
        case .airRebase: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 100, priority: 1)
        case .postureWithdraw: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 101)
        case .postureSitAndBombard: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 105)
        case .postureAttritFromRange: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 104)
        case .postureExploitFlanks: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 107)
        case .postureSteamroll: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 108)
        case .postureSurgicalCityStrike: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 106)
        case .postureHedgehog: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 50)
        case .postureCounterAttack: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 103)
        case .postureShoreBombardment: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 100)

        case .moveOperation: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 80)
        case .emergencyPurchases: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: true, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 200)

        // https://github.com/chvrsi/BarbariansEvolved/blob/00a6feec72fa7d95ef026d821f008bdbbf3ee3ab/xml/BarbarianDefines.xml

        case .barbarianCaptureCity: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 9)
        case .barbarianDamageCity: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 5)
        case .barbarianDestroyHighPriorityUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 16)
        case .barbarianDestroyMediumPriorityUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 15)
        case .barbarianDestroyLowPriorityUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 14)
        case .barbarianMoveToSafety: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 10)
        case .barbarianAttritHighPriorityUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 10)
        case .barbarianAttritMediumPriorityUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 7)
        case .barbarianAttritLowPriorityUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 6)
        case .barbarianPillage: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 12)
        case .barbarianBlockadeResource: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 10)
        case .barbarianCivilianAttack: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 13)
        case .barbarianAggressiveMove: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 3)
        case .barbarianPassiveMove: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: -1)
        case .barbarianCampDefense: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 13)
        case .barbarianDesperateAttack: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 0)
        case .barbarianEscortCivilian: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 30)
        case .barbarianPlunderTradeUnit: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 20)
        case .barbarianPillageCitadel: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 14)
        case .barbarianPillageNextTurn: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: 4)
        }
    }
}
