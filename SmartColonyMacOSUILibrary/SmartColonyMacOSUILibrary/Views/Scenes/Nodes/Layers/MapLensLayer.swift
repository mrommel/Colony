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
    let tileTexture: NSImage

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        self.mapLens = .none

        let bundle = Bundle.init(for: Textures.self)
        self.tileTexture = bundle.image(forResource: "tile")!

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

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        var textureColor: TypeColor?

        switch self.mapLens {

        case .none:
            // NOOP
            break

        case .religion:
            guard let religion = tile.owner()?.religion?.currentReligion() else {
                return
            }

            guard religion != .none else {
                return
            }

            textureColor = religion.legendColor()

        case .continents:
            textureColor = gameModel.continent(at: tile.point)?.type().legendColor()

        case .appeal:
            let appealLevel = tile.appealLevel(in: self.gameModel)
            textureColor = appealLevel.legendColor()

        case .settler:
            guard let citySiteEvaluator = self.gameModel?.citySiteEvaluator() else {
                return
            }

            let citySiteEvaluationType = citySiteEvaluator.evaluationType(of: tile.point, for: self.gameModel?.humanPlayer())
            textureColor = citySiteEvaluationType.legendColor()

        case .government:
            guard let government = tile.owner()?.government?.currentGovernment() else {
                return
            }

            textureColor = government.legendColor()

        case .tourism:
            var tourismValue = 0.0
            if tile.wonder() != .none {
                tourismValue += 5.0
            }

            if tile.isCity() {
                if let city = gameModel.city(at: tile.point) {
                    tourismValue += city.baseTourism(in: gameModel)
                }
            }

            if tourismValue > 0.0 {
                textureColor = Globals.Colors.tourismLens
            }
        }

        // place texture
        if let textureColor = textureColor {

            let lensSprite = SKSpriteNode(texture: SKTexture(image: self.tileTexture), size: MapLensLayer.kTextureSize)
            lensSprite.position = position
            lensSprite.zPosition = Globals.ZLevels.mapLens
            lensSprite.anchorPoint = CGPoint(x: 0, y: 0)
            lensSprite.color = textureColor
            lensSprite.colorBlendFactor = 1.0
            self.addChild(lensSprite)

            self.textureUtils?.set(lensSprite: lensSprite, at: tile.point)
        }
    }

    override func clear(at point: HexPoint) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let lensSprite = textureUtils.lensSprite(at: point) {
            self.removeChildren(in: [lensSprite])
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {

            let point = tile.point
            self.clear(at: point)

            let screenPoint = HexPoint.toScreen(hex: point)

            if tile.isVisible(to: self.player) || self.showCompleteMap {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
