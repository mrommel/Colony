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

    // MARK: intern classes

    private class YieldLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let foodTexture: String
        let productionTexture: String
        let goldTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, foodTexture: String, productionTexture: String, goldTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.foodTexture = foodTexture
            self.productionTexture = productionTexture
            self.goldTexture = goldTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.foodTexture)
            hasher.combine(self.productionTexture)
            hasher.combine(self.goldTexture)
        }
    }

    private class YieldLayerHasher: BaseLayerHasher<YieldLayerTile> {

    }

    // MARK: variables

    private var hasher: YieldLayerHasher?

    static let kName: String = "YieldLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.yields
        self.name = YieldLayer.kName
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
        self.hasher = YieldLayerHasher(with: gameModel)

        self.rebuild()
    }

    /// handles all yields
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let yields = tile.yields(for: self.player, ignoreFeature: false)

        // food texture
        if let textureName = self.textures?.foodTexture(for: yields) {

            let image = ImageCache.shared.image(for: textureName)

            let foodSprite = SKSpriteNode(texture: SKTexture(image: image), size: YieldLayer.kTextureSize)
            foodSprite.position = position
            foodSprite.zPosition = Globals.ZLevels.yields
            foodSprite.anchorPoint = CGPoint(x: 0, y: 0)
            foodSprite.color = .black
            foodSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(foodSprite)

            self.textureUtils?.set(foodSprite: foodSprite, at: tile.point)
        }

        // production texture
        if let textureName = self.textures?.productionTexture(for: yields) {

            let image = ImageCache.shared.image(for: textureName)

            let productionSprite = SKSpriteNode(texture: SKTexture(image: image), size: YieldLayer.kTextureSize)
            productionSprite.position = position
            productionSprite.zPosition = Globals.ZLevels.yields
            productionSprite.anchorPoint = CGPoint(x: 0, y: 0)
            productionSprite.color = .black
            productionSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(productionSprite)

            self.textureUtils?.set(productionSprite: productionSprite, at: tile.point)
        }

        // gold texture
        if let textureName = self.textures?.goldTexture(for: yields) {

            let image = ImageCache.shared.image(for: textureName)

            let goldSprite = SKSpriteNode(texture: SKTexture(image: image), size: YieldLayer.kTextureSize)
            goldSprite.position = position
            goldSprite.zPosition = Globals.ZLevels.yields
            goldSprite.anchorPoint = CGPoint(x: 0, y: 0)
            goldSprite.color = .black
            goldSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(goldSprite)

            self.textureUtils?.set(goldSprite: goldSprite, at: tile.point)
        }
    }

    func clear(tile: AbstractTile?) {

        if let tile = tile {
            if let foodSprite = self.textureUtils?.foodSprite(at: tile.point),
                let productionSprite = self.textureUtils?.productionSprite(at: tile.point),
                let goldSprite = self.textureUtils?.goldSprite(at: tile.point) {

                self.removeChildren(in: [foodSprite, productionSprite, goldSprite])
            }
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {
            let pt = tile.point

            let currentHashValue = self.hash(for: tile)
            if !self.hasher!.has(hash: currentHashValue, at: pt) {

                self.clear(tile: tile)

                let screenPoint = HexPoint.toScreen(hex: pt)

                if tile.isVisible(to: self.player) || self.showCompleteMap {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                } else if tile.isDiscovered(by: self.player) {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                }

                self.hasher?.update(hash: currentHashValue, at: tile.point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> YieldLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        let yields = tile.yields(for: self.player, ignoreFeature: false)

        var foodTexture: String = ""
        if let textureName = self.textures?.foodTexture(for: yields) {
            foodTexture = textureName
        }

        var productionTexture: String = ""
        if let textureName = self.textures?.productionTexture(for: yields) {
            productionTexture = textureName
        }

        var goldTexture: String = ""
        if let textureName = self.textures?.goldTexture(for: yields) {
            goldTexture = textureName
        }

        return YieldLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            foodTexture: foodTexture,
            productionTexture: productionTexture,
            goldTexture: goldTexture
        )
    }
}
