//
//  WaterLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 02.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class WaterLayer: SKNode {

    var player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    // MARK: constructor

    init(player: AbstractPlayer?) {

        self.player = player

        super.init()
        self.zPosition = Globals.ZLevels.water
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

                    if tile.isVisible(to: self.player) && gameModel.isFreshWater(at: pt) {
                        self.placeWaterHex(for: pt, at: screenPoint)
                    }
                }
            }
        }
    }

    /// handles all terrain
    func placeWaterHex(for point: HexPoint, at position: CGPoint) {

        let waterSprite = SKSpriteNode(imageNamed: "water")
        waterSprite.position = position
        waterSprite.zPosition = Globals.ZLevels.water
        waterSprite.anchorPoint = CGPoint(x: 0, y: 0)
        waterSprite.color = .black
        waterSprite.colorBlendFactor = 0.0
        self.addChild(waterSprite)

        self.textureUtils?.set(waterSprite: waterSprite, at: point)
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let waterSprite = textureUtils.waterSprite(at: tile.point) {
                self.removeChildren(in: [waterSprite])
            }
        }
    }

    func update(tile: AbstractTile?) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt)

            if tile.isVisible(to: self.player) && gameModel.isFreshWater(at: pt) {
                self.placeWaterHex(for: pt, at: screenPoint)
            }
        }
    }
}
