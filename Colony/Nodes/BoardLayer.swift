//
//  BoardLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BoardLayer: SKNode {
    
    let mapDisplay: HexMapDisplay
    
    init(with size: CGSize, and mapDisplay: HexMapDisplay) {
        
        self.mapDisplay = mapDisplay
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with map: HexagonTileMap) {
        
        for index0 in 0..<map.tiles.columns {
            for index1 in 0..<map.tiles.rows {
                if let tile = map.tiles[index0, index1] {
                    let screenPoint = self.mapDisplay.toScreen(hex: HexPoint(x: index0, y: index1))
                    
                    if let point = tile.point, let calderaName = map.caldera(at: point) {
                        self.placeTileHex(tile: tile, and: calderaName, at: screenPoint)
                    }
                }
            }
        }
    }
    
    func placeTileHex(tile: Tile, and calderaName: String, at position: CGPoint) {
        
        let boardSprite = SKSpriteNode(imageNamed: calderaName)
        boardSprite.position = position
        boardSprite.zPosition = GameScene.Constants.ZLevels.caldera
        boardSprite.anchorPoint = CGPoint(x: 0, y: 0.09)
        self.addChild(boardSprite)
    }
}
