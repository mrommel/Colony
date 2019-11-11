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
    let civilization: Civilization

    init(civilization: Civilization) {
        
        self.civilization = civilization
        super.init()
        self.zPosition = GameScene.Constants.ZLevels.feature
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

    func placeTileHex(tile: Tile, at position: CGPoint, alpha: CGFloat) {

        var isIce = false
        
        // place forests etc
        for feature in tile.features {

            let textureName = feature.textureNamesHex.randomItem()

            let featureSprite = SKSpriteNode(imageNamed: textureName)
            featureSprite.position = position
            featureSprite.zPosition = feature.zLevel
            featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
            featureSprite.color = .black
            featureSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(featureSprite)

            tile.featureSprites.append(featureSprite)
            
            if feature == .ice {
                isIce = true
            }
        }
        
        if !isIce {
            if let tilePoint = tile.point {
                if let iceTexture = self.map?.iceTexture(at: tilePoint) {

                    let iceSprite = SKSpriteNode(imageNamed: iceTexture)
                    iceSprite.position = position
                    iceSprite.zPosition = Feature.ice.zLevel
                    iceSprite.anchorPoint = CGPoint(x: 0, y: 0)
                    iceSprite.color = .black
                    iceSprite.colorBlendFactor = 1.0 - alpha
                    self.addChild(iceSprite)

                    tile.iceSprite = iceSprite
                }
            }
        }
    }

    func clearTileHex(at pt: HexPoint) {
        
        guard let map = self.map else {
            fatalError("map not set")
        }
        
        if let tile = map.tile(at: pt) {
            self.removeChildren(in: tile.featureSprites)
            
            if let iceSprite = tile.iceSprite {
                self.removeChildren(in: [iceSprite])
            }
        }
    }
}

extension FeatureLayer: FogStateChangedDelegate {

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
            if fogManager.discovered(at: pt, by: self.civilization) {
                self.placeTileHex(tile: tile, at: screenPoint, alpha: 0.5)
            } else if fogManager.currentlyVisible(at: pt, by: self.civilization) {
                self.placeTileHex(tile: tile, at: screenPoint, alpha: 1.0)
            }
        }
    }
}
