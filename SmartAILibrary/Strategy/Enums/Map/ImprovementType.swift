//
//  TileImprovementType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum TileImprovementType {

    case none
    
    case barbarianCamp
    case goodyHut

    case farm
    case mine
    case quarry
    case camp
    case pasture

    case plantation
    case fishingBoats
    /*case lumberMill*/
    
    case fort // Occupying unit receives +4 Civ6StrengthIcon Defense Strength, and automatically gains 2 turns of fortification.
    case citadelle

    static var all: [TileImprovementType] {
        return [.farm, .mine, .quarry, .camp, .pasture, .plantation, .fishingBoats, .fort, .citadelle]
    }

    // https://civilization.fandom.com/wiki/Tile_improvement_(Civ6)
    func yields() -> Yields {

        switch self {

        case .none: return Yields(food: 0, production: 0, gold: 0, science: 0)
            
        case .barbarianCamp: return Yields(food: 0, production: 0, gold: 0, science: 0)
        case .goodyHut: return Yields(food: 0, production: 0, gold: 0, science: 0)

        case .farm: return Yields(food: 1, production: 0, gold: 0, science: 0)
        case .mine: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .quarry: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .camp: return Yields(food: 0, production: 0, gold: 1, science: 0)
        case .pasture: return Yields(food: 0, production: 1, gold: 0, science: 0)
        case .plantation: return Yields(food: 0, production: 0, gold: 2, science: 0)
        case .fishingBoats: return Yields(food: 1, production: 0, gold: 0, science: 0)
        
        case .fort: return Yields(food: 0, production: 0, gold: 0)
        case .citadelle: return Yields(food: 0, production: 0, gold: 0)
        }
    }

    func costPerTurn() -> Int {

        switch self {

        case .none: return 0
            
        case .barbarianCamp: return 0
        case .goodyHut: return 0

        case .farm: return 1
        case .mine: return 1
        case .quarry: return 1
        case .camp: return 1
        case .pasture: return 1
        case .plantation: return 1
        case .fishingBoats: return 1
            
        case .fort: return 1
        case .citadelle: return 1
        }
    }

    func isPossible(on tile: Tile) -> Bool {

        // can't set an improvement to unowned tile or can we?
        guard tile.owner() != nil else {
            return false
        }

        switch self {

        case .none: return false // invalid everywhere
            
        case .barbarianCamp: return self.isBarbarianCampPossible(on: tile)
        case .goodyHut: return false

        case .farm: return self.isFarmPossible(on: tile)
        case .mine: return self.isMinePossible(on: tile)
        case .quarry: return false // FIXME
        case .camp: return false // FIXME
        case .pasture: return false // FIXME
        case .plantation: return false // FIXME
        case .fishingBoats: return false // FIXME
            
        case .fort: return true // FIXME
        case .citadelle: return false // FIXME
        }
    }
    
    func defenseModifier() -> Int {
        
        switch self {
            
        case .none, .barbarianCamp, .goodyHut, .farm, .mine, .quarry, .camp, .pasture, .plantation, .fishingBoats:
            return 0
        case .fort:
            return 4
        case .citadelle:
            return 6
        }
        
        // return 0
    }
    
    func canBePillaged() -> Bool {
        
        switch self {
            
        case .none: return false
        case .barbarianCamp: return false
        case .goodyHut: return false
            
        case .farm: return true
        case .mine: return true
        case .quarry: return true
        case .camp: return true
        case .pasture: return true
        case .plantation: return true
        case .fishingBoats: return true
        case .fort: return true
        case .citadelle: return true
        }
    }
    
    func nearbyEnemyDamage() -> Int {
        
        if self == .fort {
            return 2
        }
        
        if self == .citadelle {
            return 3
        }
        
        return 0
    }
    
    // MARK: private methods
    
    private func isBarbarianCampPossible(on tile: Tile) -> Bool {
        
        return tile.terrain().isLand()
    }
    
    // Farms can be built on non-desert and non-tundra flat lands, which are the most available tiles in Civilization VI.
    private func isFarmPossible(on tile: Tile) -> Bool {
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if (tile.terrain() == .grass || tile.terrain() == .plains) && !tile.hasHills() {
            return true
        }
        
        if (tile.terrain() == .grass || tile.terrain() == .plains || tile.terrain() == .desert) && !tile.hasHills() && tile.has(feature: .floodplains) && owner.has(civic: .civilEngineering) {
            
            return true
        }
        
        return false
    }
    
    private func isMinePossible(on tile: Tile) -> Bool {
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if !tile.terrain().isLand() {
            return false
        }
        
        if !tile.hasHills() {
            return false
        }
        
        if !owner.has(tech: .mining) {
            return false
        }
        
        return true
    }

    func required() -> TechType? {

        switch self {

        case .none, .barbarianCamp, .goodyHut: return nil

        case .farm: return nil
        case .mine: return .mining
        case .quarry: return .mining
        case .camp: return .animalHusbandry
        case .pasture: return .animalHusbandry
        case .plantation: return .irrigation
        case .fishingBoats: return .sailing
     
        case .fort: return .siegeTactics
        case .citadelle: return .siegeTactics
        }
    }
    
    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavors().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }
    
    func flavors() -> [Flavor] {

        switch self {

        case .none: return []
            
        case .barbarianCamp: return []
        case .goodyHut: return []
        case .farm: return []
        case .mine: return []
        case .quarry: return []
        case .camp: return []
        case .pasture: return []
        case .plantation: return []
        case .fishingBoats: return []
        case .fort: return []
        case .citadelle: return []
        }
    }
}
