//
//  FeatureLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class FeatureLayer: SKNode {
    
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
                    self.placeTileHex(tile: tile, at: screenPoint)
                }
            }
        }
    }
    
    func placeTileHex(tile: Tile, at position: CGPoint) {
        
        // place forests etc
        for feature in tile.features {
            
            let textureName = feature.textureNamesHex.randomItem()
            
            let featureSprite = SKSpriteNode(imageNamed: textureName)
            featureSprite.position = position
            featureSprite.zPosition = feature.zLevel // GameSceneConstants.ZLevels.feature // maybe need to come from feature itself
            featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
            self.addChild(featureSprite)
            
            tile.featureSprites.append(featureSprite)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
