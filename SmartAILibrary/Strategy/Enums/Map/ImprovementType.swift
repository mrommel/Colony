//
//  ImprovementType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum ImprovementType: Int, Codable {

    case none
    
    case barbarianCamp
    case goodyHut
    case ruins

    case farm
    case mine
    case quarry
    case camp
    case pasture

    case plantation
    case fishingBoats
    /*case lumberMill*/
    case oilWell
    
    case fort // Occupying unit receives +4 Civ6StrengthIcon Defense Strength, and automatically gains 2 turns of fortification.
    case citadelle

    static var all: [ImprovementType] {
        return [.farm, .mine, .quarry, .camp, .pasture, .plantation, .fishingBoats, .oilWell, .fort, .citadelle]
    }

    // https://civilization.fandom.com/wiki/Tile_improvement_(Civ6)
    func yields(for player: AbstractPlayer?) -> Yields {

        guard let techs = player?.techs else {
            fatalError("cant get techs")
        }
        
        guard let civics = player?.civics else {
            fatalError("cant get civics")
        }
        
        switch self {

        case .none: return Yields(food: 0, production: 0, gold: 0, science: 0)
            
        case .barbarianCamp: return Yields(food: 0, production: 0, gold: 0, science: 0)
        case .goodyHut: return Yields(food: 0, production: 0, gold: 0, science: 0)
        case .ruins: return Yields(food: 0, production: 0, gold: 0, science: 0)

        case .farm:
            // https://civilization.fandom.com/wiki/Farm_(Civ6)
            let yield = Yields(food: 1, production: 0, gold: 0, science: 0, housing: 0.5)
            
            if civics.has(civic: .feudalism) {
                yield.food += 1
            }
            
            /*if techs.has(tech: .replaceableParts) {
                yield.food += 1
            }*/
            
            return yield
        case .mine:
            // https://civilization.fandom.com/wiki/Mine_(Civ6)
            let yield =  Yields(food: 0, production: 1, gold: 0, science: 0, appeal: -1.0)
            
            if techs.has(tech: .apprenticesship) {
                yield.production += 1
            }
            
            /*if techs.has(tech: .industrialization) {
                yield.production += 1
            }*/
            
            return yield
        case .quarry:
            let yield = Yields(food: 0, production: 1, gold: 0, science: 0, appeal: -1.0)
            
            if techs.has(tech: .banking) {
                yield.gold += 2
            }
            
            return yield
        case .camp: return Yields(food: 0, production: 0, gold: 1, science: 0)
        case .pasture:
            let yield = Yields(food: 0, production: 1, gold: 0, science: 0, housing: 0.5)
            
            if civics.has(civic: .exploration) {
                yield.food += 1
            }
            
            return yield
        case .plantation:
            // https://civilization.fandom.com/wiki/Plantation_(Civ6)
            let yield = Yields(food: 0, production: 0, gold: 2, science: 0, housing: 0.5)
            
            if civics.has(civic: .feudalism) {
                yield.food += 1
            }
            
            /*if techs.has(tech: .scientificTheory) {
                yield.food += 1
            }*/
            
            /*if civics.has(civic: .globalization) {
                yield.gold += 2
            }*/
            
            // 'goddess of festivals' pantheon
            
            return yield
        case .fishingBoats:
            // https://civilization.fandom.com/wiki/Fishing_Boats_(Civ6)
            let yield = Yields(food: 1, production: 0, gold: 0, science: 0, housing: 0.5)
            
            if techs.has(tech: .cartography) {
                yield.gold += 2
            }
            
            if civics.has(civic: .colonialism) {
                yield.production += 1
            }
            
            /*if techs.has(tech: .plastics) {
                yield.food += 1
            }*/
            
            // 'god of the sea' pantheon
            
            return yield
        case .oilWell:
            return Yields(food: 0, production: 2, gold: 0, appeal: -1)
        
        case .fort: return Yields(food: 0, production: 0, gold: 0)
        case .citadelle: return Yields(food: 0, production: 0, gold: 0)
        }
    }

    func costPerTurn() -> Int {

        switch self {

        case .none: return 0
            
        case .barbarianCamp: return 0
        case .goodyHut: return 0
        case .ruins: return 0

        case .farm: return 1
        case .mine: return 1
        case .quarry: return 1
        case .camp: return 1
        case .pasture: return 1
        case .plantation: return 1
        case .fishingBoats: return 1
        case .oilWell: return 1
            
        case .fort: return 1
        case .citadelle: return 1
        }
    }

    func isPossible(on tile: AbstractTile?) -> Bool {

        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        // can't set an improvement to unowned tile or can we?
        guard tile.owner() != nil else {
            return false
        }

        switch self {

        case .none: return false // invalid everywhere
            
        case .barbarianCamp: return self.isBarbarianCampPossible(on: tile)
        case .goodyHut: return false
        case .ruins: return false

        case .farm: return self.isFarmPossible(on: tile)
        case .mine: return self.isMinePossible(on: tile)
        case .quarry: return self.isQuarryPossible(on: tile)
        case .camp: return self.isCampPossible(on: tile)
        case .pasture: return self.isPasturePossible(on: tile)
        case .plantation: return self.isPlantationPossible(on: tile)
        case .fishingBoats: return self.isFishingBoatsPossible(on: tile)
        case .oilWell: return self.isOilWellPossible(on: tile)
            
        case .fort: return true // FIXME
        case .citadelle: return false // FIXME
        }
    }
    
    func defenseModifier() -> Int {
        
        switch self {
            
        case .none, .barbarianCamp, .goodyHut, .ruins, .farm, .mine, .quarry, .camp, .pasture, .plantation, .fishingBoats, .oilWell:
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
        case .ruins: return false
            
        case .farm: return true
        case .mine: return true
        case .quarry: return true
        case .camp: return true
        case .pasture: return true
        case .plantation: return true
        case .fishingBoats: return true
        case .oilWell: return true
            
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
    
    private func isBarbarianCampPossible(on tile: AbstractTile?) -> Bool {
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        return tile.terrain().isLand()
    }
    
    // Farms can be built on non-desert and non-tundra flat lands, which are the most available tiles in Civilization VI.
    private func isFarmPossible(on tile: AbstractTile?) -> Bool {
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
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
    
    private func isMinePossible(on tile: AbstractTile?) -> Bool {
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
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
    
    private func isQuarryPossible(on tile: AbstractTile?) -> Bool {
    
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if !owner.has(tech: .animalHusbandry) {
            return false
        }
        
        return tile.has(resource: .stone, for: owner) || tile.has(resource: .marble, for: owner) /* || tile.has(resource: .gypsum, for: owner) */
    }
    
    private func isCampPossible(on tile: AbstractTile?) -> Bool {
    
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if !owner.has(tech: .animalHusbandry) {
            return false
        }
        
        return tile.has(resource: .deer, for: owner) || tile.has(resource: .furs, for: owner) /*|| tile.has(resource: .ivory, for: owner) || tile.has(resource: .truffles, for: owner) */
    }
    
    private func isPasturePossible(on tile: AbstractTile?) -> Bool {
    
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if !owner.has(tech: .animalHusbandry) {
            return false
        }
        
        return tile.has(resource: .cattle, for: owner) || tile.has(resource: .sheep, for: owner) || tile.has(resource: .horses, for: owner)
    }
    
    private func isPlantationPossible(on tile: AbstractTile?) -> Bool {
    
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if !owner.has(tech: .animalHusbandry) {
            return false
        }
        
        return tile.has(resource: .bananas, for: owner) || tile.has(resource: .citrus, for: owner) || tile.has(resource: .tea, for: owner)
        // FIXME: cocoa, cotton, coffee, dyes, incense, silk, spices, sugar, tobacco, wine, olives
    }
    
    private func isFishingBoatsPossible(on tile: AbstractTile?) -> Bool {
    
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if !owner.has(tech: .animalHusbandry) {
            return false
        }
        
        return tile.has(resource: .fish, for: owner) || tile.has(resource: .whales, for: owner) || tile.has(resource: .pearls, for: owner)
        // FIXME: crabs, amber, turtles
    }
    
    private func isOilWellPossible(on tile: AbstractTile?) -> Bool {
    
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let owner = tile.owner() else {
            fatalError("can check without owner")
        }
        
        if !owner.has(tech: .refining) {
            return false
        }
        
        return tile.has(resource: .oil, for: owner)
    }

    func required() -> TechType? {

        switch self {

        case .none, .barbarianCamp, .goodyHut, .ruins: return nil

        case .farm: return nil
        case .mine: return .mining
        case .quarry: return .mining
        case .camp: return .animalHusbandry
        case .pasture: return .animalHusbandry
        case .plantation: return .irrigation
        case .fishingBoats: return .sailing
        case .oilWell: return .refining
     
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
        case .ruins: return []
            
        case .barbarianCamp: return []
        case .goodyHut: return []
        case .farm: return []
        case .mine: return []
        case .quarry: return []
        case .camp: return []
        case .pasture: return []
        case .plantation: return []
        case .fishingBoats: return []
        case .oilWell: return []
            
        case .fort: return []
        case .citadelle: return []
        }
    }
    
    func enables(resource: ResourceType) -> Bool {
        
        if self == .farm && (resource == .wheat || resource == .rice) {
            return true
        }
        
        // Copper Diamonds Gold Ore  Iron  Jade  Mercury  Salt  Niter  Coal  Aluminum  Uranium  Amber
        if self == .mine && (resource == .iron || resource == .copper ) {
            return true
        }
        
        // Gypsum
        if self == .quarry && (resource == .stone || resource == .marble) {
            return true
        }
        
        // Bananas Citrus Cocoa Coffee Cotton Dyes Silk Sugar Tea Tobacco Wine Olives (Civ6) Olives
        if self == .plantation && (resource == .bananas || resource == .citrus || resource == .tea) {
            return true
        }
        
        // Deer Furs Ivory Truffles (Civ6) Truffles
        if self == .camp && (resource == .deer || resource == .furs) {
            return true
        }
        
        // Sheep Cattle Horses
        if self == .pasture && (resource == .sheep || resource == .cattle || resource == .horses) {
            return true
        }
        
        // Fish Crabs Whales Pearls Amber Turtles
        if self == .fishingBoats && (resource == .fish || resource == .whales || resource == .pearls) {
            return true
        }
        
        // oil
        if self == .oilWell && resource == .oil {
            return true
        }
        
        return false
    }
}
