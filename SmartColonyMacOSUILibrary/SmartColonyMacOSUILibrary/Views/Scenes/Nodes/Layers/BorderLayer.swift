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

    // MARK: intern classes

    private class BorderLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let mainTexture: String
        let accentTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, mainTexture: String, accentTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.mainTexture = mainTexture
            self.accentTexture = accentTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.mainTexture)
            hasher.combine(self.accentTexture)
        }
    }

    private class BorderLayerHasher: BaseLayerHasher<BorderLayerTile> {

    }

    // MARK: variables

    private var hasher: BorderLayerHasher?

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
        self.hasher = BorderLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        for player in gameModel.players {

            if player.area.contains(tile.point) {

                if let textureMainName = self.textures?.borderMainTexture(at: tile.point, in: player.area) {
                    let image = ImageCache.shared.image(for: textureMainName)

                    let borderMainSprite = SKSpriteNode(texture: SKTexture(image: image), size: BorderLayer.kTextureSize)

                    borderMainSprite.position = position
                    borderMainSprite.zPosition = Globals.ZLevels.border
                    borderMainSprite.anchorPoint = CGPoint(x: 0, y: 0)
                    borderMainSprite.color = player.leader.civilization().main
                    borderMainSprite.colorBlendFactor = 1.0
                    self.addChild(borderMainSprite)

                    self.textureUtils?.set(mainBorderSprite: borderMainSprite, at: tile.point)
                }

                if let textureAccentName = self.textures?.borderAccentTexture(at: tile.point, in: player.area) {
                    let image = ImageCache.shared.image(for: textureAccentName)

                    let borderAccentSprite = SKSpriteNode(texture: SKTexture(image: image), size: BorderLayer.kTextureSize)

                    borderAccentSprite.position = position
                    borderAccentSprite.zPosition = Globals.ZLevels.border
                    borderAccentSprite.anchorPoint = CGPoint(x: 0, y: 0)
                    borderAccentSprite.color = player.leader.civilization().accent
                    borderAccentSprite.colorBlendFactor = 1.0
                    self.addChild(borderAccentSprite)

                    self.textureUtils?.set(accentBorderSprite: borderAccentSprite, at: tile.point)

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
            if let borderSprite = textureUtils.mainBorderSprite(at: tile.point) {
                self.removeChildren(in: [borderSprite])
            }

            if let borderSprite = textureUtils.accentBorderSprite(at: tile.point) {
                self.removeChildren(in: [borderSprite])
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

                if tile.isVisible(to: self.player) || self.showCompleteMap {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                }

                self.hasher?.update(hash: currentHashValue, at: tile.point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> BorderLayerTile {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var mainTexture: String = ""
        var accentTexture: String = ""

        for player in gameModel.players {

            if player.area.contains(tile.point) {

                if let textureMainName = self.textures?.borderMainTexture(at: tile.point, in: player.area) {
                    mainTexture = textureMainName
                }

                if let textureAccentName = self.textures?.borderAccentTexture(at: tile.point, in: player.area) {
                    accentTexture = textureAccentName
                    break
                }
            }
        }

        return BorderLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            mainTexture: mainTexture,
            accentTexture: accentTexture
        )
    }
}
