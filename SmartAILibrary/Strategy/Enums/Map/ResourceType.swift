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

    case horse
    case deer
    case sheep

    // strategic
    //case coal
    case iron
    case diamonds

    static var all: [ResourceType] {
        return [
                .wheat, .rice, .horse, .deer, .sheep, .iron, .diamonds
        ]
    }

    // MARK: methods

    func usage() -> ResourceUsageType {

        switch self {

        case .none:
            return .bonus

        case .wheat, .rice, .horse, .sheep, .deer:
            return .bonus

        case .diamonds:
            return .luxury

        case .iron/*, .coal*/:
            return .strategic
        }
    }

    func revearedBy() -> TechType? {

        switch self {

        case .none: return nil

        case .wheat: return .pottery
        case .rice: return .pottery
        case .horse: return .animalHusbandry
        case .deer: return .animalHusbandry
        case .sheep: return .animalHusbandry

        case .diamonds: return .mining

        case .iron: return .mining
            //case .coal: return .industrialization
        }
    }

    func yields() -> Yields {

        switch self {

        case .none: return Yields(food: 0, production: 0, gold: 0, science: 0)

        case .wheat: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .rice: return Yields(food: 1, production: 0, gold: 0, science: 0)

        case .horse: return Yields(food: 1, production: 1, gold: 0, science: 0)
        case .deer: return Yields(food: 0, production: 0, gold: 0, science: 0)
        case .sheep: return Yields(food: 0, production: 0, gold: 0, science: 0)

            //case .coal: return Yields(food: 0, production: 2, gold: 0, science: 0)
        case .iron: return Yields(food: 0, production: 0, gold: 0, science: 1)
        case .diamonds: return Yields(food: 0, production: 0, gold: 0, science: 0)
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
        case .horse:
            return [
                Flavor(type: .mobile, value: 10)
            ]
        case .deer:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .sheep:
            return [
                Flavor(type: .growth, value: 10)
            ]
        case .iron:
            return [
                Flavor(type: .offense, value: 10)
            ]
        case .diamonds:
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
        case .horse: return 0
        case .deer: return 0
        case .sheep: return 0
        case .iron: return 0
            
            // luxury
        case .diamonds: return 5
        }
    }
    
    func techCityTrade() -> TechType? {
        
        switch self {
            
        case .none: return nil
        case .wheat: return nil
        case .rice: return nil
        case .horse: return .animalHusbandry
        case .deer: return nil
        case .sheep: return .animalHusbandry
        case .iron: return .ironWorking
            
            // luxury
        case .diamonds: return .mining
        }
    }
    
    func quantity() -> [Int] {
        
        switch self {
            
        case .none: return []
            
            //
        case .wheat: return []
        case .rice: return []
        case .deer: return []
        case .sheep: return []
            
            // strategic
        case .horse: return [2, 4]
        case .iron: return [2, 6]
            
            // luxury
        case .diamonds: return []
        }
    }
}
