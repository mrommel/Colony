//
//  TerrainLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class TerrainLayer: SKNode {
    
    weak var map: HexagonTileMap?
    
    let civilization: Civilization

    init(civilization: Civilization) {
        
        self.civilization = civilization
        
        super.init()
        self.zPosition = GameScene.Constants.ZLevels.terrain
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with map: HexagonTileMap?) {
        
        self.map = map

        guard let map = self.map else {
            fatalError("map not set")
        }
        
        map.fogManager?.delegates.addDelegate(self)
        
        guard let fogManager = self.map?.fogManager else {
            fatalError("fogManager not set")
        }
        
        for x in 0..<map.width {
            for y in 0..<map.height {
                
                let pt = HexPoint(x: x, y: y)
                if let tile = map.tile(at: pt) {
                    let screenPoint = HexMapDisplay.shared.toScreen(hex: pt)
                    if fogManager.discovered(at: pt, by: self.civilization) {
                        self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: pt), at: screenPoint, alpha: 0.5)
                    } else if fogManager.currentlyVisible(at: pt, by: self.civilization) {
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
            textureName = tile.terrain.textureNameHex.randomItem()
        }
        
        let terrainSprite = SKSpriteNode(imageNamed: textureName)
        terrainSprite.position = position
        terrainSprite.zPosition = GameScene.Constants.ZLevels.terrain
        terrainSprite.anchorPoint = CGPoint(x: 0, y: 0)
        //terrainSprite.alpha = alpha
        terrainSprite.color = .black
        terrainSprite.colorBlendFactor = 1.0 - alpha
        self.addChild(terrainSprite)
        
        tile.terrainSprite = terrainSprite
    }
    
    func clearTileHex(at pt: HexPoint) {
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tile(at: pt) {
            if let terrainSprite = tile.terrainSprite {
                self.removeChildren(in: [terrainSprite])
            }
        }
    }
}

extension TerrainLayer: FogStateChangedDelegate {

    func changed(for civilization: Civilization, to newState: FogState, at pt: HexPoint) {
       
        if self.civilization != civilization {
            // we don't care for changes of non player civs here
            return
        }
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        guard let fogManager = self.map?.fogManager else {
            fatalError("fogManager not set")
        }
        
        self.clearTileHex(at: pt)
        
        if let tile = map.tile(at: pt) {
            let screenPoint = HexMapDisplay.shared.toScreen(hex: pt)
            if fogManager.currentlyVisible(at: pt, by: self.civilization) {
                self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: pt), at: screenPoint, alpha: 1.0)
            } else if fogManager.discovered(at: pt, by: self.civilization) {
                self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: pt), at: screenPoint, alpha: 0.5)
            }
        }
    }
}
