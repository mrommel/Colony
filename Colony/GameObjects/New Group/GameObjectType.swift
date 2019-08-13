//
//  GameObjectType.swift
//  Colony
//
//  Created by Michael Rommel on 13.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum GameObjectType: String, Codable {
    
    // real units
    case ship
    case axeman
    
    // can't be moved
    case city
    
    // collectives
    case coin
    case booster
    
    // tile cannot be accessed, can't be moved
    case obstacle
    
    // simple reactive AI
    case monster
    case pirates
    case tradeShip
    
    // just wonder around
    case animal
    
    var textureName: String {
        
        switch self {
        case .ship:
            return "unit_indicator_ship"
        case .axeman:
            return "unit_indicator_axeman"
        case .pirates:
            return "unit_indicator_pirates"
        case .tradeShip:
            return "unit_indicator_tradeShip"
            
        default:
            return "unit_indicator_unknown"
        }
    }
    
    var isNaval: Bool {
        
        switch self {
        case .ship:
            return true
        case .axeman:
            return false
        case .monster:
            return false
        case .city:
            return false
        case .coin:
            return false
        case .booster:
            return false
        case .obstacle:
            return false
        case .pirates:
            return true
        case .tradeShip:
            return true
        case .animal:
            return false
        }
    }
}
