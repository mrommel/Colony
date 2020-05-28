//
//  CommandType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CommandType {
    
    case found
    case buildFarm
    case buildMine
    // case buildRoute // which?
    case pillage
    case fortify
    case hold
    case garrison
    
    public static var all: [CommandType] {
        
        return [.found, .buildFarm, .buildMine, .pillage, .fortify, .hold, .garrison]
    }
    
    public func title() -> String {
        
        switch self {

        case .found: return "Found City"
        case .buildFarm: return "Build Farm"
        case .buildMine: return "Build Mine"
        //case .buildRoute: return "Build Route"
        case .pillage: return "Pillage Improvement"
        case .fortify: return "Fortify"
        case .hold: return "Hold"
        case .garrison: return "Garrison"
        }
    }
}
