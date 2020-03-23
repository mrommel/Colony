//
//  TacticalAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum TacticalTargetType {

    case none
    case city
    case barbarianCamp
    case improvement
    case blockadeResourcePoint
    case lowPriorityUnit
    case mediumPriorityUnit
    case highPriorityUnit
    case cityToDefend
    case improvementToDefend
    case defensiveBastion
    case ancientRuins
    case bombardmentZone
    case embarkedMilitaryUnit
    case embarkedCivilian
    case lowPriorityCivilian
    case mediumPriorityCivilian
    case highPriorityCivilian
    case veryHighPriorityCivilian
}

enum TacticalMoveType {
    
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
    case barbarianDesperateAttack // AI_TACTICAL_BARBARIAN_DESPERATE_ATTACK,
    case barbarianEscortCivilian // AI_TACTICAL_BARBARIAN_ESCORT_CIVILIAN,
    case barbarianPlunderTradeUnit // AI_TACTICAL_BARBARIAN_PLUNDER_TRADE_UNIT,
    case barbarianPillageCitadel // AI_TACTICAL_BARBARIAN_PILLAGE_CITADEL,
    case barbarianPillageNextTurn // AI_TACTICAL_BARBARIAN_PILLAGE_NEXT_TURN
    
    static var allBarbarianMoves: [TacticalMoveType] {
        
        return [.barbarianCaptureCity, .barbarianDamageCity, .barbarianDestroyHighPriorityUnit, .barbarianDestroyMediumPriorityUnit, .barbarianDestroyLowPriorityUnit, .barbarianMoveToSafety, .barbarianAttritHighPriorityUnit, .barbarianAttritMediumPriorityUnit, .barbarianAttritLowPriorityUnit, .barbarianPillage, .barbarianBlockadeResource, .barbarianCivilianAttack, .barbarianAggressiveMove, .barbarianPassiveMove, .barbarianCampDefense, .barbarianDesperateAttack, .barbarianEscortCivilian, .barbarianPlunderTradeUnit, .barbarianPillageCitadel, .barbarianPillageNextTurn
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
    
    // MARK: private methods
    
    private func data() -> TacticalMoveTypeData {
        
        switch self {
            
        case .none: return TacticalMoveTypeData(operationsCanRecruit: false, dominanceZoneMove: false, offenseFlavorWeight: 0, defenseFlavorWeight: 0, priority: -1)
            
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
    let expectedTargetDamage: Int
    let city: AbstractCity?
    
    init() {
        
        self.attackStrength = 0
        self.expectedTargetDamage = 0
        self.city = nil
    }
    
    init(attackStrength: Int, expectedTargetDamage: Int, city: AbstractCity?) {
        
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
    
    init(unit: AbstractUnit? = nil) {
        
        self.attackStrength = 0
        self.healthPercent = 0
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
class TacticalAI {

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
    
    let recruitRange = 10
    let repositionRange = 10 // AI_TACTICAL_REPOSITION_RANGE

    // MARK: internal classes

    class TemporaryZone {

        var location: HexPoint = HexPoint(x: -1, y: -1)
        var lastTurn: Int = -1
        var targetType: TacticalTargetType = .none
        var navalMission: Bool = false

        init() {

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
    struct TacticalTarget {

        var targetType: TacticalTargetType
        let target: HexPoint
        var targetPlayer: AbstractPlayer?
        let dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?

        // aux data
        var unit: AbstractUnit? = nil
        var damage: Int = 0
        var city: AbstractCity? = nil
        var threatValue: Int = 0
        var tile: AbstractTile? = nil
        
        /// This target make sense for this domain of unit/zone?
        func isTargetValidIn(domain: UnitDomainType) -> Bool {
        
            switch self.targetType {
            
            case .none: return false
                
                // always valid
            case .city, .cityToDefend, .lowPriorityCivilian, .mediumPriorityCivilian, .highPriorityCivilian, .veryHighPriorityCivilian, .lowPriorityUnit, .mediumPriorityUnit, .highPriorityUnit:
                return true
                
                // land targets
            case .barbarianCamp, .improvement, .improvementToDefend, .defensiveBastion, .ancientRuins:
                return domain == .land
                
                // sea targets
            case .blockadeResourcePoint, .bombardmentZone, .embarkedMilitaryUnit, .embarkedCivilian:
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
    
    class TacticalMove: Comparable {
        
        var moveType: TacticalMoveType
        var priority: Int
        
        init() {
            
            self.moveType = .unassigned
            self.priority = TacticalMoveType.unassigned.priority()
        }
        
        static func < (lhs: TacticalAI.TacticalMove, rhs: TacticalAI.TacticalMove) -> Bool {
            return lhs.priority < rhs.priority
        }
        
        static func == (lhs: TacticalAI.TacticalMove, rhs: TacticalAI.TacticalMove) -> Bool {
            return lhs.priority == rhs.priority && lhs.moveType == rhs.moveType
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
                } else if player.leader == .barbar || unit.domain() == .air {
                    // We want ALL the barbarians and air units
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
                        if danger > 0 && self.isNearVisibleEnemy(unit: unit, range: 10 /*  */, gameModel: gameModel) {
                            unit.set(tacticalMove: .unassigned)
                            self.currentTurnUnits.append(unit)
                        }
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
            self.establishBarbarianPriorities(in: gameModel.turnsElapsed)
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
            
        case .moveNoncombatantsToSafety:
            // TACTICAL_MOVE_NONCOMBATANTS_TO_SAFETY
            self.plotMovesToSafety(combatUnits: false, in: gameModel)
        case .reposition:
            // TACTICAL_REPOSITION
            self.plotRepositionMoves(in: gameModel)
        case .garrisonAlreadyThere:
            self.plotGarrisonMoves(numTurnsAway: 0, in: gameModel)
        case .garrisonToAllowBombards:
            self.plotGarrisonMoves(numTurnsAway: 1, mustAllowRangedAttack: true, in: gameModel)
        /*case .none:
            fatalError("not implemented yet")
        case .unassigned:
            fatalError("not implemented yet")
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
            
                    if let bestPlot = self.findNearbyTarget(for: unit, in: self.repositionRange, in: gameModel) {
                        
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
                                unit.push(mission: UnitMission(type: .moveTo, target: neighbor), in: gameModel)
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
                            
                            let acceptableDanger = currentUnit.combatStrength() * 100
                            if Int(dangerLevel) > acceptableDanger {
                                addUnit = true
                            }
                        }
                        
                    } else {
                        
                        // Civilian (or embarked) units always flee from danger
                        if !currentUnit.canFortify() {
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
                
                var lowestDanger = DBL_MAX
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
                    currentUnit.push(mission: UnitMission(type: .moveTo, target: bestPlot), in: gameModel) // FIXME: , .ignoreDanger
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

            if city.lastTurnGarrisonAssigned() < gameModel.turnsElapsed {
                
                // Grab units that make sense for this move type
                self.findUnitsFor(move: .garrisonAlreadyThere, target: tile, turnsAway: numTurnsAway, rangedOnly: mustAllowRangedAttack, in: gameModel)

                if self.currentMoveHighPriorityUnits.count + self.currentMoveUnits.count > 0 {
                    
                    self.executeMoveToTarget(target: tile, garrisonIfPossible: true, in: gameModel)
                    city.setLastTurnGarrisonAssigned(turn: gameModel.turnsElapsed)
                }
            }
            
        }
    }
    
    /// Find one unit to move to target, starting with high priority list
    func executeMoveToTarget(target: AbstractTile?, garrisonIfPossible: Bool, in gameModel: GameModel?) {

        guard let target = target else {
            fatalError("cant get target")
        }
        
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

            if unit.location == target.point && unit.canFortify() {
                
                unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                unit.setFortifiedThisTurn(fortified: true)
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if garrisonIfPossible && unit.location == target.point && unit.canGarrison(at: target.point, in: gameModel) {
                
                unit.push(mission: UnitMission(type: .garrison), in: gameModel)
                unit.finishMoves()
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if currentMoveHighPriorityUnit.movesToTarget < Int.max {
                
                unit.push(mission: UnitMission(type: .moveTo, target: target.point), in: gameModel)
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

            if unit.location == target.point && unit.canFortify() {

                unit.push(mission: UnitMission(type: .fortify), in: gameModel)
                unit.setFortifiedThisTurn(fortified: true)
                self.unitProcessed(unit: unit, in: gameModel)
                return
                
            } else if currentMoveUnit.movesToTarget < Int.max {
                
                unit.push(mission: UnitMission(type: .moveTo, target: target.point), in: gameModel)
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
                    if loopUnit.defenseModifier() == 0 && loopUnit.attackModifier() == 0 {
                        suitableUnit = true
                    }
                } else if move == .guardImprovementAlreadyThere || move == .guardImprovementOneTurn || move == .bastionAlreadyThere || move == .bastionOneTurn {
                    
                    // No ranged units or units without defensive bonuses as plot defenders
                    if !loopUnit.isRanged() /*&& !loopUnit->noDefensiveBonus()*/ {
                        suitableUnit = true

                        // Units with defensive promotions are especially valuable
                        if loopUnit.defenseModifier() > 0 /* || pLoopUnit->getExtraCombatPercent() > 0*/ {
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
                
            case .barbarianCaptureCity:
                // AI_TACTICAL_BARBARIAN_CAPTURE_CITY
                self.plotCaptureCityMoves(in: gameModel)
            //case .barbarianCaptureCity:
                // AI_TACTICAL_BARBARIAN_DAMAGE_CITY
                //
            case .barbarianMoveToSafety:
                // AI_TACTICAL_BARBARIAN_MOVE_TO_SAFETY
                self.plotMovesToSafety(combatUnits: true, in: gameModel)
            default:
                // NOOP
                //print("not implemented: TacticalAI - \(move.moveType)")
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
    
    /// Assign a group of units to take down each city we can capture
    @discardableResult
    private func plotCaptureCityMoves(in gameModel: GameModel?) -> Bool {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var attackMade = false
        
        // See how many moves of this type we can execute
        for var target in self.zoneTargets(for: .city) {
            
            // See what units we have who can reach target this turn
            if let tile = target?.tile {
                
                if self.findUnitsWithinStrikingDistance(towards: tile, numTurnsAway: 1, in: gameModel) {
                    
                    // Do we have enough firepower to destroy it?
                    if let city = gameModel.city(at: tile.point) {
                        
                        let requiredDamage = 200 - city.damage()
                        target?.damage = requiredDamage
                        
                        if self.computeTotalExpectedDamage(target: target, and: tile) >= requiredDamage {
                            
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
    
    /// Estimates the damage we can apply to a target
    func computeTotalExpectedDamage(target: TacticalTarget?, and tile: AbstractTile?) -> Int {
        
        fatalError("not implemented yet")
        
        /* int rtnValue = 0;
        int iExpectedDamage;
        int iExpectedSelfDamage;

        // Loop through all units who can reach the target
        for (unsigned int iI = 0; iI < m_CurrentMoveUnits.size(); iI++)
        {
            UnitHandle pAttacker = m_pPlayer->getUnit(m_CurrentMoveUnits[iI].GetID());

            // Is target a unit?
            switch (pTarget->GetTargetType())
            {
            case AI_TACTICAL_TARGET_HIGH_PRIORITY_UNIT:
            case AI_TACTICAL_TARGET_MEDIUM_PRIORITY_UNIT:
            case AI_TACTICAL_TARGET_LOW_PRIORITY_UNIT:
                {
                    UnitHandle pDefender = pTargetPlot->getVisibleEnemyDefender(m_pPlayer->GetID());
                    if (pDefender)
                    {
                        if (pAttacker->IsCanAttackRanged())
                        {
                            iExpectedDamage = pAttacker->GetRangeCombatDamage(pDefender.pointer(), NULL, false);
                            iExpectedSelfDamage = 0;
                        }
                        else
                        {
                            int iAttackerStrength = pAttacker->GetMaxAttackStrength(NULL, pTargetPlot, NULL);
                            int iDefenderStrength = pDefender->GetMaxDefenseStrength(pTargetPlot, pAttacker.pointer());
                            UnitHandle pFireSupportUnit = CvUnitCombat::GetFireSupportUnit(pDefender->getOwner(), pTargetPlot->getX(), pTargetPlot->getY(), pAttacker->getX(), pAttacker->getY());
                            int iDefenderFireSupportCombatDamage = 0;
                            if (pFireSupportUnit)
                            {
                                iDefenderFireSupportCombatDamage = pFireSupportUnit->GetRangeCombatDamage(pAttacker.pointer(), NULL, false);
                            }
                            iExpectedDamage = pAttacker->getCombatDamage(iAttackerStrength, iDefenderStrength, pAttacker->getDamage() + iDefenderFireSupportCombatDamage, /*bIncludeRand*/ false, /*bAttackerIsCity*/ false, /*bDefenderIsCity*/ false);
                            iExpectedSelfDamage = pDefender->getCombatDamage(iDefenderStrength, iAttackerStrength, pDefender->getDamage(), /*bIncludeRand*/ false, /*bAttackerIsCity*/ false, /*bDefenderIsCity*/ false);
                        }
                        m_CurrentMoveUnits[iI].SetExpectedTargetDamage(iExpectedDamage);
                        m_CurrentMoveUnits[iI].SetExpectedSelfDamage(iExpectedSelfDamage);
                        rtnValue += iExpectedDamage;
                    }
                }
                break;

            case AI_TACTICAL_TARGET_CITY:
                {
                    CvCity *pCity = pTargetPlot->getPlotCity();
                    if (pCity != NULL)
                    {
                        if (pAttacker->IsCanAttackRanged() && pAttacker->GetMaxRangedCombatStrength(NULL, /*pCity*/ NULL, true, true) > pAttacker->GetMaxAttackStrength(NULL, pTargetPlot, NULL))
                        {
                            iExpectedDamage = pAttacker->GetRangeCombatDamage(NULL, pCity, false);
                            iExpectedSelfDamage = 0;
                        }
                        else
                        {
                            int iAttackerStrength = pAttacker->GetMaxAttackStrength(NULL, pTargetPlot, NULL);
                            int iDefenderStrength = pCity->getStrengthValue();
                            CvUnit* pFireSupportUnit = CvUnitCombat::GetFireSupportUnit(pCity->getOwner(), pTargetPlot->getX(), pTargetPlot->getY(), pAttacker->getX(), pAttacker->getY());
                            int iDefenderFireSupportCombatDamage = 0;
                            if (pFireSupportUnit != NULL)
                            {
                                iDefenderFireSupportCombatDamage = pFireSupportUnit->GetRangeCombatDamage(pAttacker.pointer(), NULL, false);
                            }
                            iExpectedDamage = pAttacker->getCombatDamage(iAttackerStrength, iDefenderStrength, pAttacker->getDamage() + iDefenderFireSupportCombatDamage, /*bIncludeRand*/ false, /*bAttackerIsCity*/ false, /*bDefenderIsCity*/ true);
                            iExpectedSelfDamage = pAttacker->getCombatDamage(iDefenderStrength, iAttackerStrength, pCity->getDamage(), /*bIncludeRand*/ false, /*bAttackerIsCity*/ true, /*bDefenderIsCity*/ false);
                        }
                        m_CurrentMoveUnits[iI].SetExpectedTargetDamage(iExpectedDamage);
                        m_CurrentMoveUnits[iI].SetExpectedSelfDamage(iExpectedSelfDamage);
                        rtnValue += iExpectedDamage;
                    }
                }
                break;
            }
        }

        return rtnValue; **/
    }
    
    /// Reset all data on queued attacks for a new turn
    func initializeQueuedAttacks() {
        
        self.queuedAttacks.removeAll()
        self.currentSeriesId = 0
    }
    
    /// Fills m_CurrentMoveUnits with all units within X turns of a target (returns TRUE if 1 or more found)
    func findUnitsWithinStrikingDistance(towards tile: AbstractTile?, numTurnsAway: Int, noRangedUnits: Bool = false, navalOnly: Bool = false, mustMoveThrough: Bool = false, in gameModel: GameModel?) -> Bool {
        
        fatalError("not implemented yet")
        
        /*
         list<int>::iterator it;
         UnitHandle pLoopUnit;

         bool rtnValue = false;
         m_CurrentMoveUnits.clear();

         // Loop through all units available to tactical AI this turn
         for (it = m_CurrentTurnUnits.begin(); it != m_CurrentTurnUnits.end(); it++)
         {
             pLoopUnit = m_pPlayer->getUnit(*it);
             if (pLoopUnit)
             {
                 if (!bNavalOnly || pLoopUnit->getDomainType() == DOMAIN_SEA)
                 {
                     // don't use non-combat units
                     if (!pLoopUnit->IsCanAttack())
                     {
                         continue;
                     }

                     if (pLoopUnit->isOutOfAttacks())
                     {
                         continue;
                     }

                     // *** Need to make this smarter and account for units that can move up on their targets and then make a ranged attack,
                     //     all in the same turn. ***
                     if (!bNoRangedUnits && !bMustMoveThrough && pLoopUnit->IsCanAttackRanged())
                     {
                         // Are we in range?
                         if (plotDistance(pLoopUnit->getX(), pLoopUnit->getY(), pTarget->getX(), pTarget->getY()) <= pLoopUnit->GetRange())
                         {
                             // Do we have LOS to the target?
                             if (pLoopUnit->canEverRangeStrikeAt(pTarget->getX(), pTarget->getY()))
                             {
                                 // Will we do any damage
                                 if (IsExpectedToDamageWithRangedAttack(pLoopUnit, pTarget))
                                 {
                                     CvTacticalUnit unit;
                                     unit.SetID(pLoopUnit->GetID());

                                     // Want ranged units to attack first, so inflate this
                                     unit.SetAttackStrength(100 * pLoopUnit->GetMaxRangedCombatStrength(NULL, /*pCity*/ NULL, true, true));
                                     unit.SetHealthPercent(100, 100);  // Don't take damage from bombarding, so show as fully healthy
                                     m_CurrentMoveUnits.push_back(unit);
                                     rtnValue = true;
                                 }
                             }
                         }
                     }
                     else
                     {
                         if (CanReachInXTurns(pLoopUnit, pTarget, iNumTurnsAway))
                         {
                             CvTacticalUnit unit;
                             unit.SetID(pLoopUnit->GetID());
                             unit.SetAttackStrength(pLoopUnit->GetMaxAttackStrength(NULL, NULL, NULL));
                             unit.SetHealthPercent(pLoopUnit->GetCurrHitPoints(), pLoopUnit->GetMaxHitPoints());
                             m_CurrentMoveUnits.push_back(unit);
                             rtnValue = true;
                         }
                     }
                 }
             }
         }

         // Now sort them in the order we'd like them to attack
         std::stable_sort (m_CurrentMoveUnits.begin(), m_CurrentMoveUnits.end());

         return rtnValue;
         */
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
                                            if unit.canMove() /*&& unit.canRangeStrikeAt(pTargetPlot->getX(), pTargetPlot->getY())*/ {
                                                
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
                unit.push(mission: UnitMission(type: .rangedAttack, target: target.target), in: gameModel)
            }
            //else if (pUnit->canNuke(NULL)) // NUKE tactical attack (ouch)
            //{
            //    pUnit->PushMission(CvTypes::getMISSION_NUKE(), pTarget->GetTargetX(), pTarget->GetTargetY());
            //}
            else {
                unit.push(mission: UnitMission(type: .moveTo, target: target.target), in: gameModel)
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

        return (isOurCapital || dominanceZone.rangeClosestEnemyUnit <= (self.recruitRange / 2) ||
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
    }
    
    /// Find last posture for a specific zone
    private func findPostureType(for dominanceZone: TacticalAnalysisMap.TacticalDominanceZone?) -> TacticalPostureType {
        
        if let dominanceZone = dominanceZone {
            
            for posture in self.postures {
                
                if posture.player?.leader == self.player?.leader && posture.isWater == dominanceZone.isWater {
                    
                    if dominanceZone.closestCity != nil && posture.city?.location == dominanceZone.closestCity?.location {
                    
                        return posture.type
                    }
                }
            }
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

        let barbsAllowedYet = gameModel.turnsElapsed >= 20
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

                        var newTarget = TacticalTarget(
                            targetType: .none,
                            target: point,
                            targetPlayer: nil,
                            dominanceZone: gameModel.tacticalAnalysisMap().plots[point]?.dominanceZone)

                        let enemyDominatedPlot = gameModel.tacticalAnalysisMap().isInEnemyDominatedZone(at: point)

                        // Have a ...
                        // ... friendly city?
                        let cityRef = gameModel.city(at: tile.point)

                        if let city = cityRef {

                            if self.player?.leader == city.player?.leader {

                                newTarget.targetType = .cityToDefend
                                newTarget.city = cityRef
                                newTarget.threatValue = city.threatValue()
                                self.allTargets.append(newTarget)


                                // ... enemy city
                            } else if diplomacyAI.isAtWar(with: city.player) {

                                newTarget.targetType = .city
                                newTarget.city = cityRef
                                newTarget.threatValue = city.threatValue()
                                self.allTargets.append(newTarget)
                            }
                        } else {
                            // ... enemy unit?
                            let unitRef = gameModel.unit(at: tile.point)
                            if let unit = unitRef {
                                if diplomacyAI.isAtWar(with: unit.player) {
                                    newTarget.targetType = .lowPriorityUnit
                                    newTarget.targetPlayer = unit.player
                                    newTarget.unit = unitRef
                                    newTarget.damage = unit.damage()
                                    self.allTargets.append(newTarget)
                                }


                                // ... undefended camp?
                            } else if tile.has(improvement: .barbarianCamp) {

                                newTarget.targetType = .barbarianCamp
                                newTarget.targetPlayer = gameModel.barbarianPlayer()
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)


                                // ... goody hut?
                            } else if tile.has(improvement: .goodyHut) {

                                newTarget.targetType = .ancientRuins
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)


                                // ... enemy resource improvement?
                            } else if diplomacyAI.isAtWar(with: tile.owner()) && !tile.has(improvement: .none) && !tile.canBePillaged() &&
                                !tile.has(resource: .none) && !enemyDominatedPlot {

                                // On land, civs only target improvements built on resources
                                if tile.has(resourceType: .strategic) || tile.has(resourceType: .luxury) || tile.terrain().isWater() || player.leader == .barbar {

                                    if tile.terrain().isWater() && player.leader == .barbar {

                                        continue
                                    } else {

                                        newTarget.targetType = .improvement
                                        newTarget.targetPlayer = tile.owner()
                                        newTarget.tile = tile
                                        self.allTargets.append(newTarget)
                                    }
                                }


                                // Or forts / citadels!
                            } else if diplomacyAI.isAtWar(with: tile.owner()) && (tile.has(improvement: .fort) && tile.has(improvement: .citadelle)) {
                                newTarget.targetType = .improvement
                                newTarget.targetPlayer = tile.owner()
                                newTarget.tile = tile
                                self.allTargets.append(newTarget)


                                // ... enemy civilian (or embarked) unit?
                            } else if unitRef?.player?.leader != player.leader {

                                if let unit = unitRef {

                                    if diplomacyAI.isAtWar(with: unit.player) && !unit.canDefend() {

                                        newTarget.targetType = .lowPriorityUnit
                                        newTarget.targetPlayer = unit.player
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
                                            } else if self.isHighPriorityCivilian(target: newTarget, in: gameModel.turnsElapsed, numCities: gameModel.cities(of: player).count) {

                                                newTarget.targetType = .highPriorityCivilian
                                            } else if self.isMediumPriorityCivilian(target: newTarget, in: gameModel.turnsElapsed) {
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
        for var target in self.allTargets {
            
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
                            
                            if enemyUnit.canAttackRanged() && enemyUnit.rangedCombatStrength(against: nil, or: city, on: tile, attacking: true) > enemyUnit.attackStrength(against: nil, or: city, on: tile) {
                            
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
                    for var unitTargetRef in self.unitTargets() {
                        
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
                    for var unitTargetRef in self.unitTargets() {
                    
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
                            
                            if var unitTarget = unitTargetRef {
                                var priorityTarget = false
                                if unitTarget.targetType != .highPriorityUnit {
                                    
                                    if let enemyUnit = gameModel.visibleEnemy(at: unitTarget.target, for: self.player) {
                                        
                                        if enemyUnit.canAttackRanged() && enemyUnit.rangedCombatStrength(against: nil, or: nil, on: tile, attacking: true) > enemyUnit.attackStrength(against: nil, or: nil, on: tile) {
                                            
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
            } else if unit.has(task: .worker) && turn < 50 { //early game?
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

        self.temporaryZones = self.temporaryZones.filter({ $0.lastTurn < gameModel.turnsElapsed })
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