//
//  RiverLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class RiverLayer: SKNode {
    
    weak var map: HexagonTileMap?
    
    let civilization: Civilization

    init(civilization: Civilization) {
        
        self.civilization = civilization
        
        super.init()
        self.zPosition = GameScene.Constants.ZLevels.labels
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
                    
                    /*if !tile.isRiver() {
                        continue
                    }*/
                    
                    let screenPoint = HexMapDisplay.shared.toScreen(hex: pt)
                    
                    if fogManager.discovered(at: pt, by: self.civilization) {
                        self.placeTileHex(tile: tile, riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 0.5)
                    } else if fogManager.currentlyVisible(at: pt, by: self.civilization) {
                        self.placeTileHex(tile: tile, riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 1.0)
                    }
                }
            }
        }
    }
    
    func placeTileHex(tile: Tile, riverTextureName: String?, at position: CGPoint, alpha: CGFloat) {
        
        if let riverTextureName = riverTextureName {
            let riverSprite = SKSpriteNode(imageNamed: riverTextureName)
            riverSprite.position = position
            riverSprite.zPosition = GameScene.Constants.ZLevels.river
            riverSprite.anchorPoint = CGPoint(x: 0, y: 0)
            riverSprite.color = .black
            riverSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(riverSprite)
            
            tile.riverSprite = riverSprite
        }
    }
    
    func clearTileHex(at pt: HexPoint) {
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tile(at: pt) {
            if let riverSprite = tile.riverSprite {
                self.removeChildren(in: [riverSprite])
            }
        }
    }
}

extension RiverLayer: FogStateChangedDelegate {
    
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
            
            if !tile.isRiver() {
                return
            }
            
            let screenPoint = HexMapDisplay.shared.toScreen(hex: pt)
            
            if fogManager.discovered(at: pt, by: self.civilization) {
                self.placeTileHex(tile: tile, riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 0.5)
            } else if fogManager.currentlyVisible(at: pt, by: self.civilization) {
                self.placeTileHex(tile: tile, riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 1.0)
            }
        }
    }
}
