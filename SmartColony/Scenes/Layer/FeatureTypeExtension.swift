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
            return ["hex_forest_mixed_summer1"]
        case .rainforest:
            return ["hex_forest_rain", "hex_forest_rain2"]
        case .floodplains:
            return []
        case .marsh:
            return ["hex_marsh"]
        case .oasis:
            return ["hex_oasis1", "hex_oasis2"]
        case .reef:
            return []
        case .ice:
            return ["hex_ice1", "hex_ice2", "hex_ice3", "hex_ice4", "hex_ice5", "hex_ice6"]
        case .mountains:
            return ["mountains1", "mountains2", "mountains3"]
        case .delicateArch:
            return []
        case .galapagos:
            return []
        case .greatBarrierReef:
            return []
        case .mountEverest:
            return []
        case .mountKilimanjaro:
            return []
        case .pantanal:
            return []
        case .yosemite:
            return []
        case .uluru:
            return []
        }
    }
    
    var zLevel: CGFloat {
    
        return Globals.ZLevels.feature
    }
}
