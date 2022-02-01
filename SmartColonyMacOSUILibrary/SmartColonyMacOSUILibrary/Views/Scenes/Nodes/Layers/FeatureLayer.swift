//
//  FeatureLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class FeatureLayer: BaseLayer {

    // MARK: intern classes

    private class FeatureLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let featureTexture: String
        let iceTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, featureTexture: String, iceTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.featureTexture = featureTexture
            self.iceTexture = iceTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.featureTexture)
            hasher.combine(self.iceTexture)
        }
    }

    private class FeatureLayerHasher: BaseLayerHasher<FeatureLayerTile> {

    }

    // MARK: variables

    private var hasher: FeatureLayerHasher?

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.feature
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
        self.hasher = FeatureLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, neighborTiles: [HexDirection: AbstractTile?], at position: CGPoint, alpha: CGFloat) {

        let feature: FeatureType = tile.feature()

        // place forests etc
        if feature != .none {

            if let textureName = self.textures?.featureTexture(for: tile, neighborTiles: neighborTiles) {

                let image = ImageCache.shared.image(for: textureName)

                let featureSprite = SKSpriteNode(texture: SKTexture(image: image), size: FeatureLayer.kTextureSize)
                featureSprite.position = position
                featureSprite.zPosition = Globals.ZLevels.feature // feature.zLevel
                featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
                featureSprite.color = .black
                featureSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(featureSprite)

                self.textureUtils?.set(featureSprite: featureSprite, at: tile.point)
            }
        }

        if feature != .ice {
            if let iceTexture = self.textures?.iceTexture(at: tile.point) {

                let image = ImageCache.shared.image(for: iceTexture)

                let iceSprite = SKSpriteNode(texture: SKTexture(image: image), size: FeatureLayer.kTextureSize)
                iceSprite.position = position
                iceSprite.zPosition = Globals.ZLevels.feature
                iceSprite.anchorPoint = CGPoint(x: 0, y: 0)
                iceSprite.color = .black
                iceSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(iceSprite)

                self.textureUtils?.set(iceSprite: iceSprite, at: tile.point)
            }
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let featureSprite = textureUtils.featureSprite(at: tile.point) {
                self.removeChildren(in: [featureSprite])
            }

            if let iceSprite = textureUtils.iceSprite(at: tile.point) {
                self.removeChildren(in: [iceSprite])
            }
        }
    }

    override func update(tile: AbstractTile?) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        if let tile = tile {
            let pt = tile.point

            let neighborTileN = gameModel.tile(at: pt.neighbor(in: .north))
            let neighborTileNE = gameModel.tile(at: pt.neighbor(in: .northeast))
            let neighborTileSE = gameModel.tile(at: pt.neighbor(in: .southeast))
            let neighborTileS = gameModel.tile(at: pt.neighbor(in: .south))
            let neighborTileSW = gameModel.tile(at: pt.neighbor(in: .southwest))
            let neighborTileNW = gameModel.tile(at: pt.neighbor(in: .northwest))

            let neighborTiles: [HexDirection: AbstractTile?]  = [
                .north: neighborTileN,
                .northeast: neighborTileNE,
                .southeast: neighborTileSE,
                .south: neighborTileS,
                .southwest: neighborTileSW,
                .northwest: neighborTileNW
            ]

            let currentHashValue = self.hash(for: tile, neighborTiles: neighborTiles)
            if !self.hasher!.has(hash: currentHashValue, at: pt) {

                self.clear(tile: tile)

                let screenPoint = HexPoint.toScreen(hex: pt)

                if tile.isVisible(to: self.player) || self.showCompleteMap {
                    self.placeTileHex(for: tile, neighborTiles: neighborTiles, at: screenPoint, alpha: 1.0)
                } else if tile.isDiscovered(by: self.player) {
                    self.placeTileHex(for: tile, neighborTiles: neighborTiles, at: screenPoint, alpha: 0.5)
                }

                self.hasher?.update(hash: currentHashValue, at: tile.point)
            }
        }
    }

    private func hash(for tile: AbstractTile?, neighborTiles: [HexDirection: AbstractTile?]) -> FeatureLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var featureTexture: String = ""
        if tile.feature() != .none {
            if let featureTextureTmp = self.textures?.featureTexture(for: tile, neighborTiles: neighborTiles) {
                featureTexture = featureTextureTmp
            }
        }

        var iceTexture: String = ""
        if tile.feature() != .ice {
            if let iceTextureTmp = self.textures?.iceTexture(at: tile.point) {
                iceTexture = iceTextureTmp
            }
        }

        return FeatureLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            featureTexture: featureTexture,
            iceTexture: iceTexture
        )
    }
}
