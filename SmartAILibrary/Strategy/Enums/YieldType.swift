//
//  YieldType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum YieldType: String, Codable {
    
    case none = "none"
    
    case food = "food" // YIELD_FOOD,
    case production = "production" // YIELD_PRODUCTION,
    case gold = "gold" // YIELD_GOLD,
    case science = "science" // YIELD_SCIENCE
    
    case culture = "culture"
    case faith = "faith"
    
    static var all: [YieldType] {
        
        return [.food, .production, .gold, .science, .culture, .faith]
    }
}
