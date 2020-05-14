//
//  YieldLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 29.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class YieldLayer: SKNode {

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    // MARK: constructor

    init(player: AbstractPlayer?) {

        self.player = player

        super.init()
        self.zPosition = Globals.ZLevels.yields
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

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {
                    let screenPoint = HexPoint.toScreen(hex: pt)

                    if tile.isVisible(to: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                    } else if tile.isDiscovered(by: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                    }
                }
            }
        }
    }

    /// handles all terrain
    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        let yields = tile.yields(for: self.player, ignoreFeature: false)

        // yield textures
        if let textureName = textureUtils.yieldTexture(for: yields) {

            let yieldsSprite = SKSpriteNode(imageNamed: textureName)
            yieldsSprite.position = position
            yieldsSprite.zPosition = Globals.ZLevels.yields
            yieldsSprite.anchorPoint = CGPoint(x: 0, y: 0)
            yieldsSprite.color = .black
            yieldsSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(yieldsSprite)

            self.textureUtils?.set(yieldsSprite: yieldsSprite, at: tile.point)
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let yieldsSprite = textureUtils.yieldsSprite(at: tile.point) {
                self.removeChildren(in: [yieldsSprite])
            }
        }
    }

    func update(tile: AbstractTile?) {

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt)

            if tile.isVisible(to: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
