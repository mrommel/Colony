//
//  TerrainType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Terrain_(Civ6)
public enum TerrainType: Int, Codable {
    
    case grass
    case plains
    case desert
    case tundra
    case snow
    
    case shore
    case ocean
    
    public static let all: [TerrainType] = [.grass, .plains, .desert, .tundra, .snow, .shore, .ocean]
    
    // MARK: public methods
    
    public func name() -> String {

        return self.data().name
    }
    
    public func yields() -> Yields {

        return self.data().yields
    }
    
    public func isLand() -> Bool {
        
        return !self.data().isWater
    }
    
    public func isWater() -> Bool {
        
        return self.data().isWater
    }
    
    // MARK: internal classes
    
    private struct TerrainData {
        
        let name: String
        let yields: Yields
        let isWater: Bool
    }
    
    // MARK: private methods
    
    private func data() -> TerrainData {
        
        switch self {

        case .ocean: return TerrainData(name: "Ocean", yields: Yields(food: 1, production: 0, gold: 0, science: 0), isWater: true)
        case .shore: return TerrainData(name: "Shore", yields: Yields(food: 1, production: 0, gold: 1, science: 0), isWater: true)
            
        case .plains: return TerrainData(name: "Plains", yields: Yields(food: 1, production: 1, gold: 0, science: 0), isWater: false)
        case .grass: return TerrainData(name: "Grassland", yields: Yields(food: 2, production: 0, gold: 0, science: 0), isWater: false)
        case .desert: return TerrainData(name: "Desert", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWater: false)
        case .tundra: return TerrainData(name: "Tundra", yields: Yields(food: 1, production: 0, gold: 0, science: 0), isWater: false)
        case .snow: return TerrainData(name: "Snow", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWater: false)
        }
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
            
        case .swimShallow:

            if self == .shore {
                return 1.0
            }
            
            return UnitMovementType.max
            
        case .walk:
            if self == .plains {
                return 1.0
            }
            
            if self == .grass {
                return 1.0
            }
            
            if self == .desert {
                return 1.0
            }
            
            if self == .tundra {
                return 1.0
            }
            
            if self == .snow {
                return 1.0
            }
            
            return UnitMovementType.max
        }
    }
}
