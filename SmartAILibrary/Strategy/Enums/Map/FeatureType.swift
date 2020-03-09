//
//  FeatureType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum FeatureType {

    case forest
    case rainforest
    case floodplains
    
    case mountains
    
    /*case river
    
    case reef
    case ice*/

    static var all: [FeatureType] {
        return [
            .forest, .rainforest, .floodplains,
            
            .mountains
        ]
    }
    
    // MARK: internal classes
    
    private struct FeatureData {
        
        let name: String
        let yields: Yields
    }
    
    // MARK: methods
    
    func name() -> String {
        
        return self.data().name
    }

    func yields() -> Yields {

        return self.data().yields
    }

    func isPossible(on tile: Tile) -> Bool {

        switch self {
        case .forest: return self.isForestPossible(on: tile)
        case .rainforest: return self.isRainforestPossible(on: tile)
        case .floodplains: return self.isFloodplainsPossible(on: tile)
            
        case .mountains: return self.isMountainPossible(on: tile)
        }
    }

    func isRemovable() -> Bool {

        switch self {
        case .forest: return true
        case .rainforest: return true
        case .floodplains: return true
        case .mountains: return false
        }
    }
    
    func isRough() -> Bool {
        
        switch self {
        case .forest: return true
        case .rainforest: return true
        case .floodplains: return false
        case .mountains: return true
        }
    }
    
    func attackModifier() -> Int {
        
        switch self {
        case .forest: return 0
        case .rainforest: return 0
        case .floodplains: return 0
        case .mountains: return 0
        }
    }
    
    func defenseModifier() -> Int {
        
        switch self {
        case .forest: return 3
        case .rainforest: return 3
        case .floodplains: return -2
        case .mountains: return 0
        }
    }
    
    func movementCosts() -> Int {
        
        switch self {
        case .forest: return 2
        case .rainforest: return 2
        case .floodplains: return 1
        case .mountains: return -1 // impassable
        }
    }
    
    // to adjacent tiles
    func appeal() -> Int {
        
        switch self {
        case .forest: return 1
        case .rainforest: return -1
        case .floodplains: return -1
        case .mountains: return 1
        }
    }

    // MARK: private methods
    
    private func data() -> FeatureData {
        
        switch self {
        case .forest: return FeatureData(name: "Forest",
                                         yields: Yields(food: 0, production: 1, gold: 0, science: 0))
        case .rainforest: return FeatureData(name: "Rainforest",
                                             yields: Yields(food: 1, production: 0, gold: 0, science: 0))
        case .floodplains: return FeatureData(name: "Floodplains",
                                              yields: Yields(food: 3, production: 0, gold: 0, science: 0))
            
        case .mountains: return FeatureData(name: "Mountains",
                                            yields: Yields(food: 0, production: 0, gold: 0, science: 0))
        }
    }

    //  Grassland, Grassland (Hills), Plains, Plains (Hills), Tundra and Tundra (Hills).
    private func isForestPossible(on tile: Tile) -> Bool {

        if tile.terrain() == .tundra || tile.terrain() == .grass || tile.terrain() == .plains {
            return true
        }

        return false
    }

    // Modifies Plains and Plains (Hills).
    private func isRainforestPossible(on tile: Tile) -> Bool {

        if tile.terrain() == .plains {
            return true
        }

        return false
    }

    // Modifies Deserts (in GS-Only also Plains and Grassland).
    private func isFloodplainsPossible(on tile: Tile) -> Bool {

        if tile.hasHills() {
            return false
        }

        if tile.terrain() == .desert || tile.terrain() == .grass || tile.terrain() == .plains {
            return true
        }

        return false
    }
    
    private func isMountainPossible(on tile: Tile) -> Bool {

        if tile.hasHills() {
            return false
        }

        if tile.terrain() == .desert || tile.terrain() == .grass || tile.terrain() == .plains || tile.terrain() == .tundra || tile.terrain() == .snow {
            return true
        }

        return false
    }
    
    func movementCost(for movementType: UnitMovementType) -> Double {
        
        switch movementType {
            
        case .immobile:
            return UnitMovementType.max
            
        case .swim:
            return UnitMovementType.max
        
        case .walk:
            
            if self == .forest {
                return 0.7
            }
            
            if self == .rainforest {
                return 1.5
            }
            
            return UnitMovementType.max
        }
        
    }
}
