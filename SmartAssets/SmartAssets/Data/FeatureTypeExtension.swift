//
//  FeatureTypeExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

extension FeatureType {

    /*func name() -> String {

        switch self {

        case .none: return ""
            
        case .forest: return "Forest"
        case .rainforest: return "Rainforest"
        case .floodplains: return "Floodplains"
        case .marsh: return "Marsh"
        case .oasis: return "Oasis"
        case .reef: return "Reef"
        case .ice: return "Ice"
        case .atoll: return "Atoll"
        case .volcano: return "Volcano"
        case .mountains: return "Mountains"
        case .lake: return "Lake"
        case .delicateArch: return "Delicate Arch"
        case .galapagos: return "Galapagos"
        case .greatBarrierReef: return "Great Barrier Reef"
        case .mountEverest: return "Mount Everest"
        case .mountKilimanjaro: return "Mount Kilimanjaro"
        case .pantanal: return "Pantanal"
        case .yosemite: return "Yosemite"
        case .uluru: return "Uluru"
        }
    }*/
    
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
}
