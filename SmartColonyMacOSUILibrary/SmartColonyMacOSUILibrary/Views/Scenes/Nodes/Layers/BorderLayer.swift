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
        let owner: LeaderType

        init(point: HexPoint, visible: Bool, discovered: Bool, owner: LeaderType, mainTexture: String, accentTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.owner = owner
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
            hasher.combine(self.owner)
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

    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint, alpha: CGFloat) {

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

                    self.textureUtils?.set(mainBorderSprite: borderMainSprite, at: point)
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

                    self.textureUtils?.set(accentBorderSprite: borderAccentSprite, at: point)

                    return
                }
            }
        }
    }

    override func clear(at point: HexPoint) {

        let alternatePoint = self.alternatePoint(for: point)

        if let borderSprite = self.textureUtils?.mainBorderSprite(at: point) {
            self.removeChildren(in: [borderSprite])
        }

        if let borderSprite = self.textureUtils?.accentBorderSprite(at: point) {
            self.removeChildren(in: [borderSprite])
        }

        if let borderSprite = self.textureUtils?.mainBorderSprite(at: alternatePoint) {
            self.removeChildren(in: [borderSprite])
        }

        if let borderSprite = self.textureUtils?.accentBorderSprite(at: alternatePoint) {
            self.removeChildren(in: [borderSprite])
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
        var owner: LeaderType = .none

        for player in gameModel.players {

            if player.area.contains(tile.point) {

                owner = player.leader

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
            owner: owner,
            mainTexture: mainTexture,
            accentTexture: accentTexture
        )
    }
}
