//
//  TerrainTypeExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.11.20.
//

import Foundation
import SmartAILibrary

extension TerrainType {
    
    func name() -> String {
        
        switch self {
            case .ocean:
                return "Ocean"
            case .shore:
                return "Shore"
            case .plains:
                return "Plains"
            case .grass:
                return "Grassland"
            case .desert:
                return "Desert"
            case .tundra:
                return "Tundra"
            case .snow:
                return "Snow"
        }
    }
    
    func textureNames() -> [String] {
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
    }
    
    /*var zLevel: CGFloat {
        
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
    }*/
}
