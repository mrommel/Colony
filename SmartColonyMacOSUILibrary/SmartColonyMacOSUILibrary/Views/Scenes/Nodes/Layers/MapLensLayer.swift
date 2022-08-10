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
    var loyaltyNodes: [TooltipNode] = []

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

    func placeTileHex(for tile: AbstractTile, and point: HexPoint, at position: CGPoint, alpha: CGFloat) {

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

        case .loyalty:
            if tile.isCity() {
                guard let city = gameModel.city(at: tile.point) else {
                    fatalError("cant get city")
                }

                /*guard let diplomacy = city.player?.diplomacyAI else {
                    fatalError("cant get diplomacy")
                }

                if city.isHuman() || diplomacy.isAllianceActive(with: city.player) {

                } else if alpha == 1.0 {

                }*/

                let cityLoyalty = city.loyalty()
                let loyaltyFromNearbyCitizen = city.loyaltyPressureFromNearbyCitizen(in: gameModel)
                let loyaltyFromGovernors = city.loyaltyFromGovernors(in: gameModel)
                let loyaltyFromAmenities = city.loyaltyFromAmenities(in: gameModel)
                var loyaltyFromOther = 0.0
                loyaltyFromOther += city.loyaltyFromWonders(in: gameModel)
                loyaltyFromOther += city.loyaltyFromTradeRoutes(in: gameModel)
                loyaltyFromOther += city.loyaltyFromOthersEffects(in: gameModel)
                var loyaltyDelta = 0.0
                loyaltyDelta += loyaltyFromNearbyCitizen
                loyaltyDelta += loyaltyFromGovernors
                loyaltyDelta += loyaltyFromAmenities
                loyaltyDelta += loyaltyFromOther

                var text = "Loyalty: \(cityLoyalty)/100 (\(loyaltyDelta.deltaDisplay))\n\n"
                text += "\(loyaltyFromNearbyCitizen.deltaDisplay) [Citizen]"
                text += "| \(loyaltyFromGovernors.deltaDisplay) [Governor]"
                text += "| \(loyaltyFromAmenities.deltaDisplay) [Amenities]"
                text += "| \(loyaltyFromOther.deltaDisplay) Other"
                self.show(text: text, at: point)
            }

            return
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

            self.textureUtils?.set(lensSprite: lensSprite, at: point)
        }
    }

    override func clear(at point: HexPoint) {

        let alternatePoint = self.alternatePoint(for: point)

        if let lensSprite = self.textureUtils?.lensSprite(at: point) {
            self.removeChildren(in: [lensSprite])
        }

        if let lensSprite = self.textureUtils?.lensSprite(at: alternatePoint) {
            self.removeChildren(in: [lensSprite])
        }

        if let loyaltyNode = self.loyaltyNodes.first(where: { $0.name == point.description }) {
            loyaltyNode.removeFromParent()
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {

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
        }
    }

    private func show(text: String, at location: HexPoint) {

        var screenPoint = HexPoint.toScreen(hex: location)

        screenPoint.x += 12 // 24 / 2

        let tooltipNode = TooltipNode(text: text, type: TooltipNodeType.blue)
        tooltipNode.position = screenPoint
        tooltipNode.zPosition = Globals.ZLevels.tooltips
        tooltipNode.setScale(0.5)
        tooltipNode.name = location.description
        self.addChild(tooltipNode)

        self.loyaltyNodes.append(tooltipNode)
    }
}
