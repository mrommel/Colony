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

    func placeTileHex(for tile: AbstractTile, with calderaName: String, at position: CGPoint, alpha: CGFloat) {

        let image = ImageCache.shared.image(for: calderaName)

        let boardSprite = SKSpriteNode(texture: SKTexture(image: image), size: BoardLayer.kTextureSize)
        boardSprite.position = position
        boardSprite.zPosition = Globals.ZLevels.caldera
        boardSprite.anchorPoint = CGPoint(x: 0, y: 0.09)
        //boardSprite.alpha = alpha
        boardSprite.color = .black
        boardSprite.colorBlendFactor = 1.0 - alpha
        self.addChild(boardSprite)

        self.textureUtils?.set(boardSprite: boardSprite, at: tile.point)
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let boardSprite = textureUtils.boardSprite(at: tile.point) {
                self.removeChildren(in: [boardSprite])
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

                if let calderaName = self.textures?.calderaTexure(at: tile.point) {
                    if tile.isVisible(to: self.player) || self.showCompleteMap {
                        self.placeTileHex(for: tile, with: calderaName, at: screenPoint, alpha: 1.0)
                    } else if tile.isDiscovered(by: self.player) {
                        self.placeTileHex(for: tile, with: calderaName, at: screenPoint, alpha: 0.5)
                    }
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
