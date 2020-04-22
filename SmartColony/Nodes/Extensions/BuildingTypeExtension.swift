//
//  BuildingTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension BuildingType {
    
    func iconTexture() -> String {
        
        switch self {
            
        case .none: return "building_default"
            
            // ancient
        case .palace: return "building_palace"
        case .granary: return "building_granary"
        case .monument: return "building_monument"
        case .library: return "building_library"
        case .shrine: return "building_shrine"
        case .ancientWalls: return "building_ancientWalls"
        case .barracks: return "building_barracks"
        case .waterMill: return "building_waterMill"
            
            // classical
        case .amphitheater: return "building_amphitheater"
        case .lighthouse: return "building_lighthouse"
        case .stable: return "building_stable"
        case .arena: return "building_default" // <=== 
        case .market: return "building_market"
        case .temple: return "building_temple"
        }
    }
}
