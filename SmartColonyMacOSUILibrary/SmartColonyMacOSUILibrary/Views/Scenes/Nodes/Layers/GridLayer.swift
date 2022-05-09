//
//  WaterLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class GridLayer: BaseLayer {

    // MARK: intern classes

    private class GridLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool

        init(point: HexPoint, visible: Bool, discovered: Bool) {

            self.visible = visible
            self.discovered = discovered

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
        }
    }

    private class GridLayerHasher: BaseLayerHasher<GridLayerTile> {

    }

    // MARK: variables

    private var hasher: GridLayerHasher?

    static let kName: String = "GridLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.grid
        self.name = GridLayer.kName
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
        self.hasher = GridLayerHasher(with: gameModel)

        self.rebuild()
    }

    /// handles all terrain
    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint) {

        let image = ImageCache.shared.image(for: "grid")

        let gridSprite = SKSpriteNode(texture: SKTexture(image: image), size: GridLayer.kTextureSize)
        gridSprite.position = position
        gridSprite.zPosition = Globals.ZLevels.grid
        gridSprite.anchorPoint = CGPoint(x: 0, y: 0)
        gridSprite.color = .black
        gridSprite.colorBlendFactor = 0.0
        self.addChild(gridSprite)

        self.textureUtils?.set(gridSprite: gridSprite, at: point)
    }

    override func clear(at point: HexPoint) {

        if let gridSprite = self.textureUtils?.gridSprite(at: point) {
            self.removeChildren(in: [gridSprite])
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {

            let point = tile.point
            let currentHashValue = self.hash(for: tile)
            if !self.hasher!.has(hash: currentHashValue, at: point) {

                self.clear(at: point)

                let originalPoint = tile.point
                let originalScreenPoint = HexPoint.toScreen(hex: originalPoint)
                let alternatePoint = self.alternatePoint(for: originalPoint)
                let alternateScreenPoint = HexPoint.toScreen(hex: alternatePoint)

                if tile.isDiscovered(by: self.player) || self.showCompleteMap {
                    self.placeTileHex(for: tile, and: originalPoint, at: originalScreenPoint)
                    self.placeTileHex(for: tile, and: alternatePoint, at: alternateScreenPoint)
                }

                self.hasher?.update(hash: currentHashValue, at: point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> GridLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        return GridLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player)
        )
    }
}
