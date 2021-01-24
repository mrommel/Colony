//
//  Textures.swift
//  SmartAssets
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

public class Textures {
    
    private static let allTextureSuffixes: [String] = [
        "-n", "-n-ne", "-n-ne-nw", "-n-ne-s", "-n-ne-s-nw", "-n-ne-s-sw", "-n-ne-s-sw-nw", "-n-ne-se", "-n-ne-se-nw", "-n-ne-se-s", "-n-ne-se-s-nw", "-n-ne-se-s-sw", "-n-ne-se-s-sw-nw", "-n-ne-se-sw", "-n-ne-se-sw-nw", "-n-ne-sw", "-n-ne-sw-nw", "-n-nw", "-n-s", "-n-s-nw", "-n-s-sw", "-n-s-sw-nw", "-n-se", "-n-se-nw", "-n-se-s", "-n-se-s-nw", "-n-se-s-sw", "-n-se-s-sw-nw", "-n-se-sw", "-n-se-sw-nw", "-n-sw", "-n-sw-nw", "-ne", "-ne-nw", "-ne-s", "-ne-s-nw", "-ne-s-sw", "-ne-s-sw-nw", "-ne-se", "-ne-se-nw", "-ne-se-s", "-ne-se-s-nw", "-ne-se-s-sw", "-ne-se-s-sw-nw", "-ne-se-sw", "-ne-se-sw-nw", "-ne-sw", "-ne-sw-nw", "-nw", "-s", "-s-nw", "-s-sw", "-s-sw-nw", "-se", "-se-nw", "-se-s", "-se-s-nw", "-se-s-sw", "-se-s-sw-nw", "-se-sw", "-se-sw-nw", "-sw", "-sw-nw"
    ]
    
    let game: GameModel?
    
    public let allTerrainTextureNames: [String]
    public let allCoastTextureNames: [String]
    public let allRiverTextureNames: [String]
    public let allFeatureTextureNames: [String]
    public let allIceFeatureTextureNames: [String]
    public let allResourceTextureNames: [String]
    
    public init(game: GameModel?) {
        
        self.game = game
        self.allTerrainTextureNames = [
            "terrain_desert", "terrain_plains_hills3", "terrain_grass_hills3", "terrain_desert_hills", "terrain_tundra", "terrain_desert_hills2", "terrain_tundra2", "terrain_shore", "terrain_desert_hills3", "terrain_ocean", "terrain_tundra3", "terrain_snow", "terrain_plains", "terrain_snow_hills", "terrain_grass", "terrain_snow_hills2", "terrain_tundra_hills", "terrain_plains_hills", "terrain_plains_hills2", "terrain_grass_hills", "terrain_snow_hills3", "terrain_grass_hills2"
        ]
        
        self.allCoastTextureNames = Textures.allTextureSuffixes.map({ "beach\($0)" })
        
        self.allRiverTextureNames = [
            "river-mouth-e", "river-n-se", "river-mouth-se", "river-ne", "river-n-ne-se", "river-mouth-ne", "river-n", "river-mouth-sw", "river-se", "river-n-ne", "river-mouth-nw", "river-ne-se", "river-mouth-w"
        ]
        
        self.allFeatureTextureNames = [
            "feature_atoll", "feature_lake", "feature_mountains_ne_sw", "feature_ice5", "feature_rainforest1", "feature_delicateArch", "feature_mountains_nw", "feature_ice6", "feature_rainforest2", "feature_floodplains", "feature_mountains_se", "feature_marsh1", "feature_mountains_se_nw", "feature_reef", "feature_forest1", "feature_marsh2", "feature_mountains_sw", "feature_uluru", "feature_forest2", "feature_mountEverest", "feature_none", "feature_galapagos", "feature_mountKilimanjaro", "feature_yosemite", "feature_greatBarrierReef", "feature_mountains1", "feature_oasis1", "feature_ice1", "feature_mountains2", "feature_oasis2", "feature_ice2", "feature_mountains3", "feature_pantanal", "feature_ice3", "feature_pine1", "feature_mountains_ne", "feature_ice4", "feature_pine1", "feature_pine2", "feature_volcano", "feature_fallout", "feature_fuji", "feature_barringCrater", "feature_mesa", "feature_gibraltar", "feature_geyser", "feature_potosi", "feature_fountainOfYouth", "feature_lakeVictoria"
        ]
        
        self.allIceFeatureTextureNames = Textures.allTextureSuffixes.map({ "feature_ice\($0)" }) + Textures.allTextureSuffixes.map({ "feature_ice-to-water\($0)" })
        
        self.allResourceTextureNames = [
            "resource_banana", "resource_marble", "resource_deer", "resource_sheep", "resource_horse", "resource_whales", "resource_cattle", "resource_niter", "resource_dyes", "resource_silk", "resource_incense", "resource_wheat", "resource_coal", "resource_oil", "resource_fish", "resource_spices", "resource_iron", "resource_wine", "resource_copper", "resource_pearls", "resource_furs", "resource_stone", "resource_ivory", "resource_cotton", "resource_rice", "resource_gold", "resource_uranium", "resource_crab", "resource_salt", "resource_cocoa", "resource_citrus", "resource_sugar", "resource_silver", "resource_aluminium", "resource_gems", "resource_tea"
        ]
    }

