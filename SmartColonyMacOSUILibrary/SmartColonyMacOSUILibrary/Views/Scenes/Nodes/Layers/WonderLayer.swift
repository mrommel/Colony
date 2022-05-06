//
//  WonderLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.11.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class WonderLayer: BaseLayer {

    // MARK: intern classes

    private class WonderLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let wonderTexture: String
        let buildingWonderTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, wonderTexture: String, buildingWonderTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.wonderTexture = wonderTexture
            self.buildingWonderTexture = buildingWonderTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.wonderTexture)
            hasher.combine(self.buildingWonderTexture)
        }
    }

    private class WonderLayerHasher: BaseLayerHasher<WonderLayerTile> {

    }

    // MARK: variables

    private var hasher: WonderLayerHasher?

    static let kName: String = "WonderLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.wonder
        self.name = WonderLayer.kName
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
        self.hasher = WonderLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let wonder = tile.wonder()
        let buildingWonder = tile.buildingWonder()

        // place wonder
        if wonder != .none {

            let wonderTextureName: String = wonder.textureName()
            let image = ImageCache.shared.image(for: wonderTextureName)

            let wonderSprite = SKSpriteNode(texture: SKTexture(image: image), size: WonderLayer.kTextureSize)
            wonderSprite.position = position
            wonderSprite.zPosition = Globals.ZLevels.wonder
            wonderSprite.anchorPoint = CGPoint(x: 0, y: 0)
            wonderSprite.color = .black
            wonderSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(wonderSprite)

            self.textureUtils?.set(wonderSprite: wonderSprite, at: tile.point)

        } else if buildingWonder != .none {

            // print("render \(buildingDistrict) pre building animation")
            let wonderTextureName: String = buildingWonder.buildingTextureName()
            let image = ImageCache.shared.image(for: wonderTextureName)

            let wonderBuildingSprite = SKSpriteNode(texture: SKTexture(image: image), size: WonderLayer.kTextureSize)
            wonderBuildingSprite.position = position
            wonderBuildingSprite.zPosition = Globals.ZLevels.wonder
            wonderBuildingSprite.anchorPoint = CGPoint(x: 0, y: 0)
            wonderBuildingSprite.color = .black
            wonderBuildingSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(wonderBuildingSprite)

            self.textureUtils?.set(wonderBuildingSprite: wonderBuildingSprite, at: tile.point)
        }
    }

    override func clear(at point: HexPoint) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let wonderSprite = textureUtils.wonderSprite(at: point) {
            self.removeChildren(in: [wonderSprite])
        }

        if let wonderBuildingSprite = textureUtils.wonderBuildingSprite(at: point) {
            self.removeChildren(in: [wonderBuildingSprite])
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {

            let point = tile.point
            let currentHashValue = self.hash(for: tile)
            if !self.hasher!.has(hash: currentHashValue, at: point) {

                self.clear(at: point)

                let screenPoint = HexPoint.toScreen(hex: point)

                if tile.isVisible(to: self.player) || self.showCompleteMap {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                } else if tile.isDiscovered(by: self.player) {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                }

                self.hasher?.update(hash: currentHashValue, at: point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> WonderLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var wonderTexture: String = ""
        var buildingWonderTexture: String = ""
        let wonder = tile.wonder()
        let buildingWonder = tile.buildingWonder()

        if wonder != .none {
            wonderTexture = wonder.textureName()
        } else if buildingWonder != .none {
            buildingWonderTexture = buildingWonder.buildingTextureName()
        }

        return WonderLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            wonderTexture: wonderTexture,
            buildingWonderTexture: buildingWonderTexture
        )
    }
}
