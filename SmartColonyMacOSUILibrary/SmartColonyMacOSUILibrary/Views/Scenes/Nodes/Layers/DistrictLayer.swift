//
//  DistrictLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.11.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class DistrictLayer: BaseLayer {

    // MARK: intern classes

    private class DistrictLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let districtTexture: String
        let buildingDistrictTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, districtTexture: String, buildingDistrictTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.districtTexture = districtTexture
            self.buildingDistrictTexture = buildingDistrictTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.districtTexture)
            hasher.combine(self.buildingDistrictTexture)
        }
    }

    private class DistrictLayerHasher: BaseLayerHasher<DistrictLayerTile> {

    }

    // MARK: variables

    private var hasher: DistrictLayerHasher?

    static let kName: String = "DistrictLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.district
        self.name = DistrictLayer.kName
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
        self.hasher = DistrictLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let district = tile.district()
        let buildingDistrict = tile.buildingDistrict()

        // place district
        if district != .none {

            let districtTextureName: String = district.textureName()
            let image = ImageCache.shared.image(for: districtTextureName)

            let districtSprite = SKSpriteNode(texture: SKTexture(image: image), size: DistrictLayer.kTextureSize)
            districtSprite.position = position
            districtSprite.zPosition = Globals.ZLevels.district
            districtSprite.anchorPoint = CGPoint(x: 0, y: 0)
            districtSprite.color = .black
            districtSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(districtSprite)

            self.textureUtils?.set(districtSprite: districtSprite, at: tile.point)

        } else if buildingDistrict != .none {

            // print("render \(buildingDistrict) pre building animation")
            let districtTextureName: String = buildingDistrict.buildingTextureName()
            let image = ImageCache.shared.image(for: districtTextureName)

            let districtBuildingSprite = SKSpriteNode(texture: SKTexture(image: image), size: DistrictLayer.kTextureSize)
            districtBuildingSprite.position = position
            districtBuildingSprite.zPosition = Globals.ZLevels.district
            districtBuildingSprite.anchorPoint = CGPoint(x: 0, y: 0)
            districtBuildingSprite.color = .black
            districtBuildingSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(districtBuildingSprite)

            self.textureUtils?.set(districtBuildingSprite: districtBuildingSprite, at: tile.point)
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let districtSprite = textureUtils.districtSprite(at: tile.point) {
                self.removeChildren(in: [districtSprite])
            }

            if let districtSprite = textureUtils.districtBuildingSprite(at: tile.point) {
                self.removeChildren(in: [districtSprite])
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

    private func hash(for tile: AbstractTile?) -> DistrictLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        var districtTexture: String = ""
        var buildingDistrictTexture: String = ""
        let district = tile.district()
        let buildingDistrict = tile.buildingDistrict()

        if district != .none {
            districtTexture = district.textureName()
        } else if buildingDistrict != .none {
            buildingDistrictTexture = buildingDistrict.buildingTextureName()
        }

        return DistrictLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            districtTexture: districtTexture,
            buildingDistrictTexture: buildingDistrictTexture
        )
    }
}
