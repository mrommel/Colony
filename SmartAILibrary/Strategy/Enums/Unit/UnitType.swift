//
//  UnitType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CivilianAttackPriorityType {

    case none
    case high
    case highEarlyGameOnly
    case low
}

public enum UnitType: Int, Codable {

    case barbarianWarrior

    // civilians

    case settler // FIXME Abilities: Found a City on a valid land tile. (Expends the unit and creates a city on its tile.)
    case builder // FIXME Attributes: Has 3 build charges.
    /*Abilities:
     Build Tile Improvement (uses 1 charge)
     Repair Tile Improvement (uses no charge)
     Remove Tile Improvement (uses no charge)
     Harvest Resource (uses 1 charge and provides a one-time yield; Bonus Resources only)
     Remove Feature (uses 1 charge and provides a one-time yield; Forest, Rainforest, or Marsh only)
     Plant Woods (uses 1 charge; requires Conservation)
     Clean Nuclear Fallout*/

    // recon

    case scout // FIXME Gains XP when activating Tribal Villages (+5 XP) and discovering Natural Wonders (+10 XP), besides the normal gains when fighting.
    // Follows a special promotion table with promotions oriented towards exploration.

    // melee

    case warrior // FIXME +10 Combat Strength vs. anti-cavalry units.
    case slinger // FIXME -17 Range Strength against district defense and Naval units.
    case archer // FIXME -17 Range Strength against district defense and Naval units.
    case spearman // FIXME +10 Combat Strength vs. light, heavy, and ranged cavalry units.
    case heavyChariot // FIXME Gains 1 bonus Civ6Movement Movement if it begins a turn on a flat tile with no Woods, Rainforest, or Hills.
    // Vulnerable to anti-cavalry units.

    // naval

    case galley // FIXME Ancient era melee naval combat unit. Can only operate on coastal waters until Cartography is researched.

    // taken from https://www.matrixgames.com/forums/tm.asp?m=2994803

    // great people
    case artist
    case admiral
    case engineer
    case general
    case merchant
    // case musician
    case prophet
    case scientist
    // case writer

    struct UnitTypeData {

        let name: String

        let sight: Int
        let range: Int
        let supportDistance: Int
        let strength: Int //
        let targetType: UnitClassType
        let flags: BitArray = BitArray(count: 4)

        // attack values
        let meleeAttack: Int
        let rangedAttack: Int

        // movement
        let moves: Int
    }

    public static var all: [UnitType] {

        return [
            // barbarians
            .barbarianWarrior,

            // civil units
            .settler, .builder,

            // ancient
            .scout, .warrior, .archer, .spearman, .heavyChariot, .galley,

            // great people
            .artist, .engineer, .merchant, .scientist, .admiral, .general, .prophet
        ]
    }
    
    public func name() -> String {

        return self.data().name
    }

    func range() -> Int {

        return self.data().range
    }

    func sight() -> Int {

        return self.data().sight
    }

    // https://panzercorps.gamepedia.com/Terrain
    func moves() -> Int {

        return self.data().moves
    }

    // melee strength
    func meleeStrength() -> Int {

        return self.data().meleeAttack
    }

    func rangedStrength() -> Int {

        if self.range() > 0 {
            return self.data().rangedAttack
        }

        return 0
    }

    func unitClass() -> UnitClassType {

        return self.data().targetType
    }

    func power() -> Int {

        var powerVal = 0

        // ***************
        // Main Factors - Strength & Moves
        // ***************

        // We want a Unit that has twice the strength to be roughly worth 3x as much with regards to Power
        powerVal = Int(pow(Double(self.meleeStrength()), 1.5))

        // Ranged Strength
        var rangedPower = Int(pow(Double(self.rangedStrength()), 1.45))

        // Naval ranged attacks are less useful
        if self.domain() == .sea {
            rangedPower /= 2
        }

        if rangedPower > 0 {
            powerVal = rangedPower
        }

        // We want Movement rate to be important, but not a dominating factor; a Unit with double the moves of a similarly-strengthed Unit should be ~1.5x as Powerful
        powerVal = Int(Double(powerVal) * pow(Double(self.moves()), 0.3))

        // ***************
        // ability modifiers
        // ***************

        /*for ability in self.abilities() {
            // FIXME
        }*/

        return powerVal
    }

