//
//  ResourceType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum ResourceUsageType {

    case bonus
    case strategic
    case luxury
}

enum ResourceType {

    case none

    // bonus
    case wheat
    case rice
    case deer
    case sheep
    case copper
    case stone // https://civilization.fandom.com/wiki/Stone_(Civ6)
    case bananas
    case cattle
    case fish
    
    // luxury
    case marble // https://civilization.fandom.com/wiki/Marble_(Civ6)
    case diamonds
    case furs // https://civilization.fandom.com/wiki/Furs_(Civ6)
    case citrus

    // strategic
    //case coal
    case horses
    case iron
    
    // Special
    // Antiquity Site
    // Shipwreck

    static var all: [ResourceType] {
        return [
            .wheat, .rice, .horses, .deer, .sheep, .iron, .diamonds, .copper, .stone, .marble, .bananas, .citrus, .furs, .cattle, .fish
        ]
    }

    // MARK: methods

    func usage() -> ResourceUsageType {

        switch self {

        case .none:
            return .bonus

        case .wheat, .rice, .sheep, .deer, .copper, .stone, .bananas, .cattle, .fish:
            return .bonus

        case .diamonds, .marble, .furs, .citrus:
            return .luxury

        case .iron, .horses /*, .coal*/:
            return .strategic
        }
    }

    func yields() -> Yields {

        switch self {

        case .none: return Yields(food: 0, production: 0, gold: 0, science: 0)

            // bonus
        case .wheat: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .rice: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .deer: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .sheep: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .copper: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .stone: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .bananas: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .cattle: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .fish: return Yields(food: 1, production: 0, gold: 0, science: 0)

            // strategic
            //case .coal: return Yields(food: 0, production: 2, gold: 0, science: 0)
        case .iron: return Yields(food: 0, production: 0, gold: 0, science: 1)
        case .horses: return Yields(food: 1, production: 1, gold: 0, science: 0)
            
            // luxury
        case .diamonds: return Yields(food: 0, production: 0, gold: 3, science: 0)
        case .citrus: return Yields(food: 2, production: 0, gold: 0, science: 0)
        case .furs: return Yields(food: 1, production: 0, gold: 1, science: 0)
        case .marble: return Yields(food: 0, production: 0, gold: 0, science: 0, culture: 1)
        }
    }
    
    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavors().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }
    
    func flavors() -> [Flavor] {

        switch self {

        case .none: return []
            
        case .wheat:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .rice:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .deer:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .sheep:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .copper:
            return [
                Flavor(type: .gold, value: 10)
            ]
        case .stone:
            return [
                Flavor(type: .production, value: 10)
            ]
        case .bananas:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .cattle:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .fish:
            return [
                Flavor(type: .navalTileImprovement, value: 10)
            ]
            
            // strategic
        case .iron:
            return [
                Flavor(type: .offense, value: 10)
            ]
        case .horses:
            return [
                Flavor(type: .mobile, value: 10)
            ]
            
            // luxury
        case .diamonds:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .marble:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .furs:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        case .citrus:
            return [
                Flavor(type: .happiness, value: 10)
            ]
        }
    }
    
    func happiness() -> Int {
        
        switch self {
            
        case .none: return 0
        case .wheat: return 0
        case .rice: return 0
        case .deer: return 0
        case .sheep: return 0
        case .copper: return 0
        case .stone: return 0
        case .bananas: return 0
        case .cattle: return 0
        case .fish: return 0
            
            // strategic
        case .iron: return 0
        case .horses: return 0
            
            // luxury
        case .diamonds: return 5
        case .marble: return 5
        case .furs: return 5
        case .citrus: return 5
        }
    }
    
    func techCityTrade() -> TechType? {
        
        switch self {
            
        case .none: return nil
        case .wheat: return nil
        case .rice: return nil
        
        case .deer: return nil
        case .sheep: return .animalHusbandry
        case .copper: return .mining
        case .stone: return .mining
        case .bananas: return .irrigation
        case .cattle: return .animalHusbandry
        case .fish: return .celestialNavigation
            
            // strategic
        case .iron: return .ironWorking
        case .horses: return .animalHusbandry
            
            // luxury
        case .diamonds: return .mining
        case .marble: return .mining
        case .furs: return .animalHusbandry
        case .citrus: return .irrigation
        
        }
    }
    
    func quantity() -> [Int] {
        
        switch self {
            
        case .none: return []
            
            // bonus
        case .wheat: return []
        case .rice: return []
        case .deer: return []
        case .sheep: return []
        case .copper: return []
        case .stone: return []
        case .bananas: return []
        case .cattle: return []
        case .fish: return []
            
            // strategic
        case .horses: return [2, 4]
        case .iron: return [2, 6]
            
            // luxury
        case .diamonds: return []
        case .marble: return []
        case .furs: return []
        case .citrus: return []
        
        }
    }
    
    func revealTech() -> TechType? {
        
        switch self {
        case .none: return nil
            
            // bonus
        case .wheat: return .pottery
        case .rice: return .pottery
        case .deer: return .animalHusbandry
        case .sheep: return .animalHusbandry
        case .copper: return .mining
        case .stone: return .mining
        case .bananas: return .irrigation
        case .cattle: return .animalHusbandry
        case .fish: return .celestialNavigation
            
            // strategic
        case .iron: return .bronzeWorking
        case .horses: return .animalHusbandry

            // luxury
        case .diamonds: return .mining
        case .marble: return .mining
        case .furs: return .animalHusbandry
        case .citrus: return .irrigation
        }
    }
}
