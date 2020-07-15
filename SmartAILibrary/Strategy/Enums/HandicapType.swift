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

    func barbCampGold() -> Int {

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
    
    func barbSpawnMod() -> Int {

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
            return 10000 // never
        case .chieftain:
            return 60
        case .warlord:
            return 20
        case .prince:
            return 0
        case .king:
            return 0
        case .emperor:
            return 0
        case .immortal:
            return 0
        case .deity:
            return 0
        }
    }
}
    
extension HandicapType: Comparable {

    public static func < (lhs: HandicapType, rhs: HandicapType) -> Bool {
        
        return lhs.rawValue < rhs.rawValue
    }
}
