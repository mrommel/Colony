//
//  YieldType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum YieldType: String, Codable {

    case none

    case food // YIELD_FOOD,
    case production // YIELD_PRODUCTION,
    case gold // YIELD_GOLD,
    case science // YIELD_SCIENCE
    case culture
    case faith
    case tourism

    public static var all: [YieldType] {

        return [.food, .production, .gold, .science, .culture, .faith, .tourism]
    }

    public func focusType() -> CityFocusType {

        switch self {

        case .none: return .none

        case .food: return .food
        case .production: return .production
        case .gold: return .gold
        case .science: return .science
        case .culture: return .culture
        case .faith: return .faith
        case .tourism: return .none
        }
    }
}
