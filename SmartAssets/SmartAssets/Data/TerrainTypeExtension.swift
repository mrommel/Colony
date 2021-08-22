//
//  TerrainTypeExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.11.20.
//

import Cocoa
import SmartAILibrary

extension TerrainType {
    
    public static func from(name: String) -> TerrainType? {
        
        for terrain in TerrainType.all {
            if terrain.name() == name {
                return terrain
            }
        }
        
        return nil
    }

    public func textureNames() -> [String] {

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

    public func textureNamesHills() -> [String] {

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
    
    public var zLevel: CGFloat {
        
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

extension TerrainType {
    
    public func overviewColor() -> NSColor {
        
        switch self {
        
        case .ocean: return NSColor.Terrain.ocean
        case .shore: return NSColor.Terrain.shore
        case .plains: return NSColor.Terrain.plains
        case .grass: return NSColor.Terrain.grass
        case .desert: return NSColor.Terrain.desert
        case .tundra: return NSColor.Terrain.tundra
        case .snow: return NSColor.Terrain.snow
        }
    }
    
    public func forgottenColor() -> NSColor {
        
        return self.overviewColor().colorWithSaturation(saturation: 0.4)
    }
}

public extension NSColor {
    
    func colorWithSaturation(saturation newSaturation: CGFloat) -> NSColor {
        
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        saturation += (newSaturation - 1.0)
        saturation = max(min(saturation, 1.0), 0.0)
            
        return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
