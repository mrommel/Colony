//
//  ResourceTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 06.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import CoreGraphics

extension ResourceType {
    
    func textureNameMarker() -> String {
        
        switch self {
            
        case .none: return "resource_marker_default"
            
        case .wheat: return "resource_marker_wheat"
        case .rice: return "resource_marker_rice"
        case .deer: return "resource_marker_deer"
        case .sheep: return "resource_marker_sheep"
        case .copper: return "resource_marker_copper"
        case .stone: return "resource_marker_stone"
        case .bananas: return "resource_marker_banana"
        case .cattle: return "resource_marker_cattle"
        case .fish: return "resource_marker_fish"
        case .marble: return "resource_marker_marble"
        case .gems: return "resource_marker_gems"
        case .furs: return "resource_marker_furs"
        case .citrus: return "resource_marker_citrus"
        case .tea: return "resource_marker_tea"
        
        case .sugar: return "resource_marker_sugar"
        case .whales: return "resource_marker_whales"
        case .pearls: return "resource_marker_pearls"
        case .ivory: return "resource_marker_ivory"
        case .wine: return "resource_marker_wine"
        case .cotton: return "resource_marker_cotton"
        case .dyes: return "resource_marker_dyes"
        case .incense: return "resource_marker_incense"
        case .silk: return "resource_marker_silk"
        case .silver: return "resource_marker_silver"
        case .gold: return "resource_marker_gold"
        case .spices: return "resource_marker_spices"
            
        case .horses: return "resource_marker_horse"
        case .iron: return "resource_marker_iron"
        case .coal: return "resource_marker_coal"
        case .oil: return "resource_marker_oil"
        case .aluminium: return "resource_marker_aluminium"
        case .uranium: return "resource_marker_uranium"
        case .niter: return "resource_marker_niter"
        }
    }
    
    var zLevel: CGFloat {
    
        return Globals.ZLevels.resource
    }
}
