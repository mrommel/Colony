//
//  FeatureType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum FeatureType {

    case none
    
    case forest
    case rainforest
    case floodplains
    case marsh
    case oasis
    case reef
    case ice
    
    case mountains
    
    // natural wonders
    case delicateArch
    case galapagos
    case greatBarrierReef
    case mountEverest
    case mountKilimanjaro
    case pantanal
    case yosemite
    case uluru
    // death valley
    

    static var all: [FeatureType] {
        return [
            .forest, .rainforest, .floodplains, .marsh, .oasis, .reef, .ice,
            
            .mountains
        ]
    }
    
    // MARK: internal classes
    
    private struct FeatureData {
        
        let name: String
        let yields: Yields
        let isWonder: Bool
    }
    
    // MARK: methods
    
    func name() -> String {
        
        return self.data().name
    }

    func yields() -> Yields {

        return self.data().yields
    }
    
    func isWonder() -> Bool {
        
        return self.data().isWonder
    }

    func isPossible(on tile: Tile) -> Bool {

        switch self {
            
        case .none: return false
            
        case .forest: return self.isForestPossible(on: tile)
        case .rainforest: return self.isRainforestPossible(on: tile)
        case .floodplains: return self.isFloodplainsPossible(on: tile)
        case .marsh: return false // FIXME
        case .oasis: return false
        case .reef: return false
        case .ice: return false
            
        case .mountains: return self.isMountainPossible(on: tile)
            
        // natural wonders
        case .delicateArch: return false
        case .galapagos: return false
        case .greatBarrierReef: return false
        case .mountEverest: return false
        case .mountKilimanjaro: return false
        case .pantanal: return false
        case .yosemite: return false
        case .uluru: return false
        }
    }

    func isRemovable() -> Bool {

        switch self {
        
        case .none: return false
            
        case .forest: return true
        case .rainforest: return true
        case .floodplains: return true
        case .mountains: return false
        case .marsh: return true
        case .oasis: return false
        case .reef: return false
        case .ice: return false
            
        // natural wonders
        case .delicateArch: return false
        case .galapagos: return false
        case .greatBarrierReef: return false
        case .mountEverest: return false
        case .mountKilimanjaro: return false
        case .pantanal: return false
        case .yosemite: return false
        case .uluru: return false
        }
    }
    
    func isRough() -> Bool {
        
        switch self {
            
        case .none: return false
            
        case .forest: return true
        case .rainforest: return true
        case .floodplains: return false
        case .mountains: return true
        case .marsh: return false
        case .oasis: return false
        case .reef: return false
        case .ice: return false
            
        // natural wonders
        case .delicateArch: return true
        case .galapagos: return true
        case .greatBarrierReef: return true
        case .mountEverest: return true
        case .mountKilimanjaro: return true
        case .pantanal: return true
        case .yosemite: return true
        case .uluru: return true
        }
    }
    
    func attackModifier() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .forest: return 0
        case .rainforest: return 0
        case .floodplains: return 0
        case .mountains: return 0
        case .marsh: return 0
        case .oasis: return 0
        case .reef: return 0
        case .ice: return 0
            
        // natural wonders
        case .delicateArch: return 0
        case .galapagos: return 0
        case .greatBarrierReef: return 0
        case .mountEverest: return 0
        case .mountKilimanjaro: return 0
        case .pantanal: return 0
        case .yosemite: return 0
        case .uluru: return 0
        }
    }
    
    func defenseModifier() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .forest: return 3
        case .rainforest: return 3
        case .floodplains: return -2
        case .mountains: return 0
        case .marsh: return -2
        case .oasis: return 0
        case .reef: return 0
        case .ice: return 0
            
        // natural wonders
        case .delicateArch: return 0
        case .galapagos: return 0
        case .greatBarrierReef: return 0
        case .mountEverest: return 0
        case .mountKilimanjaro: return 0
        case .pantanal: return -2
        case .yosemite: return 0
        case .uluru: return 0
        }
    }
    
    func movementCosts() -> Int {
        
        switch self {
        
        case .none: return 0
            
        case .forest: return 2
        case .rainforest: return 2
        case .floodplains: return 1
        case .mountains: return -1 // impassable
        case .marsh: return 2
        case .oasis: return 0
        case .reef: return 2
        case .ice: return -1
            
        // natural wonders
        case .delicateArch: return -1
        case .galapagos: return -1
        case .greatBarrierReef: return 1
        case .mountEverest: return -1
        case .mountKilimanjaro: return -1
        case .pantanal: return 2
        case .yosemite: return -1
        case .uluru: return -1
        }
    }
    
    // to adjacent tiles
    func appeal() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .forest: return 1
        case .rainforest: return -1
        case .floodplains: return -1
        case .mountains: return 1
        case .marsh: return -1
        case .oasis: return 1
        case .reef: return 2
        case .ice: return -1
            
        // natural wonders
        case .delicateArch: return 2
        case .galapagos: return 2
        case .greatBarrierReef: return 2
        case .mountEverest: return 2
        case .mountKilimanjaro: return 2
        case .pantanal: return 2
        case .yosemite: return 2
        case .uluru: return 4
        }
    }

    // MARK: private methods
    
    private func data() -> FeatureData {
        
        switch self {
        
        case .none: return FeatureData(name: "", yields: Yields(food: 0.0, production: 0.0, gold: 0.0), isWonder: false)
            
        case .forest: return FeatureData(name: "Forest", yields: Yields(food: 0, production: 1, gold: 0, science: 0), isWonder: false)
        case .rainforest: return FeatureData(name: "Rainforest", yields: Yields(food: 1, production: 0, gold: 0, science: 0), isWonder: false)
        case .floodplains: return FeatureData(name: "Floodplains", yields: Yields(food: 3, production: 0, gold: 0, science: 0), isWonder: false)
        case .marsh: return FeatureData(name: "Marsh", yields: Yields(food: 3, production: 0, gold: 0, science: 0), isWonder: false)
        case .oasis: return FeatureData(name: "Oasis", yields: Yields(food: 1, production: 0, gold: 0, science: 0), isWonder: false)
        case .reef: return FeatureData(name: "Reef", yields: Yields(food: 1, production: 0, gold: 0, science: 0), isWonder: false)
        case .ice: return FeatureData(name: "Marsh", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWonder: false)
            
        case .mountains: return FeatureData(name: "Mountains", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWonder: false)
            
        // natural wonders
        case .delicateArch: return FeatureData(name: "Delicate Arch", yields: Yields(food: 0, production: 0, gold: 1, science: 0, faith: 2), isWonder: true)
        case .galapagos: return FeatureData(name: "Galapagos", yields: Yields(food: 0, production: 0, gold: 0, science: 2), isWonder: true)
        case .greatBarrierReef: return FeatureData(name: "Great Barrier Reef", yields: Yields(food: 3, production: 0, gold: 0, science: 2), isWonder: true)
        case .mountEverest: return FeatureData(name: "Mount Kilimanjaro", yields: Yields(food: 2, production: 0, gold: 0, science: 0, faith: 1), isWonder: true)
        case .mountKilimanjaro: return FeatureData(name: "Mount Kilimanjaro", yields: Yields(food: 2, production: 0, gold: 0, science: 0), isWonder: true)
        case .pantanal: return FeatureData(name: "Pantanal", yields: Yields(food: 2, production: 0, gold: 0, science: 0, culture: 2), isWonder: true)
        case .yosemite: return FeatureData(name: "Yosemite", yields: Yields(food: 0, production: 0, gold: 1, science: 1), isWonder: true)
        case .uluru: return FeatureData(name: "Uluru", yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 2), isWonder: true)
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
            return Double(self.movementCosts())
        }
        
    }
}