    public func coastTexture(at point: HexPoint) -> String? {
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        if let tile = game.tile(at: point) {
            if tile.terrain().isLand() {
                return nil
            }
        }
        
        var texture = "beach" // "beach-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = game.tile(at: neighbor) {
                
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
    
    public func snowTexture(at point: HexPoint) -> String? {
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        var texture = "snow" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = game.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "snow-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = game.tile(at: neighbor) {
                
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
    
    public func mountainTexture(at point: HexPoint) -> String? {
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        var texture = "mountains" // "mountains-n-ne-se-s-sw-nw"
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = game.tile(at: neighbor) {
                
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
    
    public func iceTexture(at point: HexPoint) -> String? {
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        var texture = "feature_ice" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = game.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "feature_ice-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = game.tile(at: neighbor) {
                
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
    
    public func featureTexture(for tile: AbstractTile, neighborTiles: [HexDirection: AbstractTile?]) -> String? {
        
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
    
    public func riverTexture(at point: HexPoint) -> String? {
        
        guard let game = self.game else {
            fatalError("cant get game")
        }
        
        guard let tile = game.tile(at: point) else {
            return nil
        }
        
        if !tile.isRiver() {
            
            // river deltas can be at ocean only
            if tile.terrain() == .shore || tile.terrain() == .ocean {
                
                let southwestNeightbor = point.neighbor(in: .southwest)
                if let southwestTile = game.tile(at: southwestNeightbor) {
                    
                    // 1. river end west
                    if southwestTile.isRiverInNorth() {
                        return "river-mouth-w"
                    }
                    
                    // 2. river end south west
                    if southwestTile.isRiverInSouthEast(){
                        return "river-mouth-sw"
                    }
                }
                
                let northwestNeightbor = point.neighbor(in: .northwest)
                if let northwestTile = game.tile(at: northwestNeightbor) {
                    
                    // 3
                    if northwestTile.isRiverInNorthEast() {
                        return "river-mouth-nw"
                    }
                }
                
                let northNeightbor = point.neighbor(in: .north)
                if let northTile = game.tile(at: northNeightbor) {
                    
                    // 4
                    if northTile.isRiverInSouthEast() {
                        return "river-mouth-ne"
                    }
                }
                
                let southeastNeightbor = point.neighbor(in: .southeast)
                if let southeastTile = game.tile(at: southeastNeightbor) {
                    
                    // 5
                    if southeastTile.isRiverInNorth() {
                        return "river-mouth-e"
                    }
                }
                
                let southNeightbor = point.neighbor(in: .south)
                if let southTile = game.tile(at: southNeightbor) {
                    
                    // 6
                    if southTile.isRiverInNorthEast() {
                        return "river-mouth-se"
                    }
                }
            }
            
            return nil
        }
        
        
        var texture = "river" // "river-n-ne-se-s-sw-nw"
        for flow in FlowDirection.all {
            
            if tile.isRiverIn(flow: flow) {
                texture += ("-" + flow.short)
            }
        }
        
        if texture == "river" {
            return nil
        }
        
        return texture
    }
}
