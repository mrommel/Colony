//
//  Textures.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

class Textures {
    
    let map: MapModel?
    
    init(map: MapModel?) {
        
        self.map = map
    }
    
    func coastTexture(at point: HexPoint) -> String? {
        
        guard let map = self.map else {
            fatalError("cant get map")
        }
        
        if let tile = map.tile(at: point) {
            if tile.terrain().isLand() {
                return nil
            }
        }
        
        var texture = "beach" // "beach-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = map.tile(at: neighbor) {
                
                if neighborTile.terrain().isLand() {
                    texture += ("-" + direction.short())
                }
            }
        }
        
        if texture == "beach" {
            return nil
        }
        
        return texture
    }
    
    func snowTexture(at point: HexPoint) -> String? {
        
        guard let map = self.map else {
            fatalError("cant get map")
        }
        
        var texture = "snow" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = map.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "snow-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = map.tile(at: neighbor) {
                
                if neighborTile.terrain() == .snow {
                    texture += ("-" + direction.short())
                }
            }
        }
        
        if texture == "snow" || texture == "snow-to-water" {
            return nil
        }
        
        return texture
    }
    
    func mountainTexture(at point: HexPoint) -> String? {
        
        guard let map = self.map else {
            fatalError("cant get map")
        }
        
        var texture = "mountains" // "mountains-n-ne-se-s-sw-nw"
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = map.tile(at: neighbor) {
                
                if neighborTile.has(feature: .mountains) {
                    texture += ("-" + direction.short())
                }
            }
        }
        
        if texture == "mountains" {
            return nil
        }
        
        // limit to only some existing textures
        if texture != "mountains-n-ne" &&
            texture != "mountains-n" &&
            texture != "mountains-ne" &&
            texture != "mountains-n-nw" &&
            texture != "mountains-nw" {
            
            return nil
        }
        
        return texture
    }
    
    func iceTexture(at point: HexPoint) -> String? {
        
        guard let map = self.map else {
            fatalError("cant get map")
        }
        
        var texture = "feature_ice" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = map.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "feature_ice-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = map.tile(at: neighbor) {
                
                if neighborTile.has(feature: .ice) {
                    texture += ("-" + direction.short())
                }
            }
        }
        
        if texture == "feature_ice" || texture == "feature_ice-to-water" {
            return nil
        }
        
        return texture
    }
    
    func featureTexture(for tile: AbstractTile, neighborTiles: [HexDirection: AbstractTile?]) -> String? {
        
        let feature: FeatureType = tile.feature()
        
        if feature == .none {
            return nil
        }
        
        let textureName: String
        if tile.terrain() == .tundra && feature == .forest {
            textureName = ["feature_pine1", "feature_pine2"].item(from: tile.point)
        } else if feature == .mountains {
            
            let mountainsN = (neighborTiles[.north]??.feature() ?? .none) == .mountains
            let mountainsNE = (neighborTiles[.northeast]??.feature() ?? .none) == .mountains
            let mountainsSE = (neighborTiles[.southeast]??.feature() ?? .none) == .mountains
            let mountainsS = (neighborTiles[.south]??.feature() ?? .none) == .mountains
            let mountainsSW = (neighborTiles[.southwest]??.feature() ?? .none) == .mountains
            let mountainsNW = (neighborTiles[.northwest]??.feature() ?? .none) == .mountains
            
            if !mountainsN && mountainsNE && !mountainsSE && !mountainsS && !mountainsSW && !mountainsNW {
                textureName = "feature_mountains_ne"
            } else if !mountainsN && !mountainsNE && !mountainsSE && !mountainsS && mountainsSW && !mountainsNW {
                textureName = "feature_mountains_sw"
            } else if !mountainsN && mountainsNE && !mountainsSE && !mountainsS && mountainsSW && !mountainsNW {
                textureName = "feature_mountains_ne_sw"
            } else if !mountainsN && !mountainsNE && mountainsSE && !mountainsS && !mountainsSW && !mountainsNW {
                textureName = "feature_mountains_se"
            } else if !mountainsN && !mountainsNE && !mountainsSE && !mountainsS && !mountainsSW && mountainsNW {
                textureName = "feature_mountains_nw"
            } else if !mountainsN && !mountainsNE && mountainsSE && !mountainsS && !mountainsSW && mountainsNW {
                textureName = "feature_mountains_se_nw"
            } else {
                textureName = feature.textureNames().item(from: tile.point)
            }
        } else {
            textureName = feature.textureNames().item(from: tile.point)
        }
        
        return textureName
    }
}
