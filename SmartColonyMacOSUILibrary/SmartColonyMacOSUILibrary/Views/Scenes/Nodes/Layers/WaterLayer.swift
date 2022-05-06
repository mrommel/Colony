//
//  WaterLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class WaterLayer: BaseLayer {

    // MARK: intern classes

    private class WaterLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let waterTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, waterTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.waterTexture = waterTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.waterTexture)
        }
    }

    private class WaterLayerHasher: BaseLayerHasher<WaterLayerTile> {

    }

    // MARK: variables

    private var hasher: WaterLayerHasher?

    static let kName: String = "WaterLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.water
        self.name = WaterLayer.kName
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
        self.hasher = WaterLayerHasher(with: gameModel)

        self.rebuild()
    }

    /// handles all terrain
    func placeWaterHex(for point: HexPoint, at position: CGPoint) {

        let image = ImageCache.shared.image(for: "water")

        let waterSprite = SKSpriteNode(texture: SKTexture(image: image), size: WaterLayer.kTextureSize)
        waterSprite.position = position
        waterSprite.zPosition = Globals.ZLevels.water
        waterSprite.anchorPoint = CGPoint(x: 0, y: 0)
        waterSprite.color = .black
        waterSprite.colorBlendFactor = 0.0
        self.addChild(waterSprite)

        self.textureUtils?.set(waterSprite: waterSprite, at: point)
    }

    override func clear(at point: HexPoint) {

        if let waterSprite = self.textureUtils?.waterSprite(at: point) {
            self.removeChildren(in: [waterSprite])
        }
    }

    override func update(tile: AbstractTile?) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        if let tile = tile {

            let point = tile.point
            let currentHashValue = self.hash(for: tile)
            if !self.hasher!.has(hash: currentHashValue, at: point) {

                self.clear(at: point)

                let screenPoint = HexPoint.toScreen(hex: point)

                if tile.isVisible(to: self.player) && gameModel.isFreshWater(at: point) || self.showCompleteMap {
                    self.placeWaterHex(for: point, at: screenPoint)
                }

                self.hasher?.update(hash: currentHashValue, at: point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> WaterLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var waterTexture: String = ""
        if self.gameModel?.isFreshWater(at: tile.point) ?? false {
            waterTexture = "water"
        }

        return WaterLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            waterTexture: waterTexture
        )
    }
}
