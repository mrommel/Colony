//
//  BoardLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BoardLayer: SKNode {
    
    let fogManager: FogManager?
    weak var map: HexagonTileMap?
    let mapDisplay: HexMapDisplay
    
    init(with size: CGSize, and mapDisplay: HexMapDisplay, fogManager: FogManager?) {
        
        self.fogManager = fogManager
        self.mapDisplay = mapDisplay
        
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
                if let tile = map.tiles[x, y] {
                    let pt = HexPoint(x: x, y: y)
                    let screenPoint = self.mapDisplay.toScreen(hex: pt)
                    
                    if let calderaName = map.caldera(at: pt) {
                        if fogManager.discovered(at: pt) {
                            self.placeTileHex(tile: tile, and: calderaName, at: screenPoint, alpha: 1.0)
                        } else if fogManager.currentlyVisible(at: pt) {
                            self.placeTileHex(tile: tile, and: calderaName, at: screenPoint, alpha: 0.5)
                        }
                    }
                }
            }
        }
    }
    
    func placeTileHex(tile: Tile, and calderaName: String, at position: CGPoint, alpha: CGFloat) {
        
        let boardSprite = SKSpriteNode(imageNamed: calderaName)
        boardSprite.position = position
        boardSprite.zPosition = GameScene.Constants.ZLevels.caldera
        boardSprite.anchorPoint = CGPoint(x: 0, y: 0.09)
        boardSprite.alpha = alpha
        self.addChild(boardSprite)
    }
    
    func clearTileHex(at pt: HexPoint) {
        
        /*guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tiles[pt] {
         if let terrainSprite = tile.terrainSprite {
         self.removeChildren(in: [terrainSprite])
         }
         }*/
    }
}

extension BoardLayer: FogStateChangedDelegate {
    
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
            
            if let calderaName = map.caldera(at: pt) {
                if fogManager.discovered(at: pt) {
                    self.placeTileHex(tile: tile, and: calderaName, at: screenPoint, alpha: 1.0)
                } else if fogManager.currentlyVisible(at: pt) {
                    self.placeTileHex(tile: tile, and: calderaName, at: screenPoint, alpha: 0.5)
                }
            }
        }
    }
}