    func data() -> UnitTypeData {

        switch self {

        case .barbarianWarrior: return UnitTypeData(name: "barbarian", sight: 2, range: 0, supportDistance: 0, strength: 10, targetType: .melee, meleeAttack: 15, rangedAttack: 0, moves: 2)

        case .settler:
            // https://civilization.fandom.com/wiki/Settler_(Civ6)
            return UnitTypeData(name: "settler", sight: 3, range: 0, supportDistance: 0, strength: 10, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 2)
        case .builder:
            // https://civilization.fandom.com/wiki/Builder_(Civ6)
            return UnitTypeData(name: "builder", sight: 2, range: 0, supportDistance: 0, strength: 10, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 2)
        case .scout:
            // https://civilization.fandom.com/wiki/Scout_(Civ6)
            return UnitTypeData(name: "scout", sight: 2, range: 0, supportDistance: 0, strength: 10, targetType: .recon, meleeAttack: 10, rangedAttack: 0, moves: 3)
        case .warrior:
            // https://civilization.fandom.com/wiki/Warrior_(Civ6)
            return UnitTypeData(name: "warrior", sight: 2, range: 0, supportDistance: 0, strength: 10, targetType: .melee, meleeAttack: 20, rangedAttack: 0, moves: 2)
        case .slinger:
            return UnitTypeData(name: "slinger", sight: 2, range: 1, supportDistance: 1, strength: 10, targetType: .ranged, meleeAttack: 5, rangedAttack: 15, moves: 2)
        case .archer:
            return UnitTypeData(name: "archer", sight: 2, range: 2, supportDistance: 2, strength: 10, targetType: .ranged, meleeAttack: 15, rangedAttack: 25, moves: 2)
        case .spearman:
            return UnitTypeData(name: "spearman", sight: 2, range: 0, supportDistance: 0, strength: 10, targetType: .antiCavalry, meleeAttack: 25, rangedAttack: 0, moves: 2)
        case .heavyChariot:
            return UnitTypeData(name: "chariot", sight: 2, range: 0, supportDistance: 0, strength: 10, targetType: .lightCavalry, meleeAttack: 28, rangedAttack: 0, moves: 2)
        case .galley:
            return UnitTypeData(name: "galley", sight: 2, range: 0, supportDistance: 0, strength: 10, targetType: .navalMelee, meleeAttack: 0, rangedAttack: 0, moves: 3)


        case .artist:
            return UnitTypeData(name: "Artist", sight: 2, range: 0, supportDistance: 0, strength: 0, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 3)
        case .engineer:
            return UnitTypeData(name: "engineer", sight: 2, range: 0, supportDistance: 0, strength: 0, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 3)
        case .merchant:
            return UnitTypeData(name: "merchant", sight: 2, range: 0, supportDistance: 0, strength: 0, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 3)
        case .scientist:
            return UnitTypeData(name: "scientist", sight: 2, range: 0, supportDistance: 0, strength: 0, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 3)
        case .admiral:
            return UnitTypeData(name: "admiral", sight: 2, range: 0, supportDistance: 0, strength: 0, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 3)
        case .general:
            return UnitTypeData(name: "general", sight: 2, range: 0, supportDistance: 0, strength: 0, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 3)
        case .prophet:
            return UnitTypeData(name: "prophet", sight: 2, range: 0, supportDistance: 0, strength: 0, targetType: .civilian, meleeAttack: 0, rangedAttack: 0, moves: 3)
        }
    }

