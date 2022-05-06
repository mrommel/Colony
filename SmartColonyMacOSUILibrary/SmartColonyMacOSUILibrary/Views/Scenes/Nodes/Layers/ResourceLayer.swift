//
//  ResourceLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class ResourceLayer: BaseLayer {

    // MARK: intern classes

    private class ResourceLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let resourceTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, resourceTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.resourceTexture = resourceTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.resourceTexture)
        }
    }

    private class ResourceLayerHasher: BaseLayerHasher<ResourceLayerTile> {

    }

    // MARK: variables

    private var hasher: ResourceLayerHasher?

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.resource
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
        self.hasher = ResourceLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint, alpha: CGFloat) {

        let resource = tile.resource(for: self.player)
        // let resource = tile.resource(for: nil)

        // place forests etc
        if resource != .none {

            let resourceTextureName = resource.textureName()
            let image = ImageCache.shared.image(for: resourceTextureName)

            let resourceSprite = SKSpriteNode(texture: SKTexture(image: image), size: ResourceLayer.kTextureSize)
            resourceSprite.position = position
            resourceSprite.zPosition = Globals.ZLevels.resource
            resourceSprite.anchorPoint = CGPoint(x: 0, y: 0)
            resourceSprite.color = .black
            resourceSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(resourceSprite)

            self.textureUtils?.set(resourceSprite: resourceSprite, at: point)
        }
    }

    override func clear(at point: HexPoint) {

        let alternatePoint = self.alternatePoint(for: point)

        if let resourceSprite = self.textureUtils?.resourceSprite(at: point) {
            self.removeChildren(in: [resourceSprite])
        }

        if let resourceSprite = self.textureUtils?.resourceSprite(at: alternatePoint) {
            self.removeChildren(in: [resourceSprite])
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

    private func hash(for tile: AbstractTile?) -> ResourceLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var resourceTexture: String = ""
        let resource = tile.resource(for: self.player)
        if resource != .none {
            resourceTexture = resource.textureName()
        }

        return ResourceLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            resourceTexture: resourceTexture
        )
    }
}
