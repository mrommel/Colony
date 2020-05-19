//
//  BuildingType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum BuildingType: Int, Codable {

    case none
    
    // ancient
    case palace
    case granary
    case monument
    case library // https://civilization.fandom.com/wiki/Library_(Civ6)
    case shrine
    case ancientWalls
    case barracks
    case waterMill // https://civilization.fandom.com/wiki/Water_Mill_(Civ6)
    
    // classical
    case amphitheater // https://civilization.fandom.com/wiki/Amphitheater_(Civ6)
    case lighthouse // https://civilization.fandom.com/wiki/Lighthouse_(Civ6)
    case stable // https://civilization.fandom.com/wiki/Stable_(Civ6)
    case arena // https://civilization.fandom.com/wiki/Arena_(Civ6)
    case market // https://civilization.fandom.com/wiki/Market_(Civ6)
    case temple // https://civilization.fandom.com/wiki/Temple_(Civ6)
    
    // harbor

    public static var all: [BuildingType] {
        return [
            // ancient
            /*.palace, otherwise this is show */
            .granary, .monument, .library, .shrine, .ancientWalls, .barracks, .waterMill,
            
            // classical
            .amphitheater, .lighthouse, .stable, .arena, .market, .temple
        ]
    }

    // MARK: methods
    
    public func name() -> String {
        
        switch self {
            
        case .none: return ""

            // ancient
        case .palace: return "Palace"
        case .granary: return "Granary"
        case .monument: return "Monument"
        case .library: return "Library"
        case .shrine: return "Shrine"
        case .ancientWalls: return "Ancient Walls"
        case .barracks: return "Barracks"
        case .waterMill: return "Water Mill"
            
            // classical
        case .amphitheater: return "Amphitheater"
        case .lighthouse: return "Lighthouse"
        case .stable: return "Stable"
        case .arena: return "Arena"
        case .market: return "Market"
        case .temple: return "Temple"
        }
    }

    func defense() -> Int {
        
        switch self {

        case .none: return 0
            
            // ancient
        case .palace: return 3 // Palace Guard
        case .granary: return 0
        case .monument: return 0
        case .library: return 0
        case .shrine: return 0
        case .ancientWalls: return 3
        case .barracks: return 0
        case .waterMill: return 0
            
            // classical
        case .amphitheater: return 0
        case .lighthouse: return 0
        case .stable: return 0
        case .arena: return 0
        case .market: return 0
        case .temple: return 0
        }
    }
    
    func defenseModifier() -> Int {
        
        switch self {

        case .none: return 0
            
            // ancient
        case .palace: return 0
        case .granary: return 0
        case .monument: return 0
        case .library: return 0
        case .shrine: return 0
        case .ancientWalls: return 0
        case .barracks: return 0
        case .waterMill: return 0
            
            // classical
        case .amphitheater: return 0
        case .lighthouse: return 0
        case .stable: return 0
        case .arena: return 0
        case .market: return 0
        case .temple: return 0
        }
    }
    
    // in production units
    public func productionCost() -> Int {

        switch self {

        case .none: return 0
            
            // ancient
        case .palace: return 0
        case .granary: return 65
        case .monument: return 60
        case .library: return 90
        case .shrine: return 70
        case .ancientWalls: return 80
        case .barracks: return 90
        case .waterMill: return 80
            
            // classical
        case .amphitheater: return 150
        case .lighthouse: return 120
        case .stable: return 120
        case .arena: return 150
        case .market: return 120
        case .temple: return 120
        }
    }

    // in gold
    func maintenanceCost() -> Int {

        switch self {

        case .none: return 0
            
            // ancient
        case .palace: return 0
        case .granary: return 0
        case .monument: return 0
        case .library: return 1
        case .shrine: return 1
        case .ancientWalls: return 0
        case .barracks: return 1
        case .waterMill: return 0
            
            // classical
        case .amphitheater: return 1
        case .lighthouse: return 0
        case .stable: return 1
        case .arena: return 1
        case .market: return 0
        case .temple: return 2
        }
    }

    func yields() -> Yields {

        switch self {

        case .none: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0)
        
            // ancient
        case .palace: return Yields(food: 0, production: 2, gold: 5, science: 2, culture: 1, faith: 0, housing: 1)
        case .granary: return Yields(food: 1, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 2)
        case .monument: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 0, housing: 0)
        case .library: return Yields(food: 0, production: 0, gold: 0, science: 2, culture: 0, faith: 0, housing: 0)
        case .shrine: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 2, housing: 0)
        case .ancientWalls: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0, housing: 0)
        case .barracks: return Yields(food: 0, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 1)
        case .waterMill: return Yields(food: 1, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 0)
            
            // classical
        case .amphitheater: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 0, housing: 0)
        case .lighthouse: return Yields(food: 1, production: 0, gold: 1, science: 0, culture: 0, faith: 0, housing: 1)
        case .stable:
            return Yields(food: 0, production: 1, gold: 0, science: 0, culture: 0, faith: 0, housing: 1)
        case .arena:
            return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 1, faith: 0, housing: 0)
        case .market:
            return Yields(food: 0, production: 0, gold: 3, science: 0, culture: 0, faith: 0, housing: 0)
        case .temple:
            return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 4, housing: 0)
        }
    }
    
    public func amenities() -> Int {
        
        if self == .arena {
            return 1
        }
        
        return 0
    }

    public func requiredTech() -> TechType? {

        switch self {

        case .none: return nil
            
            // ancient
        case .palace: return nil
        case .granary: return .pottery
        case .monument: return nil
        case .library: return .writing
        case .shrine: return .astrology
        case .ancientWalls: return .masonry
        case .barracks: return .bronzeWorking
        case .waterMill: return .wheel
            
            // classical
        case .amphitheater: return nil
        case .lighthouse: return .celestialNavigation
        case .stable: return .horsebackRiding
        case .arena: return nil
        case .market: return .currency
        case .temple: return nil
        }
    }
    
    public func requiredCivic() -> CivicType? {

        switch self {

        case .none: return nil
            
            // ancient
        case .palace: return nil
        case .granary: return nil
        case .monument: return nil
        case .library: return nil
        case .shrine: return nil
        case .ancientWalls: return nil
        case .barracks: return nil
        case .waterMill: return nil
            
            // classical
        case .amphitheater: return .dramaAndPoetry
        case .lighthouse: return nil
        case .stable: return nil
        case .arena: return .gamesAndRecreation
        case .market: return nil
        case .temple: return .theology
        }
    }

    public func district() -> DistrictType {

        switch self {

        case .none: return .cityCenter
            
            // ancient
        case .palace: return .cityCenter
        case .granary: return .cityCenter
        case .monument: return .cityCenter
        case .library: return .campus
        case .shrine: return .holySite
        case .ancientWalls: return .cityCenter
        case .barracks: return .encampment
        case .waterMill: return .cityCenter
            
            // classical
        case .amphitheater: return .entertainment
        case .lighthouse: return .harbor
        case .stable: return .encampment
        case .arena: return .entertainment
        case .market: return .commercialHub
        case .temple: return .holySite
        }
    }
    
    func flavor(for flavorType: FlavorType) -> Int {
        
        if let flavor = self.flavours().first(where: { $0.type == flavorType }) {
            return flavor.value
        }
        
        return 0
    }

    func flavours() -> [Flavor] {

        switch self {

        case .none: return []
            
            // ancient
        case .palace: return [] // no need can't be build
            
        case .granary:
            return [Flavor(type: .growth, value: 10), Flavor(type: .greatPeople, value: 3), Flavor(type: .science, value: 4), Flavor(type: .tileImprovement, value: 3), Flavor(type: .gold, value: 2), Flavor(type: .production, value: 3), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1)]
            
            // Note: The Monument has so many flavors because culture leads to policies, which help with a number of things
        case .monument:
            return [Flavor(type: .culture, value: 7), Flavor(type: .tourism, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .wonder, value: 1), Flavor(type: .gold, value: 1), Flavor(type: .greatPeople, value: 1), Flavor(type: .production, value: 1), Flavor(type: .happiness, value: 1), Flavor(type: .science, value: 1), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .cityDefense, value: 1), Flavor(type: .naval, value: 1), Flavor(type: .navalTileImprovement, value: 1), Flavor(type: .religion, value: 1)]
        
        case .library:
            return [Flavor(type: .science, value: 8), Flavor(type: .greatPeople, value: 5), Flavor(type: .offense, value: 3), Flavor(type: .defense, value: 3)/*, Flavor(type: .spaceShip, value: 2)*/]
            
            // Note: The Shrine has a number of flavors because religion improves a variety of game aspects
        case .shrine:
            return [Flavor(type: .religion, value: 9), Flavor(type: .culture, value: 4), Flavor(type: .gold, value: 3), Flavor(type: .happiness, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .tourism, value: 2), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .growth, value: 1)]
        
        case .ancientWalls:
            return [Flavor(type: .militaryTraining, value: 7), Flavor(type: .offense, value: 5), Flavor(type: .defense, value: 5), Flavor(type: .production, value: 2), Flavor(type: .naval, value: 2), Flavor(type: .tileImprovement, value: 2)]
        
        case .barracks:
            return [Flavor(type: .cityDefense, value: 8), Flavor(type: .greatPeople, value: 5), Flavor(type: .defense, value: 4), Flavor(type: .wonder, value: 1), Flavor(type: .production, value: 1)]
            
        case .waterMill:
            return [Flavor(type: .growth, value: 7), Flavor(type: .science, value: 4), Flavor(type: .tileImprovement, value: 3), Flavor(type: .production, value: 3), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1)]
            
            // classical
        case .amphitheater:
            return [Flavor(type: .growth, value: 4), Flavor(type: .culture, value: 8), Flavor(type: .wonder, value: 1)]
            
        case .lighthouse:
            return [Flavor(type: .growth, value: 7), Flavor(type: .science, value: 4), Flavor(type: .navalTileImprovement, value: 8), Flavor(type: .gold, value: 3), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1)]
            
        case .stable:
            return [Flavor(type: .cityDefense, value: 6), Flavor(type: .greatPeople, value: 5), Flavor(type: .offense, value: 8), Flavor(type: .defense, value: 4), Flavor(type: .wonder, value: 1), Flavor(type: .production, value: 1)]
            
        case .arena:
            return [Flavor(type: .culture, value: 7), Flavor(type: .tourism, value: 3), Flavor(type: .expansion, value: 2), Flavor(type: .growth, value: 2), Flavor(type: .wonder, value: 1), Flavor(type: .gold, value: 1), Flavor(type: .greatPeople, value: 1), Flavor(type: .production, value: 1), Flavor(type: .happiness, value: 1), Flavor(type: .science, value: 1), Flavor(type: .diplomacy, value: 1), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .cityDefense, value: 1), Flavor(type: .naval, value: 1), Flavor(type: .navalTileImprovement, value: 1), Flavor(type: .religion, value: 1)]
            
        case .market:
            return [Flavor(type: .cityDefense, value: 2), Flavor(type: .greatPeople, value: 5), Flavor(type: .gold, value: 8), Flavor(type: .offense, value: 1), Flavor(type: .defense, value: 1), Flavor(type: .wonder, value: 1), Flavor(type: .production, value: 1)]
            
        case .temple:
            return [Flavor(type: .greatPeople, value: 5), Flavor(type: .religion, value: 10)]
        }
    }
    
    func specialistCount() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .palace: return 0
        case .granary: return 0
        case .monument: return 0
        case .library: return 1
        case .shrine: return 1
        case .ancientWalls: return 0
        case .barracks: return 1
        case .waterMill: return 0
            
            // classical
        case .amphitheater: return 1
        case .lighthouse: return 1
        case .stable: return 1
        case .arena: return 0
        case .market: return 1
        case .temple: return 1
        }
    }
    
    func canAddSpecialist() -> Bool {
        
        return self.specialistCount() > 0
    }
    
    // check CIV5Buildings.xml
    func specialistType() -> SpecialistType {
        
        switch self {
            
        case .none: return .none
            
        case .palace: return .none
        case .granary: return .none
        case .monument: return .none
        case .library: return .scientist
        case .shrine: return .priest
        case .ancientWalls: return .none
        case .barracks: return .commander
        case .waterMill: return .none
            
            // classical
        case .amphitheater: return .artist
        case .lighthouse: return .captain
        case .stable: return .commander
        case .arena: return .none
        case .market: return .merchant
        case .temple: return .priest
        }
    }
}
