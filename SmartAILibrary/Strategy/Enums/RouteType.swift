//
//  RouteType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum RouteType: Int, Codable {
    
    case none
    
    case road
    
    func required() -> TechType? {

        switch self {
            
        case .none: return nil
        case .road: return nil
        }
    }
    
    func yields() -> Yields {

        switch self {
        case .none: return Yields(food: 0.0, production: 0.0, gold: 0.0)
        case .road: return Yields(food: 0.0, production: 0.0, gold: 0.5)
        }
    }
}
