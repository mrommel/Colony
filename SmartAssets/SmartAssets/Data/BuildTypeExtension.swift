//
//  BuildTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension BuildType {
    
    public func iconTexture() -> String {
        
        switch self {
            
        case .none: return "build-default"
            
        case .repair: return "build-default"
            
        case .ancientRoad: return "build-default"
        case .classicalRoad: return "build-default"
        case .removeRoad: return "build-default"
            
        case .farm: return "build-farm"
        case .mine: return "build-mine"
        case .quarry: return "build-quarry"
        case .plantation: return "build-plantation"
        case .camp: return "build-camp"
        case .pasture: return "build-pasture"
        case .fishingBoats: return "build-fishingBoats"
            
        case .removeForest: return "build-default"
        case .removeRainforest: return "build-default"
        case .removeMarsh: return "build-default"
        }
    }
}
