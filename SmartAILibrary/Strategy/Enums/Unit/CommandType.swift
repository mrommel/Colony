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
    case buildCamp
    case buildPasture
    case buildQuarry
    // case buildRoute // which?
    case pillage
    case fortify
    case hold
    case garrison
    case disband
    case establishTradeRoute
    
    // combat
    case attack
    case rangedAttack
    case cancelAttack
    
    public static var all: [CommandType] {
        
        return [.found, .buildFarm, .buildMine, .buildCamp, .buildPasture, .buildQuarry, .pillage, .fortify, .hold, .garrison, .disband, .establishTradeRoute, .attack, .rangedAttack]
    }
    
    public func title() -> String {
        
        switch self {

        case .found: return "Found City"
        case .buildFarm: return "Build Farm"
        case .buildMine: return "Build Mine"
        case .buildCamp: return "Camp"
        case .buildPasture: return "Pasture"
        case .buildQuarry: return "Quarry"
        //case .buildRoute: return "Build Route"
        case .pillage: return "Pillage Improvement"
        case .fortify: return "Fortify"
        case .hold: return "Hold"
        case .garrison: return "Garrison"
        case .disband: return "Disband"
        case .establishTradeRoute: return "Establish TradeRoute"
            
        case .attack: return "Attack"
        case .rangedAttack: return "Ranged"
        case .cancelAttack: return "Cancel"
            
        }
    }
}
