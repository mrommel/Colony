//
//  YieldType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum YieldType: Int, Codable {
    
    case none
    
    case food // YIELD_FOOD,
    case production // YIELD_PRODUCTION,
    case gold // YIELD_GOLD,
    case science // YIELD_SCIENCE
    
    static var all: [YieldType] {
        
        return [.food, .production, .gold, .science]
    }
}