    // https://github.com/Thalassicus/cep-bnw/blob/9196a4d3fc84c173013a900691222ee072eb5c8a/Ceg/Ceg/AI/Flavors/Custom%20AI%20Flavors/Ancient%20-%20Early.xml
    func flavours() -> [Flavor] {

        switch self {

        case .barbarianWarrior: return []

            // ancient
        case .settler: return [
                Flavor(type: .expansion, value: 9)
            ]
        case .builder: return [
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
        case .scout: return [
                Flavor(type: .recon, value: 8),
                Flavor(type: .defense, value: 2)
            ]
        case .warrior: return [
                Flavor(type: .offense, value: 3),
                Flavor(type: .recon, value: 3),
                Flavor(type: .defense, value: 3)
            ]
        case .slinger: return [
                Flavor(type: .ranged, value: 8),
                Flavor(type: .recon, value: 10),
                Flavor(type: .offense, value: 3),
                Flavor(type: .defense, value: 4),
            ]
        case .archer: return [
                Flavor(type: .ranged, value: 6),
                Flavor(type: .recon, value: 3),
                Flavor(type: .offense, value: 1),
                Flavor(type: .defense, value: 2),
            ]
        case .spearman: return [
                Flavor(type: .defense, value: 4),
                Flavor(type: .recon, value: 2),
                Flavor(type: .offense, value: 2),
            ]
        case .heavyChariot: return [
                Flavor(type: .recon, value: 9),
                Flavor(type: .ranged, value: 5),
                Flavor(type: .mobile, value: 10),
                Flavor(type: .offense, value: 3),
                Flavor(type: .defense, value: 6),
            ]
        case .galley: return []

        case .artist: return []
        case .engineer: return []
        case .merchant: return []
        case .scientist: return []
        case .general: return []
        case .admiral: return []
        case .prophet: return []
        }
    }

    func domain() -> UnitDomainType {

        switch self {

        case .barbarianWarrior: return .land

            // ancient
        case .settler: return .land
        case .builder: return .land
        case .scout: return .land
        case .warrior: return .land
        case .slinger: return .land
        case .archer: return .land
        case .spearman: return .land
        case .heavyChariot: return .land
        case .galley: return .sea

            // great people
        case .artist: return .land
        case .engineer: return .land
        case .merchant: return .land
        case .scientist: return .land
        case .general: return .land
        case .admiral: return .land
        case .prophet: return .land
        }
    }

    func canFound() -> Bool {

        return self == .settler
    }

    func unitTasks() -> [UnitTaskType] {

        switch self {

        case .barbarianWarrior: return [.attack]

            // ancient
        case .settler: return [.settle]
        case .builder: return [.worker]
        case .scout: return [.explore]
        case .warrior: return [.attack, .defense, .explore]
        case .slinger: return [.ranged]
        case .archer: return [.ranged]
        case .spearman: return [.attack, .defense]
        case .heavyChariot: return [.attack, .defense, .explore]
        case .galley: return [.exploreSea, .attackSea, .escortSea, .reserveSea]

            // great people
        case .artist: return []
        case .engineer: return []
        case .merchant: return []
        case .scientist: return []
        case .general: return []
        case .admiral: return []
        case .prophet: return []
        }
    }

    func defaultTask() -> UnitTaskType {

        switch self {

        case .barbarianWarrior: return .attack

            // ancient
        case .settler: return .settle
        case .builder: return .worker
        case .scout: return .explore
        case .warrior: return .explore
        case .slinger: return .ranged
        case .archer: return .ranged
        case .spearman: return .defense
        case .heavyChariot: return .attack
        case .galley: return .exploreSea

            // great people
        case .artist: return .general
        case .engineer: return .general
        case .merchant: return .general
        case .scientist: return .general
        case .general: return .general
        case .admiral: return .general
        case .prophet: return .general
        }
    }

    func movementType() -> UnitMovementType {

        switch self {
        case .barbarianWarrior: return .walk

        case .settler: return .walk
        case .builder: return .walk

        case .scout: return .walk
        case .warrior: return .walk
        case .slinger: return .walk
        case .archer: return .walk
        case .spearman: return .walk
        case .heavyChariot: return .walk // FIXME

        case .galley: return .swim

            // great people
        case .artist: return .walk
        case .engineer: return .walk
        case .merchant: return .walk
        case .scientist: return .walk
        case .general: return .walk
        case .admiral: return .walk
        case .prophet: return .walk
        }
    }

    /// cost in production
    func productionCost() -> Int {

        switch self {

        case .barbarianWarrior: return 0

            // ancient
        case .settler: return 80
        case .builder: return 50
        case .scout: return 30
        case .warrior: return 40
        case .slinger: return 35
        case .archer: return 60
        case .spearman: return 65
        case .heavyChariot: return 65
        case .galley: return 65

            // great people
        case .artist: return 0
        case .engineer: return 0
        case .merchant: return 0
        case .scientist: return 0
        case .general: return 0
        case .admiral: return 0
        case .prophet: return 0
        }
    }

    /// cost in gold
    func purchaseCost() -> Int {

        switch self {

        case .barbarianWarrior: return 0

            // ancient
        case .settler: return 320
        case .builder: return 200
        case .scout: return 120
        case .warrior: return 160
        case .slinger: return 140
        case .archer: return 240
        case .spearman: return 260
        case .heavyChariot: return 260
        case .galley: return 260

            // great people
        case .artist: return 0
        case .engineer: return 0
        case .merchant: return 0
        case .scientist: return 0
        case .general: return 0
        case .admiral: return 0
        case .prophet: return 0
        }
    }

    /// maintenance cost in gold
    func maintenanceCost() -> Int {

        switch self {

        case .barbarianWarrior: return 0

            // ancient
        case .settler: return 0
        case .builder: return 0
        case .scout: return 0
        case .warrior: return 0
        case .slinger: return 0
        case .archer: return 1
        case .spearman: return 1
        case .heavyChariot: return 1
        case .galley: return 1

            // great people
        case .artist: return 0
        case .engineer: return 0
        case .merchant: return 0
        case .scientist: return 0
        case .general: return 0
        case .admiral: return 0
        case .prophet: return 0
        }
    }

    public func required() -> TechType? {

        switch self {

        case .barbarianWarrior: return nil

            // ancient
        case .settler: return nil
        case .builder: return nil

        case .scout: return nil
        case .warrior: return nil
        case .slinger: return nil
        case .archer: return .archery
        case .spearman: return .bronzeWorking
        case .heavyChariot: return .wheel
        case .galley: return .sailing

            // great people
        case .artist: return nil
        case .engineer: return nil
        case .merchant: return nil
        case .scientist: return nil
        case .general: return nil
        case .admiral: return nil
        case .prophet: return nil
        }
    }

    // is unit type special to any civ? nil if not
    public func civilization() -> CivilizationType? {

        switch self {

        case .barbarianWarrior: return .barbarian

            // ancient
        case .settler: return nil
        case .builder: return nil

        case .scout: return nil
        case .warrior: return nil
        case .slinger: return nil
        case .archer: return nil
        case .spearman: return nil
        case .heavyChariot: return nil
        case .galley: return nil

        case .artist: return nil
        case .engineer: return nil
        case .merchant: return nil
        case .scientist: return nil
        case .general: return nil
        case .admiral: return nil
        case .prophet: return nil
        }
    }

    func abilities() -> [UnitAbilityType] {

        switch self {

        case .barbarianWarrior: return []

            // ancient
        case .settler: return [.canFound]
        case .builder: return [.canImprove]

        case .scout: return [.experienceFromTribal]
        case .warrior: return [.canCapture]
        case .slinger: return [.canCapture]
        case .archer: return [.canCapture]
        case .spearman: return [.canCapture]
        case .heavyChariot: return [.canCapture]
        case .galley: return [.oceanImpassable, .canCapture]

        case .artist: return []
        case .engineer: return []
        case .merchant: return []
        case .scientist: return []
        case .general: return []
        case .admiral: return []
        case .prophet: return []
        }
    }

    func civilianAttackPriority() -> CivilianAttackPriorityType {

        if self == .settler {
            return .highEarlyGameOnly
        }

        if self == .builder {
            return .low
        }

        return .none
    }

    // https://civilization.fandom.com/wiki/Combat_(Civ6)
    func unitClassModifier(for targetUnitClass: UnitClassType) -> Int {

        // Melee units versus Anti-Cavalry units receive a +10 CS bonus.
        if self.unitClass() == .melee && targetUnitClass == .antiCavalry {
            return 10
        }

        // Anti-Cavalry units versus Light Cavalry or Heavy Cavalry units receive a +10 CS bonus.
        if self.unitClass() == .antiCavalry && (targetUnitClass == .lightCavalry || targetUnitClass == .heavyCavalry) {
            return 10
        }

        // Ranged units versus City/District defenses or Naval units receive a -17 CS penalty.
        if self.unitClass() == .ranged && (targetUnitClass == .city || targetUnitClass == .navalMelee || targetUnitClass == .navalRaider || targetUnitClass == .navalRanged || targetUnitClass == .navalCarrier) {
            return -17
        }

        // Siege units versus any other unit types incur a -17 CS modifier.
        if self.unitClass() == .siege && targetUnitClass != .city {
            return -17
        }

        return 0
    }

    func canBuild(build: BuildType) -> Bool {

        switch build {

        case .none: return false

        case .repair: return self.has(ability: .canImprove)
        case .road: return self.has(ability: .canImprove)
        case .removeRoad: return self.has(ability: .canImprove)
        case .farm: return self.has(ability: .canImprove)
        case .mine: return self.has(ability: .canImprove)
        case .quarry: return self.has(ability: .canImprove)
        case .plantation: return self.has(ability: .canImprove)
        case .camp: return self.has(ability: .canImprove)
        case .pasture: return self.has(ability: .canImprove)

        case .removeForest: return self.has(ability: .canImprove)
        case .removeRainforest: return self.has(ability: .canImprove)
        case .removeMarsh: return self.has(ability: .canImprove)
        }
    }

    func has(ability: UnitAbilityType) -> Bool {

        return self.abilities().contains(ability)
    }

    func workRate() -> Int {

        if self == .builder {
            return 100
        }

        return 0
    }

    func captureType() -> UnitType? {

        if self == .builder || self == .settler {
            return .builder
        }

        return nil
    }

    func canPillage() -> Bool {

        if self == .builder || self == .settler {
            return false
        }

        return true
    }
}
