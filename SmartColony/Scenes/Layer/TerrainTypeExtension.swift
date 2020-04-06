//
//  TerrainTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 05.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import CoreGraphics
import SmartAILibrary

extension TerrainType {
    
    func textureNameHex() -> [String] {
        switch self {
            case .ocean:
                return ["hex_ocean"]
            case .shore:
                return ["hex_shore"]
            case .plains:
                return ["hex_plains"]
            case .grass:
                return ["hex_grass"]
            case .desert:
                return ["hex_desert"]
            case .tundra:
                return ["hex_tundra"]
            case .snow:
                return ["hex_snow"]
        }
    }
    
    var zLevel: CGFloat {
        
        switch self {
        case .ocean:
            return Globals.ZLevels.terrain
        case .shore:
            return Globals.ZLevels.terrain
        case .plains:
            return Globals.ZLevels.terrain
        case .grass:
            return Globals.ZLevels.terrain
        case .desert:
            return Globals.ZLevels.terrain
        case .tundra:
            return Globals.ZLevels.terrain
        case .snow:
            return Globals.ZLevels.snow
        }
    }
}
