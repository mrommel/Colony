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

    // MARK: intern classes

    private class RiverLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let riverName: String

        init(point: HexPoint, visible: Bool, discovered: Bool, riverName: String) {

            self.visible = visible
            self.discovered = discovered
            self.riverName = riverName

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.riverName)
        }
    }

    private class RiverLayerHasher: BaseLayerHasher<RiverLayerTile> {

    }

    // MARK: variables

    private var hasher: RiverLayerHasher?

    // MARK: constructor

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
        self.hasher = RiverLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint, alpha: CGFloat) {

        if let riverTextureName = self.textures?.riverTexture(at: tile.point) {

            let image = ImageCache.shared.image(for: riverTextureName)

            let riverSprite = SKSpriteNode(texture: SKTexture(image: image), size: RiverLayer.kTextureSize)
            riverSprite.position = position
            riverSprite.zPosition = Globals.ZLevels.river
            riverSprite.anchorPoint = CGPoint(x: 0, y: 0)
            riverSprite.color = .black
            riverSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(riverSprite)

            self.textureUtils?.set(riverSprite: riverSprite, at: point)
        }
    }

    override func clear(at point: HexPoint) {

        let alternatePoint = self.alternatePoint(for: point)

        if let riverSprite = self.textureUtils?.riverSprite(at: point) {
            self.removeChildren(in: [riverSprite])
        }

        if let riverSprite = self.textureUtils?.riverSprite(at: alternatePoint) {
            self.removeChildren(in: [riverSprite])
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {

            let currentHashValue = self.hash(for: tile)
            if !self.hasher!.has(hash: currentHashValue, at: tile.point) {

                self.clear(at: tile.point)

                let originalPoint = tile.point
                let originalScreenPoint = HexPoint.toScreen(hex: originalPoint)
                let alternatePoint = self.alternatePoint(for: originalPoint)
                let alternateScreenPoint = HexPoint.toScreen(hex: alternatePoint)

                if tile.isVisible(to: self.player) || self.showCompleteMap {
                    self.placeTileHex(for: tile, and: originalPoint, at: originalScreenPoint, alpha: 1.0)
                    self.placeTileHex(for: tile, and: alternatePoint, at: alternateScreenPoint, alpha: 1.0)
                } else if tile.isDiscovered(by: self.player) {
                    self.placeTileHex(for: tile, and: originalPoint, at: originalScreenPoint, alpha: 0.5)
                    self.placeTileHex(for: tile, and: alternatePoint, at: alternateScreenPoint, alpha: 0.5)
                }

                self.hasher?.update(hash: currentHashValue, at: tile.point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> RiverLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var riverName: String = ""
        if let riverTextureTmp = self.textures?.riverTexture(at: tile.point) {
            riverName = riverTextureTmp
        }

        return RiverLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            riverName: riverName
        )
    }
}
