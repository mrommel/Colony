//
//  TerrainLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class TerrainLayer: SKNode {
    
    let mapDisplay: HexMapDisplay
    
    init(with size: CGSize, and mapDisplay: HexMapDisplay) {
        
        self.mapDisplay = mapDisplay
        
        super.init()
    }
    
    func populate(with map: HexagonTileMap) {
        
        for index0 in 0..<map.tiles.columns {
            for index1 in 0..<map.tiles.rows {
                if let tile = map.tiles[index0, index1] {
                    let screenPoint = self.mapDisplay.toScreen(hex: HexPoint(x: index0, y: index1))
                    self.placeTileHex(tile: tile, coastTexture: map.coastTexture(at: tile.point!), at: screenPoint)
                }
            }
        }
    }
    
    func placeTileHex(tile: Tile, coastTexture: String?, at position: CGPoint) {
        
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
        self.addChild(terrainSprite)
        
        tile.terrainSprite = terrainSprite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
