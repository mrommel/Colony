//
//  RouteType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum RouteType: Int, Codable {

    case none

    case ancientRoad
    case classicalRoad
    case industrialRoad
    case modernRoad

    func era() -> EraType? {

        switch self {

        case .none: return nil

        case .ancientRoad: return .ancient
        case .classicalRoad: return .classical
        case .industrialRoad: return .industrial
        case .modernRoad: return .modern
        }
    }

    // https://civilization.fandom.com/wiki/Roads_(Civ6)
    func movementCost() -> Double {

        switch self {

        case .none:
            return 200

        case .ancientRoad:
            // Starting road, well-packed dirt. Most terrain costs 1 MP; crossing rivers still costs 3 MP.
            return 1.0

        case .classicalRoad:
            // Adds bridges over rivers; crossing costs reduced to only 1 MP.
            return 1.0

        case .industrialRoad:
            // Paved roads are developed; 0.75 MP per tile.
            return 0.75

        case .modernRoad:
            // Asphalted roads are developed; 0.50 MP per tile.
            return 0.5
        }
    }
}
