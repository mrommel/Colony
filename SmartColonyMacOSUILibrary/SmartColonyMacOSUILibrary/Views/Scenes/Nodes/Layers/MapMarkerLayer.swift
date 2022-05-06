//
//  MapMarkerLayer.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 30.04.22.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class MapMarkerLayer: BaseLayer {

    // MARK: intern classes

    private class MapMarkerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let markerTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, markerTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.markerTexture = markerTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.markerTexture)
        }
    }

    private class MapMarkerHasher: BaseLayerHasher<MapMarkerTile> {

    }

    // MARK: variables

    private var hasher: MapMarkerHasher?

    static let kName: String = "MapMarkerLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.mapMarkers
        self.name = MapMarkerLayer.kName
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
        self.hasher = MapMarkerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        if let marker = self.player?.marker(at: tile.point) {

            let markerTextureName = marker.type.markerTexture()
            let image = ImageCache.shared.image(for: markerTextureName)

            // place texture
            let markerSprite = SKSpriteNode(texture: SKTexture(image: image), size: MapMarkerLayer.kTextureSize)
            markerSprite.position = position
            markerSprite.zPosition = Globals.ZLevels.mapMarkers
            markerSprite.anchorPoint = CGPoint(x: 0, y: 0)
            markerSprite.color = .black
            markerSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(markerSprite)

            self.textureUtils?.set(markerSprite: markerSprite, at: tile.point)
        }
    }

    override func clear(at point: HexPoint) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let markerSprite = textureUtils.markerSprite(at: point) {
            self.removeChildren(in: [markerSprite])
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {

            let point = tile.point
            let currentHashValue = self.hash(for: tile)
            if !self.hasher!.has(hash: currentHashValue, at: point) {

                self.clear(at: point)

                let screenPoint = HexPoint.toScreen(hex: point)

                if tile.isVisible(to: self.player) || self.showCompleteMap {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
                } else if tile.isDiscovered(by: self.player) {
                    self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
                }

                self.hasher?.update(hash: currentHashValue, at: point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> MapMarkerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var markerTexture: String = ""

        if let marker = self.player?.marker(at: tile.point) {

            markerTexture = marker.type.iconTexture()
        }

        return MapMarkerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            markerTexture: markerTexture
        )
    }
}
