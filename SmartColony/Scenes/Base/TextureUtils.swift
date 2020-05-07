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
        var borderSprite: SKSpriteNode? = nil
        var yieldsSprite: SKSpriteNode? = nil
        var waterSprite: SKSpriteNode? = nil
        var riverSprite: SKSpriteNode? = nil
        var improvementSprite: SKSpriteNode? = nil
        
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
    
    func terrainSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.terrainSprite
    }
    
    func set(snowSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.snowSprite = snowSprite
    }
    
    func snowSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.snowSprite
    }
    
    func set(boardSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.boardSprite = boardSprite
    }
    
    func boardSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.boardSprite
    }
    
    func set(featureSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.featureSprite = featureSprite
    }
    
    func featureSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.featureSprite
    }
    
    func set(resourceSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.resourceSprite = resourceSprite
    }
    
    func resourceSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.resourceSprite
    }
    
    func set(borderSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.borderSprite = borderSprite
    }
    
    func borderSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.borderSprite
    }
    
    func set(iceSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.iceSprite = iceSprite
    }
    
    func iceSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.iceSprite
    }
    
    func set(yieldsSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.yieldsSprite = yieldsSprite
    }
    
    func yieldsSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.yieldsSprite
    }
    
    func set(waterSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.waterSprite = waterSprite
    }
    
    func waterSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.waterSprite
    }
    
    func set(riverSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.riverSprite = riverSprite
    }
    
    func riverSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.riverSprite
    }
    
    func set(improvementSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.improvementSprite = improvementSprite
    }
    
    func improvementSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.improvementSprite
    }
    
    // MARK -
    
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
    
    func riverTexture(at point: HexPoint) -> String? {
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let tile = gameModel.tile(at: point) else {
            return nil
        }
        
        if !tile.isRiver() {
            
            // river deltas can be at ocean only
            if tile.terrain() == .shore || tile.terrain() == .ocean {
                
                let southwestNeightbor = point.neighbor(in: .southwest)
                if let southwestTile = gameModel.tile(at: southwestNeightbor) {
                    
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
                if let northwestTile = gameModel.tile(at: northwestNeightbor) {
                    
                    // 3
                    if northwestTile.isRiverInNorthEast() {
                        return "river-mouth-nw"
                    }
                }
                
                let northNeightbor = point.neighbor(in: .north)
                if let northTile = gameModel.tile(at: northNeightbor) {
                    
                    // 4
                    if northTile.isRiverInSouthEast() {
                        return "river-mouth-ne"
                    }
                }
                
                let southeastNeightbor = point.neighbor(in: .southeast)
                if let southeastTile = gameModel.tile(at: southeastNeightbor) {
                    
                    // 5
                    if southeastTile.isRiverInNorth() {
                        return "river-mouth-e"
                    }
                }
                
                let southNeightbor = point.neighbor(in: .south)
                if let southTile = gameModel.tile(at: southNeightbor) {
                    
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
    
    func yieldTexture(for yields: Yields) -> String? {
        
        let food = Int(yields.food)
        let production = Int(yields.production)
        let gold = Int(yields.gold)
        
        if food == 0 && production == 0 && gold == 0 {
            return nil
        }
        
        return "yield_\(food)_\(production)_\(gold)"
    }
}
