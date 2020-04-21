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
    
    func textureNamesHex() -> [String] {
        
        switch self {
            
        case .none:
            return []
        case .wheat:
            return ["hex_wheat"]
        case .rice:
            return ["hex_rice"]
        case .deer:
            return ["hex_deer"]
        case .sheep:
            return ["hex_sheep"]
        case .copper:
            return ["hex_copper"]
        case .stone:
            return ["hex_stone"]
        case .bananas:
            return ["hex_banana"]
        case .cattle:
            return ["hex_cattle"]
        case .fish:
            return ["hex_fish"]
        case .marble:
            return ["hex_marble"]
        case .diamonds:
            return ["hex_diamonds"]
        case .furs:
            return ["hex_furs"]
        case .citrus:
            return ["hex_citrus"]
        case .horses:
            return ["hex_horse"]
        case .iron:
            return ["hex_iron"]
        case .tea:
            return ["hex_tea"]
        }
    }
    
    var zLevel: CGFloat {
    
        return Globals.ZLevels.resource
    }
}
