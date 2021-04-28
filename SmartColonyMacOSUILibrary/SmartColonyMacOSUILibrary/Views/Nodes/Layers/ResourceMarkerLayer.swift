//
//  ResourceMarkerLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class ResourceMarkerLayer: BaseLayer {
    
    override init(player: AbstractPlayer?) {
        
        super.init(player: player)
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

        self.rebuild()
    }
    
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let resource = tile.resource(for: self.player)
        //let resource = tile.resource(for: nil)
        
        // place forests etc
        if resource != .none {

            let textureName = resource.textureMarkerName()
            
            let image = ImageCache.shared.image(for: textureName)

            let resourceSprite = SKSpriteNode(texture: SKTexture(image: image), size: CGSize(width: 144, height: 144))
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
    
    override func update(tile: AbstractTile?) {
        
        if let tile = tile {
            let pt = tile.point
            
            self.clear(tile: tile)
            
            let screenPoint = HexPoint.toScreen(hex: pt) * 3.0
            
            if tile.isVisible(to: self.player) || self.showCompleteMap {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
