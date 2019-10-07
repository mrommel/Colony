//
//  UnitType.swift
//  Colony
//
//  Created by Michael Rommel on 13.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum UnitType: String, Codable {
    
    // neutral
    case trader
    //case caravan
    
    // hostile
    case pirates
    
    // civilian
    case settler
    case builder
    
    // naval
    case galley
    case trireme
    case galleass
    case caravel
    case frigate
    case ironclad
    case destroyer
    
    case axeman
    case archer
    
    static var unitTypes: [UnitType] {
        return [.caravel, .axeman, .archer]
    }
    
    var title: String {
        
        switch self {
        case .caravel:
            return "Caravel"
        case .axeman:
            return "Axeman"
        case .archer:
            return "Archer"
            
        default:
            return "Unknown"
        }
    }
    
    var movementType: MovementType {
        
        switch self {
        case .caravel:
            return .swimOcean
        case .axeman:
            return .walk
        case .archer:
            return .walk
            
        default:
            return .immobile
        }
    }
    
    var textureName: String {
        
        switch self {
        case .caravel:
            return "unit_caravel"
        case .axeman:
            return "unit_axeman"
        case .archer:
            return "unit_archer"
            
        default:
            return "unit_unknown"
        }
    }
    
    var indicatorTextureName: String {
        
        switch self {
        case .caravel:
            return "unit_indicator_caravel"
        case .axeman:
            return "unit_indicator_axeman"
        case .archer:
            return "unit_indicator_archer"
            
        default:
            return "unit_indicator_unknown"
        }
    }
    
    var isNaval: Bool {
        
        switch self {
            
        case .trader:
            return true
        case .pirates:
            return true
            
        // civilian units
            
        case .settler:
            return false
        case .builder:
            return false
            
        // sea units
            
        case .caravel:
            return true
        case .galley:
            return true
        case .trireme:
            return true
        case .galleass:
            return true
        case .frigate:
            return true
        case .ironclad:
            return true
        case .destroyer:
            return true
            
        // land units
            
        case .axeman:
            return false
        case .archer:
            return false
            
        }
    }
    
    var properties: UnitProperties? {
        
        switch self {
            
        // sea units
            
        case .caravel:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 1, supportDistance: 2, strength: 10, targetType: .hard, softAttack: 2, hardAttack: 1, airAttack: 0, navalAttack: 2, groundDefense: 2, closeDefense: 2, airDefense: 1)
            
            unitProperties.isSwimming = true
            
            return unitProperties
        
        // land units
            
        case .axeman:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 0, supportDistance: 1, strength: 10, targetType: .soft, softAttack: 3, hardAttack: 0, airAttack: 0, navalAttack: 0, groundDefense: 1, closeDefense: 2, airDefense: 0)
            
            unitProperties.isSwimming = false
            unitProperties.isInfantery = true
            
            return unitProperties
            
        default:
            return nil
        }
    }
}
