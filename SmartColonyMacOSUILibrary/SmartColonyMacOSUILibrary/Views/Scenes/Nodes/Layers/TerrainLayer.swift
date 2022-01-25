//
//  TerrainLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class TerrainLayer: BaseLayer {

    // MARK: intern classes

    private class TerrainLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let terrainTexture: String
        let snowTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, terrainTexture: String, snowTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.terrainTexture = terrainTexture
            self.snowTexture = snowTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.terrainTexture)
            hasher.combine(self.snowTexture)
        }
    }

    private class TerrainLayerHasher: BaseLayerHasher<TerrainLayerTile> {

    }

    private var hasher: TerrainLayerHasher?

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.terrain
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
        self.hasher = TerrainLayerHasher(with: gameModel)

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {
                    let screenPoint = HexPoint.toScreen(hex: pt)

                    if tile.isVisible(to: self.player) || self.showCompleteMap {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                    } else if tile.isDiscovered(by: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                    }

                    self.hasher?.update(hash: self.hash(for: tile), at: tile.point)
                }
            }
        }
    }

    /// handles all terrain
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        // place terrain
        if let terrainTexture = self.textures?.terrainTexture(at: tile.point) {

            let image = ImageCache.shared.image(for: terrainTexture)

            let terrainSprite = SKSpriteNode(texture: SKTexture(image: image), size: TerrainLayer.kTextureSize)
            terrainSprite.position = position
            terrainSprite.zPosition = tile.terrain().zLevel
            terrainSprite.anchorPoint = CGPoint(x: 0, y: 0)
            terrainSprite.color = .black
            terrainSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(terrainSprite)

            self.textureUtils?.set(terrainSprite: terrainSprite, at: tile.point)
        }

        // place snow
        if tile.terrain() != .snow {

            if let snowTexture = self.textures?.snowTexture(at: tile.point) {

                let image = ImageCache.shared.image(for: snowTexture)

                let snowSprite = SKSpriteNode(texture: SKTexture(image: image), size: TerrainLayer.kTextureSize)
                snowSprite.position = position
                snowSprite.zPosition = Globals.ZLevels.snow
                snowSprite.anchorPoint = CGPoint(x: 0, y: 0)
                snowSprite.color = .black
                snowSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(snowSprite)

                self.textureUtils?.set(snowSprite: snowSprite, at: tile.point)
            }
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let terrainSprite = textureUtils.terrainSprite(at: tile.point) {
                self.removeChildren(in: [terrainSprite])
            }

            if let snowSprite = textureUtils.snowSprite(at: tile.point) {
                self.removeChildren(in: [snowSprite])
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

    private func hash(for tile: AbstractTile?) -> TerrainLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var terrainTexture: String = ""
        if let terrainTextureTmp = self.textures?.terrainTexture(at: tile.point) {
            terrainTexture = terrainTextureTmp
        }

        var snowTexture: String = ""
        if tile.terrain() != .snow {
            if let snowTextureTmp = self.textures?.snowTexture(at: tile.point) {
                snowTexture = snowTextureTmp
            }
        }

        return TerrainLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            terrainTexture: terrainTexture,
            snowTexture: snowTexture
        )
    }
}
