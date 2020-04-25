//
//  BoardLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BoardLayer: SKNode {

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    init(player: AbstractPlayer?) {

        self.player = player

        super.init()
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

        // map.fogManager?.delegates.addDelegate(self)
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                if let tile = gameModel.tile(x: x, y: y) {
                    //self.place(tile: tile)
                    let screenPoint = HexPoint.toScreen(hex: tile.point)

                    if let calderaName = self.textureUtils?.calderaTexure(at: tile.point) {

                        if tile.isVisible(to: self.player) {
                            self.placeTileHex(for: tile, with: calderaName, at: screenPoint, alpha: 1.0)
                        } else if tile.isDiscovered(by: self.player) {
                            self.placeTileHex(for: tile, with: calderaName, at: screenPoint, alpha: 0.5)
                        }
                    }
                }
            }
        }
    }

    func placeTileHex(for tile: AbstractTile, with calderaName: String, at position: CGPoint, alpha: CGFloat) {

        let boardSprite = SKSpriteNode(imageNamed: calderaName)
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

    func update(tile: AbstractTile?) {

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt)

            if let calderaName = self.textureUtils?.calderaTexure(at: tile.point) {
                if tile.isVisible(to: self.player) {
                    self.placeTileHex(for: tile, with: calderaName, at: screenPoint, alpha: 1.0)
                } else if tile.isDiscovered(by: self.player) {
                    self.placeTileHex(for: tile, with: calderaName, at: screenPoint, alpha: 0.5)
                }
            }
        }
    }
}
