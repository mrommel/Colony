//
//  BorderLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 25.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BorderLayer: SKNode {

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?

    // MARK: constructor

    init(player: AbstractPlayer?) {

        self.player = player
        
        super.init()
        self.zPosition = Globals.ZLevels.border
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

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {
                    let screenPoint = HexPoint.toScreen(hex: pt)

                    if tile.isVisible(to: self.player) {
                        self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                    }
                }
            }
        }
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        for player in gameModel.players {
        
            if player.area.contains(tile.point) {
                let textureName = self.texture(for: tile.point, in: player.area)
                
                let borderSprite = SKSpriteNode(imageNamed: textureName)
                borderSprite.position = position
                borderSprite.zPosition = tile.terrain().zLevel
                borderSprite.anchorPoint = CGPoint(x: 0, y: 0)
                borderSprite.color = player.leader.civilization().backgroundColor()
                borderSprite.colorBlendFactor = 1.0
                self.addChild(borderSprite)

                self.textureUtils?.set(borderSprite: borderSprite, at: tile.point)
                
                return
            }
        }
    }
    
    private func texture(for point: HexPoint, in area: HexArea) -> String {

        var textureName = "hex_border_"

        if !area.contains(where: { $0 == point.neighbor(in: .north) }) {
            textureName += "n_"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .northeast) }) {
            textureName += "ne_"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .southeast) }) {
            textureName += "se_"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .south) }) {
            textureName += "s_"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .southwest) }) {
            textureName += "sw_"
        }

        if !area.contains(where: { $0 == point.neighbor(in: .northwest) }) {
            textureName += "nw_"
        }

        if textureName == "hex_border_" {
            return "hex_border_all"
        }

        textureName.removeLast()
        return textureName
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
    
    func update(tile: AbstractTile?) {
        
        if let tile = tile {
            let pt = tile.point
            
            self.clear(tile: tile)
            
            let screenPoint = HexPoint.toScreen(hex: pt)
            
            if tile.isVisible(to: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            }
        }
    }
}
