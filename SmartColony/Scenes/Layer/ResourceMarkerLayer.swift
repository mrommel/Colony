//
//  ResourceMarkerLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 12.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class ResourceMarkerLayer: SKNode {
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        
        super.init()
        self.zPosition = Globals.ZLevels.resourceMarker
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with gameModel: GameModel?) {
        
        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        self.textureUtils = TextureUtils(with: gameModel)
        
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                
                if let tile = gameModel.tile(at: pt) {
                    
                    let screenPoint = HexPoint.toScreen(hex: pt)
                    
                    if tile.isVisible(to: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                    } else if tile.isDiscovered(by: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                    }
                }
            }
        }
    }
    
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let resource = tile.resource(for: self.player)
        //let resource = tile.resource(for: nil)
        
        // place forests etc
        if resource != .none {

            let textureName = resource.textureMarkerName()

            let resourceSprite = SKSpriteNode(imageNamed: textureName)
            resourceSprite.position = position
            resourceSprite.zPosition = Globals.ZLevels.resourceMarker
            resourceSprite.anchorPoint = CGPoint(x: 0, y: 0)
            resourceSprite.color = .black
            resourceSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(resourceSprite)

            self.textureUtils?.set(resourceMarkerSprite: resourceSprite, at: tile.point)
        }
    }
    
    func clear(tile: AbstractTile?) {
        
        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }
        
        if let tile = tile {
            if let resourceSprite = textureUtils.resourceMarkerSprite(at: tile.point) {
                self.removeChildren(in: [resourceSprite])
            }
        }
    }
    
    func update(tile: AbstractTile?) {
        
        if let tile = tile {
            let pt = tile.point
            
            self.clear(tile: tile)
            
            let screenPoint = HexPoint.toScreen(hex: pt)
            
            if tile.isVisible(to: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
