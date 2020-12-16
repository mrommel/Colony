//
//  FeatureTypeExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

extension FeatureType {

    public static func from(name: String) -> FeatureType? {
        
        for feature in FeatureType.all {
            if feature.name() == name {
                return feature
            }
        }
        
        return nil
    }
    
    public func textureNames() -> [String] {
        
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
            return ["feature_marsh1", "feature_marsh2"]
        case .oasis:
            return ["feature_oasis1", "feature_oasis2"]
        case .reef:
            return ["feature_reef"]
        case .ice:
            return ["feature_ice1", "feature_ice2", "feature_ice3", "feature_ice4", "feature_ice5", "feature_ice6"]
        case .atoll:
            return ["feature_atoll"]
        case .volcano:
            return ["feature_volcano"]
            
        case .mountains:
            return ["feature_mountains1", "feature_mountains2", "feature_mountains3"]
        case .lake:
            return ["feature_lake"]
        case .fallout:
            return ["feature_fallout"]
            
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
        case .fuji:
            return ["feature_fuji"]
        case .barringCrater:
            return ["feature_barringCrater"]
        case .mesa:
            return ["feature_mesa"]
        case .gibraltar:
            return ["feature_gibraltar"]
        case .geyser:
            return ["feature_geyser"]
        case .potosi:
            return ["feature_potosi"]
        case .fountainOfYouth:
            return ["feature_fountainOfYouth"]
        }
    }
}
