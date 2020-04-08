//
//  TextureUtils.swift
//  SmartColony
//
//  Created by Michael Rommel on 05.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class TextureUtils {
    
    weak var gameModel: GameModel?
    var tileTextures: Array2D<TextureItem>?
    
    class TextureItem: Codable, Equatable {
        
        enum CodingKeys: CodingKey {
            case point
        }
        
        let point: HexPoint
        var terrainSprite: SKSpriteNode? = nil
        var featureSprite: SKSpriteNode? = nil
        var resourceSprite: SKSpriteNode? = nil
        var snowSprite: SKSpriteNode? = nil
        var boardSprite: SKSpriteNode? = nil
        var iceSprite: SKSpriteNode? = nil
        
        init(point: HexPoint) {
            
            self.point = point
        }
        
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.point = try container.decode(HexPoint.self, forKey: .point)
        }
        
        static func == (lhs: TextureUtils.TextureItem, rhs: TextureUtils.TextureItem) -> Bool {
            return lhs.point == rhs.point
        }
    }
    
    init(with gameModel: GameModel?) {
        
        self.gameModel = gameModel
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        let mapSize = gameModel.mapSize()
        
        self.tileTextures = Array2D<TextureItem>(width: mapSize.width(), height: mapSize.height())
        
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                self.tileTextures?[x, y] = TextureItem(point: HexPoint(x: x, y: y))
            }
        }
    }
    
    func set(terrainSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.terrainSprite = terrainSprite
    }
    
    func set(snowSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.snowSprite = snowSprite
    }
    
    func set(boardSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.boardSprite = boardSprite
    }
    
    func set(featureSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.featureSprite = featureSprite
    }
    
    func set(resourceSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.resourceSprite = resourceSprite
    }
    
    func set(iceSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.iceSprite = iceSprite
    }
    
    func coastTexture(at point: HexPoint) -> String? {
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        if let tile = gameModel.tile(at: point) {
            if tile.terrain().isLand() {
                return nil
            }
        }
        
        var texture = "beach" // "beach-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                
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
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        var texture = "snow" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = gameModel.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "snow-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                
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
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        var texture = "mountains" // "mountains-n-ne-se-s-sw-nw"
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                
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
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        var texture = "ice" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = gameModel.tile(at: point) {
            if tile.terrain().isWater() {
                texture = "ice-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                
                if neighborTile.has(feature: .ice) {
                    texture += ("-" + direction.short())
                }
            }
        }
        
        if texture == "ice" || texture == "ice-to-water" {
            return nil
        }
        
        return texture
    }
    
    /*func isCalderaSouth(at hex: HexPoint) -> Bool {
        return hex.y == self.tiles.rows - 1
    }

    func isCalderaEast(at hex: HexPoint) -> Bool {
        return hex.x == self.tiles.columns - 1
    }*/

    func calderaTexure(at hex: HexPoint) -> String? {
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        let calderaIsSouth = hex.y == gameModel.mapSize().height() - 1 //self.isCalderaSouth(at: hex)
        let calderaIsEast = hex.x == gameModel.mapSize().width() - 1 // self.isCalderaEast(at: hex)

        if calderaIsSouth || calderaIsEast {
            if calderaIsSouth && calderaIsEast {
                return "hex_board"
            }
            
            if calderaIsSouth {
                return "hex_board_south"
            }
            
            if hex.y % 2 == 1 {
                return "hex_board_east"
            }
            
            return "hex_board_southeast"
        }

        if hex.x == 0 && hex.y % 2 == 1 {
            return "hex_board_west"
        }

        return nil
    }
}
