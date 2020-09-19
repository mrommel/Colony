//
//  TacticalAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum TacticalTargetType: Int, Codable {

    case none // AI_TACTICAL_TARGET_NONE
    case city // AI_TACTICAL_TARGET_CITY
    case barbarianCamp // AI_TACTICAL_TARGET_BARBARIAN_CAMP
    case improvement // AI_TACTICAL_TARGET_IMPROVEMENT
    case blockadeResourcePoint // AI_TACTICAL_TARGET_BLOCKADE_RESOURCE_POINT
    case lowPriorityUnit // AI_TACTICAL_TARGET_LOW_PRIORITY_UNIT,    // Can't attack one of our cities
    case mediumPriorityUnit // AI_TACTICAL_TARGET_MEDIUM_PRIORITY_UNIT, // Can damage one of our cities
    case highPriorityUnit // AI_TACTICAL_TARGET_HIGH_PRIORITY_UNIT,   // Can contribute to capturing one of our cities
    case cityToDefend // AI_TACTICAL_TARGET_CITY_TO_DEFEND
    case improvementToDefend // AI_TACTICAL_TARGET_IMPROVEMENT_TO_DEFEND
    case defensiveBastion // AI_TACTICAL_TARGET_DEFENSIVE_BASTION
    case ancientRuins // AI_TACTICAL_TARGET_ANCIENT_RUINS
    case bombardmentZone // AI_TACTICAL_TARGET_BOMBARDMENT_ZONE,     // Used for naval bombardment operation
    case embarkedMilitaryUnit // AI_TACTICAL_TARGET_EMBARKED_MILITARY_UNIT
    case embarkedCivilian // AI_TACTICAL_TARGET_EMBARKED_CIVILIAN
    case lowPriorityCivilian // AI_TACTICAL_TARGET_LOW_PRIORITY_CIVILIAN
    case mediumPriorityCivilian // AI_TACTICAL_TARGET_MEDIUM_PRIORITY_CIVILIAN
    case highPriorityCivilian // AI_TACTICAL_TARGET_HIGH_PRIORITY_CIVILIAN
    case veryHighPriorityCivilian // AI_TACTICAL_TARGET_VERY_HIGH_PRIORITY_CIVILIAN
    
    case tradeUnitSea // AI_TACTICAL_TARGET_TRADE_UNIT_SEA,
    case tradeUnitLand // AI_TACTICAL_TARGET_TRADE_UNIT_LAND,
    case tradeUnitSeaPlot // AI_TACTICAL_TARGET_TRADE_UNIT_SEA_PLOT, // Used for idle unit moves to plunder trade routes that go through our territory
    case tradeUnitLandPlot // AI_TACTICAL_TARGET_TRADE_UNIT_LAND_PLOT,
    case citadel // AI_TACTICAL_TARGET_CITADEL
    case improvementResource // AI_TACTICAL_TARGET_IMPROVEMENT_RESOURCE
}

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
        
        return [.barbarianCaptureCity, .barbarianDamageCity, .barbarianDestroyHighPriorityUnit, .barbarianDestroyMediumPriorityUnit, .barbarianDestroyLowPriorityUnit, .barbarianMoveToSafety, .barbarianAttritHighPriorityUnit, .barbarianAttritMediumPriorityUnit, .barbarianAttritLowPriorityUnit, .barbarianPillage, .barbarianBlockadeResource, .barbarianCivilianAttack, .barbarianAggressiveMove, .barbarianPassiveMove, .barbarianCampDefense, .barbarianDesperateAttack, .barbarianEscortCivilian, .barbarianPlunderTradeUnit, .barbarianPillageCitadel, .barbarianPillageNextTurn, .barbarianGuardCamp
        ]
    }
    
    static var allPlayerMoves: [TacticalMoveType] {
    
        return [.moveNoncombatantsToSafety, .captureCity, .damageCity, .destroyHighUnit, .destroyMediumUnit, .destroyLowUnit, .toSafety, .attritHighUnit, .attritMediumUnit, .attritLowUnit, .reposition, .barbarianCamp, .pillage, .civilianAttack, .safeBombards, .heal, .ancientRuins, .garrisonToAllowBombards, .bastionAlreadyThere, .garrisonAlreadyThere, .guardImprovementAlreadyThere, .bastionOneTurn, .garrisonOneTurn, .guardImprovementOneTurn, .airSweep, .airIntercept, .airRebase, .closeOnTarget, .moveOperation, .emergencyPurchases
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

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvTacticalPosture
//!  \brief        The posture an AI has adopted for fighting in a specific dominance zone
//
//!  Key Attributes:
//!  - Used to keep consistency in approach from turn-to-turn
//!  - Reevaluated by tactical AI each turn before units are moved for this zone
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
enum TacticalPostureType {
    
    case none
    case withdraw
    case sitAndBombard
    case attritFromRange
    case exploitFlanks
    case steamRoll
    case surgicalCityStrike
    case hedgehog
    case counterAttack
    case shoreBombardment
    case emergencyPurchases
}

// Object stored in the list of current move cities (currentMoveCities)
class TacticalCity: Comparable {

    let attackStrength: Int
    var expectedTargetDamage: Int
    let city: AbstractCity?
    
    init(attackStrength: Int = 0, expectedTargetDamage: Int = 0, city: AbstractCity? = nil) {
        
        self.attackStrength = attackStrength
        self.expectedTargetDamage = expectedTargetDamage
        self.city = city
    }
    
    static func < (lhs: TacticalCity, rhs: TacticalCity) -> Bool {
        
        return lhs.attackStrength > rhs.attackStrength
    }
    
    static func == (lhs: TacticalCity, rhs: TacticalCity) -> Bool {
        
        return false
    }
}

// Object stored in the list of current move units (currentMoveUnits)
class TacticalUnit: Comparable {

    var attackStrength: Int
    var healthPercent: Int
    var movesToTarget: Int
    var expectedTargetDamage: Int
    var expectedSelfDamage: Int
    var unit: AbstractUnit?
    
    init(unit: AbstractUnit? = nil, attackStrength: Int = 0, healthPercent: Int = 0) {
        
        self.attackStrength = attackStrength
        self.healthPercent = healthPercent
        self.movesToTarget = 0
        self.expectedTargetDamage = 0
        self.expectedSelfDamage = 0
        self.unit = unit
    }
    
    // Derived
    func attackPriority() -> Int {
        
        return self.attackStrength * self.healthPercent
    }
    
    static func < (lhs: TacticalUnit, rhs: TacticalUnit) -> Bool {
        
        return lhs.attackStrength > rhs.attackStrength
    }
    
    static func == (lhs: TacticalUnit, rhs: TacticalUnit) -> Bool {
        
        return false
    }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvTacticalAI
//!  \brief        A player's AI to control units as they fight out battles
//
//!  Key Attributes:
//!  - Handed units to control by the operational AI
//!  - Handles moves for these units until dead or objective completed
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
public class TacticalAI: Codable {

    enum CodingKeys: String, CodingKey {
        
        case temporaryZones
        case allTargets
        
        case movePriotityTurn
    }
    
    var player: Player?

    var temporaryZones: [TemporaryZone]
    var allTargets: [TacticalTarget]
    var queuedAttacks: [QueuedAttack]
    var movePriorityList: [TacticalMove]
    var postures: [TacticalPosture]
    var zoneTargets: [TacticalTarget]
    
    var currentTurnUnits: [AbstractUnit?]
    var currentMoveCities: [TacticalCity?]
    var currentMoveUnits: [TacticalUnit?]
    var currentMoveHighPriorityUnits: [TacticalUnit?]
    
    var movePriotityTurn: Int = 0
    var currentSeriesId: Int = -1
    
    static let recruitRange = 10
    static let repositionRange = 10 // AI_TACTICAL_REPOSITION_RANGE

    // MARK: internal classes

    class TemporaryZone: Codable {
        
        enum CodingKeys: String, CodingKey {
        
            case location
            case lastTurn
            case targetType
            case navalMission
        }

        var location: HexPoint = HexPoint(x: -1, y: -1)
        var lastTurn: Int = -1
        var targetType: TacticalTargetType = .none
        var navalMission: Bool = false

        init(location: HexPoint = HexPoint(x: -1, y: -1), lastTurn: Int = -1, targetType: TacticalTargetType = .none, navalMission: Bool = false) {

            self.location = location
            self.lastTurn = lastTurn
            self.targetType = targetType
            self.navalMission = navalMission
        }
        
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
        
            self.location = try container.decode(HexPoint.self, forKey: .location)
            self.lastTurn = try container.decode(Int.self, forKey: .lastTurn)
            self.targetType = try container.decode(TacticalTargetType.self, forKey: .targetType)
            self.navalMission = try container.decode(Bool.self, forKey: .navalMission)
        }
        
        func encode(to encoder: Encoder) throws {
            
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.location, forKey: .location)
            try container.encode(self.lastTurn, forKey: .lastTurn)
            try container.encode(self.targetType, forKey: .targetType)
            try container.encode(self.navalMission, forKey: .navalMission)
        }
    }

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //  CLASS:      CvTacticalTarget
    //!  \brief        A target of opportunity for the tactical AI this turn
    //
    //!  Key Attributes:
    //!  - Arises during processing of CvTacticalAI::FindTacticalTargets()
    //!  - Targets are reexamined each turn (so shouldn't need to be serialized)
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    class TacticalTarget: Codable {

        enum CodingKeys: String, CodingKey {
        
            case targetType
            case target
            case targetLeader
            case dominanceZone
        }
        
        var targetType: TacticalTargetType
        let target: HexPoint
        var targetLeader: LeaderType
        let dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?

        // aux data
        var unit: AbstractUnit? = nil
        var damage: Int = 0
        var city: AbstractCity? = nil
        var threatValue: Int = 0
        var tile: AbstractTile? = nil
        
        init(targetType: TacticalTargetType, target: HexPoint, targetLeader: LeaderType, dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) {
            
            self.targetType = targetType
            self.target = target
            self.targetLeader = targetLeader
            self.dominanceZone = dominanceZone
        }
        
        required init(from decoder: Decoder) throws {
        
            let container = try decoder.container(keyedBy: CodingKeys.self)
        
            self.targetType = try container.decode(TacticalTargetType.self, forKey: .targetType)
            self.target = try container.decode(HexPoint.self, forKey: .target)
            self.targetLeader = try container.decode(LeaderType.self, forKey: .targetLeader)
            self.dominanceZone = nil // try container.decodeIfPresent(TacticalAnalysisMap.TacticalDominanceZone.self, forKey: .dominanceZone)
        }
        
        func encode(to encoder: Encoder) throws {
        
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.targetType, forKey: .targetType)
            try container.encode(self.target, forKey: .target)
            try container.encode(self.targetLeader, forKey: .targetLeader)
            //try container.encodeIfPresent(self.dominanceZone, forKey: .dominanceZone)
        }
        
        /// This target make sense for this domain of unit/zone?
        func isTargetValidIn(domain: UnitDomainType) -> Bool {
        
            switch self.targetType {
            
            case .none: return false
                
                // always valid
            case .city, .cityToDefend, .lowPriorityCivilian, .mediumPriorityCivilian, .highPriorityCivilian, .veryHighPriorityCivilian, .lowPriorityUnit, .mediumPriorityUnit, .highPriorityUnit:
                return true
                
                // land targets
            case .barbarianCamp, .improvement, .improvementToDefend, .defensiveBastion, .ancientRuins, .tradeUnitLand, .tradeUnitLandPlot, .citadel, .improvementResource:
                return domain == .land
                
                // sea targets
            case .blockadeResourcePoint, .bombardmentZone, .embarkedMilitaryUnit, .embarkedCivilian, .tradeUnitSea, .tradeUnitSeaPlot:
                return domain == .sea
            }
        }
    }
    
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //  CLASS:      CvQueuedAttack
    //!  \brief        A planned attack waiting to execute
    //
    //!  Key Attributes:
    //!  - Arises during processing of CvTacticalAI::ExecuteAttacks() or ProcessUnit()
    //!  - Created by calling QueueFirstAttack() or QueueSubsequentAttack()
    //!  - Combat animation system calls back into tactical AI when animation completes with call CombatResolved()
    //!  - This callback signals it is time to execute the next attack
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    class QueuedAttack {
        
        var attackerUnit: AbstractUnit?
        var attackerCity: AbstractCity?
        var target: TacticalTarget?
        var ranged: Bool
        var cityAttack: Bool
        var seriesId: Int
        
        init() {
            self.attackerUnit = nil
            self.attackerCity = nil
            self.target = nil
            self.ranged = false
            self.cityAttack = false
            self.seriesId = -1
        }
    }
    
    class TacticalMove: Comparable, CustomStringConvertible, CustomDebugStringConvertible {
        
        var moveType: TacticalMoveType
        var priority: Int
        
        init() {
            
            self.moveType = .unassigned
            self.priority = TacticalMoveType.unassigned.priority()
        }
        
        // this will sort highest priority to the beginning
        static func < (lhs: TacticalAI.TacticalMove, rhs: TacticalAI.TacticalMove) -> Bool {
            return lhs.priority > rhs.priority
        }
        
        static func == (lhs: TacticalAI.TacticalMove, rhs: TacticalAI.TacticalMove) -> Bool {
            return lhs.priority == rhs.priority && lhs.moveType == rhs.moveType
        }
        
        var description: String {
            return "TacticalMove(\(self.priority), \(self.moveType))"
        }

        var debugDescription: String {
            return "TacticalMove(\(self.priority), \(self.moveType))"
        }
    }
    
    class TacticalPosture {
        
        let type: TacticalPostureType
        let player: AbstractPlayer?
        let city: AbstractCity?
        let isWater: Bool
        
        init(of type: TacticalPostureType, for player: AbstractPlayer?, in city: AbstractCity?, isWater: Bool) {
            self.type = type
            self.player = player
            self.city = city
            self.isWater = isWater
        }
    }

    // MARK: constructors

    init(player: Player?) {

        self.player = player

        self.temporaryZones = []
        self.allTargets = []
        
        self.queuedAttacks = []
        self.movePriorityList = []
        self.postures = []
        self.zoneTargets = []
        
        self.currentTurnUnits = []
        self.currentMoveCities = []
        self.currentMoveUnits = []
        self.currentMoveHighPriorityUnits = []
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.temporaryZones = try container.decode([TemporaryZone].self, forKey: .temporaryZones)
        self.allTargets = try container.decode([TacticalTarget].self, forKey: .allTargets)
        
        self.queuedAttacks = []
        self.movePriorityList = []
        self.postures = []
        self.zoneTargets = []
        
        self.currentTurnUnits = []
        self.currentMoveCities = []
        self.currentMoveUnits = []
        self.currentMoveHighPriorityUnits = []

        self.movePriotityTurn = try container.decode(Int.self, forKey: .movePriotityTurn)
    }
    
    public func encode(to encoder: Encoder) throws {
      
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.temporaryZones, forKey: .temporaryZones)
        try container.encode(self.allTargets, forKey: .allTargets)
        
        try container.encode(self.movePriotityTurn, forKey: .movePriotityTurn)
    }
    
    /// Update the AI for units
    func turn(in gameModel: GameModel?) {

        self.findTacticalTargets(in: gameModel)

        // Loop through each dominance zone assigning moves
        self.processDominanceZones(in: gameModel)
    }
    
    func commandeerUnits(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let dangerPlotsAI = player.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }
        
        self.currentTurnUnits.removeAll()
        
        for unitRef in gameModel.units(of: player) {
            
            if let unit = unitRef {
                
                // Never want immobile/dead units, explorers, ones that have already moved
                if unit.has(task: .explore) || !unit.canMove() {
                    continue
                } else if player.leader == .barbar {
                    // We want ALL the barbarians that are not guarding a camp
                    /*if let tile = gameModel.tile(at: unit.location) {
                        if tile.has(improvement: .barbarianCamp) {
                            unit.finishMoves()
                            self.unitProcessed(unit: unit, markTacticalMap: unit.isCombatUnit(), in: gameModel)
                        } else {*/
                            unit.set(tacticalMove: .unassigned)
                            self.currentTurnUnits.append(unit)
                        /*}
                    }*/
                } else if unit.domain() == .air {
                    // and air units
                    unit.set(tacticalMove: .unassigned)
                    self.currentTurnUnits.append(unit)
                } else if !unit.isCombatUnit() /*&& !unit.isGreatGeneral()*/ {
                    // Now down to land and sea units ... in these groups our unit must have a base combat strength ... or be a great general
                    continue
                } else {
                    // Is this one in an operation we can't interrupt?
                    if let army = unit.army() {
                        //if army.canInterrupt(unit: unit) {
                        unit.set(tacticalMove: .none)
                        //}
                    } else {
                        // Non-zero danger value, near enemy, or deploying out of an operation?
                        let danger = dangerPlotsAI.danger(at: unit.location)
                        if danger > 0 || self.isNearVisibleEnemy(unit: unit, range: 10 /*  */, gameModel: gameModel) /* ||
                        pLoopUnit->GetDeployFromOperationTurn() + GC.getAI_TACTICAL_MAP_TEMP_ZONE_TURNS() >= GC.getGame().getGameTurn() */ {
                            unit.set(tacticalMove: .unassigned)
                            self.currentTurnUnits.append(unit)
                        } /* else if (pLoopUnit->canParadrop(pLoopUnit->plot(),false))
                        {
                            pLoopUnit->setTacticalMove((TacticalAIMoveTypes)m_CachedInfoTypes[eTACTICAL_UNASSIGNED]);
                            m_CurrentTurnUnits.push_back(pLoopUnit->GetID());
                        } */
                    }
                }
            }
        }
    }
    
    /// Am I within range of an enemy?
    private func isNearVisibleEnemy(unit unitToTest: AbstractUnit?, range: Int, gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
         
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        guard let unitToTest = unitToTest else {
            fatalError("cant get unitToTest")
        }
        
        // Loop through enemies
        for otherPlayer in gameModel.players {
            
            if otherPlayer.isAlive() && otherPlayer.leader != player.leader && diplomacyAI.isAtWar(with: otherPlayer) {
                
                // Loop through their units
                for unitRef in gameModel.units(of: otherPlayer) {
                    
                    if let unit = unitRef {
                        
                        // Make sure this tile is visible to us
                        if let tile = gameModel.tile(at: unit.location) {
                            
                            if tile.isVisible(to: player) && unitToTest.location.distance(to: unit.location) < range {
                                return true
                            }
                        }
                    }
                }
                
                // Loop through their cities
                for cityRef in gameModel.cities(of: otherPlayer) {
                    
                    if let city = cityRef {
                        
                        // Make sure this tile is visible to us
                        if let tile = gameModel.tile(at: city.location) {
                            
                            if tile.isVisible(to: player) && unitToTest.location.distance(to: city.location) < range {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }

    /// Process units that we recruited out of operational moves.  Haven't used them, so let them go ahead with those moves
    func updateOperationalArmyMoves() {

        guard let operations = self.player?.operations else {
            fatalError("cant get operations")
        }

        fatalError("not implement yet")
    }
    
    func processDominanceZones(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        let tacticalAnalysisMap = gameModel.tacticalAnalysisMap()
        
        // Barbarian processing is straightforward -- just one big list of priorites and everything is considered at once
        if player?.leader == .barbar {
            self.establishBarbarianPriorities(in: gameModel.currentTurn)
            self.extractTargets()
            self.assignBarbarianMoves(in: gameModel)
            
        } else {
            self.establishTacticalPriorities()
            self.updatePostures(in: gameModel)

            // Proceed in priority order
            for move in self.movePriorityList {
                
                if move.priority >= 0 {
                    
                    if move.moveType.dominanceZoneMove() {
                        
                        for dominanceZone in tacticalAnalysisMap.dominanceZones {

                            let postureType = self.findPostureType(for: dominanceZone)
                            
                            // Is this move of the right type for this zone?
                            var match = false
                            if move.moveType == .closeOnTarget {   // This one okay for all zones
                                match = true
                            } else if postureType == .withdraw && move.moveType == .postureWithdraw {
                                match = true
                            } else if postureType == .sitAndBombard && move.moveType == .postureSitAndBombard {
                                match = true;
                            } else if postureType == .attritFromRange && move.moveType == .postureAttritFromRange {
                                match = true
                            } else if postureType == .exploitFlanks && move.moveType == .postureExploitFlanks {
                                match = true
                            } else if postureType == .steamRoll && move.moveType == .postureSteamroll {
                                match = true
                            } else if postureType == .surgicalCityStrike && move.moveType == .postureSurgicalCityStrike {
                                match = true
                            } else if postureType == .hedgehog && move.moveType == .postureHedgehog {
                                match = true
                            } else if postureType == .counterAttack && move.moveType == .postureCounterAttack {
                                match = true
                            } else if postureType == .shoreBombardment && move.moveType == .postureShoreBombardment {
                                match = true
                            } else if dominanceZone.dominanceFlag == .enemy && dominanceZone.territoryType == .friendly && move.moveType == .emergencyPurchases {
                                match = true
                            }

                            if match {
                                if !self.useThis(dominanceZone: dominanceZone) {
                                    continue
                                }

                                self.extractTargets(for: dominanceZone)

                                // Must have some moves to continue or it must be land around an enemy city (which we always want to process because
                                // we might have an operation targeting it)
                                if self.zoneTargets.count <= 0 && dominanceZone.territoryType != .tempZone && (dominanceZone.territoryType != .enemy || dominanceZone.isWater) {
                                    continue
                                }

                                self.assign(tacticalMove: move, in: gameModel)
                            }
                        }
                    } else {
                        self.extractTargets()
                        self.assign(tacticalMove: move, in: gameModel)
                    }
                }
            }
        }
    }
    
    /// Sift through the target list and find just those that apply to the dominance zone we are currently looking at
    private func extractTarget(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) {
        
        fatalError("not implemented yet")
    }
    
    /// Choose which tactics to run and assign units to it
    private func assign(tacticalMove: TacticalMove, in gameModel: GameModel?) {
        
        switch tacticalMove.moveType {
            
        case .moveNoncombatantsToSafety: // TACTICAL_MOVE_NONCOMBATANTS_TO_SAFETY
            self.plotMovesToSafety(combatUnits: false, in: gameModel)
        case .reposition: // TACTICAL_REPOSITION
            self.plotRepositionMoves(in: gameModel)
        case .garrisonAlreadyThere:
            self.plotGarrisonMoves(numTurnsAway: 0, in: gameModel)
        case .garrisonToAllowBombards:
            self.plotGarrisonMoves(numTurnsAway: 1, mustAllowRangedAttack: true, in: gameModel)
        /*
        case .captureCity:
            fatalError("not implemented yet")
        case .damageCity:
            fatalError("not implemented yet")
        case .destroyHighUnit:
            fatalError("not implemented yet")
        case .destroyMediumUnit:
            fatalError("not implemented yet")
        case .destroyLowUnit:
            fatalError("not implemented yet")
        case .toSafety:
            fatalError("not implemented yet")
        case .attritHighUnit:
            fatalError("not implemented yet")
        case .attritMediumUnit:
            fatalError("not implemented yet")
        case .attritLowUnit:
            fatalError("not implemented yet")
        case .barbarianCamp:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .pillage:
            fatalError("not implemented yet")
        case .civilianAttack:
            fatalError("not implemented yet")
        case .safeBombards:
            fatalError("not implemented yet")
        case .heal:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .ancientRuins:
            fatalError("not implemented yet")
        case .garrisonToAllowBombards:
            fatalError("not implemented yet")
        case .bastionAlreadyThere:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .guardImprovementAlreadyThere:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .bastionOneTurn:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .garrisonOneTurn:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .guardImprovementOneTurn:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .airSweep:
            fatalError("not implemented yet")
        case .airIntercept:
            fatalError("not implemented yet")
        case .airRebase:
            //fatalError("not implemented yet")
            // FIXME
            break
        case .closeOnTarget:
            fatalError("not implemented yet")
        case .moveOperation:
            fatalError("not implemented yet")
        case .emergencyPurchases:
            fatalError("not implemented yet")
        case .postureWithdraw:
            fatalError("not implemented yet")
        case .postureSitAndBombard:
            fatalError("not implemented yet")
        case .postureAttritFromRange:
            fatalError("not implemented yet")
        case .postureExploitFlanks:
            fatalError("not implemented yet")
        case .postureSteamroll:
            fatalError("not implemented yet")
        case .postureSurgicalCityStrike:
            fatalError("not implemented yet")
        case .postureHedgehog:
            fatalError("not implemented yet")
        case .postureCounterAttack:
            fatalError("not implemented yet")
        case .postureShoreBombardment:
            fatalError("not implemented yet")*/
        
        default:
            // NOOP
            //print("not implemented: TacticalAI - \(tacticalMove.moveType)")
            break
        }
    }
    
    /// Move units to a better location
    private func plotRepositionMoves(in gameModel: GameModel?) {
        
        self.currentMoveUnits.removeAll()

        // Loop through all recruited units
        for currentTurnUnitRef in self.currentTurnUnits {
            
            if let currentTurnUnit = currentTurnUnitRef {
                
                self.currentMoveUnits.append(TacticalUnit(unit: currentTurnUnit))
            }
        }

        if self.currentMoveUnits.count > 0 {
            self.executeRepositionMoves(in: gameModel)
        }
    }
    
    /// Execute moving units to a better location
    private func executeRepositionMoves(in gameModel: GameModel?)
    {
        //CvPlot* pBestPlot = NULL;
        //CvString strTemp;
        
        for currentMoveUnitRef in self.currentMoveUnits {
            
            if let currentMoveUnit = currentMoveUnitRef, let unit = currentMoveUnit.unit {
                
                // LAND MOVES
                if unit.domain() == .land {
            
                    if let bestPlot = self.findNearbyTarget(for: unit, in: TacticalAI.repositionRange, in: gameModel) {
                        
                        if self.moveToEmptySpaceNearTarget(unit: unit, target: bestPlot, land: unit.domain() == .land, in: gameModel) {
                            
                            unit.finishMoves()
                            self.unitProcessed(unit: unit, markTacticalMap: unit.isCombatUnit(), in: gameModel)
                            
                            print("\(unit.name()) moved to empty space near target, \(bestPlot), Current \(unit.location)")
                        }
                    }
                }
            }
        }
    }
    
    /// Move up to our target avoiding our own units if possible
    @discardableResult
    private func moveToEmptySpaceNearTarget(unit: AbstractUnit?, target: HexPoint, land: Bool, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }

        // Look at spaces adjacent to target
        for neighbor in target.neighbors() {
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                
                if neighborTile.terrain().isLand() && land {
                    
                    // Must be currently empty of friendly combat units
                    // Enemies too
                    let occupant = gameModel.unit(at: neighbor)
                    
                    if occupant == nil {
                        
                        // And if it is a city, make sure we are friends with them, else we will automatically attack
                        let city = gameModel.city(at: neighbor)
                        if city == nil || city?.player?.leader == unit.player?.leader {
                            
                            // Find a path to this space
                            if unit.canReach(at: neighbor, in: 1, in: gameModel) {
                                // Go ahead with mission
                                unit.push(mission: UnitMission(type: .moveTo, at: neighbor), in: gameModel)
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    private func findNearbyTarget(for unit: AbstractUnit?, in range: Int, of type: TacticalTargetType = .none, noLikeUnit: AbstractUnit? = nil, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        var bestMovePlot: HexPoint? = nil
        var bestValue: Int = Int.max

        // Loop through all appropriate targets to find the closest
        for zoneTarget in self.zoneTargets {
            
            // Is the target of an appropriate type?
            var typeMatch = false
            
            if type == .none {
                
                if zoneTarget.targetType == .highPriorityUnit || zoneTarget.targetType == .mediumPriorityUnit || zoneTarget.targetType == .lowPriorityUnit || zoneTarget.targetType == .city || zoneTarget.targetType == .improvement {
                    
                    typeMatch = true
                }
            }
            else if zoneTarget.targetType == type {
                
                typeMatch = true
            }

            // Is this unit near enough?
            if typeMatch {
                
                if let tile = gameModel.tile(at: zoneTarget.target), let unitTile = gameModel.tile(at: unit.location) {
                    
                    let distance = tile.point.distance(to: unit.location)
                    
                    if distance == 0 {
                        return tile.point
                    } else if distance < range {
                        
                        if unitTile.area == tile.area {
                            
                            let unitAtTile = gameModel.unit(at: tile.point)
                            if noLikeUnit != nil || (unitAtTile != nil && unitAtTile!.hasSameType(as: noLikeUnit)) {
                                
                                let value = unit.turnsToReach(at: tile.point, in: gameModel)

                                if value < bestValue {
                                    bestMovePlot = tile.point
                                    bestValue = value
                                }
                            }
                        }
                    }
                }
            }
        }

        return bestMovePlot
    }
    
    /// Moved endangered units to safe hexes
    private func plotMovesToSafety(combatUnits: Bool, in gameModel: GameModel?) {
    
        guard let dangerPlotsAI = self.player?.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }
        
        self.currentMoveUnits.removeAll()

        // Loop through all recruited units
        for currentUnitRef in self.currentTurnUnits {
            
            if let currentUnit = currentUnitRef {
            
                let dangerLevel = dangerPlotsAI.danger(at: currentUnit.location)
                
                // Danger value of plot must be greater than 0
                if dangerLevel > 0 {
                
                    var addUnit = false
                    if combatUnits {
                        
                        // If under 100% health, might flee to safety
                        if currentUnit.damage() > 0 {
                            
                            if currentUnit.player?.leader == .barbar {
                                
                                // Barbarian combat units - only naval units flee (but they flee if have taken ANY damage)
                                if currentUnit.domain() == .sea {
                                    addUnit = true
                                }
                            }

                            // Everyone else flees at less than or equal to 50% combat strength
                            else if currentUnit.damage() > 50 {
                                addUnit = true
                            }
                        }

                        // Also flee if danger is really high in current plot (but not if we're barbarian)
                        else if currentUnit.player?.leader != .barbar {
                            
                            let acceptableDanger = currentUnit.baseCombatStrength(ignoreEmbarked: true) * 100
                            if Int(dangerLevel) > acceptableDanger {
                                addUnit = true
                            }
                        }
                        
                    } else {
                        
                        // Civilian (or embarked) units always flee from danger
                        if !currentUnit.canFortify(at: currentUnit.location, in: gameModel) {
                            addUnit = true
                        }
                    }

                    if addUnit {
                        // Just one unit involved in this move to execute
                        let tacticalUnit: TacticalUnit = TacticalUnit()
                        tacticalUnit.unit = currentUnitRef
                        self.currentMoveUnits.append(tacticalUnit)
                    }
                }
            }
        }

        if self.currentMoveUnits.count > 0 {
            self.executeMovesToSafestPlot(in: gameModel)
        }
    }
    
    /// Moves units to the hex with the lowest danger
    func executeMovesToSafestPlot(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let dangerPlotsAI = player?.dangerPlotsAI else {
            fatalError("cant get gameModel")
        }
        
        for currentUnitRef in self.currentTurnUnits {
            
            if let currentUnit = currentUnitRef {
                
                let range = currentUnit.moves()
                
                var lowestDanger = Double.greatestFiniteMagnitude
                var bestPlot: HexPoint? = nil

                var resultHasZeroDangerMove = false
                var resultInTerritory = false
                var resultInCity = false
                var resultInCover = false
                
                // For each plot within movement range of the fleeing unit
                for neighbor in currentUnit.location.areaWith(radius: range) {
                    
                    if !gameModel.valid(point: neighbor) {
                        continue
                    }
                    
                    // Can't be a plot with another player's unit in it or another of our unit of same type
                    if let otherUnit = gameModel.unit(at: neighbor) {
                        
                        if otherUnit.player?.leader == currentUnit.player?.leader {
                            continue
                        } else if currentUnit.hasSameType(as: otherUnit) {
                            continue
                        }
                    }
                    
                    if !currentUnit.canReach(at: neighbor, in: 1, in: gameModel) {
                        continue
                    }
                    
                    //   prefer being in a city with the lowest danger value
                    //   prefer being in a plot with no danger value
                    //   prefer being under a unit with the lowest danger value
                    //   prefer being in your own territory with the lowest danger value
                    //   prefer the lowest danger value
                    
                    let danger = dangerPlotsAI.danger(at: neighbor)
                    let isZeroDanger = danger <= 0.0
                    let city = gameModel.city(at: neighbor)
                    let isInCity = city != nil ? city!.player?.leader == self.player?.leader : false
                    let unit = gameModel.unit(at: neighbor)
                    let isInCover = unit != nil
                    let tile = gameModel.tile(at: neighbor)
                    let isInTerritory = tile != nil ? tile?.owner()?.leader == self.player?.leader : false

                    var updateBestValue = false
                    
                    if isInCity {
                        if !resultInCity || danger < lowestDanger {
                            updateBestValue = true
                        }
                    } else if isZeroDanger {
                        if !resultInCity {
                            if resultHasZeroDangerMove {
                                if isInTerritory && !resultInTerritory {
                                    updateBestValue = true
                                }
                            } else {
                                updateBestValue = true
                            }
                        }
                    } else if isInCover {
                        if !resultInCity && !resultHasZeroDangerMove {
                            if !resultInCover || danger < lowestDanger {
                                updateBestValue = true
                            }
                        }
                    } else if isInTerritory {
                        if !resultInCity && !resultInCover && !resultHasZeroDangerMove {
                            if !resultInTerritory || danger < lowestDanger {
                                updateBestValue = true
                            }
                        }
                    } else if !resultInCity && !resultInCover && !resultInTerritory && !resultHasZeroDangerMove {
                        
                        // if we have no good home, head to the lowest danger value
                        if danger < lowestDanger {
                            updateBestValue = true
                        }
                    }

                    if updateBestValue {
                        bestPlot = neighbor
                        lowestDanger = danger;

                        resultInTerritory = isInTerritory
                        resultInCity      = isInCity
                        resultInCover     = isInCover
                        resultHasZeroDangerMove = isZeroDanger
                    }
                }
                
                if let bestPlot = bestPlot {
                    
                    // Move to the lowest danger value found
                    currentUnit.push(mission: UnitMission(type: .moveTo, at: bestPlot), in: gameModel) // FIXME: , .ignoreDanger
                    currentUnit.finishMoves()
                    self.unitProcessed(unit: currentUnit, in: gameModel)
                    
                    print("Moving \(currentUnit) to safety, \(bestPlot)")
                }
            }
        }
    }
    
    /// Make a defensive move to garrison a city
    func plotGarrisonMoves(numTurnsAway: Int, mustAllowRangedAttack: Bool = false, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let targets = self.zoneTargets.filter({ $0.targetType == .cityToDefend })

        for target in targets {
            
            guard let tile = gameModel.tile(at: target.target) else {
                continue
            }
            
            guard let city = gameModel.city(at: target.target) else {
                continue
            }

            if city.lastTurnGarrisonAssigned() < gameModel.currentTurn {
                
                // Grab units that make sense for this move type
                self.findUnitsFor(move: .garrisonAlreadyThere, target: tile, turnsAway: numTurnsAway, rangedOnly: mustAllowRangedAttack, in: gameModel)

                if self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count > 0 {
                    
                    self.executeMoveToTarget(target: target.target, garrisonIfPossible: true, in: gameModel)
                    city.setLastTurnGarrisonAssigned(turn: gameModel.currentTurn)
                }
            }
            
        }
    }
    
    /// Find one unit to move to target, starting with high priority list
    func executeMoveToTarget(target point: HexPoint, garrisonIfPossible: Bool, in gameModel: GameModel?) {
        
        // Start with high priority list
        for currentMoveHighPriorityUnit in self.currentMoveHighPriorityUnits {
            
            guard let currentMoveHighPriorityUnit = currentMoveHighPriorityUnit else {
                continue
            }
            
            guard let unit = currentMoveHighPriorityUnit.unit else {
                continue
            }
            
            // Don't move high priority unit, if regular priority unit is closer
            if let firstCurrentUnit = self.currentMoveUnits.first {
                if firstCurrentUnit!.movesToTarget < currentMoveHighPriorityUnit.movesToTarget {
                    break
                }
            }

            if unit.location == point && unit.canFortify(at: point, in: gameModel) {
                
                unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                unit.doFortify(in: gameModel)
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if garrisonIfPossible && unit.location == point && unit.canGarrison(at: point, in: gameModel) {
                
                unit.push(mission: UnitMission(type: .garrison), in: gameModel)
                unit.finishMoves()
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if currentMoveHighPriorityUnit.movesToTarget < Int.max {
                
                unit.push(mission: UnitMission(type: .moveTo, at: point), in: gameModel)
                unit.finishMoves()
                self.unitProcessed(unit: unit, in: gameModel)
                return
            }
        }

        // Then regular priority
        for currentMoveUnit in self.currentMoveUnits {
            
            guard let currentMoveUnit = currentMoveUnit else {
                continue
            }
            
            guard let unit = currentMoveUnit.unit else {
                continue
            }

            if unit.location == point && unit.canFortify(at: unit.location, in: gameModel) {

                unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                unit.doFortify(in: gameModel)
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if currentMoveUnit.movesToTarget < Int.max {
                
                unit.push(mission: UnitMission(type: .moveTo, at: point), in: gameModel)
                unit.finishMoves()
                self.unitProcessed(unit: unit, in: gameModel)
                return
            }
        }
    }
    
    /// Finds both high and normal priority units we can use for this move (returns true if at least 1 unit found)
    @discardableResult
    private func findUnitsFor(move: TacticalMoveType, target: AbstractTile?, turnsAway: Int = -1, rangedOnly: Bool, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        //UnitHandle pLoopUnit;
        var rtnValue = false

        //list<int>::iterator it;
        self.currentMoveUnits.removeAll()
        self.currentMoveHighPriorityUnits.removeAll()
        
        let astar = AStarPathfinder()

        // Loop through all units available to tactical AI this turn
        for currentTurnUnit in self.currentTurnUnits {
            
            guard let loopUnit = currentTurnUnit else {
                continue
            }
            
            if loopUnit.domain() != .air && loopUnit.isCombatUnit() {
                
                // Make sure domain matches
                if loopUnit.domain() == .sea && !target.terrain().isWater() ||
                    loopUnit.domain() == .land && target.terrain().isWater() {
                    continue
                }

                var suitableUnit = false
                var highPriority = false

                if move == .garrisonAlreadyThere || move == .garrisonOneTurn {
                    
                    // Want to put ranged units in cities to give them a ranged attack
                    if loopUnit.isRanged() {
                        suitableUnit = true
                        highPriority = true
                    } else if rangedOnly {
                        continue
                    }

                    // Don't put units with a combat strength boosted from promotions in cities, these boosts are ignored
                    if loopUnit.defenseModifier(against: nil, on: nil, ranged: false, in: gameModel) == 0 && loopUnit.attackModifier(against: nil, or: nil, on: nil, in: gameModel) == 0 {
                        suitableUnit = true
                    }
                } else if move == .guardImprovementAlreadyThere || move == .guardImprovementOneTurn || move == .bastionAlreadyThere || move == .bastionOneTurn {
                    
                    // No ranged units or units without defensive bonuses as plot defenders
                    if !loopUnit.isRanged() /*&& !loopUnit->noDefensiveBonus()*/ {
                        suitableUnit = true

                        // Units with defensive promotions are especially valuable
                        if loopUnit.defenseModifier(against: nil, on: nil, ranged: false, in: gameModel) > 0 /* || pLoopUnit->getExtraCombatPercent() > 0*/ {
                            highPriority = true
                        }
                    }
                } else if move == .ancientRuins {
                    
                    // Fast movers are top priority
                    if loopUnit.has(task: .fastAttack) {
                        suitableUnit = true
                        highPriority = true
                    } else if loopUnit.canAttack() {
                        suitableUnit = true
                    }
                }

                if suitableUnit {
                    // Is it even possible for the unit to reach in the number of requested turns (ignoring roads and RR)
                    let distance = target.point.distance(to: loopUnit.location)
                    if loopUnit.maxMoves(in: gameModel) > 0 {
                        
                        let movesPerTurn = loopUnit.maxMoves(in: gameModel) // / GC.getMOVE_DENOMINATOR();
                        let leastTurns = (distance + movesPerTurn - 1) / movesPerTurn
                        
                        if turnsAway == -1 || leastTurns <= turnsAway {
                            
                            // If unit was suitable, and close enough, add it to the proper list
                            astar.dataSource = gameModel.ignoreUnitsPathfinderDataSource(for: loopUnit.movementType(), for: loopUnit.player)
                            let moves = astar.turnsToReachTarget(for: loopUnit, to: target.point)
                            
                            if moves != Int.max && (turnsAway == -1 || (turnsAway == 0 && loopUnit.location == target.point) || moves <= turnsAway) {
                                
                                let unit = TacticalUnit(unit: loopUnit)
                                unit.healthPercent = loopUnit.healthPoints() * 100 / loopUnit.maxHealthPoints()
                                unit.movesToTarget = moves

                                if highPriority {
                                    self.currentMoveHighPriorityUnits.append(unit)
                                } else {
                                    self.currentMoveUnits.append(unit)
                                }
                                rtnValue = true
                            }
                        }
                    }
                }
            }
        }

        return rtnValue
    }
    
    /// Choose which tactics to run and assign units to it (barbarian version)
    private func assignBarbarianMoves(in gameModel: GameModel?) {
     
        for move in self.movePriorityList {
            
            switch move.moveType {
                
            case .barbarianCaptureCity: // AI_TACTICAL_BARBARIAN_CAPTURE_CITY
                self.plotCaptureCityMoves(in: gameModel)
                
            case .barbarianDamageCity: // AI_TACTICAL_BARBARIAN_DAMAGE_CITY
                self.plotDamageCityMoves(in: gameModel)
                
            case .barbarianDestroyHighPriorityUnit: // AI_TACTICAL_BARBARIAN_DESTROY_HIGH_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .highPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianDestroyMediumPriorityUnit: // AI_TACTICAL_BARBARIAN_DESTROY_MEDIUM_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .mediumPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianDestroyLowPriorityUnit: // AI_TACTICAL_BARBARIAN_DESTROY_LOW_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: true, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianMoveToSafety: // AI_TACTICAL_BARBARIAN_MOVE_TO_SAFETY
                self.plotMovesToSafety(combatUnits: true, in: gameModel)
                
            case .barbarianAttritHighPriorityUnit: // AI_TACTICAL_BARBARIAN_ATTRIT_HIGH_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .highPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianAttritMediumPriorityUnit: // AI_TACTICAL_BARBARIAN_ATTRIT_MEDIUM_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .mediumPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianAttritLowPriorityUnit: // AI_TACTICAL_BARBARIAN_ATTRIT_LOW_PRIORITY_UNIT
                self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: false, in: gameModel)
                
            case .barbarianPillage: // AI_TACTICAL_BARBARIAN_PILLAGE
                self.plotPillageMoves(targetType: .improvementResource, firstPass: true, in: gameModel)
                
            case .barbarianPillageCitadel: // AI_TACTICAL_BARBARIAN_PILLAGE_CITADEL
                self.plotPillageMoves(targetType: .citadel, firstPass: true, in: gameModel)
                
            case .barbarianPillageNextTurn: // AI_TACTICAL_BARBARIAN_PILLAGE_NEXT_TURN
                self.plotPillageMoves(targetType: .citadel, firstPass: false, in: gameModel)
                self.plotPillageMoves(targetType: .improvementResource, firstPass: false, in: gameModel)
                
            case .barbarianBlockadeResource: // AI_TACTICAL_BARBARIAN_PRIORITY_BLOCKADE_RESOURCE
                //            PlotBlockadeImprovementMoves();
                break
                
            case .barbarianCivilianAttack: // AI_TACTICAL_BARBARIAN_CIVILIAN_ATTACK
                self.plotCivilianAttackMoves(targetType: .veryHighPriorityCivilian, in: gameModel)
                self.plotCivilianAttackMoves(targetType: .highPriorityCivilian, in: gameModel)
                self.plotCivilianAttackMoves(targetType: .mediumPriorityCivilian, in: gameModel)
                self.plotCivilianAttackMoves(targetType: .lowPriorityCivilian, in: gameModel)
            
            case .barbarianCampDefense: // AI_TACTICAL_BARBARIAN_CAMP_DEFENSE
                self.plotCampDefenseMoves(in: gameModel)
                        
            case .barbarianAggressiveMove: // AI_TACTICAL_BARBARIAN_AGGRESSIVE_MOVE
                self.plotBarbarianMove(aggressive: true, in: gameModel)
                        
            case .barbarianPassiveMove: // AI_TACTICAL_BARBARIAN_PASSIVE_MOVE
                self.plotBarbarianMove(aggressive: false, in: gameModel)
                        
            case .barbarianDesperateAttack: // AI_TACTICAL_BARBARIAN_DESPERATE_ATTACK
                self.plotDestroyUnitMoves(targetType: .lowPriorityUnit, mustBeAbleToKill: false, attackAtPoorOdds: true, in: gameModel)
                        
            case .barbarianEscortCivilian: // AI_TACTICAL_BARBARIAN_ESCORT_CIVILIAN
                self.plotBarbarianCivilianEscortMove(in: gameModel)
                        
            case .barbarianPlunderTradeUnit: // AI_TACTICAL_BARBARIAN_PLUNDER_TRADE_UNIT
                self.plotBarbarianPlunderTradeUnitMove(in: .land, in: gameModel)
                self.plotBarbarianPlunderTradeUnitMove(in: .sea, in: gameModel)

            case .barbarianGuardCamp:
                self.plotGuardBarbarianCamp(in: gameModel)
                
            default:
                // NOOP
                print("not implemented: TacticalAI - \(move.moveType)")
                break
            }
        }
        
        self.reviewUnassignedUnits(in: gameModel)
    }
    
    /// Log that we couldn't find assignments for some units
    func reviewUnassignedUnits(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Loop through all remaining units
        for currentTurnUnitRef in self.currentTurnUnits {
            
            if let currentTurnUnit = currentTurnUnitRef {
                
                // Barbarians and air units aren't handled by the operational or homeland AIs
                if currentTurnUnit.player?.leader == .barbar || currentTurnUnit.domain() == .air {
                    
                    currentTurnUnit.push(mission: UnitMission(type: .skip), in: gameModel)
                    currentTurnUnit.set(turnProcessed: true)
                    
                    print("Unassigned \(currentTurnUnit.name()) at \(currentTurnUnit.location)")
                }
            }
        }
    }
    
    /// Move barbarians across the map
    func plotBarbarianMove(aggressive: Bool, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if player.isBarbarian() {
            
            self.currentMoveUnits.removeAll()

            // Loop through all recruited units
            for currentTurnUnitRef in self.currentTurnUnits {
                
                guard let currentTurnUnit = currentTurnUnitRef else {
                    continue
                }
                
                let unit = TacticalUnit(unit: currentTurnUnit)

                self.currentMoveUnits.append(unit);
            }

            if self.currentMoveUnits.count > 0 {
                self.executeBarbarianMoves(aggressive: aggressive, in: gameModel)
            }
        }
    }
    
    /// Plunder trade routes
    func plotBarbarianPlunderTradeUnitMove(in domain: UnitDomainType, in gameModel: GameModel?) {
        
        var targetType: TacticalTargetType = TacticalTargetType.none
        var navalOnly = false
        
        if domain == .land {
            targetType = TacticalTargetType.tradeUnitLand
        } else if domain == .sea {
            targetType = TacticalTargetType.tradeUnitSea
            navalOnly = true
        }

        if targetType == TacticalTargetType.none {
            return
        }

        for target in self.zoneTargets(for: targetType) {
            
            // See what units we have who can reach target this turn
            if self.findUnitsWithinStrikingDistance(towards: target!.target, numTurnsAway: 0, noRangedUnits: false, navalOnly: navalOnly, in: gameModel) {
                
                // Queue best one up to capture it
                self.executePlunderTradeUnit(at: target!.target, in: gameModel)
            }
        }
    }
    
    /// Escort captured civilians back to barbarian camps
    func plotBarbarianCivilianEscortMove(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }
               
        if player.isBarbarian() {
            
            self.currentMoveUnits.removeAll()

            for currentTurnUnitRef in self.currentTurnUnits {
                
                guard let currentTurnUnit = currentTurnUnitRef else {
                    continue
                }
                
                // Find any civilians we may have "acquired" from the civs
                if !currentTurnUnit.canAttack() {
                    
                    let unit = TacticalUnit(unit: currentTurnUnit)
                    self.currentMoveUnits.append(unit)
                }
            }

            if self.currentMoveUnits.count > 0 {
                self.executeBarbarianCivilianEscortMove(in: gameModel)
            }
        }
    }
    
    /// Move Barbarian civilian to a camp (with escort if possible)
    func executeBarbarianCivilianEscortMove(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        for civilianMoveUnitRef in self.currentMoveUnits {
            
            guard let civilian = civilianMoveUnitRef?.unit else {
                continue
            }

            if let target = self.findNearbyTarget(for: civilian, in: Int.max, of: .barbarianCamp, noLikeUnit: civilian, in: gameModel) {

                // If we're not there yet, we have work to do
                var current = civilian.location
                if current == target {
                    civilian.finishMoves()
                    self.unitProcessed(unit: civilian, in: gameModel)
                } else {
                    
                    var escortRef: AbstractUnit? = nil
                    
                    if let loopUnit = gameModel.unit(at: current) {
                        
                        if civilian.player!.isEqual(to: loopUnit.player) {
                            escortRef = loopUnit
                        }
                    }

                    // Handle case of no path found at all for civilian
                    if let path = civilian.path(towards: target, in: gameModel) {
                        
                        let civilianMove = path.last!.0 // pCivilian->GetPathEndTurnPlot();

                        // Can we reach our target this turn?
                        if civilianMove == target {
                            
                            // See which defender is stronger
                            //UnitHandle pCampDefender = pCivilianMove->getBestDefender(m_pPlayer->GetID());
                            if let escort = escortRef {
                                self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel)
                                self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)

                            } else {
                                self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                            }
                        } else if escortRef == nil {
                            // Can't reach target and don't have escort...
                            self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                        } else { // Can't reach target and DO have escort...
                            // See if escort can move to the same location in one turn
                            
                            if let escort = escortRef {
                                if escort.turnsToReach(at: civilianMove, in: gameModel) <= 1 {
                                    self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel)
                                    self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                                } else {
                                    
                                    // See if friendly blocking unit is ending the turn there, or if no blocking unit (which indicates this is somewhere civilian
                                    // can move that escort can't), then find a new path based on moving the escort
                                    if let blockingUnit = gameModel.unit(at: civilianMove) {
                                        
                                        // Looks like we should be able to move the blocking unit out of the way
                                        if self.executeMoveOfBlockingUnit(of: blockingUnit, in: gameModel) {
                                            self.executeMoveToPlot(of: escort, to: civilianMove, in: gameModel)
                                            self.executeMoveToPlot(of: civilian, to: civilianMove, in: gameModel)
                                        } else {
                                            civilian.finishMoves()
                                            escort.finishMoves()
                                        }
                                    } else {
                                        
                                        if let path = civilian.path(towards: target, in: gameModel) {
                                            
                                            let escortMove = path.last!.0

                                            // See if civilian can move to the same location in one turn
                                            if civilian.turnsToReach(at: escortMove, in: gameModel) <= 1 {
                                                self.executeMoveToPlot(of: escort, to: escortMove, in: gameModel)
                                                self.executeMoveToPlot(of: civilian, to: escortMove, in: gameModel)
                                            } else {
                                                civilian.finishMoves()
                                                escort.finishMoves()
                                            }
                                        } else  {
                                            civilian.finishMoves()
                                            escort.finishMoves()
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        
                        civilian.finishMoves()
                        if let escort = escortRef {
                            escort.finishMoves()
                        }
                    }
                }
            }
            
        }
    }
    
    /// Find an adjacent hex to move a blocking unit to
    func executeMoveOfBlockingUnit(of blockingUnit: AbstractUnit?, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let blockingUnit = blockingUnit else {
            fatalError("cant get blockingUnit")
        }
        
        if !blockingUnit.canMove() || self.isInQueuedAttack(unit: blockingUnit) {
            return false
        }

        guard let oldPlot = gameModel.tile(at: blockingUnit.location) else {
            fatalError("cant get old plot")
        }

        for neighbor in blockingUnit.location.neighbors() {
            
            if let plot = gameModel.tile(at: neighbor) {
                
                // Don't embark for one of these moves
                if !oldPlot.isWater() && plot.isWater() && blockingUnit.domain() == .land {
                    continue
                }

                // Has to be somewhere we can move and be empty of other units/enemy cities
                if gameModel.visibleEnemy(at: neighbor, for: self.player) == nil && gameModel.visibleEnemyCity(at: blockingUnit.location, for: self.player) == nil /*&& pBlockingUnit->GeneratePath(pPlot))*/ {
                    
                    self.executeMoveToPlot(of: blockingUnit, to: neighbor, in: gameModel)

                    return true
                }
            }
        }
        
        return false
    }
    
    /// Is this unit waiting to get its turn to attack?
    func isInQueuedAttack(unit: AbstractUnit?) -> Bool {
        
        if self.queuedAttacks.count > 0 {
            
            for queuedAttacksRef in self.queuedAttacks {
                
                if let attacker = queuedAttacksRef.attackerUnit {
                    if attacker.isEqual(to: unit) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    /// Move barbarian to a new location
    func executeBarbarianMoves(aggressive: Bool, in gameModel: GameModel?) {

        for currentMoveUnitRef in self.currentMoveUnits {
            
            if let unit = currentMoveUnitRef?.unit {
                
                if unit.isBarbarian() {
                    
                    // LAND MOVES
                    if unit.domain() == .land {
                        
                        var bestPlot: HexPoint?
                        if aggressive {
                            bestPlot = self.findBestBarbarianLandMove(for: unit, in: gameModel)
                        } else {
                            bestPlot = self.findPassiveBarbarianLandMove(for: unit, in: gameModel)
                        }

                        if let bestPlot = bestPlot {
                            self.moveToEmptySpaceNearTarget(unit: unit, target: bestPlot, land: true, in: gameModel)
                            unit.finishMoves();
                            self.unitProcessed(unit: unit, in: gameModel)
                        } else {
                            unit.finishMoves();
                            self.unitProcessed(unit: unit, in: gameModel)
                        }
                    } else { // NAVAL MOVES
                        
                        var bestPlot: HexPoint?
                        
                        // Do I still have a destination from a previous turn?
                        let currentDestination = unit.tacticalTarget()

                        // Compute a new destination if I don't have one or am already there
                        if currentDestination == nil || currentDestination == unit.location {
                            bestPlot = self.findBestBarbarianSeaMove(for: unit, in: gameModel)
                        } else { // Otherwise just keep moving there (assuming a path is available)
                            if unit.turnsToReach(at: currentDestination!, in: gameModel) != Int.max {
                                bestPlot = currentDestination
                            } else {
                                bestPlot = self.findBestBarbarianSeaMove(for: unit, in: gameModel)
                            }
                        }

                        if let bestPlot = bestPlot {
                            
                            unit.set(tacticalTarget: bestPlot)
                            unit.push(mission: UnitMission(type: .moveTo, at: bestPlot), in: gameModel)
                            unit.finishMoves();
                            self.unitProcessed(unit: unit, in: gameModel)
                        } else {
                            unit.resetTacticalTarget()
                            unit.finishMoves()
                            self.unitProcessed(unit: unit, in: gameModel)
                        }
                    }
                }
            }
        }
    }
    
    /// Find a multi-turn target for a sea barbarian to wander towards
    func findBestBarbarianSeaMove(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let economicAI = self.player?.economicAI else {
            fatalError("cant get economicAI")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        let barbarianSeaTargetRange = gameModel.handicap.barbarbianSeaTargetRange()
        
        var bestValue = Int.max
        var bestMovePlot: HexPoint? = nil

        // Loop through all unit targets to find the closest
        for targetRef in self.unitTargets() {
            
            guard let target = targetRef else {
                continue
            }
            
            // Is this unit nearby enough?
            if unit.location.distance(to: target.target) < barbarianSeaTargetRange {
                
                if gameModel.area(of: unit.location) ==  gameModel.area(of: target.target) {
                    
                    let value = unit.turnsToReach(at: target.target, in: gameModel)
                    if value < bestValue {
                        bestValue = value
                        bestMovePlot = target.target
                    }
                }
            }
        }

        // move toward trade routes
        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianGankTradeRouteTarget(for: unit, in: gameModel)
        }

        // No units to pick on, so sail to a tile adjacent to the second closest barbarian camp
        if bestMovePlot == nil {
        
            var nearestCamp: HexPoint? = nil
            var bestCampDistance = Int.max
            var bestValue = Int.max

            // Start by finding the very nearest camp
            for targetRef in self.zoneTargets(for: .barbarianCamp) {
                
                guard let target = targetRef else {
                    continue
                }
                
                let distance = unit.location.distance(to: target.target)
                
                if distance < bestCampDistance {
                    
                    nearestCamp = target.target
                    bestCampDistance = distance
                }
            }

            // The obvious way to do this next part is to plot moves to each naval tile adjacent to each camp ...
            // starting with the first camp and then proceeding to the final one.  But our optimization (to drop out
            // targets that are further from the closest we've found so far) might in worst case not help at all if we
            // check the closest camp last.  So instead we'll loop by DIRECTIONS first which should mean we pick up some plot
            // from a close camp early (and the optimization will help)
            for dir in HexDirection.all {
                
                for targetRef in self.zoneTargets(for: .barbarianCamp) {
                
                    guard let target = targetRef else {
                        continue
                    }
                    
                    if nearestCamp != target.target {
                        
                        if let tile = gameModel.tile(at: target.target) {
                            
                            if tile.isWater() {
                                
                                let distance = unit.location.distance(to: target.target)
                                
                                if distance < bestValue {
                                    
                                    bestMovePlot = target.target
                                    bestValue = distance
                                }
                            }
                        }
                    }
                }
            }
        }

        // No obvious target, let's scan nearby tiles for the best choice, borrowing some of the code from the explore AI
        if bestMovePlot == nil {
            
            // Now looking for BEST score
            var bestValue = 0
            let movementRange = unit.movesLeft()
            
            for considerLocation in unit.location.areaWith(radius: movementRange) {
                
                if gameModel.unit(at: considerLocation) != nil {
                    continue
                }
                
                guard let considerPlot = gameModel.tile(at: considerLocation) else {
                    continue
                }
                    
                if !considerPlot.isDiscovered(by: unit.player) {
                    continue
                }
                
                
                if !unit.canReach(at: considerLocation, in: movementRange, in: gameModel) {
                    continue
                }
                
                // Value them based on their explore value
                var value: Int = economicAI.scoreExplore(plot: considerLocation, for: self.player, range: unit.sight(), domain: unit.domain(), in: gameModel)
                
                // Add special value for being near enemy lands
                /*if considerPlot.isAdjacentOwned() {
                    value += 100
                } else*/ if considerPlot.hasOwner() {
                    value += 200
                }
                
                // If still have no value, score equal to distance from my current plot
                if value == 0 {
                    value = unit.location.distance(to: considerLocation)
                }

                if value > bestValue {
                    bestMovePlot = considerLocation
                    bestValue = value
                }
            }
        }

        return bestMovePlot
    }
    
    /// Find a multi-turn target for a land barbarian to wander towards
    func findBestBarbarianLandMove(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        let landBarbarianRange = gameModel.handicap.barbarbianLandTargetRange()
        
        var bestMovePlot = self.findNearbyTarget(for: unit, in: landBarbarianRange, in: gameModel)
        
        // move toward trade routes
        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianGankTradeRouteTarget(for: unit, in: gameModel)
        }

        // explore wander
        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianExploreTarget(for: unit, in: gameModel)
        }

        return bestMovePlot
    }
    
    /// Scan nearby tiles for a trade route to sit and gank from
    func findBarbarianGankTradeRouteTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        var bestMovePlot: HexPoint? = nil

        // Now looking for BEST score
        var bestValue = 0;
        let movementRange = unit.movesLeft()
        
        for plot in unit.location.areaWith(radius: movementRange) {
            
            if plot == unit.location {
                continue
            }
            
            guard let tile = gameModel.tile(at: plot) else {
                continue
            }
            
            if !tile.isDiscovered(by: self.player) {
                continue
            }
            
            if !unit.canReach(at: plot, in: movementRange, in: gameModel) {
                continue
            }
            
            let value = gameModel.numTradeRoutes(at: plot)
            
            if value > bestValue {
                bestMovePlot = plot
                bestValue = value
            }
        }
        
        return bestMovePlot
    }
    
    /// Find a multi-turn target for a land barbarian to wander towards
    func findPassiveBarbarianLandMove(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
    
        guard let unit = unit else {
            fatalError("cant get unit")
        }

        var bestValue = Int.max
        var bestMovePlot: HexPoint? = nil

        for allTarget in self.allTargets {
            
            // Is this target a camp?
            if allTarget.targetType == .barbarianCamp {
                
                let value = unit.location.distance(to: allTarget.target)
                
                if value < bestValue {
                    
                    bestValue = value
                    bestMovePlot = allTarget.target
                }
            }
        }

        if bestMovePlot == nil {
            bestMovePlot = self.findBarbarianExploreTarget(for: unit, in: gameModel)
        }

        return bestMovePlot
    }
    
    /// Scan nearby tiles for the best choice, borrowing code from the explore AI
    func findBarbarianExploreTarget(for unit: AbstractUnit?, in gameModel: GameModel?) -> HexPoint? {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let economicAI = self.player?.economicAI else {
            fatalError("cant get economicAI")
        }
    
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        var bestValue = 0
        var bestMovePlot: HexPoint? = nil
        let movementRange = unit.movesLeft()

        // Now looking for BEST score
        for plot in unit.location.areaWith(radius: movementRange) {
        
            if plot == unit.location {
                continue
            }
        
            guard let tile = gameModel.tile(at: plot) else {
                continue
            }
        
            if !tile.isDiscovered(by: self.player) {
                continue
            }
            
            if !unit.canReach(at: plot, in: movementRange, in: gameModel) {
                continue
            }
            
            // Value them based on their explore value
            var value = economicAI.scoreExplore(plot: plot, for: self.player, range: unit.sight(), domain: unit.domain(), in: gameModel)

            // Add special value for popping up on hills or near enemy lands
            /*if(pPlot->isAdjacentOwned())
            {
                iValue += 100;
            }
             else*/ if tile.hasOwner() {
                value += 200
            }

            // If still have no value, score equal to distance from my current plot
            if value == 0 {
                value = unit.location.distance(to: plot)
            }
            
            if value > bestValue {
                bestMovePlot = plot
                bestValue = value
            }
        }
        
        return bestMovePlot
    }
    
    /// Pillage an undefended improvement
    func executePlunderTradeUnit(at point: HexPoint, in gameModel: GameModel?) {
        
        // Move first one to target
        if let currentMoveUnit = self.currentMoveUnits.first {
            
            if let unit = currentMoveUnit?.unit {
                unit.push(mission: UnitMission(type: .moveTo, buildType: nil, at: point), in: gameModel)
                unit.push(mission: UnitMission(type: .plunderTradeRoute), in: gameModel)
                unit.finishMoves()
                
                // Delete this unit from those we have to move
                self.unitProcessed(unit: unit, in: gameModel)
            }
        }
    }
    
    /// Assign a group of units to attack each unit we think we can destroy
    func plotDestroyUnitMoves(targetType: TacticalTargetType, mustBeAbleToKill: Bool, attackAtPoorOdds: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var requiredDamage: Int = 0
        var expectedDamage: Int = 0

        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: targetType) {
            
            var unitCanAttack = false
            var cityCanAttack = false
            
            // See what units we have who can reach targets this turn
            if let targetLocation = target?.target {
                
                guard let tile = gameModel.tile(at: targetLocation) else {
                    continue
                }
                
                if let defender = gameModel.unit(at: targetLocation) {
                
                    unitCanAttack = self.findUnitsWithinStrikingDistance(towards: targetLocation, numTurnsAway: 1, noRangedUnits: false, navalOnly: false, in: gameModel)
                    cityCanAttack = self.findCitiesWithinStrikingDistance(of: targetLocation, in: gameModel)
                    
                    if unitCanAttack || cityCanAttack {
                        
                        expectedDamage = self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel)
                        expectedDamage += self.computeTotalExpectedBombardDamage(against: defender, in: gameModel)
                        requiredDamage = defender.healthPoints()
                        target?.damage = requiredDamage

                        if !mustBeAbleToKill {
                            // Attack no matter what
                            if attackAtPoorOdds {
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: false, in: gameModel)
                            } else {
                                // If we can at least knock the defender to 40% strength with our combined efforts, go ahead even if each individual attack isn't favorable
                                var mustInflictWhatWeTake = true
                                if expectedDamage >= (requiredDamage * 40) / 100 {
                                    mustInflictWhatWeTake = false
                                }
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: mustInflictWhatWeTake, mustSurviveAttack: true, in: gameModel)
                            }
                        } else {
                            // Do we have enough firepower to destroy it?
                            if expectedDamage > requiredDamage {
                                
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: (targetType != .highPriorityUnit), in: gameModel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Assigns units to capture undefended civilians
    func plotCivilianAttackMoves(targetType: TacticalTargetType, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for targetRef in self.zoneTargets(for: targetType) {
        
            guard let target = targetRef else {
                continue
            }
            
            // See what units we have who can reach target this turn
            if self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 1, noRangedUnits: false, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: false, willPillage: false, targetUndefended: true, in: gameModel) {
                
                // Queue best one up to capture it
                self.executeCivilianCapture(at: target.target, in: gameModel)
            }
        }
    }
    
    /// Assigns a barbarian to go protect an undefended camp
    func plotCampDefenseMoves(in gameModel: GameModel?) {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        for targetRef in self.zoneTargets(for: .barbarianCamp) {
        
            guard let target = targetRef else {
                continue
            }
            
            if self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 1, noRangedUnits: true, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: false, willPillage: false, targetUndefended: true, in: gameModel) {
                
                self.executeMoveToPlot(to: target.target, saveMoves: false, in: gameModel)
            }
        }
    }
    
    func plotGuardBarbarianCamp(in gameModel: GameModel?) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if player.isBarbarian() {
        
            self.currentMoveUnits.removeAll()
                
            for loopUnitRef in self.currentTurnUnits {
            
                guard let loopUnit = loopUnitRef else {
                    continue
                }
                
                // is unit already at a camp?
                if let tile = gameModel?.tile(at: loopUnit.location) {
                    if tile.has(improvement: .barbarianCamp) {
                        let unit = TacticalUnit(unit: loopUnit)
                        self.currentMoveUnits.append(unit)
                    }
                }
            }
            
            if self.currentMoveUnits.count > 0 {
                self.executeGuardBarbarianCamp(in: gameModel)
            }
        }
    }
    
    func executeGuardBarbarianCamp(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // unit should stay
        for currentMoveUnitRef in self.currentMoveUnits {
            
            guard let currentMoveUnit = currentMoveUnitRef?.unit else {
                continue
            }
            
            currentMoveUnit.finishMoves()
            self.unitProcessed(unit: currentMoveUnit, markTacticalMap: currentMoveUnit.isCombatUnit(), in: gameModel)
        }
    }
    
    /// Move unit to protect a specific tile (retrieve unit from first entry in m_CurrentMoveUnits)
    func executeMoveToPlot(to point: HexPoint, saveMoves: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Move first one to target
        if let firstCurrentModeUnit = self.currentMoveUnits.first {
            
            if let unit = firstCurrentModeUnit?.unit {
                
                self.executeMoveToPlot(of: unit, to: point, saveMoves: saveMoves, in: gameModel)
            }
        }
    }
    
    /// Move unit to protect a specific tile (retrieve unit from first entry in m_CurrentMoveUnits)
    func executeMoveToPlot(of unit: AbstractUnit?, to point: HexPoint, saveMoves: Bool = false, in gameModel: GameModel?) {
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        // Unit already at target plot?
        if point == unit.location {
            
            // Fortify if possible
            if unit.canFortify(at: point, in: gameModel) {
                 unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                //unit.fort ->SetFortifiedThisTurn(true);
            } else {
                unit.push(mission: UnitMission(type: .skip), in: gameModel)
                if !saveMoves {
                    unit.finishMoves()
                }
            }
        } else {
            unit.push(mission: UnitMission(type: .moveTo, at: point) , in: gameModel)
            if !saveMoves {
                unit.finishMoves()
            }
        }

        self.unitProcessed(unit: unit, markTacticalMap: unit.isCombatUnit(), in: gameModel)
    }
    
    /// Capture an undefended civilian
    func executeCivilianCapture(at point: HexPoint, in gameModel: GameModel?) {
        
        // Move first one to target
        if let currentMoveUnit = self.currentMoveUnits.first {
            
            if let unit = currentMoveUnit?.unit {
                unit.push(mission: UnitMission(type: .moveTo, buildType: nil, at: point), in: gameModel)
                unit.finishMoves()
                
                // Delete this unit from those we have to move
                self.unitProcessed(unit: unit, in: gameModel)
                
                unit.resetTacticalTarget()
            }
        }
    }
    
    /// Assigns units to pillage enemy improvements
    func plotPillageMoves(targetType: TacticalTargetType, firstPass: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        //let pillageHeal = 25 /* PILLAGE_HEAL_AMOUNT */

        for targetRef in self.zoneTargets(for: targetType) {
            
            guard let target = targetRef else {
                continue
            }
            
            // try paratroopers first, not because they are more effective, just because it looks cooler...
            /*if (bFirstPass && FindParatroopersWithinStrikingDistance(pPlot))
            {
                // Queue best one up to capture it
                ExecuteParadropPillage(pPlot);
            } else */
            
            if firstPass && self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 0, noRangedUnits: false , navalOnly: false, mustMoveThrough: true, includeBlockedUnits: false, willPillage: true, in: gameModel) {
                
                // Queue best one up to capture it
                self.executePillage(at: target.target, in: gameModel)
            }

            // No one can reach it this turn, what about next turn?
            else if !firstPass && self.findUnitsWithinStrikingDistance(towards: target.target, numTurnsAway: 2, noRangedUnits: false, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: false, willPillage: true, in: gameModel) {
                
                self.executeMoveToTarget(target: target.target, garrisonIfPossible: false, in: gameModel)
            }
        }
    }
    
    /// Pillage an undefended improvement
    private func executePillage(at point: HexPoint, in gameModel: GameModel?) {
        
        // Move first one to target
        if let currentMoveUnit = self.currentMoveUnits.first {
            
            if let unit = currentMoveUnit?.unit {
                unit.push(mission: UnitMission(type: .moveTo, buildType: nil, at: point), in: gameModel)
                unit.push(mission: UnitMission(type: .pillage), in: gameModel)
                unit.finishMoves()
                
                // Delete this unit from those we have to move
                self.unitProcessed(unit: unit, in: gameModel)
            }
        }
    }
    
    /// Assign a group of units to take down each city we can capture
    @discardableResult
    private func plotCaptureCityMoves(in gameModel: GameModel?) -> Bool {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var attackMade = false
        
        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: .city) {
            
            // See what units we have who can reach target this turn
            if let tile = target?.tile {
                
                if self.findUnitsWithinStrikingDistance(towards: tile.point, numTurnsAway: 1, in: gameModel) {
                    
                    // Do we have enough firepower to destroy it?
                    if let city = gameModel.city(at: tile.point) {
                        
                        let requiredDamage = 200 - city.damage()
                        target?.damage = requiredDamage
                        
                        if self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel) >= requiredDamage {
                            
                            print("### Attacking city of \(city.name) to capture \(city.location.x), \(city.location.y) by \(String(describing: self.player?.leader))")
                            
                            // If so, execute enough moves to take it
                            self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: false, in: gameModel)
                            attackMade = true
                            
                            // Did it work?  If so, don't need a temporary dominance zone if had one here
                            if tile.owner()?.leader == self.player?.leader {
                                self.deleteTemporaryZone(at: tile.point)
                            }
                        }
                    }
                }
            }
        }
        
        return attackMade
    }
    
    /// Assign a group of units to take down each city we can capture
    @discardableResult
    func plotDamageCityMoves(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var attackMade = false

        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: .city) {
    
            // See what units we have who can reach target this turn
            if let tile = target?.tile {
                
                self.currentMoveCities.removeAll()
                
                if self.findUnitsWithinStrikingDistance(towards: tile.point, numTurnsAway: 1, noRangedUnits: false, navalOnly: false, mustMoveThrough: false, includeBlockedUnits: true, in: gameModel) {

                    if let city = gameModel.city(at: tile.point) {

                        let requiredDamage = city.maxHealthPoints() - city.damage()
                        target?.damage = requiredDamage

                        // Don't want to hammer away to try and take down a city for more than 8 turns
                        if self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel) > (requiredDamage / 8) {
                            
                            // If so, execute enough moves to take it
                            self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: true, in: gameModel)
                            attackMade = true
                        }
                    }
                }
            }
        }
        
        return attackMade
    }
    
    /// Assign a group of units to attack each unit we think we can destroy
    func plotDestroyUnitMoves(for targetType: TacticalTargetType, mustBeAbleToKill: Bool, attackAtPoorOdds: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var requiredDamage: Int = 0
        var expectedDamage: Int = 0

        // See how many moves of this type we can execute
        for target in self.zoneTargets(for: targetType) {
            
            var unitCanAttack = false
            var cityCanAttack = false
            
            if let targetLocation = target?.target {
            
                guard let tile = gameModel.tile(at: targetLocation) else {
                    continue
                }
            
                if let defender = gameModel.unit(at: targetLocation) {
                    
                    unitCanAttack = self.findUnitsWithinStrikingDistance(towards: tile.point, numTurnsAway: 1, noRangedUnits: false, in: gameModel)
                    cityCanAttack = self.findCitiesWithinStrikingDistance(of: targetLocation, in: gameModel)
                    
                    if unitCanAttack || cityCanAttack {
                        
                        expectedDamage = self.computeTotalExpectedDamage(target: target, and: tile, in: gameModel)
                        expectedDamage += self.computeTotalExpectedBombardDamage(against: defender, in: gameModel)
                        requiredDamage = defender.healthPoints()
                        
                        target?.damage = requiredDamage

                        if !mustBeAbleToKill {

                            // Attack no matter what
                            if attackAtPoorOdds {
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: false, in: gameModel)
                            } else {
                                // If we can at least knock the defender to 40% strength with our combined efforts, go ahead even if each individual attack isn't favorable
                                var mustInflictWhatWeTake = true
                                if expectedDamage >= (requiredDamage * 40) / 100 {
                                    mustInflictWhatWeTake = false
                                }
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: mustInflictWhatWeTake, mustSurviveAttack: true, in: gameModel)
                            }
                        } else { // Do we have enough firepower to destroy it?
                            if expectedDamage > requiredDamage {
                                self.executeAttack(target: target, targetPlot: tile, inflictWhatWeTake: false, mustSurviveAttack: (targetType != .highPriorityUnit), in: gameModel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Estimates the damage we can apply to a target
    func computeTotalExpectedDamage(target: TacticalTarget?, and targetPlot: AbstractTile?, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let targetPlot = targetPlot else {
            fatalError("cant get targetPlot")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var rtnValue = 0
        var expectedDamage = 0
        var expectedSelfDamage = 0

        // Loop through all units who can reach the target
        for attackerRef in self.currentMoveUnits {
            
            guard let attacker = attackerRef?.unit else {
                continue
            }

            // Is target a unit?
            switch target.targetType {
                
            case .highPriorityUnit, .mediumPriorityUnit, .lowPriorityUnit:
                if let defender = gameModel.unit(at: targetPlot.point) {

                    if attacker.canAttackRanged() {
                        let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = 0
                    } else {
                        
                        let result = Combat.predictMeleeAttack(between: attacker, and: defender, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = result.attackerDamage
                    }
                    
                    attackerRef?.expectedTargetDamage = expectedDamage
                    attackerRef?.expectedSelfDamage = expectedSelfDamage
                    
                    rtnValue += expectedDamage
                }

            case .city:
                
                if let city = gameModel.city(at: targetPlot.point) {
                    
                    if attacker.canAttackRanged() {
                        let result = Combat.predictRangedAttack(between: attacker, and: city, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = 0
                    } else {
                        
                        let result = Combat.predictMeleeAttack(between: attacker, and: city, in: gameModel)
                        
                        expectedDamage = result.defenderDamage
                        expectedSelfDamage = result.attackerDamage
                    }
                    
                    attackerRef?.expectedTargetDamage = expectedDamage
                    attackerRef?.expectedSelfDamage = expectedSelfDamage
                    
                    rtnValue += expectedDamage
                }
                
            default:
                // NOOP
                break
            }
        }

        return rtnValue
    }
    
    /// Estimates the bombard damage we can apply to a target
    func computeTotalExpectedBombardDamage(against defender: AbstractUnit?, in gameModel: GameModel?) -> Int {
        
        var rtnValue = 0
        var expectedDamage = 0

        // Now loop through all the cities that can bombard it
        for attackingCityRef in self.currentMoveCities {
            
            guard let attackingCity = attackingCityRef?.city else {
                continue
            }
            
            let result = Combat.predictRangedAttack(between: attackingCity, and: defender, in: gameModel)
            
            expectedDamage = result.defenderDamage
            attackingCityRef?.expectedTargetDamage = expectedDamage
            rtnValue += expectedDamage
        }

        return rtnValue
    }
    
    /// Reset all data on queued attacks for a new turn
    func initializeQueuedAttacks() {
        
        self.queuedAttacks.removeAll()
        self.currentSeriesId = 0
    }
    
    /// Fills m_CurrentMoveUnits with all units within X turns of a target (returns TRUE if 1 or more found)
    // FIXME: method needs update
    func findUnitsWithinStrikingDistance(towards targetLocation: HexPoint, numTurnsAway: Int, noRangedUnits: Bool = false, navalOnly: Bool = false, mustMoveThrough: Bool = false, includeBlockedUnits: Bool = false, willPillage: Bool = false, targetUndefended: Bool = false, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var rtnValue = false
        self.currentMoveUnits.removeAll()
        
        let isCityTarget = gameModel.city(at: targetLocation) != nil

         // Loop through all units available to tactical AI this turn
        for loopUnitRef in self.currentTurnUnits {
            
            guard let loopUnit = loopUnitRef else {
                continue
            }
            
            if !navalOnly || loopUnit.domain() == .sea {
                
                     // don't use non-combat units
                if !loopUnit.canAttack() {
                    continue
                }

                if loopUnit.isOutOfAttacks() {
                    continue
                }
                
                /*if !isCityTarget && loopUnit.cityAttackOnly() {
                    continue;
                }*/

                if willPillage && !loopUnit.canPillage(at: targetLocation, in: gameModel) {
                    continue
                }

                // *** Need to make this smarter and account for units that can move up on their targets and then make a ranged attack,
                //     all in the same turn. ***
                if !noRangedUnits && !mustMoveThrough && loopUnit.canAttackRanged() {
                    
                    // Are we in range?
                    if loopUnit.location.distance(to: targetLocation) <= loopUnit.range() {
                        
                        // Do we have LOS to the target?
                        //if loopUnit.canEverRangeStrikeAt(pTarget->getX(), pTarget->getY())) {
                        // Will we do any damage
                        if self.isExpectedToDamageWithRangedAttack(by: loopUnit, towards: targetLocation, in: gameModel) {
                                     
                            // Want ranged units to attack first, so inflate this
                            // Don't take damage from bombarding, so show as fully healthy
                            let unit = TacticalUnit(unit: loopUnit, attackStrength: 100 * loopUnit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel), healthPercent: 100)
                            self.currentMoveUnits.append(unit)
                            rtnValue = true
                         }
                    }
                    // {
                 } else {
                    if loopUnit.canReach(at: targetLocation, in: numTurnsAway, in: gameModel) {
                        let unit = TacticalUnit(unit: loopUnit, attackStrength: 100 * loopUnit.rangedCombatStrength(against: nil, or: nil, on: nil, attacking: true, in: gameModel), healthPercent: loopUnit.healthPoints())
                         self.currentMoveUnits.append(unit)
                         rtnValue = true
                     }
                 }
             }
        }

        // Now sort them in the order we'd like them to attack
        self.currentMoveUnits.sort(by: { $0! < $1! })

        return rtnValue
    }
    
    func isExpectedToDamageWithRangedAttack(by attacker: AbstractUnit?, towards targetLocation: HexPoint, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var expectedDamage = 0

        if let city = gameModel.city(at: targetLocation) {
            
            let result = Combat.predictRangedAttack(between: attacker, and: city, in: gameModel)
            expectedDamage = result.defenderDamage
        } else if let defender = gameModel.unit(at: targetLocation) {
            
            let result = Combat.predictRangedAttack(between: attacker, and: defender, in: gameModel)
            expectedDamage = result.defenderDamage
        }

        return expectedDamage > 0
    }
    
    /// Fills m_CurrentMoveCities with all cities within bombard range of a target (returns TRUE if 1 or more found)
    func findCitiesWithinStrikingDistance(of point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var rtnValue = false
        self.currentMoveCities.removeAll()

        // Loop through all of our cities
        for loopCityRef in gameModel.cities(of: player) {
            
            guard let loopCity = loopCityRef else {
                continue
            }
            
            if loopCity.canRangeStrike(towards: point) && !self.isCityInQueuedAttack(city: loopCity) {
                let cityTarget = TacticalCity(city: loopCity)
                self.currentMoveCities.append(cityTarget)
                rtnValue = true
            }
        }

        // Now sort them in the order we'd like them to attack
        self.currentMoveCities.sort(by: { $0! < $1! })

        return rtnValue
    }
    
    /// Is this unit waiting to get its turn to attack?
    func isCityInQueuedAttack(city attackCity: AbstractCity?) -> Bool {
        
        if self.queuedAttacks.count > 0 {
             
            for queuedAttack in self.queuedAttacks {
                if queuedAttack.cityAttack && queuedAttack.attackerCity?.location == attackCity?.location {
                    return true
                }
            }
        }
        return false
    }
       
    /// Queue up the attack - return TRUE if first attack on this target
    func queueAttack(attacker: AbstractUnit?, target: TacticalTarget?, ranged: Bool) -> Bool {
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var rtnValue = true
        var seriesId = -1

        // Can we find this target in the queue, if so what is its series ID
        if let queuedAttack = self.isAlreadyTargeted(at: target.target) {
            seriesId = queuedAttack.seriesId
            rtnValue = false
        } else {
            self.currentSeriesId += 1
            seriesId = self.currentSeriesId
        }

        let attack = QueuedAttack()
        attack.attackerUnit = attacker
        attack.target = target
        attack.ranged = ranged
        attack.cityAttack = false
        attack.seriesId = seriesId
        self.queuedAttacks.append(attack)

        print("Queued attack with \(attacker?.name() ?? "--"), To \(target.target), From \(attacker?.location ?? HexPoint(x: -1, y: -1))")

        return rtnValue
    }
    
    /// Queue up the attack - return TRUE if first attack on this target
    func queueAttack(attacker: AbstractCity?, target: TacticalTarget?, ranged: Bool) -> Bool {
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var rtnValue = true
        var seriesId = -1

        // Can we find this target in the queue, if so what is its series ID
        if let queuedAttack = self.isAlreadyTargeted(at: target.target) {
            seriesId = queuedAttack.seriesId
            rtnValue = false
        } else {
            self.currentSeriesId += 1
            seriesId = self.currentSeriesId
        }

        let attack = QueuedAttack()
        attack.attackerCity = attacker
        attack.target = target
        attack.ranged = ranged
        attack.cityAttack = false
        attack.seriesId = seriesId
        self.queuedAttacks.append(attack)

        print("Queued attack with \(attacker?.name ?? "--"), To \(target.target), From \(attacker?.location ?? HexPoint(x: -1, y: -1))")

        return rtnValue
    }
    
    /// Attack a defended space
    private func executeAttack(target: TacticalTarget?, targetPlot: AbstractTile?, inflictWhatWeTake: Bool, mustSurviveAttack: Bool, in gameModel: GameModel?) {
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        var firstAttacker: AbstractUnit? = nil
        var firstCity: AbstractCity? = nil
        var firstAttackRanged = false
        var firstAttackCity = false

        if self.isAlreadyTargeted(at: target.target) != nil {
            return
        }

        // How much damage do we still need to inflict?
        var damageRemaining = (target.damage * 150) / 100

        // Start by applying damage from city bombards
        for currentMoveCityRef in self.currentMoveCities {
            
            if let currentMoveCity = currentMoveCityRef {
                
                if damageRemaining <= 0 {
                    break
                }
            
                if currentMoveCity.city != nil {
                 
                    if self.queueAttack(attacker: currentMoveCity.city, target: target, ranged: true) {
                        
                        firstCity = currentMoveCity.city
                        firstAttackRanged = true
                        firstAttackCity = true
                    }
                    
                    // Subtract off expected damage
                    damageRemaining -= currentMoveCity.expectedTargetDamage
                }
            }
        }        

        // First loop is ranged units only
        for currentMoveUnitRef in self.currentMoveUnits {
        
            if damageRemaining <= 0 {
                break
            }
            
            if let currentMoveUnit = currentMoveUnitRef {
             
                if !inflictWhatWeTake || currentMoveUnit.expectedTargetDamage >= currentMoveUnit.expectedSelfDamage {
                    
                    if let unit = currentMoveUnit.unit {

                        if unit.moves() > 0 {
                            
                            if !mustSurviveAttack || ((currentMoveUnit.expectedSelfDamage + unit.damage()) < Int(Unit.maxHealth)) {
                                
                                // Are we a ranged unit
                                if unit.canAttackRanged() {
                                    
                                    // Are we in range?
                                    let dist = unit.location.distance(to: target.target)
                                    if dist <= unit.range() {
                                        
                                        // Do we have LOS line of sight to the target?
                                        if unit.canReach(at: target.target, in: dist, in: gameModel) {
                                            
                                            // Do we need to set up to make a ranged attack?
                                            /*if unit.canSetUpForRangedAttack(NULL) {
                                                unit.setSetUpForRangedAttack(true);
                                                print("Set up \(unit.name()) for ranged attack")

                                                if !unit.canMove() {
                                                    unit->SetTacticalAIPlot(NULL);
                                                    self.unitProcessed(pUnit->GetID());
                                                }
                                            }*/

                                            // Can we hit it with a ranged attack?  If so, that gets first priority
                                            if unit.canMove() && unit.canRangeStrike(at: target.target, needWar: true, noncombatAllowed: false) {
                                                
                                                // Queue up this attack
                                                if self.queueAttack(attacker: unit, target: target, ranged: true) {
                                                    
                                                    firstAttacker = unit
                                                    firstAttackRanged = true
                                                }
                                                
                                                unit.resetTacticalMove()
                                                self.unitProcessed(unit: currentMoveUnit.unit, in: gameModel)

                                                // Subtract off expected damage
                                                damageRemaining -= currentMoveUnit.expectedTargetDamage
                                            }
                                        }
                                    }
                                }
                            } else {
                                
                                print("Not attacking with unit. We'll destroy ourself.")
                            }
                        }
                    }
                    
                } else {
                    
                    print("Not attacking with unit. Can't generate a good damage ratio.")
                }
            }
        }

        // If target is city, want to get in one melee attack, so set damage remaining to 1
        if target.targetType == .city && damageRemaining < 1 {
            damageRemaining = 1
        }

        // Second loop are only melee units
        for currentMoveUnitRef in self.currentMoveUnits {
            
            if damageRemaining <= 0 {
                break
            }
            
            if let currentMoveUnit = currentMoveUnitRef {
            
                if !inflictWhatWeTake || currentMoveUnit.expectedTargetDamage >= currentMoveUnit.expectedSelfDamage {
                   
                    if let unit = currentMoveUnit.unit {
                    
                        if unit.moves() > 0 && (!mustSurviveAttack || ((currentMoveUnit.expectedSelfDamage + unit.damage()) < Int(Unit.maxHealth))) {
                            
                            // Are we a melee unit
                            if !unit.canAttackRanged() {
                                
                                // Queue up this attack
                                if self.queueAttack(attacker: unit, target: target, ranged: false) {
                                    firstAttacker = unit
                                }
                                unit.resetTacticalMove()
                                self.unitProcessed(unit: currentMoveUnit.unit, markTacticalMap: false, in: gameModel)

                                // Subtract off expected damage
                                damageRemaining -= currentMoveUnit.expectedTargetDamage
                            }
                        } else {
                            print("Not attacking with unit. We'll destroy ourself.")
                        }
                    
                    }
                }
            } else {
                print("Not attacking with unit. Can't generate a good damage ratio.")
            }
        }

        // Start up first attack
        if firstAttackCity && firstCity  != nil {
            self.launchAttack(for: firstCity, target: target, firstAttack: true, ranged: firstAttackRanged, in: gameModel)
        } else if !firstAttackCity && firstAttacker != nil {
            self.launchAttack(for: firstAttacker, target: target, firstAttack: true, ranged: firstAttackRanged, in: gameModel)
        } else {
            fatalError("no gonna happen")
        }
    }
    
    /// Remove a unit that we've allocated from list of units to move this turn
    private func unitProcessed(unit: AbstractUnit?, markTacticalMap: Bool = true, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }

        self.currentTurnUnits.removeAll(where: { unit.isEqual(to: $0) })

        unit.set(turnProcessed: true)

        if markTacticalMap {
            
            let map = gameModel.tacticalAnalysisMap()
            
            if map.isBuild {
                
                let cell = map.plots[unit.location]
                cell?.friendlyTurnEndTile = true
            }
        }
    }
    
    /// Pushes the mission to launch an attack and logs this activity
    private func launchAttack(for attacker: AbstractUnit?, target: TacticalTarget?, firstAttack: Bool, ranged: Bool, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let unit = attacker else {
            fatalError("cant get attacker")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        let rangedStr = ranged ? "ranged " : ""
        if firstAttack {
            print("Made initial \(rangedStr) attack with \(unit.name()) towards \(target.target)")
        } else {
            print("Made follow-on \(rangedStr) attack with \(unit.name()) towards \(target.target)")
        }
        
        let sendAttack = unit.moves() > 0 && !unit.isOutOfAttacks()
        if sendAttack {
            
            if ranged && unit.domain() != .air  {
                // Air attack is ranged, but it goes through the 'move to' mission.
                unit.push(mission: UnitMission(type: .rangedAttack, at: target.target), in: gameModel)
            }
            //else if (pUnit->canNuke(NULL)) // NUKE tactical attack (ouch)
            //{
            //    pUnit->PushMission(CvTypes::getMISSION_NUKE(), pTarget->GetTargetX(), pTarget->GetTargetY());
            //}
            else {
                unit.push(mission: UnitMission(type: .moveTo, at: target.target), in: gameModel)
            }
        }

        // Make sure we did make an attack, if not we should take out this unit from the queue
        if !sendAttack || !unit.canMove() /*&& !pUnit->isFighting()*/ {
            unit.set(turnProcessed: false)
            self.combatResolved(for: attacker, victorious: false, in: gameModel)
        }
    }
    
    private func launchAttack(for attacker: AbstractCity?, target: TacticalTarget?, firstAttack: Bool, ranged: Bool, in gameModel: GameModel?) {
        
        guard let city = attacker else {
            fatalError("cant get city")
        }
        
        guard let target = target else {
            fatalError("cant get target")
        }
        
        let rangedStr = ranged ? "ranged " : ""
        let firstAttackStr = firstAttack ? "initial" : "follow-on"
        print("Made \(firstAttackStr) \(rangedStr) attack with \(city.name) towards \(target.target)")
        
        city.doTask(taskType: .rangedAttack, target: target.target, in: gameModel)
    }
    
    private func combatResolved(for attacker: AbstractUnit?, victorious: Bool, in gameModel: GameModel?) {
        
        var seriesId = 0
        var foundIt = false

        guard let unit = attacker else {
            fatalError("cant get attacker")
        }

        if self.queuedAttacks.count > 0 {
            
            //std::list<CvQueuedAttack>::iterator nextToErase, nextInList;
            //nextToErase = m_QueuedAttacks.begin();

            // Find first attack with this unit/city
            var index = 0
            for nextToErase in self.queuedAttacks {
                
                if unit.isEqual(to: nextToErase.attackerUnit) {
                    
                    seriesId = nextToErase.seriesId
                    foundIt = true
                    break
                }
                
                index += 1
            }

            // Couldn't find it ... could have been an accidental attack moving to deploy near a target
            // So safe to ignore these
            if !foundIt {
                return
            }

            // If this attacker gets multiple attacks, release him to be processed again
            /*if unit.canMoveAfterAttacking() && unit.moves() > 0 {
                
                unit.set(turnProcessed: false)
            }*/

            // If victorious, dump follow-up attacks
            if victorious {
                
                var first = true
                var queuedAttacksIterator = self.queuedAttacks.makeIterator()
                queuedAttacksIterator.skip(index)
                
                for nextToErase in queuedAttacksIterator {

                    if nextToErase.seriesId != seriesId {
                        break
                    }
                    
                    // Only the first unit being erased is done for the turn
                    if !first && !nextToErase.cityAttack {
                        
                        nextToErase.attackerUnit?.set(turnProcessed: false)
                    }
                    
                    first = false
                }
                
                self.queuedAttacks.removeAll(where: { $0.seriesId == seriesId })
                
            } else {
                // Otherwise look for a follow-up attack
                if index + 1 < self.queuedAttacks.count {
                    
                    let nextInList = self.queuedAttacks[index + 1]
                    if nextInList.seriesId == seriesId {
                        
                        // Calling LaunchAttack can be recursive if the launched combat is resolved immediately.
                        // We'll make a copy of the iterator's contents before erasing.  This is not technically needed because
                        // the current queue is a std::list and iterators don't invalidate on erase, but we'll be safe, in case
                        // the container type changes.
                        if nextInList.cityAttack {
                            self.launchAttack(for: nextInList.attackerCity, target: nextInList.target, firstAttack: false, ranged: nextInList.ranged, in: gameModel)
                        } else {
                            self.launchAttack(for: nextInList.attackerUnit, target: nextInList.target, firstAttack: false, ranged: nextInList.ranged, in: gameModel)
                        }
                    }
                    
                    self.queuedAttacks.remove(at: index + 1)
                }

            }
        }
    }
    
    /// Find the first target of a requested type in current dominance zone (call after ExtractTargetsForZone())
    private func zoneTargets(for targetType: TacticalTargetType) -> [TacticalTarget?] {
        
        var tempTargets: [TacticalTarget?] = []
        for zoneTarget in self.zoneTargets {
            
            if targetType == .none || zoneTarget.targetType == targetType {
                tempTargets.append(zoneTarget)
            }
        }
        
        return tempTargets
    }
    
    /// Choose which tactics the barbarians should emphasize this turn
    private func establishBarbarianPriorities(in turn: Int) {
        
        // Only establish priorities once per turn
        if turn <= self.movePriotityTurn {
            return
        }
        
        self.movePriorityList.removeAll()
        self.movePriotityTurn = turn
        
        // Loop through each possible tactical move (other than "none" or "unassigned")
        for barbarianTacticalMove in TacticalMoveType.allBarbarianMoves {
            
            var priority = barbarianTacticalMove.priority()
            
            // Make sure base priority is not negative
            if priority >= 0 {
                
                // Finally, add a random die roll to each priority
                priority += Int.random(in: -2...2) /* AI_TACTICAL_MOVE_PRIORITY_RANDOMNESS */

                // Store off this move and priority
                let move = TacticalMove()
                move.moveType = barbarianTacticalMove
                move.priority = priority
                self.movePriorityList.append(move)
            }
        }
        
        self.movePriorityList.sort()
    }
    
    /// Choose which tactics to emphasize this turn
    private func establishTacticalPriorities() {
        
        self.movePriorityList.removeAll()
        
        for tacticalMove in TacticalMoveType.allPlayerMoves {
            
            var priority = tacticalMove.priority()
            
            // Make sure base priority is not negative
            if priority >= 0 {
                
                // Finally, add a random die roll to each priority
                priority += Int.random(in: -2...2) /* AI_TACTICAL_MOVE_PRIORITY_RANDOMNESS */

                // Store off this move and priority
                let move = TacticalMove()
                move.moveType = tacticalMove
                move.priority = priority
                self.movePriorityList.append(move)
            }
        }
        
        // Loop through each possible tactical move
        self.movePriorityList.sort()
    }
    
    /// Establish postures for each dominance zone (taking into account last posture)
    private func updatePostures(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let tacticalAnalysisMap = gameModel.tacticalAnalysisMap()
        
        var newPostures: [TacticalPosture] = []
        
        for dominanceZone in tacticalAnalysisMap.dominanceZones {
            
            // Check to make sure we want to use this zone
            if self.useThis(dominanceZone: dominanceZone) {
                
                let lastPostureType = self.findPostureType(for: dominanceZone)
                let newPostureType = self.selectPostureType(for: dominanceZone, old: lastPostureType, dominancePercentage: tacticalAnalysisMap.dominancePercentage)
                
                let posture = TacticalPosture(of: newPostureType, for: dominanceZone.owner, in: dominanceZone.closestCity, isWater: dominanceZone.isWater)
                newPostures.append(posture)
            }
        }
        
        self.postures = newPostures
    }
    
    /// Do we want to process moves for this dominance zone?
    private func useThis(dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) -> Bool {
        
        guard let dominanceZone = dominanceZone else {
            fatalError("cant get dominanceZone")
        }
        
        var isOurCapital = false
        //int iCityID = -1;
        
        if let city = dominanceZone.closestCity {
            isOurCapital = self.player?.leader == city.player?.leader && city.isCapital()
        }

        return (isOurCapital || dominanceZone.rangeClosestEnemyUnit <= (TacticalAI.recruitRange / 2) ||
            (dominanceZone.dominanceFlag != .noUnitsPresent && dominanceZone.dominanceFlag != .notVisible))
    }
    
    /// Sift through the target list and find just those that apply to the dominance zone we are currently looking at
    private func extractTargets(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone? = nil) {
        
        self.zoneTargets.removeAll()
        
        for target in self.allTargets {
            
            var valid = false
            
            if let dominanceZone = dominanceZone {
            
                let domain: UnitDomainType = dominanceZone.isWater ? .sea : .land
                valid = target.isTargetValidIn(domain: domain)
                
            } else {
                valid = true
            }
            
            if valid {
             
                if dominanceZone == nil || dominanceZone == target.dominanceZone {
                 
                    self.zoneTargets.append(target)
                    
                } else {
                    // Not obviously in this zone, but if within 2 of city we want them anyway
                    if let city = dominanceZone?.closestCity {
                    
                        if target.target.distance(to: city.location) <= 2 {
                            self.zoneTargets.append(target)
                        }
                    }
                }
            }
        }
        
        // print("targets extracted: \(self.zoneTargets.count)")
    }
    
    /// Find last posture for a specific zone
    private func findPostureType(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) -> TacticalPostureType {
        
        guard let player = self.player else {
            fatalError("cant get leader")
        }
        
        guard let dominanceZone = dominanceZone else {
            return TacticalPostureType.none
        }
        
        guard let closestCity = dominanceZone.closestCity else {
            return TacticalPostureType.none
        }
        
        if let posture = self.postures.first(where: { player.isEqual(to: $0.player) && $0.isWater == dominanceZone.isWater && $0.city?.location == closestCity.location }) {
                
            return posture.type
        }
        
        return TacticalPostureType.none
    }
    
    /// Select a posture for a specific zone
    private func selectPostureType(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?, old lastPosture: TacticalPostureType, dominancePercentage: Int) -> TacticalPostureType {
        
        guard let dominanceZone = dominanceZone else {
            fatalError("cant get dominanceZone")
        }
        
        var chosenPosture: TacticalPostureType = .none
        var rangedDominance: TacticalDominanceType = .even
        var unitCountDominance: TacticalDominanceType = .even
        
        // Compute who is dominant in various areas
        //   Ranged strength
        if dominanceZone.enemyRangedStrength <= 0 {
            rangedDominance = .friendly
        } else {
            
            let ratio = dominanceZone.friendlyRangedStrength * 100 / dominanceZone.enemyRangedStrength
            if ratio > 100 + dominancePercentage {
                rangedDominance = .friendly
            } else if ratio < 100 - dominancePercentage {
                rangedDominance = .enemy
            }
        }
        
        //   Number of units
        if dominanceZone.enemyUnitCount <= 0 {
            unitCountDominance = .friendly
        } else {
            
            let ratio = dominanceZone.friendlyUnitCount * 100 / dominanceZone.enemyUnitCount
            if ratio > 100 + dominancePercentage {
                unitCountDominance = .friendly
            } else if ratio < 100 - dominancePercentage {
                unitCountDominance = .enemy
            }
        }
        
        // Choice based on whose territory this is
        switch dominanceZone.territoryType {
            
        
        case .enemy:
            
            if dominanceZone.dominanceFlag == .enemy || dominanceZone.friendlyRangedUnitCount == dominanceZone.friendlyUnitCount {
                // Always withdraw if enemy dominant overall
                chosenPosture = .withdraw
            } else if dominanceZone.enemyUnitCount > 0 && dominanceZone.dominanceFlag == .friendly &&
                (rangedDominance != .enemy || dominanceZone.friendlyStrength > dominanceZone.enemyStrength * 2) {
                // Destroy units then assault - for first time need dominance in total strength but not enemy dominance in ranged units OR just double total strength
                chosenPosture = .steamRoll
            } else if lastPosture == .steamRoll && dominanceZone.dominanceFlag == .friendly && dominanceZone.enemyUnitCount > 0 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .steamRoll
            } else if rangedDominance == .friendly && unitCountDominance != .enemy {
                // Sit and bombard - for first time need dominance in ranged strength and total unit count
                chosenPosture = .sitAndBombard
            } else if lastPosture == .sitAndBombard && rangedDominance != .enemy && unitCountDominance != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .sitAndBombard
            } else if dominanceZone.dominanceFlag == .friendly {
                // Go right after the city - need tactical dominance
                chosenPosture = .surgicalCityStrike
            } else if unitCountDominance == .friendly && dominanceZone.enemyUnitCount > 1 {
                // Exploit flanks - for first time need dominance in unit count
                chosenPosture = .exploitFlanks
            } else if lastPosture == .exploitFlanks && unitCountDominance != .enemy && dominanceZone.enemyUnitCount > 1 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .exploitFlanks
            } else {
                // Default for this zone
                chosenPosture = .surgicalCityStrike
            }
        
        case .neutral, .noOwner:
            if rangedDominance == .friendly && unitCountDominance != .enemy {
                chosenPosture = .attritFromRange
            } else if lastPosture == .attritFromRange && rangedDominance != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .attritFromRange
            } else if unitCountDominance == .friendly && dominanceZone.enemyUnitCount > 0 {
                // Exploit flanks - for first time need dominance in unit count
                chosenPosture = .exploitFlanks
            } else if lastPosture == .exploitFlanks && unitCountDominance != .enemy && dominanceZone.enemyUnitCount > 0 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .exploitFlanks
            } else {
                // Default for this zone
                chosenPosture = .exploitFlanks
            }
            
        case .friendly:
            if rangedDominance == .friendly && dominanceZone.friendlyRangedUnitCount > 1 {
                chosenPosture = .attritFromRange
            } else if lastPosture == .attritFromRange && dominanceZone.friendlyRangedUnitCount > 1 && rangedDominance != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .attritFromRange
            } else if unitCountDominance == .friendly && dominanceZone.enemyUnitCount > 0 {
                // Exploit flanks - for first time need dominance in unit count
                chosenPosture = .exploitFlanks
            } else if lastPosture == .exploitFlanks && unitCountDominance != .enemy && dominanceZone.enemyUnitCount > 0 {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .exploitFlanks
            } else if dominanceZone.dominanceFlag == .friendly || dominanceZone.dominanceFlag == .even && rangedDominance == .enemy {
                // Counterattack - for first time must be stronger or even with enemy having a ranged advantage
                chosenPosture = .counterAttack
            } else if lastPosture == .counterAttack && dominanceZone.dominanceFlag != .enemy {
                //                 - less stringent if continuing this from a previous turn
                chosenPosture = .counterAttack
            } else {
                // Default for this zone
                chosenPosture = .hedgehog
            }
            
            
        case .tempZone:
            // Land or water?
            if dominanceZone.isWater {
                chosenPosture = .shoreBombardment
            } else {
                // Should be a barbarian camp
                chosenPosture = .exploitFlanks
            }
        }
        
        return chosenPosture
    }

    /// Make lists of everything we might want to target with the tactical AI this turn
    private func findTacticalTargets(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        guard let dangerPlotsAI = player.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }

        // Clear out target list since we rebuild it each turn
        self.allTargets.removeAll()

        let barbsAllowedYet = gameModel.currentTurn >= 20
        let mapSize = gameModel.mapSize()

        // Look at every tile on map
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let point = HexPoint(x: x, y: y)
                var validPlot = false
                if let tile = gameModel.tile(at: point) {

                    if tile.isVisible(to: player) {

                        // Make sure I am not a barbarian who can not move into owned territory this early in the game
                        if self.player?.leader != .barbar || barbsAllowedYet {

                            validPlot = true
                        } else {
                            if !tile.hasOwner() {
                                validPlot = true
                            }
                        }

                        if validPlot {
                            if self.isAlreadyTargeted(at: point) != nil {
                                validPlot = false
                            }
                        }
                    }

                    if validPlot {

                        let newTarget = TacticalTarget(
                            targetType: .none,
                            target: point,
                            targetLeader: .none,
                            dominanceZone: gameModel.tacticalAnalysisMap().plots[point]?.dominanceZone)

                        let enemyDominatedPlot = gameModel.tacticalAnalysisMap().isInEnemyDominatedZone(at: point)

                        // Have a ...
                        
                        let cityRef = gameModel.city(at: tile.point)

                        if let city = cityRef {

                            if self.player?.leader == city.player?.leader {

                                // ... friendly city?
                                newTarget.targetType = .cityToDefend
                                newTarget.city = cityRef
                                newTarget.threatValue = city.threatValue()
                                self.allTargets.append(newTarget)

                                
                            } else if diplomacyAI.isAtWar(with: city.player) {

                                // ... enemy city
                                newTarget.targetType = .city
                                newTarget.city = cityRef
                                newTarget.threatValue = city.threatValue()
                                self.allTargets.append(newTarget)
                            }
                        } else {
                            
                            let unitRef = gameModel.unit(at: tile.point)
                            if let unit = unitRef {
                                if diplomacyAI.isAtWar(with: unit.player) {
                                    
                                    // ... enemy unit?
                                    newTarget.targetType = .lowPriorityUnit
                                    newTarget.targetLeader = unit.player!.leader
                                    newTarget.unit = unitRef
                                    newTarget.damage = unit.damage()
                                    self.allTargets.append(newTarget)
                                }

                            } else if tile.has(improvement: .barbarianCamp) {

                                // ... undefended camp?
                                newTarget.targetType = .barbarianCamp
                                newTarget.targetLeader = .barbar
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)

                            } else if tile.has(improvement: .goodyHut) {

                                // ... goody hut?
                                newTarget.targetType = .ancientRuins
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)

                            } else if diplomacyAI.isAtWar(with: tile.owner()) && !tile.has(improvement: .none) && !tile.canBePillaged() &&
                                !tile.has(resource: .none, for: player) && !enemyDominatedPlot {
                                
                                // ... enemy resource improvement?

                                // On land, civs only target improvements built on resources
                                if tile.has(resourceType: .strategic, for: player) || tile.has(resourceType: .luxury, for: player) || tile.terrain().isWater() || player.leader == .barbar {

                                    if tile.terrain().isWater() && player.leader == .barbar {

                                        continue
                                    } else {

                                        newTarget.targetType = .improvement
                                        newTarget.targetLeader = tile.owner()!.leader
                                        newTarget.tile = tile
                                        self.allTargets.append(newTarget)
                                    }
                                }

                                // Or forts / citadels!
                            } else if diplomacyAI.isAtWar(with: tile.owner()) && (tile.has(improvement: .fort) && tile.has(improvement: .citadelle)) {
                                newTarget.targetType = .improvement
                                newTarget.targetLeader = tile.owner()!.leader
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)


                                // ... enemy civilian (or embarked) unit?
                            } else if unitRef?.player?.leader != player.leader {

                                if let unit = unitRef {

                                    if diplomacyAI.isAtWar(with: unit.player) && !unit.canDefend() {

                                        newTarget.targetType = .lowPriorityUnit
                                        newTarget.targetLeader = unit.player!.leader
                                        newTarget.unit = unit

                                        if unit.isEmbarked() {

                                            if unit.isCombatUnit() {
                                                newTarget.targetType = .embarkedMilitaryUnit
                                            } else {
                                                newTarget.targetType = .embarkedCivilian
                                            }
                                        } else {

                                            if self.isVeryHighPriorityCivilian(target: newTarget) {

                                                newTarget.targetType = .veryHighPriorityCivilian //(AI_TACTICAL_TARGET_VERY_HIGH_PRIORITY_CIVILIAN);
                                            } else if self.isHighPriorityCivilian(target: newTarget, in: gameModel.currentTurn, numCities: gameModel.cities(of: player).count) {

                                                newTarget.targetType = .highPriorityCivilian
                                            } else if self.isMediumPriorityCivilian(target: newTarget, in: gameModel.currentTurn) {
                                                newTarget.targetType = .mediumPriorityCivilian
                                            }
                                        }

                                        self.allTargets.append(newTarget)
                                    }

                                    
                                } else if player.leader == tile.owner()?.leader && tile.defenseModifier(for: player) > 0 &&
                                    dangerPlotsAI.danger(at: point) > 0.0 {
                                    
                                    // ... defensive bastion?
                                    if let defenseCity = gameModel.friendlyCityAdjacent(to: point, for: player) {
                                        
                                        newTarget.targetType = .defensiveBastion
                                        newTarget.tile = tile
                                        newTarget.threatValue = defenseCity.threatValue() + Int(dangerPlotsAI.danger(at: point))
                                        self.allTargets.append(newTarget)
                                    }
                                    
                                    
                                } else if player.leader == tile.owner()?.leader && !tile.has(improvement: .none) && !tile.has(improvement: .goodyHut) && tile.canBePillaged() {
                                    // ... friendly improvement?
                                
                                    newTarget.targetType = .improvementToDefend
                                    newTarget.tile = tile
                                    self.allTargets.append(newTarget)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // POST-PROCESSING ON TARGETS

        // Mark enemy units threatening our cities (or camps) as priority targets
        if player.leader == .barbar {
            self.identifyPriorityBarbarianTargets(in: gameModel)
        } else {
            self.identifyPriorityTargets(in: gameModel)
        }

        // Also add some priority targets that we'd like to hit just because of their unit type (e.g. catapults)
        self.identifyPriorityTargetsByType(in: gameModel)

        // Remove extra targets
        self.eliminateNearbyBlockadePoints()

        // Sort remaining targets by aux data (if used for that target type)
        self.allTargets.sort(by: { $0.threatValue > $1.threatValue })
    }
    
    /// Mark units that we'd like to make opportunity attacks on because of their unit type (e.g. catapults)
    private func identifyPriorityTargetsByType(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        // Look through all the enemies we can see
        for target in self.allTargets {
            
            // Don't consider units that are already medium priority
            if target.targetType == .highPriorityUnit || target.targetType == .lowPriorityUnit {
                
                // Ranged units will always be medium priority targets
                if let unit = target.unit {
                    
                    if unit.canAttackRanged() {
                        target.targetType = .mediumPriorityUnit
                    }
                }
            }
            
            // Don't consider units that are already high priority
            if target.targetType == .mediumPriorityUnit || target.targetType == .lowPriorityUnit {
                
                if let unit = target.unit, let tile = gameModel.tile(at: unit.location) {
                    
                    // Units defending citadels will always be high priority targets
                    if tile.has(improvement: .fort) || tile.has(improvement: .citadelle) {
                        target.targetType = .highPriorityUnit
                    }
                }
            }
        }
    }
    
    /// Don't allow tiles within 2 to both be blockade points
    private func eliminateNearbyBlockadePoints() {
        
        //fatalError("not implemented yet")
        
        /*// First, sort the sentry points by priority
        self.naval
        std::stable_sort(m_NavalResourceBlockadePoints.begin(), m_NavalResourceBlockadePoints.end());

        // Create temporary copy of list
        TacticalList tempPoints;
        tempPoints = m_NavalResourceBlockadePoints;

        // Clear out main list
        m_NavalResourceBlockadePoints.clear();

        // Loop through all points in copy
        TacticalList::iterator it, it2;
        for (it = tempPoints.begin(); it != tempPoints.end(); ++it)
        {
            bool bFoundAdjacent = false;

            // Is it adjacent to a point in the main list?
            for (it2 = m_NavalResourceBlockadePoints.begin(); it2 != m_NavalResourceBlockadePoints.end(); ++it2)
            {
                if (plotDistance(it->GetTargetX(), it->GetTargetY(), it2->GetTargetX(), it2->GetTargetY()) <= 2)
                {
                    bFoundAdjacent = true;
                    break;
                }
            }

            if (!bFoundAdjacent)
            {
                m_NavalResourceBlockadePoints.push_back(*it);
            }
        }

        // Now copy all points into main target list
        for (it = m_NavalResourceBlockadePoints.begin(); it != m_NavalResourceBlockadePoints.end(); ++it)
        {
            m_AllTargets.push_back(*it);
        } */
    }
    
    /// Mark units that can damage key items as priority targets
    private func identifyPriorityTargets(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // Loop through each of our cities
        for cityRef in gameModel.cities(of: player) {
            
            if let city = cityRef {
                
                var possibleAttackers: [TacticalTarget] = []
                var expectedTotalDamage = 0
                
                for unitTargetRef in self.unitTargets() {
                    
                    if let unitTarget = unitTargetRef, let tile = unitTargetRef?.tile {
                        if let enemyUnit = gameModel.visibleEnemy(at: unitTarget.target, for: self.player) {
                    
                            var expectedDamage = 0
                            
                            if enemyUnit.canAttackRanged() && enemyUnit.rangedCombatStrength(against: nil, or: city, on: tile, attacking: true, in: gameModel) > enemyUnit.attackStrength(against: nil, or: city, on: tile, in: gameModel) {
                            
                                if enemyUnit.location.distance(to: city.location) <= enemyUnit.range() {
                                    
                                    let combatResult = Combat.predictRangedAttack(between: enemyUnit, and: cityRef, in: gameModel)
                                    expectedDamage = combatResult.defenderDamage
                                }
                                
                            } else if enemyUnit.canReach(at: city.location, in: 1, in: gameModel) {
                                
                                let combatResult = Combat.predictMeleeAttack(between: enemyUnit, and: cityRef, in: gameModel)
                                
                                // FIXME: add fire support
                                
                                expectedDamage = combatResult.defenderDamage
                            }
                            
                            if expectedDamage > 0 {
                                expectedTotalDamage += expectedDamage
                                possibleAttackers.append(unitTarget)
                            }
                        }
                    }
                }
                
                // If they can take the city down and they are a melee unit, then they are a high priority target
                if expectedTotalDamage > (city.maxHealthPoints() - city.damage()) {
                    
                    var attackerIndex = 0

                    // Loop until we've found all the attackers in the unit target list
                    for unitTargetRef in self.unitTargets() {
                        
                        if attackerIndex >= possibleAttackers.count {
                            break
                        }
                        
                        if let unitTarget = unitTargetRef {
                            
                            // Match based on X, Y
                            if unitTarget.target == possibleAttackers[attackerIndex].target {
                                
                                if let enemyUnit = gameModel.visibleEnemy(at: unitTarget.target, for: self.player) {
                                    
                                    if enemyUnit.canAttackRanged() {
                                        unitTargetRef?.targetType = .mediumPriorityUnit
                                    } else {
                                        unitTargetRef?.targetType = .highPriorityUnit
                                    }
                                }
                                
                                attackerIndex += 1
                            }
                        }
                    }
                }

                // If they can damage a city they are a medium priority target
                else if possibleAttackers.count > 0 {
                    
                    var attackerIndex = 0

                    // Loop until we've found all the attackers in the unit target list
                    for unitTargetRef in self.unitTargets() {
                    
                        if attackerIndex >= possibleAttackers.count {
                            break
                        }
                    
                        if let unitTarget = unitTargetRef {
                        
                            // Match based on X, Y
                            if unitTarget.target == possibleAttackers[attackerIndex].target {
                                
                                if unitTarget.targetType != .highPriorityUnit {
                                
                                    unitTargetRef?.targetType = .mediumPriorityUnit
                                }
                                
                                attackerIndex += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Mark units that can damage our barbarian camps as priority targets
    private func identifyPriorityBarbarianTargets(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        let mapSize = gameModel.mapSize()
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                
                let point = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: point) {
                    
                    if tile.has(improvement: .barbarianCamp) {
                        
                        for unitTargetRef in self.unitTargets() {
                            
                            if let unitTarget = unitTargetRef {
                                var priorityTarget = false
                                if unitTarget.targetType != .highPriorityUnit {
                                    
                                    if let enemyUnit = gameModel.visibleEnemy(at: unitTarget.target, for: self.player) {
                                        
                                        if enemyUnit.canAttackRanged() && enemyUnit.rangedCombatStrength(against: nil, or: nil, on: tile, attacking: true, in: gameModel) > enemyUnit.attackStrength(against: nil, or: nil, on: tile, in: gameModel) {
                                            
                                            if enemyUnit.location.distance(to: point) <= enemyUnit.range() {
                                                priorityTarget = true
                                            }
                                        } else if enemyUnit.canReach(at: point, in: 1, in: gameModel) {
                                            priorityTarget = true
                                        }
                                        
                                        if priorityTarget {
                                            unitTarget.targetType = .highPriorityUnit
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func unitTargets() -> [TacticalTarget?] {
        
        var list: [TacticalTarget?] = []
        
        for target in self.allTargets {
            if target.targetType == .lowPriorityUnit || target.targetType == .mediumPriorityUnit || target.targetType == .highPriorityUnit {
                list.append(target)
            }
        }
        
        return list
    }
    
    /// Do we already have a queued attack running on this plot? Return series ID if yes, -1 if no.
    func isAlreadyTargeted(at point: HexPoint) -> QueuedAttack? {
        
        if self.queuedAttacks.count > 0 {
            
            for queuedAttack in self.queuedAttacks {
                
                if let target = queuedAttack.target {
                    if target.target == point {
                        return queuedAttack
                    }
                }
            }
        }
        
        return nil
    }

    /// Is this civilian target of the highest priority?
    func isVeryHighPriorityCivilian(target: TacticalTarget) -> Bool {

        if let unit = target.unit {
            if unit.has(task: .general) {
                return true
            }
        }

        return false
    }

    /// Is this civilian target of high priority?
    func isHighPriorityCivilian(target: TacticalTarget, in turn: Int, numCities: Int) -> Bool {

        var returnValue = false

        if let unit = target.unit {

            if unit.civilianAttackPriority() == .high {
                returnValue = true
            } else if unit.civilianAttackPriority() == .highEarlyGameOnly {
                if turn < 50 {
                    returnValue = true
                }
            }

            if returnValue == false && unit.has(task: .settle) {

                if numCities < 5 {
                    returnValue = true
                } else if turn < 50 {
                    returnValue = true
                }
            }

            if returnValue == false && player?.leader == .barbar {
                //always high priority for barbs
                returnValue = true
            }
        }

        return returnValue
    }
    
    /// Is this civilian target of medium priority?
    func isMediumPriorityCivilian(target: TacticalTarget, in turn: Int) -> Bool {
        
        if let unit = target.unit {
        
            //embarked civilians
            if unit.isEmbarked() && !unit.isCombatUnit() {
                return true
            } else if unit.has(task: .settle) && turn >= 50 {
                return true
            } else if unit.has(task: .work) && turn < 50 { //early game?
                return true
            }
        }
        
        return false
    }
        
    /// Add a temporary dominance zone around a short-term target
    func add(temporaryZone: TemporaryZone) {

        self.temporaryZones.append(temporaryZone)
    }

    /// Remove temporary zones that have expired
    /// FIXME: rename to update
    func dropObsoleteZones(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.temporaryZones = self.temporaryZones.filter({ $0.lastTurn < gameModel.currentTurn })
    }

/// Remove a temporary dominance zone we no longer need to track
    func deleteTemporaryZone(at location: HexPoint) {

        self.temporaryZones = self.temporaryZones.filter({ $0.location != location })
    }

/// Is this a city that an operation just deployed in front of?
    func isTemporaryZone(a city: AbstractCity?) -> Bool {

        guard let city = city else {
            fatalError("cant get city")
        }

        for temporaryZone in self.temporaryZones {

            if temporaryZone.location == city.location && temporaryZone.targetType == .city {
                return true
            }
        }

        return false
    }
}
