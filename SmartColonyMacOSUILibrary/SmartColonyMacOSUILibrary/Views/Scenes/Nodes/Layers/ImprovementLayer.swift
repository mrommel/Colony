//
//  ImprovementLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class ImprovementLayer: BaseLayer {

    // MARK: intern classes

    private class ImprovementLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let improvementTexture: String
        let roadTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, improvementTexture: String, roadTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.improvementTexture = improvementTexture
            self.roadTexture = roadTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.improvementTexture)
            hasher.combine(self.roadTexture)
        }
    }

    private class ImprovementLayerHasher: BaseLayerHasher<ImprovementLayerTile> {

    }

    // MARK: variables

    private var hasher: ImprovementLayerHasher?

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.improvement
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
        self.hasher = ImprovementLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint, alpha: CGFloat) {

        let improvement = tile.improvement()

        // place farms/mines, ...
        if improvement != .none {

            let improvementTextureName = improvement.textureNames().item(from: tile.point)
            let image = ImageCache.shared.image(for: improvementTextureName)

            let improvementSprite = SKSpriteNode(texture: SKTexture(image: image), size: ImprovementLayer.kTextureSize)
            improvementSprite.position = position
            improvementSprite.zPosition = Globals.ZLevels.improvement
            improvementSprite.anchorPoint = CGPoint(x: 0, y: 0)
            improvementSprite.color = .black
            improvementSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(improvementSprite)

            self.textureUtils?.set(improvementSprite: improvementSprite, at: point)
        } else {
            for buildType in BuildType.allImprovements {
                if tile.buildProgress(of: buildType) > 0 {
                    print("render \(buildType) pre building animation")
                }
            }
        }

        let route = tile.route()

        if route != .none {

            if let roadTextureName = self.textures?.roadTexture(at: tile.point) {

                let image = ImageCache.shared.image(for: roadTextureName)

                let routeSprite = SKSpriteNode(texture: SKTexture(image: image), size: ImprovementLayer.kTextureSize)
                routeSprite.position = position
                routeSprite.zPosition = Globals.ZLevels.route
                routeSprite.anchorPoint = CGPoint(x: 0, y: 0)
                routeSprite.color = .black
                routeSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(routeSprite)

                self.textureUtils?.set(routeSprite: routeSprite, at: point)
            }
        }
    }

    override func clear(at point: HexPoint) {

        let alternatePoint = self.alternatePoint(for: point)

        if let improvementSprite = self.textureUtils?.improvementSprite(at: point) {
            self.removeChildren(in: [improvementSprite])
        }

        if let routeSprite = self.textureUtils?.routeSprite(at: point) {
            self.removeChildren(in: [routeSprite])
        }

        if let improvementSprite = self.textureUtils?.improvementSprite(at: alternatePoint) {
            self.removeChildren(in: [improvementSprite])
        }

        if let routeSprite = self.textureUtils?.routeSprite(at: alternatePoint) {
            self.removeChildren(in: [routeSprite])
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

    private func hash(for tile: AbstractTile?) -> ImprovementLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var improvementTexture: String = ""
        let improvement = tile.improvement()
        if improvement != .none {
            improvementTexture = improvement.textureNames().item(from: tile.point)
        }

        var roadTexture: String = ""
        let route = tile.route()
        if route != .none {
            if let roadTextureName = self.textures?.roadTexture(at: tile.point) {
                roadTexture = roadTextureName
            }
        }

        return ImprovementLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            improvementTexture: improvementTexture,
            roadTexture: roadTexture
        )
    }
}
