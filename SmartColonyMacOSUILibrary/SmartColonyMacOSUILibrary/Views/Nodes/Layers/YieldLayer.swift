//
//  YieldLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class YieldLayer: BaseLayer {

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.yields
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

        let mapSize = gameModel.mapSize()

        self.rebuild()
    }

    /// handles all terrain
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let yields = tile.yields(for: self.player, ignoreFeature: false)

        // yield textures
        if let textureName = self.textures?.yieldTexture(for: yields) {
            
            let image = ImageCache.shared.image(for: textureName)

            let yieldsSprite = SKSpriteNode(texture: SKTexture(image: image), size: CGSize(width: 144, height: 144))
            yieldsSprite.position = position
            yieldsSprite.zPosition = Globals.ZLevels.yields
            yieldsSprite.anchorPoint = CGPoint(x: 0, y: 0)
            yieldsSprite.color = .black
            yieldsSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(yieldsSprite)

            self.textureUtils?.set(yieldsSprite: yieldsSprite, at: tile.point)
        }
    }

    func clear(tile: AbstractTile?) {

        if let tile = tile {
            if let yieldsSprite = self.textureUtils?.yieldsSprite(at: tile.point) {
                self.removeChildren(in: [yieldsSprite])
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
