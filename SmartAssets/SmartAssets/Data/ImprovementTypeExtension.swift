//
//  ImprovementTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 28.04.21.
//

import SmartAILibrary

extension ImprovementType {
    
    public func textureNames() -> [String] {
    
        switch self {
            
        case .none: return ["improvement-none"]
            
        case .barbarianCamp: return ["improvement-barbarianCamp"] // #
        case .goodyHut: return ["improvement-goodyHut"] // #
        case .ruins: return ["improvement-ruins"] // #
            
        case .farm: return ["improvement-farm"]
        case .mine: return ["improvement-mine"]
        case .quarry: return ["improvement-quarry"]
        case .camp: return ["improvement-camp"]
        case .pasture: return ["improvement-pasture"] // #
        case .plantation: return ["improvement-plantation"]
        case .fishingBoats: return ["improvement-fishingBoats"]
        case .oilWell: return ["improvement-oilWell"] // #
            
        case .fort: return ["improvement-fort"] // #
        case .citadelle: return ["improvement-citadelle"] // #
        }
    }
}
