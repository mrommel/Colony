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
    case archer
    
    // can't be moved
    case city
    case field
    case castle
    
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
    
    var title: String {
        
        switch self {
        case .ship:
            return "Ship"
        case .axeman:
            return "Axeman"
        case .archer:
            return "Archer"
        case .pirates:
            return "Pirates"
        case .tradeShip:
            return "TradeShip"
            
        default:
            return "Unknown"
        }
    }
    
    var textureName: String {
        
        switch self {
        case .ship:
            return "unit_indicator_ship"
        case .axeman:
            return "unit_indicator_axeman"
        case .archer:
            return "unit_indicator_archer"
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
            
        // sea units
            
        case .ship:
            return true
        case .pirates:
            return true
        case .tradeShip:
            return true
        case .monster:
            return true
            
        // land units
            
        case .axeman:
            return false
        case .archer:
            return false
        
        // misc units
            
        case .city:
            return false
        case .field:
            return false
        case .castle:
            return false
            
        case .coin:
            return false
        case .booster:
            return false
        case .obstacle:
            return false
        
        case .animal:
            return false
        }
    }
    
    var properties: UnitProperties? {
        
        switch self {
            
        // sea units
            
        case .ship:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 1, strength: 10, targetType: .hard, softAttack: 2, hardAttack: 1, airAttack: 0, navalAttack: 2, groundDefense: 2, closeDefense: 2, airDefense: 1)
            
            unitProperties.isSwimming = true
            
            return unitProperties
            
        case .monster:
            var unitProperties = UnitProperties(initiative: 2, sight: 2, range: 0, strength: 10, targetType: .soft, softAttack: 1, hardAttack: 1, airAttack: 0, navalAttack: 1, groundDefense: 2, closeDefense: 1, airDefense: 0)
            
            unitProperties.isSwimming = true
            
            return unitProperties
            
        case .pirates:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 1, strength: 10, targetType: .hard, softAttack: 2, hardAttack: 1, airAttack: 0, navalAttack: 2, groundDefense: 2, closeDefense: 3, airDefense: 1)
            
            unitProperties.isSwimming = true
            
            return unitProperties
            
        case .tradeShip:
            var unitProperties = UnitProperties(initiative: 1, sight: 2, range: 1, strength: 10, targetType: .hard, softAttack: 1, hardAttack: 1, airAttack: 0, navalAttack: 2, groundDefense: 2, closeDefense: 2, airDefense: 1)
            
            unitProperties.isSwimming = true
            
            return unitProperties
        
        // land units
            
        case .axeman:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 0, strength: 10, targetType: .soft, softAttack: 3, hardAttack: 0, airAttack: 0, navalAttack: 0, groundDefense: 1, closeDefense: 2, airDefense: 0)
            
            unitProperties.isSwimming = true
            unitProperties.isInfantery = true
            
            return unitProperties
            
        default:
            return nil
        }
    }
}
