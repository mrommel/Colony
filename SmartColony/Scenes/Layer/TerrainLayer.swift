//
//  TerrainLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
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

class TextureUtils {
    
    weak var gameModel: GameModel?
    
    init(with gameModel: GameModel?) {
        self.gameModel = gameModel
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
}

class TerrainLayer: SKNode {
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    var tileTextures: Array2D<TerrainLayerTextureItem>?
    
    class TerrainLayerTextureItem: Codable, Equatable {
        
        enum CodingKeys: CodingKey {
            case point
        }
        
        let point: HexPoint
        var terrainSprite: SKSpriteNode? = nil
        var snowSprite: SKSpriteNode? = nil
        
        init(point: HexPoint) {
            
            self.point = point
        }
        
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.point = try container.decode(HexPoint.self, forKey: .point)
        }
        
        static func == (lhs: TerrainLayer.TerrainLayerTextureItem, rhs: TerrainLayer.TerrainLayerTextureItem) -> Bool {
            return lhs.point == rhs.point
        }
    }
    
    // MARK: constructor
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        
        super.init()
        self.zPosition = Globals.ZLevels.terrain
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with gameModel: GameModel?) {
        
        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        self.textureUtils = TextureUtils(with: gameModel)
        
        let mapSize = gameModel.mapSize()
        
        self.tileTextures = Array2D<TerrainLayerTextureItem>(width: mapSize.width(), height: mapSize.height())
        
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                self.tileTextures?[x, y] = TerrainLayerTextureItem(point: HexPoint(x: x, y: y))
            }
        }

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                
                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {
                    let screenPoint = HexPoint.toScreen(hex: pt)
                    if tile.isDiscovered(by: self.player) {
                        self.placeTileHex(tile: tile, at: screenPoint, alpha: 0.5)
                    } else if tile.isVisible(to: self.player) {
                        self.placeTileHex(tile: tile, at: screenPoint, alpha: 1.0)
                    }
                }
            }
        }
    }
    
    /// handles all terrain
    func placeTileHex(tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {
        
        // place terrain
        var textureName = ""
        if let coastTexture = self.textureUtils?.coastTexture(at: tile.point) {
            textureName = coastTexture
        } else {
            textureName = tile.terrain().textureNameHex().randomItem()
        }

        let terrainSprite = SKSpriteNode(imageNamed: textureName)
        terrainSprite.position = position
        terrainSprite.zPosition = tile.terrain().zLevel
        terrainSprite.anchorPoint = CGPoint(x: 0, y: 0)
        terrainSprite.color = .black
        terrainSprite.colorBlendFactor = 1.0 - alpha
        self.addChild(terrainSprite)

        self.tileTextures?[tile.point.x, tile.point.y]?.terrainSprite = terrainSprite
        
        // snow
        if tile.terrain() != .snow {
        
            if let snowTexture = self.textureUtils?.snowTexture(at: tile.point) {

                let snowSprite = SKSpriteNode(imageNamed: snowTexture)
                snowSprite.position = position
                snowSprite.zPosition = Globals.ZLevels.snow
                snowSprite.anchorPoint = CGPoint(x: 0, y: 0)
                snowSprite.color = .black
                snowSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(snowSprite)

                self.tileTextures?[tile.point.x, tile.point.y]?.snowSprite = snowSprite
            }
        }
        
        // mountain
        /*if tile.terrain != .mountain {
            if let tilePoint = tile.point {
                if let mountainTexture = self.map?.mountainTexture(at: tilePoint) {
                    
                    let mountainSprite = SKSpriteNode(imageNamed: mountainTexture)
                    mountainSprite.position = position
                    mountainSprite.zPosition = GameScene.Constants.ZLevels.mountain
                    mountainSprite.anchorPoint = CGPoint(x: 0, y: 0)
                    mountainSprite.color = .black
                    mountainSprite.colorBlendFactor = 1.0 - alpha
                    self.addChild(mountainSprite)

                    tile.mountainSprite = mountainSprite
                }
            }
        }*/
    }
    
    func clearTileHex(at pt: HexPoint) {
        
        /*guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tile(at: pt) {
            if let terrainSprite = tile.terrainSprite {
                self.removeChildren(in: [terrainSprite])
            }
            
            if let snowSprite = tile.snowSprite {
                self.removeChildren(in: [snowSprite])
            }
            
            if let mountainSprite = tile.mountainSprite {
                self.removeChildren(in: [mountainSprite])
            }
        }*/
    }
}
