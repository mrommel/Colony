//
//  FeatureLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

// swiftlint:disable nesting
class FeatureLayer: BaseLayer {

    // MARK: intern classes

    private class FeatureLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let featureTexture: String
        let mountainsCaldera: String
        let iceTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, featureTexture: String, mountainsCaldera: String, iceTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.featureTexture = featureTexture
            self.mountainsCaldera = mountainsCaldera
            self.iceTexture = iceTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.featureTexture)
            hasher.combine(self.mountainsCaldera)
            hasher.combine(self.iceTexture)
        }
    }

    private class FeatureLayerHasher: BaseLayerHasher<FeatureLayerTile> {

    }

    private enum FeaturePatternTileType: String, Codable {

        case first
        case second
        case third
        case forth
    }

    private enum FeaturePatternType: Codable, Equatable {

        enum CodingKeys: String, CodingKey {

            case value // Int
            case tile // FeaturePatternTileType / String
        }

        case none
        case mountain3SE(tile: FeaturePatternTileType)
        case mountain3NE(tile: FeaturePatternTileType)
        case mountain4(tile: FeaturePatternTileType)

        // MARK: constructors

        public init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            let value = try container.decode(Int.self, forKey: .value)

            switch value {

            case 1:
                let tile = try container.decode(FeaturePatternTileType.self, forKey: .tile)
                self = .mountain3SE(tile: tile)

            case 2:
                let tile = try container.decode(FeaturePatternTileType.self, forKey: .tile)
                self = .mountain3NE(tile: tile)

            case 3:
                let tile = try container.decode(FeaturePatternTileType.self, forKey: .tile)
                self = .mountain4(tile: tile)

            default:
                self = .none
            }
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            switch self {

            case .none:
                try container.encode(0, forKey: .value)

            case .mountain3SE(tile: let tile):
                try container.encode(1, forKey: .value)
                try container.encode(tile, forKey: .tile)

            case .mountain3NE(tile: let tile):
                try container.encode(2, forKey: .value)
                try container.encode(tile, forKey: .tile)

            case .mountain4(tile: let tile):
                try container.encode(3, forKey: .value)
                try container.encode(tile, forKey: .tile)
            }
        }
    }

    // MARK: variables

    private var hasher: FeatureLayerHasher?
    private var patternArray: Array2D<FeaturePatternType>?

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.feature
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
        self.hasher = FeatureLayerHasher(with: gameModel)

        self.preparePatterns()

        self.rebuild()
    }

    func preparePatterns() {

        guard let gameModel = self.gameModel else {
            return
        }

        let mapSize = gameModel.mapSize()
        self.patternArray = Array2D<FeaturePatternType>(width: mapSize.width(), height: mapSize.height())

        // prefill
        self.patternArray?.fill(with: FeaturePatternType.none)

        for pt in gameModel.points().shuffled {

            let feature = gameModel.tile(at: pt)?.feature() ?? .none

            if feature == .mountains {

                // N
                let neighborNE = pt.neighbor(in: .northeast)
                let neighborSE = pt.neighbor(in: .southeast)
                let neighborS = pt.neighbor(in: .south)
                let neighborSW = pt.neighbor(in: .southwest)
                let neighborNW = pt.neighbor(in: .northwest)

                // let neighborFeatureN = gameModel.tile(at: pt.neighbor(in: .north))?.feature() ?? .none

                let neighborFeatureNE = gameModel.tile(at: neighborNE)?.feature() ?? .none
                let patternNE = gameModel.valid(point: neighborNE) ? self.patternArray![neighborNE]! : .none

                let neighborFeatureSE = gameModel.tile(at: neighborSE)?.feature() ?? .none
                let patternSE = gameModel.valid(point: neighborSE) ? self.patternArray![neighborSE]! : .none

                let neighborFeatureS = gameModel.tile(at: pt.neighbor(in: .south))?.feature() ?? .none
                let patternS = gameModel.valid(point: neighborS) ? self.patternArray![neighborS]! : .none

                let neighborFeatureSW = gameModel.tile(at: neighborSW)?.feature() ?? .none
                let patternSW = gameModel.valid(point: neighborSW) ? self.patternArray![neighborSW]! : .none

                let neighborFeatureNW = gameModel.tile(at: neighborNW)?.feature() ?? .none
                let patternNW = gameModel.valid(point: neighborNW) ? self.patternArray![neighborNW]! : .none

                if neighborFeatureNW == .mountains && patternNW == .none &&
                    neighborFeatureSE == .mountains && patternSE == .none {

                    // print("found pattern: mountain3SE")
                    self.patternArray?[neighborNW] = .mountain3SE(tile: .first)
                    self.patternArray?[pt] = .mountain3SE(tile: .second)
                    self.patternArray?[neighborSE] = .mountain3SE(tile: .third)
                }

                if neighborFeatureNE == .mountains && patternNE == .none &&
                    neighborFeatureSW == .mountains && patternSW == .none {

                    // print("found pattern: mountain3NE")
                    self.patternArray?[neighborSW] = .mountain3NE(tile: .first)
                    self.patternArray?[pt] = .mountain3NE(tile: .second)
                    self.patternArray?[neighborNE] = .mountain3NE(tile: .third)
                }

                if neighborFeatureSE == .mountains && patternSE == .none &&
                    neighborFeatureSW == .mountains && patternSW == .none &&
                    neighborFeatureS == .mountains && patternS == .none {

                    // print("found pattern: mountain4")
                    self.patternArray?[pt] = .mountain4(tile: .first)
                    self.patternArray?[neighborSE] = .mountain4(tile: .second)
                    self.patternArray?[neighborSW] = .mountain4(tile: .third)
                    self.patternArray?[neighborS] = .mountain4(tile: .forth)
                }
            }
        }
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let feature: FeatureType = tile.feature()
        let pattern: FeaturePatternType = self.patternArray![tile.point] ?? .none

        // place forests etc
        if feature != .none {

            var textureName: String?

            switch pattern {

            case .none:
                if let tmpTextureName = self.textures?.featureTexture(for: tile) {

                    textureName = tmpTextureName
                }

            case .mountain3SE(tile: let tile):

                switch tile {

                case .first:
                    textureName = "feature-mountains-range1-1"
                case .second:
                    textureName = "feature-mountains-range1-2"
                case .third:
                    textureName = "feature-mountains-range1-3"
                case .forth:
                    textureName = nil
                }

            case .mountain3NE(tile: let tile):

                switch tile {

                case .first:
                    textureName = "feature-mountains-range2-1"
                case .second:
                    textureName = "feature-mountains-range2-2"
                case .third:
                    textureName = "feature-mountains-range2-3"
                case .forth:
                    textureName = nil
                }

            case .mountain4(tile: let tile):

                switch tile {

                case .first:
                    textureName = "feature-mountains-range3-1"
                case .second:
                    textureName = "feature-mountains-range3-2"
                case .third:
                    textureName = "feature-mountains-range3-3"
                case .forth:
                    textureName = "feature-mountains-range3-4"
                }
            }

            if let textureName = textureName {

                let image = ImageCache.shared.image(for: textureName)

                let featureSprite = SKSpriteNode(texture: SKTexture(image: image), size: FeatureLayer.kTextureSize)
                featureSprite.position = position
                featureSprite.zPosition = Globals.ZLevels.feature // feature.zLevel
                featureSprite.anchorPoint = CGPoint(x: 0, y: 0)
                featureSprite.color = .black
                featureSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(featureSprite)

                self.textureUtils?.set(featureSprite: featureSprite, at: tile.point)
            }
        }

        // mountains caldera
        if feature != .mountains {
            if let mountainsTexture = self.textures?.mountainsTexture(at: tile.point) {

                let image = ImageCache.shared.image(for: mountainsTexture)

                let mountainsCalderaSprite = SKSpriteNode(texture: SKTexture(image: image), size: FeatureLayer.kTextureSize)
                mountainsCalderaSprite.position = position
                mountainsCalderaSprite.zPosition = Globals.ZLevels.feature
                mountainsCalderaSprite.anchorPoint = CGPoint(x: 0, y: 0)
                mountainsCalderaSprite.color = .black
                mountainsCalderaSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(mountainsCalderaSprite)

                self.textureUtils?.set(mountainsCalderaSprite: mountainsCalderaSprite, at: tile.point)
            }
        }

        // icy caldera
        if feature != .ice {
            if let iceTexture = self.textures?.iceTexture(at: tile.point) {

                let image = ImageCache.shared.image(for: iceTexture)

                let iceSprite = SKSpriteNode(texture: SKTexture(image: image), size: FeatureLayer.kTextureSize)
                iceSprite.position = position
                iceSprite.zPosition = Globals.ZLevels.feature
                iceSprite.anchorPoint = CGPoint(x: 0, y: 0)
                iceSprite.color = .black
                iceSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(iceSprite)

                self.textureUtils?.set(iceSprite: iceSprite, at: tile.point)
            }
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let featureSprite = textureUtils.featureSprite(at: tile.point) {
                self.removeChildren(in: [featureSprite])
            }

            if let mountainsCalderaSprite = textureUtils.mountainsCalderaSprite(at: tile.point) {
                self.removeChildren(in: [mountainsCalderaSprite])
            }

            if let iceSprite = textureUtils.iceSprite(at: tile.point) {
                self.removeChildren(in: [iceSprite])
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

    private func hash(for tile: AbstractTile?) -> FeatureLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var featureTexture: String = ""
        if tile.feature() != .none {
            if let featureTextureTmp = self.textures?.featureTexture(for: tile) {
                featureTexture = featureTextureTmp
            }
        }

        var mountainsCalderaTexture: String = ""
        if tile.feature() != .mountains {
            if let mountainsTextureTmp = self.textures?.mountainsTexture(at: tile.point) {
                mountainsCalderaTexture = mountainsTextureTmp
            }
        }

        var iceTexture: String = ""
        if tile.feature() != .ice {
            if let iceTextureTmp = self.textures?.iceTexture(at: tile.point) {
                iceTexture = iceTextureTmp
            }
        }

        return FeatureLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            featureTexture: featureTexture,
            mountainsCaldera: mountainsCalderaTexture,
            iceTexture: iceTexture
        )
    }
}
