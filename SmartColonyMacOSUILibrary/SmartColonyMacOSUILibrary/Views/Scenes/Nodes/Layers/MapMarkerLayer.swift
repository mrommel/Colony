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

    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint, alpha: CGFloat) {

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

            self.textureUtils?.set(markerSprite: markerSprite, at: point)
        }
    }

    override func clear(at point: HexPoint) {

        let alternatePoint = self.alternatePoint(for: point)

        if let markerSprite = self.textureUtils?.markerSprite(at: point) {
            self.removeChildren(in: [markerSprite])
        }

        if let markerSprite = self.textureUtils?.markerSprite(at: alternatePoint) {
            self.removeChildren(in: [markerSprite])
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
