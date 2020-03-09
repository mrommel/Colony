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
}
