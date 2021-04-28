//
//  YieldLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class YieldLayer: SKNode {

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    var textures: Textures?

    // MARK: constructor

    init(player: AbstractPlayer?) {

        self.player = player

        super.init()
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

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {
                    let screenPoint = HexPoint.toScreen(hex: pt) * 3.0

                    if tile.isVisible(to: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                    } else if tile.isDiscovered(by: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                    }
                }
            }
        }
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

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let yieldsSprite = textureUtils.yieldsSprite(at: tile.point) {
                self.removeChildren(in: [yieldsSprite])
            }
        }
    }

    func update(tile: AbstractTile?) {

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt) * 3.0

            if tile.isVisible(to: self.player) || true {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
