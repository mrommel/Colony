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
                    let screenPoint = HexPoint.toScreen(hex: pt)
                    
                    if tile.isVisible(to: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                    } else if tile.isDiscovered(by: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                    }
                }
            }
        }
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let feature = tile.feature()
        
        // place forests etc
        if feature != .none {

            let textureName = feature.textureNamesHex().randomItem()

            let featureSprite = SKSpriteNode(imageNamed: textureName)
            featureSprite.position = position
            featureSprite.zPosition = feature.zLevel
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
                iceSprite.zPosition = FeatureType.ice.zLevel
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
        
        if let tile = tile {
            let pt = tile.point
            
            self.clear(tile: tile)
            
            let screenPoint = HexPoint.toScreen(hex: pt)
            
            if tile.isVisible(to: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
