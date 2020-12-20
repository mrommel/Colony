//
//  FeatureType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum FeatureType: Int, Codable {

    case none
    
    case forest
    case rainforest
    case floodplains
    case marsh
    case oasis
    case reef
    case ice
    case atoll
    case volcano
    
    case mountains
    case lake
    case fallout
    
    // natural wonders
    case delicateArch
    case galapagos
    case greatBarrierReef
    case mountEverest
    case mountKilimanjaro
    case pantanal
    case yosemite
    case uluru
    case fuji
    case barringCrater
    case mesa
    case gibraltar
    case geyser
    case potosi // civ5
    case fountainOfYouth // civ5 + civ6
    case lakeVictoria

    public static var all: [FeatureType] {
        return [
            .forest, .rainforest, .floodplains, .marsh, .oasis, .reef, .ice, .atoll, .volcano, .mountains, .lake, .fallout
        ]
    }
    
    public static var naturalWonders: [FeatureType] {
        return [
            .delicateArch, .galapagos, .greatBarrierReef, .mountEverest, .mountKilimanjaro, .pantanal, .yosemite, .uluru, .fuji, .barringCrater, .mesa, .gibraltar, .geyser, .potosi, .fountainOfYouth, .lakeVictoria
        ]
    }
    
    // MARK: internal classes
    
    private struct FeatureData {
        
        let name: String
        let yields: Yields
        let isWonder: Bool
    }
    
    // MARK: methods
    
    public func name() -> String {
        
        return self.data().name
    }

    func yields() -> Yields {

        return self.data().yields
    }
    
    func isWonder() -> Bool {
        
        return self.data().isWonder
    }

    func isPossible(on tile: AbstractTile) -> Bool {

        switch self {
            
        case .none: return false
            
        case .forest: return self.isForestPossible(on: tile)
        case .rainforest: return self.isRainforestPossible(on: tile)
        case .floodplains: return self.isFloodplainsPossible(on: tile)
        case .marsh: return self.isMarshPossible(on: tile)
        case .oasis: return self.isOasisPossible(on: tile)
        case .reef: return self.isReefPossible(on: tile)
        case .ice: return self.isIcePossible(on: tile)
        case .atoll: return self.isAtollPossible(on: tile)
        case .volcano: return self.isVolcanoPossible(on: tile)
            
        case .mountains: return self.isMountainPossible(on: tile)
        case .lake: return self.isLakePossible(on: tile)
        case .fallout: return self.isFalloutPossible(on: tile)
            
        // natural wonders
        case .delicateArch: return self.isDelicateArchPossible(on: tile)
        case .galapagos: return self.isGalapagosPossible(on: tile)
        case .greatBarrierReef: return self.isBarrierReefPossible(on: tile)
        case .mountEverest: return self.isEverestPossible(on: tile)
        case .mountKilimanjaro: return self.isKilimanjaroPossible(on: tile)
        case .pantanal: return self.isPantanalPossible(on: tile)
        case .yosemite: return self.isYosemitePossible(on: tile)
        case .uluru: return self.isUluruPossible(on: tile)
        case .fuji: return self.isFujiPossible(on: tile)
        case .barringCrater: return self.isReefPossible(on: tile)
        case .mesa: return self.isMesaPossible(on: tile)
        case .gibraltar: return self.isGibraltarPossible(on: tile)
        case .geyser: return self.isGeyserPossible(on: tile)
        case .potosi: return self.isPotosiPossible(on: tile)
        case .fountainOfYouth: return self.isFountainOfYouthPossible(on: tile)
        case .lakeVictoria: return self.isLakeVictoriaPossible(on: tile)
            
        }
    }

    func isRemovable() -> Bool {

        switch self {
        
        case .none: return false
            
        case .forest: return true
        case .rainforest: return true
        case .floodplains: return true
        case .marsh: return true
        case .oasis: return false
        case .reef: return false
        case .ice: return false
        case .atoll: return false
        case .volcano: return false
            
        case .mountains: return false
        case .lake: return false
        case .fallout: return false
            
        // natural wonders
        case .delicateArch: return false
        case .galapagos: return false
        case .greatBarrierReef: return false
        case .mountEverest: return false
        case .mountKilimanjaro: return false
        case .pantanal: return false
        case .yosemite: return false
        case .uluru: return false
        case .fuji: return false
        case .barringCrater: return false
        case .mesa: return false
        case .gibraltar: return false
        case .geyser: return false
        case .potosi: return false
        case .fountainOfYouth: return false
        case .lakeVictoria: return false
        }
    }
    
    func isRough() -> Bool {
        
        switch self {
            
        case .none: return false
            
        case .forest: return true
        case .rainforest: return true
        case .floodplains: return false
        case .marsh: return false
        case .oasis: return false
        case .reef: return false
        case .ice: return false
        case .atoll: return false
        case .volcano: return false
            
        case .mountains: return true
        case .lake: return false
        case .fallout: return false
            
        // natural wonders
        case .delicateArch: return true
        case .galapagos: return true
        case .greatBarrierReef: return true
        case .mountEverest: return true
        case .mountKilimanjaro: return true
        case .pantanal: return true
        case .yosemite: return true
        case .uluru: return true
        case .fuji: return true
        case .barringCrater: return true
        case .mesa: return true
        case .gibraltar: return true
        case .geyser: return true
        case .potosi: return true
        case .fountainOfYouth: return true
        case .lakeVictoria: return true
        }
    }
    
    func attackModifier() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .forest: return 0
        case .rainforest: return 0
        case .floodplains: return 0
        case .marsh: return 0
        case .oasis: return 0
        case .reef: return 0
        case .ice: return 0
        case .atoll: return 0
        case .volcano: return 0
            
        case .mountains: return 0
        case .lake: return 0
        case .fallout: return 0
            
        // natural wonders
        case .delicateArch: return 0
        case .galapagos: return 0
        case .greatBarrierReef: return 0
        case .mountEverest: return 0
        case .mountKilimanjaro: return 0
        case .pantanal: return 0
        case .yosemite: return 0
        case .uluru: return 0
        case .fuji: return 0
        case .barringCrater: return 0
        case .mesa: return 0
        case .gibraltar: return 0
        case .geyser: return 0
        case .potosi: return 0
        case .fountainOfYouth: return 0
        case .lakeVictoria: return 0
        }
    }
    
    func defenseModifier() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .forest: return 3
        case .rainforest: return 3
        case .floodplains: return -2
        case .marsh: return -2
        case .oasis: return 0
        case .reef: return 0
        case .ice: return 0
        case .atoll: return 0
        case .volcano: return 0
            
        case .mountains: return 0
        case .lake: return 0
        case .fallout: return 0
            
        // natural wonders
        case .delicateArch: return 0
        case .galapagos: return 0
        case .greatBarrierReef: return 0
        case .mountEverest: return 0
        case .mountKilimanjaro: return 0
        case .pantanal: return -2
        case .yosemite: return 0
        case .uluru: return 0
        case .fuji: return 0
        case .barringCrater: return 0
        case .mesa: return 0
        case .gibraltar: return 0
        case .geyser: return 0
        case .potosi: return 0
        case .fountainOfYouth: return 0
        case .lakeVictoria: return 0
        }
    }
    
    func movementCosts() -> Double {
        
        switch self {
        
        case .none: return 0
            
        case .forest: return 2
        case .rainforest: return 2
        case .floodplains: return 1
        case .marsh: return 2
        case .oasis: return 0
        case .reef: return 2
        case .ice: return UnitMovementType.max
        case .atoll: return 2
        case .volcano: return UnitMovementType.max
            
        case .mountains: return 2 // UnitMovementType.max // impassable
        case .lake: return UnitMovementType.max // impassable
        case .fallout: return 2
            
        // natural wonders
        case .delicateArch: return UnitMovementType.max
        case .galapagos: return UnitMovementType.max
        case .greatBarrierReef: return 1
        case .mountEverest: return UnitMovementType.max
        case .mountKilimanjaro: return UnitMovementType.max
        case .pantanal: return 2
        case .yosemite: return UnitMovementType.max
        case .uluru: return UnitMovementType.max
        case .fuji: return UnitMovementType.max
        case .barringCrater: return UnitMovementType.max
        case .mesa: return UnitMovementType.max
        case .gibraltar: return UnitMovementType.max
        case .geyser: return UnitMovementType.max
        case .potosi: return UnitMovementType.max
        case .fountainOfYouth: return UnitMovementType.max
        case .lakeVictoria: return UnitMovementType.max
        }
    }
    
    // to adjacent tiles
    func appeal() -> Int {
        
        switch self {
            
        case .none: return 0
            
        case .forest: return 1
        case .rainforest: return -1
        case .floodplains: return -1
        case .marsh: return -1
        case .oasis: return 1
        case .reef: return 2
        case .ice: return -1
        case .atoll: return 1
        case .volcano: return 1
            
        case .mountains: return 1
        case .lake: return 2
        case .fallout: return -3
            
        // natural wonders
        case .delicateArch: return 2
        case .galapagos: return 2
        case .greatBarrierReef: return 2
        case .mountEverest: return 2
        case .mountKilimanjaro: return 2
        case .pantanal: return 2
        case .yosemite: return 2
        case .uluru: return 4
        case .fuji: return 2
        case .barringCrater: return 2
        case .mesa: return 2
        case .gibraltar: return 2
        case .geyser: return 2
        case .potosi: return 2
        case .fountainOfYouth: return 2
        case .lakeVictoria: return 2
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
        case .ice: return FeatureData(name: "Ice", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWonder: false)
        case .atoll: return FeatureData(name: "Atoll", yields: Yields(food: 1, production: 0, gold: 0, science: 0), isWonder: false)
        case .volcano: return FeatureData(name: "Volcano", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWonder: false)
            
        case .mountains: return FeatureData(name: "Mountains", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWonder: false)
        case .lake: return FeatureData(name: "Lake", yields: Yields(food: 0, production: 0, gold: 0, science: 0), isWonder: false)
        case .fallout: return FeatureData(name: "Fallout", yields: Yields(food: -3, production: -3, gold: -3, science: 0), isWonder: false)
            
        // natural wonders
        case .delicateArch: return FeatureData(name: "Delicate Arch", yields: Yields(food: 0, production: 0, gold: 1, science: 0, faith: 2), isWonder: true)
        case .galapagos: return FeatureData(name: "Galapagos", yields: Yields(food: 0, production: 0, gold: 0, science: 2), isWonder: true)
        case .greatBarrierReef: return FeatureData(name: "Great Barrier Reef", yields: Yields(food: 3, production: 0, gold: 0, science: 2), isWonder: true)
        case .mountEverest: return FeatureData(name: "Mount Kilimanjaro", yields: Yields(food: 2, production: 0, gold: 0, science: 0, faith: 1), isWonder: true)
        case .mountKilimanjaro: return FeatureData(name: "Mount Kilimanjaro", yields: Yields(food: 2, production: 0, gold: 0, science: 0), isWonder: true)
        case .pantanal: return FeatureData(name: "Pantanal", yields: Yields(food: 2, production: 0, gold: 0, science: 0, culture: 2), isWonder: true)
        case .yosemite: return FeatureData(name: "Yosemite", yields: Yields(food: 0, production: 0, gold: 1, science: 1), isWonder: true)
        case .uluru: return FeatureData(name: "Uluru", yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 2, faith: 2), isWonder: true)
        case .fuji: return FeatureData(name: "Fuji", yields: Yields(food: 0, production: 0, gold: 2, science: 0, culture: 2, faith: 2), isWonder: true)
        case .barringCrater: return FeatureData(name: "The Barringer Crater", yields: Yields(food: 0, production: 0, gold: 2, science: 3, culture: 0, faith: 0), isWonder: true)
        case .mesa: return FeatureData(name: "The Grand Mesa", yields: Yields(food: 0, production: 2, gold: 3, science: 0, culture: 0, faith: 0), isWonder: true)
        case .gibraltar: return FeatureData(name: "Rock of Gibraltar", yields: Yields(food: 2, production: 0, gold: 5, science: 0, culture: 0, faith: 0), isWonder: true)
        case .geyser: return FeatureData(name: "Old Faithful", yields: Yields(food: 0, production: 0, gold: 0, science: 2, culture: 0, faith: 0), isWonder: true)
        case .potosi: return FeatureData(name: "Cerro de Potosi", yields: Yields(food: 0, production: 0, gold: 10, science: 0, culture: 0, faith: 0), isWonder: true)
        case .fountainOfYouth: return FeatureData(name: "Fountain of Youth", yields: Yields(food: 0, production: 0, gold: 0, science: 0, culture: 0, faith: 0), isWonder: true) // fixme: 10 happiness
        case .lakeVictoria: return FeatureData(name: "Lake Victoria", yields: Yields(food: 6, production: 0, gold: 0, science: 0, culture: 0, faith: 0), isWonder: true)
        }
    }

    //  Grassland, Grassland (Hills), Plains, Plains (Hills), Tundra and Tundra (Hills).
    private func isForestPossible(on tile: AbstractTile) -> Bool {

        if tile.terrain() == .tundra || tile.terrain() == .grass || tile.terrain() == .plains {
            return true
        }

        return false
    }

    // Modifies Plains and Plains (Hills).
    private func isRainforestPossible(on tile: AbstractTile) -> Bool {

        if tile.terrain() == .plains {
            return true
        }

        return false
    }

    // Modifies Deserts (in GS-Only also Plains and Grassland).
    private func isFloodplainsPossible(on tile: AbstractTile) -> Bool {

        if tile.hasHills() {
            return false
        }

        if tile.terrain() != .desert && tile.terrain() != .grass && tile.terrain() != .plains {
            return false
        }
        
        return true
    }
    
    private func isMarshPossible(on tile: AbstractTile) -> Bool {
        
        if tile.hasHills() {
            return false
        }
        
        if tile.terrain() != .grass {
            return false
        }
        
        return true
    }
    
    private func isOasisPossible(on tile: AbstractTile) -> Bool {
        
        if tile.hasHills() {
            return false
        }
        
        if tile.terrain() != .desert {
            return false
        }
        
        return true
    }
    
    private func isReefPossible(on tile: AbstractTile) -> Bool {
        
        if !tile.isWater() {
            return false
        }
        
        if tile.terrain() != .shore {
            return false
        }
        
        return true
    }
    
    private func isMesaPossible(on tile: AbstractTile) -> Bool {
        
        if tile.feature() != .mountains {
            return false
        }
        
        return true
    }
    
    private func isGibraltarPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .grass {
            return false
        }
        
        return true
    }
    
    // Grassland, Plains, Tundra, Mountains
    private func isGeyserPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .grass && tile.terrain() != .plains && tile.terrain() != .tundra {
            return false
        }
        
        return true
    }
    
    // https://civilization.fandom.com/wiki/Cerro_de_Potosi_(Civ5)
    private func isPotosiPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .plains {
            return false
        }
        
        if tile.feature() != .mountains {
            return false
        }
        
        return true
    }
    
    // https://civilization.fandom.com/wiki/Fountain_of_Youth_(Civ5)
    private func isFountainOfYouthPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .plains {
            return false
        }
        
        return true
    }
    
    // https://civilization.fandom.com/wiki/Lake_Victoria_(Civ5)
    private func isLakeVictoriaPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .plains {
            return false
        }
        
        return true
    }
    
    private func isIcePossible(on tile: AbstractTile) -> Bool {
        
        if !tile.isWater() {
            return false
        }
        
        return true
    }
    
    private func isAtollPossible(on tile: AbstractTile) -> Bool {
        
        if !tile.isWater() {
            return false
        }
        
        return true
    }
    
    private func isVolcanoPossible(on tile: AbstractTile) -> Bool {
        
        if tile.feature() != .mountains {
            return false
        }
        
        return true
    }
    
    private func isMountainPossible(on tile: AbstractTile) -> Bool {

        if tile.hasHills() {
            return false
        }

        if tile.terrain() == .desert || tile.terrain() == .grass || tile.terrain() == .plains || tile.terrain() == .tundra || tile.terrain() == .snow {
            return true
        }

        return false
    }
    
    private func isLakePossible(on tile: AbstractTile) -> Bool {

        if tile.hasHills() {
            return false
        }

        return true
    }
    
    private func isFalloutPossible(on tile: AbstractTile) -> Bool {

        if !tile.isWater() {
            return false
        }
        
        return true
    }
    
    private func isDelicateArchPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .desert {
            return false
        }
        
        return true
    }
    
    private func isGalapagosPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .shore {
            return false
        }
        
        return true
    }
    
    private func isBarrierReefPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .shore {
            return false
        }
        
        return true
    }
    
    private func isEverestPossible(on tile: AbstractTile) -> Bool {
        
        if tile.feature() != .mountains {
            return false
        }
        
        return true
    }
    
    private func isKilimanjaroPossible(on tile: AbstractTile) -> Bool {
        
        if tile.feature() != .mountains {
            return false
        }
        
        return true
    }
    
    private func isPantanalPossible(on tile: AbstractTile) -> Bool {
        
        if tile.feature() != .marsh {
            return false
        }
        
        return true
    }

    private func isYosemitePossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .plains && tile.terrain() != .tundra {
            return false
        }
        
        return true
    }
    
    private func isUluruPossible(on tile: AbstractTile) -> Bool {
        
        if tile.terrain() != .desert {
            return false
        }
        
        return true
    }
    
    private func isFujiPossible(on tile: AbstractTile) -> Bool {
        
        if tile.feature() != .mountains {
            return false
        }
        
        return true
    }
    
    func isNoImprovement() -> Bool {
        
        if self.isWonder() {
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
            
        case .swimShallow:
            return UnitMovementType.max
        
        case .walk:
            return Double(self.movementCosts())
        }
        
    }
}
