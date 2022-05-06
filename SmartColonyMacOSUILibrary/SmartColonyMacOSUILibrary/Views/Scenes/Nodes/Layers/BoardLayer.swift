//
//  BorderLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class BoardLayer: BaseLayer {

    // MARK: intern classes

    private class BoardLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let calderaName: String

        init(point: HexPoint, visible: Bool, discovered: Bool, calderaName: String) {

            self.visible = visible
            self.discovered = discovered
            self.calderaName = calderaName

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.calderaName)
        }
    }

    private class BoardLayerHasher: BaseLayerHasher<BoardLayerTile> {

    }

    // MARK: variables

    private var hasher: BoardLayerHasher?

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.labels
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
        self.hasher = BoardLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint, alpha: CGFloat) {

        if let calderaName = self.textures?.calderaTexure(at: tile.point) {
            let image = ImageCache.shared.image(for: calderaName)

            let boardSprite = SKSpriteNode(texture: SKTexture(image: image), size: BoardLayer.kTextureSize)
            boardSprite.position = position
            boardSprite.zPosition = Globals.ZLevels.caldera
            boardSprite.anchorPoint = CGPoint(x: 0, y: 0.09)
            // boardSprite.alpha = alpha
            boardSprite.color = .black
            boardSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(boardSprite)

            self.textureUtils?.set(boardSprite: boardSprite, at: point)
        }
    }

    override func clear(at point: HexPoint) {

        let alternatePoint = self.alternatePoint(for: point)

        if let boardSprite = self.textureUtils?.boardSprite(at: point) {
            self.removeChildren(in: [boardSprite])
        }

        if let boardSprite = self.textureUtils?.boardSprite(at: alternatePoint) {
            self.removeChildren(in: [boardSprite])
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

    private func hash(for tile: AbstractTile?) -> BoardLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var calderaName: String = ""
        if let calderaNameTmp = self.textures?.calderaTexure(at: tile.point) {
            calderaName = calderaNameTmp
        }

        return BoardLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            calderaName: calderaName
        )
    }
}
