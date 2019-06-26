//
//  FeatureLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class FeatureLayer: SKNode {

    weak var map: HexagonTileMap?

    override init() {
        
        super.init()
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
                    if fogManager.discovered(at: pt) {
                        self.placeTileHex(tile: tile, at: screenPoint, alpha: 0.5)
                    } else if fogManager.currentlyVisible(at: pt) {
                        self.placeTileHex(tile: tile, at: screenPoint, alpha: 1.0)
                    }
                }
            }
        }
    }

    func placeTileHex(tile: Tile, at position: CGPoint, alpha: CGFloat) {

        // place forests etc
        for feature in tile.features {

            let textureName = feature.textureNamesHex.randomItem()

            let featureSprite = SKSpriteNode(imageNamed: textureName)
            featureSprite.position = position
            featureSprite.zPosition = feature.zLevel // GameSceneConstants.ZLevels.feature // maybe need to come from feature itself
            featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
            featureSprite.alpha = alpha
            self.addChild(featureSprite)

            tile.featureSprites.append(featureSprite)
        }
    }

    func clearTileHex(at pt: HexPoint) {
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tile(at: pt) {
            self.removeChildren(in: tile.featureSprites)
        }
    }
}

extension FeatureLayer: FogStateChangedDelegate {

    func changed(to newState: FogState, at pt: HexPoint) {

        guard let map = self.map else {
            fatalError("map not set")
        }

        guard let fogManager = self.map?.fogManager else {
            fatalError("fogManager not set")
        }
        
        self.clearTileHex(at: pt)

        if let tile = map.tile(at: pt) {
            let screenPoint = HexMapDisplay.shared.toScreen(hex: pt)
            if fogManager.discovered(at: pt) {
                self.placeTileHex(tile: tile, at: screenPoint, alpha: 0.5)
            } else if fogManager.currentlyVisible(at: pt) {
                self.placeTileHex(tile: tile, at: screenPoint, alpha: 1.0)
            }
        }
    }
}
