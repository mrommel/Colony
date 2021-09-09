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

// swiftlint:disable type_body_length
public enum UnitType: Int, Codable {

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
    case trader
    /*
     Attributes:
     Creates Roads while traveling along a TradeRoute6 Trade Route.
     Abilities:
     Establish a TradeRoute6 Trade Route from its current base city to a destination city within range.
     Switch City (Instantly moves the Trader to another city in its owner's empire.)
     */

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

    // support

    case medic

    // taken from https://www.matrixgames.com/forums/tm.asp?m=2994803

    // great people
    case artist
    case admiral
    case engineer
    case general
    case merchant
    case musician
    case prophet
    case scientist
    case writer

    // player overrides
    // barbarians

    case barbarianWarrior
    case barbarianArcher

    public static var all: [UnitType] {

        return [

            // civil units
            .settler, .builder, .trader,

            // ancient
            .scout, .warrior, .archer, .spearman, .heavyChariot, .galley,

            // industrial
            .medic,

            // great people
            .artist, .engineer, .merchant, .scientist, .admiral, .general, .prophet
        ]
    }

    public static var greatPersons: [UnitType] {

        return [.general, .artist, .admiral, .engineer, .general, .merchant, .prophet, .scientist]
    }

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    public func era() -> EraType {

        return self.data().era
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

    // returns the unittype of non standard units (such as special units of civilizations)
    func baseType() -> UnitType? {

        switch self {

            // barbarian
        case .barbarianWarrior: return .warrior
        case .barbarianArcher: return .archer

            // ancient
        case .settler: return .settler
        case .builder: return .builder
        case .trader: return .trader

        case .scout: return .scout
        case .warrior: return .warrior
        case .slinger: return .slinger
        case .archer: return .archer
        case .spearman: return .spearman
        case .heavyChariot: return .heavyChariot
        case .galley: return  .galley

            // industrial
        case .medic: return .medic

            // great people
        case .artist: return .artist
        case .admiral: return .admiral
        case .engineer: return .engineer
        case .general: return .general
        case .merchant: return .merchant
        case .musician: return .musician
        case .prophet: return .prophet
        case .scientist: return .scientist
        case .writer: return .writer
        }
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

    private struct UnitTypeData {

        let name: String
        let effects: [String]

        let era: EraType
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

    private func data() -> UnitTypeData {

        switch self {

        case .barbarianWarrior:
            return UnitTypeData(name: "Barbarian Warrior",
                                effects: [],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .melee,
                                meleeAttack: 15,
                                rangedAttack: 0,
                                moves: 2)

        case .barbarianArcher:
            return UnitTypeData(name: "Barbarian Archer",
                                effects: [],
                                era: .none,
                                sight: 2,
                                range: 1,
                                supportDistance: 2,
                                strength: 10,
                                targetType: .ranged,
                                meleeAttack: 15,
                                rangedAttack: 20,
                                moves: 2)

            // ancient
        case .settler:
            // https://civilization.fandom.com/wiki/Settler_(Civ6)
            return UnitTypeData(name: "Settler",
                                effects: [
                                    "May create new cities. Reduces city's Citizen Population by 1 when completed. Requires at least 2 Citizen Population.",
                                    "Production cost is progressive."
                                ],
                                era: .ancient,
                                sight: 3,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 2)
        case .builder:
            // https://civilization.fandom.com/wiki/Builder_(Civ6)
            return UnitTypeData(name: "Builder",
                                effects: [
                                    "May create tile improvements or remove features like Woods or Rainforest. Build charges number can be increased through policies or wonders like the Pyramids.",
                                    "Production cost is progressive."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 2)
        case .trader:
            // https://civilization.fandom.com/wiki/Trader_(Civ6)
            return UnitTypeData(name: "Trader",
                                effects: [
                                    "May make and maintain a single Trade Route Trade Route. Automatically creates Roads as it travels.",
                                    "Production cost is progressive."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 2)

        case .scout:
            // https://civilization.fandom.com/wiki/Scout_(Civ6)
            return UnitTypeData(name: "Scout",
                                effects: [
                                    "Fast-moving, Ancient era recon unit."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .recon,
                                meleeAttack: 10,
                                rangedAttack: 0,
                                moves: 3)
        case .warrior:
            // https://civilization.fandom.com/wiki/Warrior_(Civ6)
            return UnitTypeData(name: "Warrior",
                                effects: [
                                    "Weak Ancient era melee unit."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .melee,
                                meleeAttack: 20,
                                rangedAttack: 0,
                                moves: 2)
        case .slinger:
            // https://civilization.fandom.com/wiki/Slinger_(Civ6)
            return UnitTypeData(name: "Slinger",
                                effects: [
                                    "Weak Ancient era ranged unit. Better on attack than defense."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 1,
                                supportDistance: 1,
                                strength: 10,
                                targetType: .ranged,
                                meleeAttack: 5,
                                rangedAttack: 15,
                                moves: 2)
        case .archer:
            // https://civilization.fandom.com/wiki/Archer_(Civ6)
            return UnitTypeData(name: "Archer",
                                effects: [
                                    "First Ancient era ranged unit with Range of 2."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 2,
                                supportDistance: 2,
                                strength: 10,
                                targetType: .ranged,
                                meleeAttack: 15,
                                rangedAttack: 25,
                                moves: 2)
        case .spearman:
            // https://civilization.fandom.com/wiki/Spearman_(Civ6)
            return UnitTypeData(name: "Spearman",
                                effects: [
                                    "Ancient era melee unit that's effective against mounted units."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .antiCavalry,
                                meleeAttack: 25,
                                rangedAttack: 0,
                                moves: 2)
        case .heavyChariot:
            // https://civilization.fandom.com/wiki/Heavy_Chariot_(Civ6)
            return UnitTypeData(name: "Heavy Chariot",
                                effects: [
                                    "Hard-hitting, Ancient era heavy cavalry unit.",
                                    "Gains 1 bonus Movement if it begins a turn on a flat tile with no Woods, Rainforest, or Hills."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .lightCavalry,
                                meleeAttack: 28,
                                rangedAttack: 0,
                                moves: 2)
        case .galley:
            // https://civilization.fandom.com/wiki/Galley_(Civ6)
            return UnitTypeData(name: "Galley",
                                effects: [
                                    "Ancient era melee naval combat unit.",
                                    "Can only operate on coastal waters until Cartography is researched."
                                ],
                                era: .ancient,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .navalMelee,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)

            // industrial
        case .medic:
            // https://civilization.fandom.com/wiki/Medic_(Civ6)
            return UnitTypeData(name: "Medic",
                                effects: [
                                    "Industrial era support unit.",
                                    "Can heal adjacent units."
                                ],
                                era: .industrial,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 10,
                                targetType: .support,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 2)

            // great people
        case .admiral:
            // https://civilization.fandom.com/wiki/Great_Admiral_(Civ6)
            return UnitTypeData(name: "Admiral",
                                effects: [
                                    "Boosts combat strength and mobility of nearby naval units. Can \"Retire\" to expend it once no longer useful."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .artist:
            // https://civilization.fandom.com/wiki/Great_Artist_(Civ6)
            return UnitTypeData(name: "Artist",
                                effects: [
                                    "Activate on an appropriate tile to create Great Work."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .engineer:
            // https://civilization.fandom.com/wiki/Great_Engineer_(Civ6)
            return UnitTypeData(name: "Engineer",
                                effects: [
                                    "Activate on an appropriate tile to receive their effects."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .general:
            // https://civilization.fandom.com/wiki/Great_General_(Civ6)
            return UnitTypeData(name: "General",
                                effects: [
                                    "Boosts combat strength and mobility of nearby land units. Can \"Retire\" to expend it once no longer useful."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .merchant:
            // https://civilization.fandom.com/wiki/Great_Merchant_(Civ6)
            return UnitTypeData(name: "Merchant",
                                effects: [
                                    "Activate on an appropriate tile to receive their effects."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .musician:
            // https://civilization.fandom.com/wiki/Great_Musician_(Civ6)
            return UnitTypeData(name: "Musician",
                                effects: [
                                    "Activate on an appropriate tile to create Great Work."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .prophet:
            // https://civilization.fandom.com/wiki/Great_Prophet_(Civ6)
            return UnitTypeData(name: "Prophet",
                                effects: [
                                    "Activate on Holy Site or Stonehenge to found a Religion."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .scientist:
            // https://civilization.fandom.com/wiki/Great_Scientist_(Civ6)
            return UnitTypeData(name: "Scientist",
                                effects: [
                                    "Activate on an appropriate tile to receive their effects."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        case .writer:
            // https://civilization.fandom.com/wiki/Great_Writer_(Civ6)
            return UnitTypeData(name: "Writer",
                                effects: [
                                    "Activate on an appropriate tile, such as an Amphitheatre, to create the Great Work."
                                ],
                                era: .none,
                                sight: 2,
                                range: 0,
                                supportDistance: 0,
                                strength: 0,
                                targetType: .civilian,
                                meleeAttack: 0,
                                rangedAttack: 0,
                                moves: 3)
        }
    }

    // https://github.com/Thalassicus/cep-bnw/blob/9196a4d3fc84c173013a900691222ee072eb5c8a/Ceg/Ceg/AI/Flavors/Custom%20AI%20Flavors/Ancient%20-%20Early.xml
    func flavours() -> [Flavor] {

        switch self {

        case .barbarianWarrior: return []
        case .barbarianArcher: return []

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
        case .trader: return [
                Flavor(type: .gold, value: 10)
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
                Flavor(type: .defense, value: 4)
            ]
        case .archer: return [
                Flavor(type: .ranged, value: 6),
                Flavor(type: .recon, value: 3),
                Flavor(type: .offense, value: 1),
                Flavor(type: .defense, value: 2)
            ]
        case .spearman: return [
                Flavor(type: .defense, value: 4),
                Flavor(type: .recon, value: 2),
                Flavor(type: .offense, value: 2)
            ]
        case .heavyChariot: return [
                Flavor(type: .recon, value: 9),
                Flavor(type: .ranged, value: 5),
                Flavor(type: .mobile, value: 10),
                Flavor(type: .offense, value: 3),
                Flavor(type: .defense, value: 6)
            ]
        case .galley: return []

            // industral
        case .medic: return []

            // great people
        case .admiral: return []
        case .artist: return []
        case .engineer: return []
        case .general: return []
        case .merchant: return []
        case .musician: return []
        case .prophet: return []
        case .scientist: return []
        case .writer: return []

        }
    }

    func domain() -> UnitDomainType {

        switch self {

        case .barbarianWarrior: return .land
        case .barbarianArcher: return .land

            // ancient
        case .settler: return .land
        case .builder: return .land
        case .trader: return .land // FIXME (how to handle sea?)
        case .scout: return .land
        case .warrior: return .land
        case .slinger: return .land
        case .archer: return .land
        case .spearman: return .land
        case .heavyChariot: return .land
        case .galley: return .sea

            // industral
        case .medic: return .land

            // great people
        case .admiral: return .land
        case .artist: return .land
        case .engineer: return .land
        case .general: return .land
        case .merchant: return .land
        case .musician: return .land
        case .prophet: return .land
        case .scientist: return .land
        case .writer: return .land
        }
    }

    func canFound() -> Bool {

        return self == .settler
    }

    func unitTasks() -> [UnitTaskType] {

        switch self {

        case .barbarianWarrior: return [.attack]
        case .barbarianArcher: return [.ranged]

            // ancient
        case .settler: return [.settle]
        case .builder: return [.work]
        case .trader: return [.trade]
        case .scout: return [.explore]
        case .warrior: return [.attack, .defense, .explore]
        case .slinger: return [.ranged]
        case .archer: return [.ranged]
        case .spearman: return [.attack, .defense]
        case .heavyChariot: return [.attack, .defense, .explore]
        case .galley: return [.exploreSea, .attackSea, .escortSea, .reserveSea]

            // industral
        case .medic: return [.unknown]

            // great people
        case .admiral: return []
        case .artist: return []
        case .engineer: return []
        case .general: return []
        case .merchant: return []
        case .musician: return []
        case .prophet: return []
        case .scientist: return []
        case .writer: return []
        }
    }

    func defaultTask() -> UnitTaskType {

        switch self {

        case .barbarianWarrior: return .attack
        case .barbarianArcher: return .ranged

            // ancient
        case .settler: return .settle
        case .builder: return .work
        case .trader: return .trade

        case .scout: return .explore
        case .warrior: return .attack // UNITAI_ATTACK
        case .slinger: return .ranged
        case .archer: return .ranged
        case .spearman: return .defense
        case .heavyChariot: return .attack
        case .galley: return .attackSea // UNITAI_ATTACK_SEA

            // industral
        case .medic: return .unknown

            // great people
        case .admiral: return .general
        case .artist: return .general
        case .engineer: return .general
        case .general: return .general
        case .merchant: return .general
        case .musician: return .general
        case .prophet: return .general
        case .scientist: return .general
        case .writer: return .general
        }
    }

    func movementType() -> UnitMovementType {

        switch self {
        case .barbarianWarrior: return .walk
        case .barbarianArcher: return .walk

            // ancient
        case .settler: return .walk
        case .builder: return .walk
        case .trader: return .walk

        case .scout: return .walk
        case .warrior: return .walk
        case .slinger: return .walk
        case .archer: return .walk
        case .spearman: return .walk
        case .heavyChariot: return .walk // FIXME

        case .galley: return .swimShallow

            // industral
        case .medic: return .walk

            // great people
        case .artist: return .walk
        case .admiral: return .walk
        case .engineer: return .walk
        case .general: return .walk
        case .merchant: return .walk
        case .musician: return .walk
        case .prophet: return .walk
        case .scientist: return .walk
        case .writer: return .walk
        }
    }

    /// cost in production
    public func productionCost() -> Int {

        switch self {

        case .barbarianWarrior: return 0
        case .barbarianArcher: return 0

            // ancient
        case .settler: return 80
        case .builder: return 50
        case .trader: return 40
        case .scout: return 30
        case .warrior: return 40
        case .slinger: return 35
        case .archer: return 60
        case .spearman: return 65
        case .heavyChariot: return 65
        case .galley: return 65

            // industral
        case .medic: return 370

            // great people
        case .artist: return -1
        case .admiral: return -1
        case .engineer: return -1
        case .general: return -1
        case .merchant: return -1
        case .musician: return -1
        case .prophet: return -1
        case .scientist: return -1
        case .writer: return -1
        }
    }

    /// cost in gold
    func purchaseCost() -> Int {

        switch self {

        case .barbarianWarrior: return -1
        case .barbarianArcher: return -1

            // ancient
        case .settler: return 320
        case .builder: return 200
        case .trader: return 160
        case .scout: return 120
        case .warrior: return 160
        case .slinger: return 140
        case .archer: return 240
        case .spearman: return 260
        case .heavyChariot: return 260
        case .galley: return 260

            // industral
        case .medic: return 1480

            // great people
        case .artist: return -1
        case .admiral: return -1
        case .engineer: return -1
        case .general: return -1
        case .merchant: return -1
        case .musician: return -1
        case .prophet: return -1
        case .scientist: return -1
        case .writer: return -1
        }
    }

    /// cost in faith
    func faithCost() -> Int {

        switch self {

        case .barbarianWarrior: return -1
        case .barbarianArcher: return -1

            // ancient
        case .settler: return -1
        case .builder: return -1
        case .trader: return -1
        case .scout: return -1
        case .warrior: return -1
        case .slinger: return -1
        case .archer: return -1
        case .spearman: return -1
        case .heavyChariot: return -1
        case .galley: return -1

            // industral
        case .medic: return -1

            // great people
        case .artist: return -1
        case .admiral: return -1
        case .engineer: return -1
        case .general: return -1
        case .merchant: return -1
        case .musician: return -1
        case .prophet: return -1
        case .scientist: return -1
        case .writer: return -1
        }
    }

    /// maintenance cost in gold
    func maintenanceCost() -> Int {

        switch self {

        case .barbarianWarrior: return 0
        case .barbarianArcher: return 0

            // ancient
        case .settler: return 0
        case .builder: return 0
        case .trader: return 0
        case .scout: return 0
        case .warrior: return 0
        case .slinger: return 0
        case .archer: return 1
        case .spearman: return 1
        case .heavyChariot: return 1
        case .galley: return 1

            // industral
        case .medic: return 5

            // great people
        case .admiral: return 0
        case .artist: return 0
        case .engineer: return 0
        case .merchant: return 0
        case .musician: return 0
        case .general: return 0
        case .prophet: return 0
        case .scientist: return 0
        case .writer: return 0
        }
    }

    public func requiredTech() -> TechType? {

        switch self {

        case .barbarianWarrior: return nil
        case .barbarianArcher: return .archery

            // ancient
        case .settler: return nil
        case .builder: return nil
        case .trader: return nil

        case .scout: return nil
        case .warrior: return nil
        case .slinger: return nil
        case .archer: return .archery
        case .spearman: return .bronzeWorking
        case .heavyChariot: return .wheel
        case .galley: return .sailing

            // industral
        case .medic: return .sanitation

            // great people
        case .admiral: return nil
        case .artist: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    public func obsoleteTech() -> TechType? {

        return nil
    }

    public func requiredCivic() -> CivicType? {

        switch self {

        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // ancient
        case .settler: return nil
        case .builder: return nil
        case .trader: return .foreignTrade

        case .scout: return nil
        case .warrior: return nil
        case .slinger: return nil
        case .archer: return nil
        case .spearman: return nil
        case .heavyChariot: return nil
        case .galley: return nil

            // industral
        case .medic: return nil

            // great people
        case .admiral: return nil
        case .artist: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    public func requiredResource() -> ResourceType? {

        return nil
    }

    // is unit type special to any civ? nil if not
    public func civilization() -> CivilizationType? {

        switch self {

        case .barbarianWarrior: return .barbarian
        case .barbarianArcher: return .barbarian

            // ancient
        case .settler: return nil
        case .builder: return nil
        case .trader: return nil

        case .scout: return nil
        case .warrior: return nil
        case .slinger: return nil
        case .archer: return nil
        case .spearman: return nil
        case .heavyChariot: return nil
        case .galley: return nil

            // industrial
        case .medic: return nil

            // great people
        case .admiral: return nil
        case .artist: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    public func unitType(for civilization: CivilizationType) -> UnitType? {

        switch self {

            // ----------------------------
            // barbarian
        case .barbarianWarrior:
            if civilization == .barbarian {
                return .barbarianWarrior
            }

            return nil

        case .barbarianArcher:
            if civilization == .barbarian {
                return .barbarianArcher
            }

            return nil

            // ----------------------------
            // ancient
        case .settler:
            if civilization == .barbarian {
                return nil
            }

            return .settler

        case .builder:
            if civilization == .barbarian {
                return nil
            }

            return .builder

        case .trader:
            if civilization == .barbarian {
                return nil
            }

            return .trader

        case .scout:
            if civilization == .barbarian {
                return nil
            }

            return .scout

        case .warrior:
            if civilization == .barbarian {
                return .barbarianWarrior
            }

            return .warrior

        case .slinger:
            if civilization == .barbarian {
                return nil
            }

            return .slinger

        case .archer:
            if civilization == .barbarian {
                return .barbarianArcher
            }

            return .archer

        case .spearman:
            if civilization == .barbarian {
                return nil
            }

            return .spearman

        case .heavyChariot:
            if civilization == .barbarian {
                return nil
            }

            return .heavyChariot

        case .galley:
            if civilization == .barbarian {
                return nil
            }

            return .galley

            // ----------------------------
            // industrial
        case .medic:
            if civilization == .barbarian {
                return nil
            }

            return .medic

            // ----------------------------
            // great people
        case .admiral:
            if civilization == .barbarian {
                return nil
            }

            return .admiral

        case .artist:
            if civilization == .barbarian {
                return nil
            }

            return .artist

        case .engineer:
            if civilization == .barbarian {
                return nil
            }

            return .engineer

        case .general:
            if civilization == .barbarian {
                return nil
            }

            return .general

        case .merchant:
            if civilization == .barbarian {
                return nil
            }

            return .merchant

        case .musician:
            if civilization == .barbarian {
                return nil
            }

            return .musician

        case .prophet:
            if civilization == .barbarian {
                return nil
            }

            return .prophet

        case .scientist:
            if civilization == .barbarian {
                return nil
            }

            return .scientist

        case .writer:
            if civilization == .barbarian {
                return nil
            }

            return .writer

        }
    }

    func abilities() -> [UnitAbilityType] {

        switch self {

        case .barbarianWarrior: return [.canCapture]
        case .barbarianArcher: return [.canCapture]

            // ancient
        case .settler: return [.canFound]
        case .builder: return [.canImprove]
        case .trader: return [.canEstablishTradeRoute, .canMoveInRivalTerritory]

        case .scout: return [.experienceFromTribal]
        case .warrior: return [.canCapture]
        case .slinger: return [.canCapture]
        case .archer: return [.canCapture]
        case .spearman: return [.canCapture]
        case .heavyChariot: return [.canCapture]
        case .galley: return [.oceanImpassable, .canCapture]

            // industrial
        case .medic: return [.canHeal]

            // great people
        case .admiral: return []
        case .artist: return []
        case .engineer: return []
        case .general: return []
        case .merchant: return []
        case .musician: return []
        case .prophet: return []
        case .scientist: return []
        case .writer: return []
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

    func canBuild(build: BuildType) -> Bool {

        switch build {

        case .none: return false

        case .repair: return self.has(ability: .canImprove)

        case .ancientRoad: return self.has(ability: .canBuildRoads)
        case .classicalRoad: return self.has(ability: .canBuildRoads)
        case .removeRoad: return self.has(ability: .canImprove)

        case .farm: return self.has(ability: .canImprove)
        case .mine: return self.has(ability: .canImprove)
        case .quarry: return self.has(ability: .canImprove)
        case .plantation: return self.has(ability: .canImprove)
        case .camp: return self.has(ability: .canImprove)
        case .pasture: return self.has(ability: .canImprove)
        case .fishingBoats: return self.has(ability: .canImprove)

        case .removeForest: return self.has(ability: .canImprove)
        case .removeRainforest: return self.has(ability: .canImprove)
        case .removeMarsh: return self.has(ability: .canImprove)
        }
    }

    func has(ability: UnitAbilityType) -> Bool {

        return self.abilities().contains(ability)
    }

    func workRate() -> Int {

        // in civ6 builders are building improvements immediately
        if self == .builder {
            return 1000 // used to be 100
        }

        return 0
    }

    public func buildCharges() -> Int {

        if self == .builder {
            return 3
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

    func healingAdjacentUnits() -> Int {

        if self.has(ability: .canHeal) {
            return 20
        }

        return 0
    }

    func canFoundReligion() -> Bool {

        if self == .prophet {
            return true
        }

        return false
    }

    func isGreatPerson() -> Bool {

        if self == .artist || self == .engineer || self == .merchant || self == .scientist || self == .admiral || self == .general || self == .prophet {

            return true
        }

        return false
    }

    func canMoveInRivalTerritory() -> Bool {

        return self.has(ability: .canMoveInRivalTerritory)
    }
}
