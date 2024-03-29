//
//  HandicapType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civ6.gamepedia.com/Game_difficulty
public enum HandicapType: Int, Codable {

    case settler
    case chieftain
    case warlord
    case prince
    case king
    case emperor
    case immortal
    case deity

    public static var all: [HandicapType] = [
        .settler, .chieftain, .warlord, .prince, .king, .emperor, .immortal, .deity
    ]

    public func name() -> String {

        switch self {

        case .settler: return "TXT_KEY_HANDICAP_SETTLER"
        case .chieftain: return "TXT_KEY_HANDICAP_CHIEFTAIN"
        case .warlord: return "TXT_KEY_HANDICAP_WARLORD"
        case .prince: return "TXT_KEY_HANDICAP_PRINCE"
        case .king: return "TXT_KEY_HANDICAP_KING"
        case .emperor: return "TXT_KEY_HANDICAP_EMPEROR"
        case .immortal: return "TXT_KEY_HANDICAP_IMMORTAL"
        case .deity: return "TXT_KEY_HANDICAP_DEITY"
        }
    }

    func barbarianCampGold() -> Int {

        switch self {

        case .settler: return 50
        case .chieftain: return 40
        case .warlord: return 30
        case .prince: return 25
        case .king: return 25
        case .emperor: return 25
        case .immortal: return 25
        case .deity: return 25
        }
    }

    func barbarianSpawnMod() -> Int {

        switch self {

        case .settler: return 8
        case .chieftain: return 5
        case .warlord: return 3
        case .prince: return 0
        case .king: return 0
        case .emperor: return 0
        case .immortal: return 0
        case .deity: return 0
        }
    }

    public func freeHumanTechs() -> [TechType] {

        switch self {

        case .settler:
            return [.pottery, .animalHusbandry, .mining]
        case .chieftain:
            return [.pottery, .animalHusbandry]
        case .warlord:
            return [.pottery]
        case .prince:
            return []
        case .king:
            return []
        case .emperor:
            return []
        case .immortal:
            return []
        case .deity:
            return []
        }
    }

    public func freeHumanCivics() -> [CivicType] {

        switch self {

        case .settler:
            return [.codeOfLaws]
        case .chieftain:
            return [.codeOfLaws]
        case .warlord:
            return [.codeOfLaws]
        case .prince:
            return [.codeOfLaws]
        case .king:
            return [.codeOfLaws]
        case .emperor:
            return [.codeOfLaws]
        case .immortal:
            return [.codeOfLaws]
        case .deity:
            return [.codeOfLaws]
        }
    }

    public func freeAITechs() -> [TechType] {

        switch self {

        case .settler:
            return []
        case .chieftain:
            return []
        case .warlord:
            return []
        case .prince:
            return []
        case .king:
            return [.pottery]
        case .emperor:
            return [.pottery, .animalHusbandry]
        case .immortal:
            return [.pottery, .animalHusbandry]
        case .deity:
            return [.pottery, .animalHusbandry, .mining, .wheel]
        }
    }

    public func freeAICivics() -> [CivicType] {

        switch self {

        case .settler:
            return [.codeOfLaws]
        case .chieftain:
            return [.codeOfLaws]
        case .warlord:
            return [.codeOfLaws]
        case .prince:
            return [.codeOfLaws]
        case .king:
            return [.codeOfLaws]
        case .emperor:
            return [.codeOfLaws]
        case .immortal:
            return [.codeOfLaws]
        case .deity:
            return [.codeOfLaws]
        }
    }

    public func freeHumanStartingUnitTypes() -> [UnitType] {

        switch self {

        case .settler:
            return [.settler, .warrior, .warrior, .builder]
        case .chieftain:
            return [.settler, .warrior, .builder]
        case .warlord:
            return [.settler, .warrior, .builder]
        case .prince:
            return [.settler, .warrior]
        case .king:
            return [.settler, .warrior]
        case .emperor:
            return [.settler, .settler]
        case .immortal:
            return [.settler, .settler]
        case .deity:
            return [.settler, .settler]
        }
    }

    public func freeAIStartingUnitTypes() -> [UnitType] {

        switch self {

        case .settler:
            return [.settler, .warrior]
        case .chieftain:
            return [.settler, .warrior]
        case .warlord:
            return [.settler, .warrior]
        case .prince:
            return [.settler, .warrior]
        case .king:
            return [.settler, .warrior, .warrior, .builder]
        case .emperor:
            return [.settler, .settler, .warrior, .warrior, .warrior, .builder]
        case .immortal:
            return [.settler, .settler, .warrior, .warrior, .warrior, .warrior, .builder, .builder]
        case .deity:
            return [.settler, .settler, .settler, .warrior, .warrior, .warrior, .warrior, .warrior, .builder, .builder]
        }
    }

    func earliestBarbarianReleaseTurn() -> Int {

        switch self {

        case .settler:
            return 50
        case .chieftain:
            return 40
        case .warlord:
            return 35
        case .prince:
            return 35
        case .king:
            return 30
        case .emperor:
            return 20
        case .immortal:
            return 10
        case .deity:
            return 0
        }
    }

    func barbarbianSeaTargetRange() -> Int {

        switch self {

        case .settler:
            return 4
        case .chieftain:
            return 6
        case .warlord:
            return 8
        case .prince:
            return 10
        case .king:
            return 12
        case .emperor:
            return 15
        case .immortal:
            return 18
        case .deity:
            return 20
        }
    }

    func barbarbianLandTargetRange() -> Int {

        switch self {

        case .settler:
            return 2
        case .chieftain:
            return 3
        case .warlord:
            return 4
        case .prince:
            return 5
        case .king:
            return 5
        case .emperor:
            return 6
        case .immortal:
            return 7
        case .deity:
            return 8
        }
    }

    func freeAICombatBonus() -> Int {

        switch self {

        case .settler: return -1
        case .chieftain: return -1
        case .warlord: return -1
        case .prince: return 0
        case .king: return 1
        case .emperor: return 2
        case .immortal: return 3
        case .deity: return 4
        }
    }

    func freeHumanCombatBonus() -> Int {

        switch self {

        case .settler: return 3
        case .chieftain: return 2
        case .warlord: return 1
        case .prince: return 0
        case .king: return 0
        case .emperor: return 0
        case .immortal: return 0
        case .deity: return 0
        }
    }

    func happinessDefault() -> Int {

        switch self {

        case .settler: return 15
        case .chieftain: return 12
        case .warlord: return 12
        case .prince: return 9
        case .king: return 9
        case .emperor: return 9
        case .immortal: return 9
        case .deity: return 9
        }
    }

    func extraHappinessPerLuxury() -> Int {

        switch self {

        case .settler: return 1
        case .chieftain: return 1
        case .warlord: return 0
        case .prince: return 0
        case .king: return 0
        case .emperor: return 0
        case .immortal: return 0
        case .deity: return 0
        }
    }

    // -3 - +3
    /* Deity -2 to -8
     Immortal -1 to -7
     Emperor 0 a -6
     King1 to -5
     Prince 2 to -4
     https://forums.civfanatics.com/threads/first-impression-of-you.613161/ */
    func firstImpressionBaseValue() -> Int {

        switch self {

        case .settler: return 2
        case .chieftain: return 1
        case .warlord: return 0
        case .prince: return -1
        case .king: return -2
        case .emperor: return -3
        case .immortal: return -4
        case .deity: return -5
        }
    }
}

extension HandicapType: Comparable {

    public static func < (lhs: HandicapType, rhs: HandicapType) -> Bool {

        return lhs.rawValue < rhs.rawValue
    }
}
