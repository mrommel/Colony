//
//  BorderLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class BorderLayer: BaseLayer {

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.improvement
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: methods

    func populate(with gameModel: GameModel?) {

        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        self.textureUtils = TextureUtils(with: gameModel)
        self.textures = Textures(game: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        for player in gameModel.players {

            if player.area.contains(tile.point) {

                if let textureName = self.textures?.borderTexture(at: tile.point, in: player.area) {
                    let image = ImageCache.shared.image(for: textureName)

                    let borderSprite = SKSpriteNode(texture: SKTexture(image: image), size: BorderLayer.kTextureSize)

                    borderSprite.position = position
                    borderSprite.zPosition = Globals.ZLevels.border
                    borderSprite.anchorPoint = CGPoint(x: 0, y: 0)
                    borderSprite.color = player.leader.civilization().main
                    borderSprite.colorBlendFactor = 1.0
                    self.addChild(borderSprite)

                    self.textureUtils?.set(borderSprite: borderSprite, at: tile.point)

                    return
                }
            }
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let borderSprite = textureUtils.borderSprite(at: tile.point) {
                self.removeChildren(in: [borderSprite])
            }
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt)

            if tile.isVisible(to: self.player) || self.showCompleteMap {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            }
        }
    }
}
