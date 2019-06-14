//
//  BoardLayer.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BoardLayer: SKNode {

    weak var map: HexagonTileMap?

    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with map: HexagonTileMap?) {

        self.map = map

        guard let map = self.map else {
            fatalError("map not set")
        }
        
        map.fogManager?.delegates.addDelegate(self)

        for x in 0..<map.tiles.columns {
            for y in 0..<map.tiles.rows {
                if let tile = map.tiles[x, y] {
                    self.place(tile: tile)
                }
            }
        }
    }

    func place(tile: Tile) {

        guard let map = self.map else {
            fatalError("map not set")
        }

        guard let fogManager = self.map?.fogManager else {
            fatalError("fogManager not set")
        }
        
        if let pt = tile.point {
            let screenPoint = HexMapDisplay.shared.toScreen(hex: pt)

            if let calderaName = map.caldera(at: pt) {
                if fogManager.currentlyVisible(at: pt) {
                    self.placeTileHex(tile: tile, and: calderaName, at: screenPoint, alpha: GameScene.Constants.Visibility.currently)
                } else if fogManager.discovered(at: pt) {
                    self.placeTileHex(tile: tile, and: calderaName, at: screenPoint, alpha: GameScene.Constants.Visibility.discovered)
                }
            }
        }
    }

    func placeTileHex(tile: Tile, and calderaName: String, at position: CGPoint, alpha: CGFloat) {

        let boardSprite = SKSpriteNode(imageNamed: calderaName)
        boardSprite.position = position
        boardSprite.zPosition = GameScene.Constants.ZLevels.caldera
        boardSprite.anchorPoint = CGPoint(x: 0, y: 0.09)
        boardSprite.alpha = alpha
        self.addChild(boardSprite)

        tile.boardSprite = boardSprite
    }

    func clearTileHex(at pt: HexPoint) {

        guard let map = self.map else {
            fatalError("map not set")
        }

        if let tile = map.tiles[pt] {
            if let boardSprite = tile.boardSprite {
                self.removeChildren(in: [boardSprite])
            }
        }
    }
}

extension BoardLayer: FogStateChangedDelegate {

    func changed(to newState: FogState, at pt: HexPoint) {

        guard let map = self.map else {
            fatalError("map not set")
        }

        self.clearTileHex(at: pt)

        if let tile = map.tiles[pt] {

            self.place(tile: tile)
        }
    }
}
