//
//  BuildingType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum BuildingType {

    // ancient
    case palace
    case granary
    case monument
    case library
    case shrine
    case ancientWalls
    case barracks

    static var all: [BuildingType] {
        return [
            // ancient
                .palace, .granary, .monument, .library, .shrine, .ancientWalls, .barracks
        ]
    }

    // MARK: methods
    
    func name() -> String {
        
        switch self {

            // ancient
        case .palace: return "Palace"
        case .granary: return "Granary"
        case .monument: return "Monument"
        case .library: return "Library"
        case .shrine: return "Shrine"
        case .ancientWalls: return "Ancient Walls"
        case .barracks: return "Baracks"
        }
    }

    func defense() -> Int {
        
        switch self {

            // ancient
        case .palace: return 3 // Palace Guard
        case .granary: return 0
        case .monument: return 0
        case .library: return 0
        case .shrine: return 0
        case .ancientWalls: return 3
        case .barracks: return 0
        }
    }
    
    func defenseModifier() -> Int {
        
        switch self {

            // ancient
        case .palace: return 0
        case .granary: return 0
        case .monument: return 0
        case .library: return 0
        case .shrine: return 0
        case .ancientWalls: return 0
        case .barracks: return 0
        }
    }
    
    // in production units
    func productionCost() -> Int {

        switch self {

            // ancient
        case .palace: return 0
        case .granary: return 65
        case .monument: return 60
        case .library: return 90
        case .shrine: return 70
        case .ancientWalls: return 80
        case .barracks: return 90
        }
    }

    // in gold
    func maintenanceCosts() -> Int {

        switch self {

            // ancient
        case .palace: return 0
        case .granary: return 0
        case .monument: return 0
        case .library: return 1
        case .shrine: return 1
        case .ancientWalls: return 0
        case .barracks: return 1
        }
    }

    func yields() -> Yields {

        switch self {

            // ancient
        case .palace: return Yields(food: 0, production: 2, gold: 5, science: 2, culture: 1, faith: 0, housing: 1)
        case .granary: return Yields(food: 1, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 2)
        case .monument: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 0, housing: 0)
        case .library: return Yields(food: 0, production: 0, gold: 0, science: 2, culture: 0, faith: 0, housing: 0)
        case .shrine: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 2, housing: 0)
        case .ancientWalls: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0)
        case .barracks: return Yields(food: 0, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 1)
        }
    }

    func required() -> TechType? {

        switch self {

            // ancient
        case .palace: return nil
        case .granary: return .pottery
        case .monument: return nil
        case .library: return .writing
        case .shrine: return .astrology
        case .ancientWalls: return .masonry
        case .barracks: return .bronzeWorking
        }
    }

    func district() -> DistrictType {

        switch self {

            // ancient
        case .palace: return .cityCenter
        case .granary: return .cityCenter
        case .monument: return .cityCenter
        case .library: return .campus
        case .shrine: return .holySite
        case .ancientWalls: return .cityCenter
        case .barracks: return .encampment
        }
    }

    func flavours() -> [Flavor] {

        switch self {

            // ancient
        case .palace: return [] // no need can't be build
            
        case .granary: return [Flavor(type: .growth, value: 10), Flavor(type: .greatPeople, value: 3), Flavor(type: .science, value: 4), Flavor(type: .tileImprovement, value: 3), Flavor(type: .gold, value: 2), Flavor(type: .production, value: 3), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1)]
            
            // Note: The Monument has so many flavors because culture leads to policies, which help with a number of things
        case .monument: return [Flavor(type: .culture, value: 7), Flavor(type: .tourism, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .wonder, value: 1), Flavor(type: .gold, value: 1), Flavor(type: .greatPeople, value: 1), Flavor(type: .production, value: 1), Flavor(type: .happiness, value: 1), Flavor(type: .science, value: 1), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .cityDefense, value: 1), Flavor(type: .naval, value: 1), Flavor(type: .navalTileImprovement, value: 1), Flavor(type: .religion, value: 1)]
        
        case .library: return [Flavor(type: .science, value: 8), Flavor(type: .greatPeople, value: 5), Flavor(type: .offense, value: 3), Flavor(type: .defense, value: 3)/*, Flavor(type: .spaceShip, value: 2)*/]
            
            // Note: The Shrine has a number of flavors because religion improves a variety of game aspects
        case .shrine: return [Flavor(type: .religion, value: 9), Flavor(type: .culture, value: 4), Flavor(type: .gold, value: 3), Flavor(type: .happiness, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .tourism, value: 2), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .growth, value: 1)]
        
        case .ancientWalls: return [Flavor(type: .militaryTraining, value: 7), Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 5), Flavor(type: .production, value: 2), Flavor(type: .naval, value: 2), Flavor(type: .tileImprovement, value: 2)]
        
        case .barracks: return [Flavor(type: .cityDefense, value: 8), Flavor(type: .greatPeople, value: 5), Flavor(type: .defense, value: 4), Flavor(type: .wonder, value: 1), Flavor(type: .production, value: 1)]
        }
    }
}
