//
//  RiverLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class RiverLayer: BaseLayer {
    
    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.river
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
        self.textures = Textures(game: gameModel)
        
        self.rebuild()
    }
    
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        if let riverTextureName = self.textures?.riverTexture(at: tile.point) {
            
            let image = ImageCache.shared.image(for: riverTextureName)

            let riverSprite = SKSpriteNode(texture: SKTexture(image: image), size: RiverLayer.kTextureSize)
            riverSprite.position = position
            riverSprite.zPosition = Globals.ZLevels.river
            riverSprite.anchorPoint = CGPoint(x: 0, y: 0)
            riverSprite.color = .black
            riverSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(riverSprite)

            self.textureUtils?.set(riverSprite: riverSprite, at: tile.point)
        }
    }
    
    func clear(tile: AbstractTile?) {
        
        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }
        
        if let tile = tile {
            if let riverSprite = textureUtils.riverSprite(at: tile.point) {
                self.removeChildren(in: [riverSprite])
            }
        }
    }
    
    override func update(tile: AbstractTile?) {
        
        if let tile = tile {
            let pt = tile.point
            
            self.clear(tile: tile)
            
            let screenPoint = HexPoint.toScreen(hex: pt)
            
            if tile.isVisible(to: self.player) || self.showCompleteMap {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
