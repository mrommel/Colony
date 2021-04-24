//
//  FeatureLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class FeatureLayer: SKNode {
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    var textures: Textures?
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        
        super.init()
        self.zPosition = Globals.ZLevels.feature
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
        self.textures = Textures(game: gameModel)
        
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                
                if let tile = gameModel.tile(at: pt) {
                    self.update(tile: tile)
                }
            }
        }
    }

    func placeTileHex(for tile: AbstractTile, neighborTiles: [HexDirection: AbstractTile?], at position: CGPoint, alpha: CGFloat) {

        let feature: FeatureType = tile.feature()
        
        // place forests etc
        if feature != .none {

            if tile.feature() != .none {

                if let textureName = self.textures?.featureTexture(for: tile, neighborTiles: neighborTiles) {

                    let image = ImageCache.shared.image(for: textureName)

                    let featureSprite = SKSpriteNode(texture: SKTexture(image: image))
                    featureSprite.position = position
                    featureSprite.zPosition = Globals.ZLevels.feature // feature.zLevel
                    featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
                    featureSprite.color = .black
                    featureSprite.colorBlendFactor = 1.0 - alpha
                    self.addChild(featureSprite)

                    self.textureUtils?.set(featureSprite: featureSprite, at: tile.point)
                }
            }
        }
        
        if feature != .ice {
            if let iceTexture = self.textures?.iceTexture(at: tile.point) {

                let image = ImageCache.shared.image(for: iceTexture)

                let iceSprite = SKSpriteNode(texture: SKTexture(image: image))
                iceSprite.position = position
                iceSprite.zPosition = Globals.ZLevels.feature
                iceSprite.anchorPoint = CGPoint(x: 0, y: 0)
                iceSprite.color = .black
                iceSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(iceSprite)

                self.textureUtils?.set(iceSprite: iceSprite, at: tile.point)
            }
        }
    }

    func clear(tile: AbstractTile?) {
        
        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }
        
        if let tile = tile {
            if let featureSprite = textureUtils.featureSprite(at: tile.point) {
                self.removeChildren(in: [featureSprite])
            }
            
            if let iceSprite = textureUtils.iceSprite(at: tile.point) {
                self.removeChildren(in: [iceSprite])
            }
        }
    }
    
    func update(tile: AbstractTile?) {
        
        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        if let tile = tile {
            let pt = tile.point
            
            self.clear(tile: tile)
            
            let screenPoint = HexPoint.toScreen(hex: pt)
            
            let neighborTileN = gameModel.tile(at: pt.neighbor(in: .north))
            let neighborTileNE = gameModel.tile(at: pt.neighbor(in: .northeast))
            let neighborTileSE = gameModel.tile(at: pt.neighbor(in: .southeast))
            let neighborTileS = gameModel.tile(at: pt.neighbor(in: .south))
            let neighborTileSW = gameModel.tile(at: pt.neighbor(in: .southwest))
            let neighborTileNW = gameModel.tile(at: pt.neighbor(in: .northwest))
            
            let neighborTiles: [HexDirection: AbstractTile?]  = [
                .north: neighborTileN,
                .northeast: neighborTileNE,
                .southeast: neighborTileSE,
                .south: neighborTileS,
                .southwest: neighborTileSW,
                .northwest: neighborTileNW
            ]
     
            if tile.isVisible(to: self.player) || true {
                self.placeTileHex(for: tile, neighborTiles: neighborTiles, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, neighborTiles: neighborTiles, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
