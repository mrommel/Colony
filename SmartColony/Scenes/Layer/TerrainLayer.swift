//
//  TerrainLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class TerrainLayer: SKNode {
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    
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
    
    /// handles all terrain
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {
        
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

        self.textureUtils?.set(terrainSprite: terrainSprite, at: tile.point)
        
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

                self.textureUtils?.set(snowSprite: snowSprite, at: tile.point)
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
    
    func clear(tile: AbstractTile?) {
        
        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }
        
        if let tile = tile {
            if let terrainSprite = textureUtils.terrainSprite(at: tile.point) {
                self.removeChildren(in: [terrainSprite])
            }
            
            if let snowSprite = textureUtils.snowSprite(at: tile.point) {
                self.removeChildren(in: [snowSprite])
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
