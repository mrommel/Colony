//
//  RiverLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class RiverLayer: SKNode {
    
    let mapDisplay: HexMapDisplay
    weak var map: HexagonTileMap?
    let fogManager: FogManager?
    
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
                    
                    if !tile.isRiver() {
                        continue
                    }
                    
                    let screenPoint = self.mapDisplay.toScreen(hex: pt)
                    
                    if fogManager.discovered(at: pt) {
                        self.placeTileHex(riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 1.0)
                    } else if fogManager.currentlyVisible(at: pt) {
                        self.placeTileHex(riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 0.5)
                    }
                }
            }
        }
    }
    
    func placeTileHex(riverTextureName: String?, at position: CGPoint, alpha: CGFloat) {
        
        if let riverTextureName = riverTextureName {
            let riverFlowSprite = SKSpriteNode(imageNamed: riverTextureName)
            riverFlowSprite.position = position
            riverFlowSprite.zPosition = GameScene.Constants.ZLevels.river
            riverFlowSprite.anchorPoint = CGPoint(x: 0, y: 0)
            self.addChild(riverFlowSprite)
        }
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

extension RiverLayer: FogStateChangedDelegate {
    
    func changed(to newState: FogState, at pt: HexPoint) {
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        guard let fogManager = self.fogManager else {
            fatalError("fogManager not set")
        }
        
        self.clearTileHex(at: pt)
        
        if let tile = map.tiles[pt] {
            
            if !tile.isRiver() {
                return
            }
            
            let screenPoint = self.mapDisplay.toScreen(hex: pt)
            
            if fogManager.discovered(at: pt) {
                self.placeTileHex(riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 1.0)
            } else if fogManager.currentlyVisible(at: pt) {
                self.placeTileHex(riverTextureName: map.riverTexture(at: pt), at: screenPoint, alpha: 0.5)
            }
        }
    }
}
