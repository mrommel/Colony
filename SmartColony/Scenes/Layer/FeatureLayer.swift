//
//  FeatureLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class FeatureLayer: SKNode {
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    
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
                    textureName = feature.textureNamesHex().item(from: tile.point)
                }
            } else {
                textureName = feature.textureNamesHex().item(from: tile.point)
            }

            let featureSprite = SKSpriteNode(imageNamed: textureName)
            featureSprite.position = position
            featureSprite.zPosition = Globals.ZLevels.feature // feature.zLevel
            featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
            featureSprite.color = .black
            featureSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(featureSprite)

            self.textureUtils?.set(featureSprite: featureSprite, at: tile.point)
        }
        
        if feature != .ice {
            if let iceTexture = self.textureUtils?.iceTexture(at: tile.point) {

                let iceSprite = SKSpriteNode(imageNamed: iceTexture)
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
     
            if tile.isVisible(to: self.player) {
                self.placeTileHex(for: tile, neighborTiles: neighborTiles, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, neighborTiles: neighborTiles, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
