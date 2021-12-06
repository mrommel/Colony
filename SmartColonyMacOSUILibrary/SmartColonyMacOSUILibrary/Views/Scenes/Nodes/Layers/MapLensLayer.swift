//
//  MapLensLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.12.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class MapLensLayer: BaseLayer {

    static let kName: String = "MapLensLayer"

    var mapLens: MapLensType

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        self.mapLens = .none

        super.init(player: player)
        self.zPosition = Globals.ZLevels.mapLens
        self.name = MapLensLayer.kName
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
        let bundle = Bundle.init(for: Textures.self)

        // pre-load textures
        let appealLevelTextureNames = AppealLevel.all.map { $0.textureName() }
        for textureName in appealLevelTextureNames {

            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        let settlerTextureNames = CitySiteEvaluationType.all.map { $0.textureName() }
        for textureName in settlerTextureNames {

            ImageCache.shared.add(
                image: bundle.image(forResource: textureName),
                for: textureName
            )
        }

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        var textureName: String?

        switch self.mapLens {

        case .none:
            // NOOP
            break

        case .religion:
            textureName = "water"
        case .continents:
            // NOOP
            break
        case .appeal:
            let appealLevel = tile.appealLevel(in: self.gameModel)
            textureName = appealLevel.textureName()
        case .settler:
            guard let citySiteEvaluator = self.gameModel?.citySiteEvaluator() else {
                return
            }

            let citySiteEvaluationType = citySiteEvaluator.evaluationType(of: tile.point, for: self.gameModel?.humanPlayer())
            textureName = citySiteEvaluationType.textureName()
        case .government:
            // NOOP
            break
        case .political:
            // NOOP
            break
        case .tourism:
            // NOOP
            break
        case .empire:
            // NOOP
            break
        }

        // place texture
        if let lensTextureName = textureName {

            let image = ImageCache.shared.image(for: lensTextureName)

            let lensSprite = SKSpriteNode(texture: SKTexture(image: image), size: MapLensLayer.kTextureSize)
            lensSprite.position = position
            lensSprite.zPosition = Globals.ZLevels.wonder
            lensSprite.anchorPoint = CGPoint(x: 0, y: 0)
            lensSprite.color = .black
            lensSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(lensSprite)

            self.textureUtils?.set(lensSprite: lensSprite, at: tile.point)
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let lensSprite = textureUtils.lensSprite(at: tile.point) {
                self.removeChildren(in: [lensSprite])
            }
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt)

            if tile.isVisible(to: self.player) || self.showCompleteMap {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
