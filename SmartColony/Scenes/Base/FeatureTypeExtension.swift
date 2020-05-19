//
//  FeatureTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 05.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import CoreGraphics

extension FeatureType {
    
    func textureNamesHex() -> [String] {
        
        switch self {
        case .none:
            return []
        case .forest:
            return ["feature_forest1", "feature_forest2"]
        case .rainforest:
            return ["feature_rainforest1", "feature_rainforest2"]
        case .floodplains:
            return ["feature_floodplains"]
        case .marsh:
            return ["feature_marsh"]
        case .oasis:
            return ["feature_oasis1", "feature_oasis2"]
        case .reef:
            return ["feature_reef"]
        case .ice:
            return ["feature_ice1", "feature_ice2", "feature_ice3", "feature_ice4", "feature_ice5", "feature_ice6"]
        case .atoll:
            return ["feature_atoll"]
            
        case .mountains:
            return ["feature_mountains1", "feature_mountains2", "feature_mountains3"]
        case .lake:
            return ["feature_lake"]
            
        case .delicateArch:
            return ["feature_delicateArch"]
        case .galapagos:
            return ["feature_galapagos"]
        case .greatBarrierReef:
            return ["feature_greatBarrierReef"]
        case .mountEverest:
            return ["feature_mountEverest"]
        case .mountKilimanjaro:
            return ["feature_mountKilimanjaro"]
        case .pantanal:
            return ["feature_pantanal"]
        case .yosemite:
            return ["feature_yosemite"]
        case .uluru:
            return ["feature_uluru"]
        }
    }
    
    var zLevel: CGFloat {
    
        return Globals.ZLevels.feature
    }
}
