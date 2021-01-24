//
//  TerrainTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 05.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import CoreGraphics
import SmartAILibrary
import SpriteKit

extension TerrainType {
    
    func overviewColor() -> UIColor {
        
        switch self {
        case .ocean: return UIColor(red: 79, green: 112, blue: 141)
        case .shore: return UIColor(red: 91, green: 129, blue: 166)
        case .plains: return UIColor(red: 98, green: 122, blue: 32)
        case .grass: return UIColor(red: 75, green: 113, blue: 21)
        case .desert: return UIColor(red: 197, green: 174, blue: 108)
        case .tundra: return UIColor(red: 140, green: 106, blue: 68)
        case .snow: return UIColor(red: 237, green: 240, blue: 240)
        }
    }
}

extension TerrainType {
    
    /*func textureNames() -> [String] {
        switch self {
            case .ocean:
                return ["terrain_ocean"]
            case .shore:
                return ["terrain_shore"]
            case .plains:
                return ["terrain_plains"]
            case .grass:
                return ["terrain_grass"]
            case .desert:
                return ["terrain_desert"]
            case .tundra:
                return ["terrain_tundra", "terrain_tundra2", "terrain_tundra3"]
            case .snow:
                return ["terrain_snow"]
        }
    }
    
    func textureNamesHills() -> [String] {
        switch self {
            case .ocean:
                return []
            case .shore:
                return []
            case .plains:
                return ["terrain_plains_hills", "terrain_plains_hills2", "terrain_plains_hills3"]
            case .grass:
                return ["terrain_grass_hills", "terrain_grass_hills2", "terrain_grass_hills3"]
            case .desert:
                return ["terrain_desert_hills", "terrain_desert_hills2", "terrain_desert_hills3"]
            case .tundra:
                return ["terrain_tundra_hills"]
            case .snow:
                return ["terrain_snow_hills", "terrain_snow_hills2", "terrain_snow_hills3"]
        }
    }*/
    
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
