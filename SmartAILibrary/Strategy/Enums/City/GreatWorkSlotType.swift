//
//  GreatWorkSlotType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 25.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum GreatWorkType {

    case writing
    case music
    case artwork // => 4 types: religious, portrait, landscape, sculpture
    case artifact
    case relic

    func slotTypes() -> [GreatWorkSlotType] {

        switch self {

        case .writing:
            return [.any, .written]
        case .music:
            return [.any, .music]
        case .artwork:
            return [.any, .artwork]
        case .artifact:
             return [.any, .written]
        case .relic:
            return [.any, .relic]
        }
    }

    func yields() -> Yields {

        switch self {

        case .writing:
            return Yields(food: 0.0, production: 0.0, gold: 0.0, science: 0.0, culture: 4.0, faith: 0.0, housing: 0.0, appeal: 0.0)
        case .music:
            return Yields(food: 0.0, production: 0.0, gold: 0.0, science: 0.0, culture: 4.0, faith: 0.0, housing: 0.0, appeal: 0.0)
        case .artwork:
            return Yields(food: 0.0, production: 0.0, gold: 0.0, science: 0.0, culture: 4.0, faith: 0.0, housing: 0.0, appeal: 0.0)
        case .artifact:
            return Yields(food: 0.0, production: 0.0, gold: 0.0, science: 0.0, culture: 4.0, faith: 0.0, housing: 0.0, appeal: 0.0) // 3 tourism
        case .relic:
            return Yields(food: 0.0, production: 0.0, gold: 0.0, science: 0.0, culture: 0.0, faith: 4.0, housing: 0.0, appeal: 0.0) // 8 tourism
        }
    }
}

public enum GreatWorkSlotType: Int, Codable {

    case any // in the palace

    case written
    case music
    case artwork
    case artifact
    case relic
}
