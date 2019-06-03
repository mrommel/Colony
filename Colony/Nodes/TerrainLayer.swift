//
//  TerrainLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class TerrainLayer: SKNode {
    
    let fogManager: FogManager?
    weak var map: HexagonTileMap?
    let mapDisplay: HexMapDisplay
    
    init(with size: CGSize, and mapDisplay: HexMapDisplay, fogManager: FogManager?) {
        
        self.mapDisplay = mapDisplay
        self.fogManager = fogManager
        
        super.init()
    
        self.fogManager?.delegates.addDelegate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with map: HexagonTileMap?) {
        
        self.map = map
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        guard let fogManager = self.fogManager else {
            fatalError("fogManager not set")
        }
        
        for x in 0..<map.tiles.columns {
            for y in 0..<map.tiles.rows {
                
                let pt = HexPoint(x: x, y: y)
                if let tile = map.tiles[x, y] {
                    let screenPoint = self.mapDisplay.toScreen(hex: pt)
                    if fogManager.discovered(at: pt) {
                        self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: pt), at: screenPoint, alpha: 0.5)
                    } else if fogManager.currentlyVisible(at: pt) {
                        self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: pt), at: screenPoint, alpha: 1.0)
                    }
                }
            }
        }
    }
    
    func placeTileHex(tile: Tile, coastTexture: String?, at position: CGPoint, alpha: CGFloat) {
        
        // place terrain
        var textureName = ""
        if let coastTexture = coastTexture {
            textureName = coastTexture
        } else {
            textureName = tile.terrain.textureNameHex
        }
        
        let terrainSprite = SKSpriteNode(imageNamed: textureName)
        terrainSprite.position = position
        terrainSprite.zPosition = GameScene.Constants.ZLevels.terrain
        terrainSprite.anchorPoint = CGPoint(x: 0, y: 0)
        terrainSprite.alpha = alpha
        self.addChild(terrainSprite)
        
        tile.terrainSprite = terrainSprite
    }
    
    func clearTileHex(at pt: HexPoint) {
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tiles[pt] {
            if let terrainSprite = tile.terrainSprite {
                self.removeChildren(in: [terrainSprite])
            }
        }
    }
}

extension TerrainLayer: FogStateChangedDelegate {
    
    func changed(to newState: FogState, at pt: HexPoint) {
       
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        guard let fogManager = self.fogManager else {
            fatalError("fogManager not set")
        }
        
        self.clearTileHex(at: pt)
        
        if let tile = map.tiles[pt] {
            let screenPoint = self.mapDisplay.toScreen(hex: pt)
            if fogManager.currentlyVisible(at: pt) {
                self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: pt), at: screenPoint, alpha: 1.0)
            } else if fogManager.discovered(at: pt) {
                self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: pt), at: screenPoint, alpha: 0.5)
            }
        }
    }
}
