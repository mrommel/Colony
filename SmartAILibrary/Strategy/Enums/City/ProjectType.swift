//
//  ProjectType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum ProjectType: Int, Codable {

    // ancient
    case stonehenge
    case templeOfArtemis
    case hangingGardens
    case pyramids
    case oracle
    case greatBath

    // classical
    case colosseum
    case colossus
    case greatLighthouse
    case greatLibrary

    static var all: [ProjectType] {
        return [
            // ancient
            .stonehenge, .templeOfArtemis, hangingGardens, .pyramids, .oracle, .greatBath,

            // classical
            .colosseum, .colossus, .greatLighthouse, .greatLibrary
        ]
    }

    func flavours() -> [Flavor] {

        switch self {

            // ancient
        case .stonehenge: return []
        case .templeOfArtemis: return [Flavor(type: .growth, value: 10)]
        case .hangingGardens: return []
        case .pyramids: return []
        case .oracle: return []
        case .greatBath: return []

            // classical
        case .colosseum: return []
        case .colossus: return []
        case .greatLighthouse: return []
        case .greatLibrary: return []

        }
    }

    func required() -> TechType? {

        switch self {

            // ancient
        case .stonehenge: return nil
        case .templeOfArtemis: return nil
        case .hangingGardens: return nil
        case .pyramids: return nil
        case .oracle: return nil
        case .greatBath: return nil

            // classical
        case .colosseum: return nil
        case .colossus: return nil
        case .greatLighthouse: return nil
        case .greatLibrary: return nil

        }
    }

    // in production units
    func productionCost() -> Int {

        switch self {

            // ancient
        case .stonehenge: return 0
        case .templeOfArtemis: return 0
        case .hangingGardens: return 0
        case .pyramids: return 0
        case .oracle: return 0
        case .greatBath: return 0

            // classical
        case .colosseum: return 0
        case .colossus: return 0
        case .greatLighthouse: return 0
        case .greatLibrary: return 0

        }
    }
}
