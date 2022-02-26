//
//  GrandStrategyAIType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum GrandStrategyAIType: Int, Codable {

    case none // default
    case conquest
    case culture
    case council // aka united nations

    static var all: [GrandStrategyAIType] {
        return [.conquest, .culture, .council]
    }

    func flavor(for flavorType: FlavorType) -> Int {

        return self.flavorBase() + self.flavorModifier(for: flavorType)
    }

    func flavorModifier(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavorModifier().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }

    // MARK: private methods

    private func flavorBase() -> Int {

        switch self {

        case .none:
            return 0
        case .conquest:
            return 11
        case .culture:
            return 11
        case .council:
            return 10
        }
    }

    private func flavorModifier() -> [Flavor] {

        switch self {

        case .none:
            return []
        case .conquest:
            return [Flavor(type: .militaryTraining, value: 2),
                    Flavor(type: .growth, value: -1),
                    Flavor(type: .amenities, value: 1)]
        case .culture:
            return [Flavor(type: .defense, value: 1),
                    Flavor(type: .cityDefense, value: 1),
                    Flavor(type: .offense, value: -1)]
        case .council:
            return [Flavor(type: .defense, value: 1),
                    Flavor(type: .offense, value: -1),
                    Flavor(type: .recon, value: 1)]
        }
    }

    func yields() -> Yields {

        switch self {

        case .none: return Yields(food: 0.0, production: 0.0, gold: 0.0)
        case .conquest: return Yields(food: 0.0, production: 200.0, gold: 0.0)
        case .culture: return Yields(food: 0.0, production: 0.0, gold: 50.0, science: 50.0)
        case .council: return Yields(food: 0.0, production: 0.0, gold: 100.0)
            /*
             
             <Row>
                 <AIGrandStrategyType>AIGRANDSTRATEGY_SPACESHIP</AIGrandStrategyType>
                 <YieldType>YIELD_SCIENCE</YieldType>
                 <Yield>100</Yield>
             </Row>
             <Row>
                 <AIGrandStrategyType>AIGRANDSTRATEGY_SPACESHIP</AIGrandStrategyType>
                 <YieldType>YIELD_PRODUCTION</YieldType>
                 <Yield>100</Yield>
             </Row>
             */
        }
    }

}
