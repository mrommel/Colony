//
//  TerrainType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Terrain_(Civ6)
enum TerrainType: Int, Codable {
    
    case grass
    case plains
    case desert
    case tundra
    case snow
    
    case shore
    case ocean
    
    func yields() -> Yields {
        
        switch self {
            
        case .grass:
            return Yields(food: 2, production: 0, gold: 0, science: 0)
        case .plains:
            return Yields(food: 1, production: 1, gold: 0, science: 0)
        case .desert:
            return Yields(food: 0, production: 0, gold: 0, science: 0)
        case .tundra:
            return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .snow:
            return Yields(food: 0, production: 0, gold: 0, science: 0)
            
        case .shore:
            return Yields(food: 1, production: 0, gold: 1, science: 0)
        case .ocean:
            return Yields(food: 1, production: 0, gold: 0, science: 0)
        }
    }
    
    func isLand() -> Bool {
        
        switch self {
        case .grass, .plains, .desert, .tundra, .snow:
            return true
        case .shore, .ocean:
            return false
        }
    }
    
    func isWater() -> Bool {
        
        switch self {
        case .grass, .plains, .desert, .tundra, .snow:
            return false
        case .shore, .ocean:
            return true
        }
    }
    
    func attackModifier() -> Int {
        
        return 0
    }
    
    func defenseModifier() -> Int {
        
        return 0
    }
    
    func movementCost(for movementType: UnitMovementType) -> Double {
        
        switch movementType {
            
        case .immobile:
            return UnitMovementType.max
            
        case .swim:
            if self == .ocean {
                return 1.5
            }
            
            if self == .shore {
                return 1.0
            }
            
            return UnitMovementType.max
            
        case .walk:
            if self == .plains {
                return 1.0
            }
            
            if self == .grass {
                return 1.1
            }
            
            if self == .desert {
                return 1.2
            }
            
            if self == .tundra {
                return 1.1
            }
            
            if self == .snow {
                return 1.5
            }
            
            return UnitMovementType.max
        }
    }
}
