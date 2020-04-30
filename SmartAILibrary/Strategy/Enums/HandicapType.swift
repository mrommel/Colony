//
//  HandicapType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civ6.gamepedia.com/Game_difficulty   
public enum HandicapType {

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

    func validGoodies() -> [GoodyType] {

        switch self {

        case .settler: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit, .worker, .settler]
        case .chieftain: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit]
        case .warlord: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit]
        case .prince: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit]
        case .king: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit]
        case .emperor: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit]
        case .immortal: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit]
        case .deity: return [.population, .culture, .gold, .map, .tech, .revealNearbyBarbarians, .upgradeUnit]
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
}
