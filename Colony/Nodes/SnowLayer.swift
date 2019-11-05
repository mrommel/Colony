//
//  SnowLayer.swift
//  Colony
//
//  Created by Michael Rommel on 21.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class SnowLayer: SKNode {
    
    weak var map: HexagonTileMap?

    let civilization: Civilization

    init(civilization: Civilization) {
        
        self.civilization = civilization
        
        super.init()
        self.zPosition = GameScene.Constants.ZLevels.snow
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
                        self.placeTileHex(tile: tile, at: screenPoint, alpha: 0.5)
                    } else if fogManager.currentlyVisible(at: pt, by: self.civilization) {
                        self.placeTileHex(tile: tile, at: screenPoint, alpha: 1.0)
                    }
                }
            }
        }
    }
    
    /*
     
     func snowTexture(at point: HexPoint) -> String? {
         
         if let tile = self.tile(at: point) {
             if !tile.isWater {
                 return nil
             }
         }
         
         var texture = "snow" // "snow-n-ne-se-s-sw-nw"
         for direction in HexDirection.all {
             let neighbor = point.neighbor(in: direction)
             
             if let neighborTile = self.tile(at: neighbor) {
                 
                 if neighborTile.isGround {
                     texture += ("-" + direction.short)
                 }
             }
         }
         
         if texture == "snow" {
             return nil
         }
         
         return texture
     }
     
     */
    
    func placeTileHex(tile: Tile, at position: CGPoint, alpha: CGFloat) {
        
        guard tile.terrain == .snow else {
            return
        }
        
        let textureName = tile.terrain.textureNameHex.randomItem()

        let snowSprite = SKSpriteNode(imageNamed: textureName)
        snowSprite.position = position
        snowSprite.zPosition = GameScene.Constants.ZLevels.terrain
        snowSprite.anchorPoint = CGPoint(x: 0, y: 0)
        //terrainSprite.alpha = alpha
        snowSprite.color = .black
        snowSprite.colorBlendFactor = 1.0 - alpha
        self.addChild(snowSprite)
        
        tile.snowSprite = snowSprite
    }
    
    func clearTileHex(at pt: HexPoint) {
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tile(at: pt) {
            if let snowSprite = tile.snowSprite {
                self.removeChildren(in: [snowSprite])
            }
        }
    }
}

extension SnowLayer: FogStateChangedDelegate {
    
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
                self.placeTileHex(tile: tile, at: screenPoint, alpha: 1.0)
            } else if fogManager.discovered(at: pt, by: self.civilization) {
                self.placeTileHex(tile: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
