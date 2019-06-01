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
    
    init(with size: CGSize, and mapDisplay: HexMapDisplay) {
        
        self.mapDisplay = mapDisplay
        
        super.init()
    }
    
    func populate(with map: HexagonTileMap) {
        
        for index0 in 0..<map.tiles.columns {
            for index1 in 0..<map.tiles.rows {
                if let tile = map.tiles[index0, index1] {
                    let screenPoint = self.mapDisplay.toScreen(hex: HexPoint(x: index0, y: index1))
                    
                    for flow in map.flows(at: tile.point!) {
                        
                        self.placeTileHex(flow: flow, at: screenPoint)
                    }
                }
            }
        }
    }
    
    func placeTileHex(flow: FlowDirection, at position: CGPoint) {
        
        let flowTextureName = "flow_\(flow.stringValue)"
        
        let riverFlowSprite = SKSpriteNode(imageNamed: flowTextureName)
        riverFlowSprite.position = position
        riverFlowSprite.zPosition = GameScene.Constants.ZLevels.river
        riverFlowSprite.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(riverFlowSprite)
        
        //tile.terrainSprite = terrainSprite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
