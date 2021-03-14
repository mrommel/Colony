//
//  FoodHarvestingType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.03.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum FoodHarvestingType: Int, Codable {
    
    case hunterGatherer = 0
    case settled = 1
    
    func peopleSupportedOn(terrain: TerrainType) -> Int {
        
        switch self {
        case .hunterGatherer:
            return self.peopleSupportedByHunterGatheringOn(terrain: terrain)
        case .settled:
            return self.peopleSupportedBySettledOn(terrain: terrain)
        }
    }
    
    func peopleBonusWith(feature: FeatureType) -> Int {
        
        switch self {
        case .hunterGatherer:
            return self.peopleBonusByHunterGatheringWith(feature: feature)
        case .settled:
            return self.peopleBonusBySettledWith(feature: feature)
        }
    }
    
    private func peopleSupportedByHunterGatheringOn(terrain: TerrainType) -> Int {
        
        switch terrain {
        
        case .grass:
            return 2500
        case .plains:
            return 2000
        case .desert:
            return 500
        case .tundra:
            return 1500
        case .snow:
            return 500
        case .shore:
            return 0
        case .ocean:
            return 0
        }
    }
    
    private func peopleSupportedBySettledOn(terrain: TerrainType) -> Int {
        
        switch terrain {
        
        case .grass:
            return 10000
        case .plains:
            return 5000
        case .desert:
            return 0
        case .tundra:
            return 2500
        case .snow:
            return 0
        case .shore:
            return 0
        case .ocean:
            return 0
        }
    }
    
    private func peopleBonusByHunterGatheringWith(feature: FeatureType) -> Int {
        
        switch feature {
        
        case .none:
            return 0
        case .forest:
            return 1000
        case .rainforest:
            return 700
        case .floodplains:
            return 200
        case .marsh:
            return 200
        case .oasis:
            return 1000
        case .reef:
            return 0
        case .ice:
            return 0
        case .atoll:
            return 0
            
        case .mountains:
            return -8000
            
        default:
            return 0
        }
    }
    
    private func peopleBonusBySettledWith(feature: FeatureType) -> Int {
        
        switch feature {
        
        case .none:
            return 0
        case .forest:
            return -500
        case .rainforest:
            return 700
        case .floodplains:
            return 200
        case .marsh:
            return 200
        case .oasis:
            return 1000
        case .reef:
            return 0
        case .ice:
            return 0
        case .atoll:
            return 0
        default:
            return 0
        }
    }
}
