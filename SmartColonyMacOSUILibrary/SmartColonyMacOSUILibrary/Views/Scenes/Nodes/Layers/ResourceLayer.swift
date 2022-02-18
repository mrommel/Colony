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

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

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

            self.textureUtils?.set(resourceSprite: resourceSprite, at: tile.point)
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let resourceSprite = textureUtils.resourceSprite(at: tile.point) {
                self.removeChildren(in: [resourceSprite])
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
                } else if tile.isDiscovered(by: self.player) {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
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
