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
        let emptyDistrictTexture: String
        let firstBuildingDistrictTexture: String // also building texture
        let secondBuildingDistrictTexture: String
        let thirdBuildingDistrictTexture: String

        init(point: HexPoint, visible: Bool, discovered: Bool, emptyDistrictTexture: String,
             firstBuildingDistrictTexture: String, secondBuildingDistrictTexture: String,
             thirdBuildingDistrictTexture: String) {

            self.visible = visible
            self.discovered = discovered
            self.emptyDistrictTexture = emptyDistrictTexture
            self.firstBuildingDistrictTexture = firstBuildingDistrictTexture
            self.secondBuildingDistrictTexture = secondBuildingDistrictTexture
            self.thirdBuildingDistrictTexture = thirdBuildingDistrictTexture

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.emptyDistrictTexture)
            hasher.combine(self.firstBuildingDistrictTexture)
            hasher.combine(self.secondBuildingDistrictTexture)
            hasher.combine(self.thirdBuildingDistrictTexture)
        }
    }

    private class DistrictLayerHasher: BaseLayerHasher<DistrictLayerTile> {

    }

    // MARK: variables

    private var hasher: DistrictLayerHasher?

    static let kName: String = "DistrictLayer"
    static let buildingTextureName = "district-building"

    public static let buildingTextures: [String] = [
        "district-building",
        "district-cityCenter-monument",
        "district-cityCenter-granary",
        "district-cityCenter-waterMill",
        "district-campus-library",
        "district-campus-university",
        "district-campus-researchLab",
        "district-holySite-shrine",
        "district-holySite-temple",
        "district-holySite-cathedral",
        "district-encampment-barracks",
        "district-encampment-stable",
        "district-harbor-lighthouse",
        "district-harbor-shipyard"
    ]

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.districtEmpty
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

    private func firstBuildingDistrictTexture(for district: DistrictType, city: AbstractCity) -> String? {

        switch district {

        case .cityCenter:
            if city.has(building: .monument) {
                return "district-cityCenter-monument"
            }

            return nil

        case .campus:
            if city.has(building: .library) {
                return "district-campus-library"
            }

            return nil

        case .holySite:
            if city.has(building: .shrine) {
                return "district-holySite-shrine"
            }

            return nil

        case .holySite:
            if city.has(building: .barracks) {
                return "district-encampment-barracks"
            }

            if city.has(building: .stable) {
                return "district-encampment-stable"
            }

            return nil

        case .harbor:
            if city.has(building: .lighthouse) {
                return "district-harbor-lighthouse"
            }

            return nil

        default:
            return nil
        }
    }

    private func secondBuildingDistrictTexture(for district: DistrictType, city: AbstractCity) -> String? {

        switch district {

        case .cityCenter:
            if city.has(building: .granary) {
                return "district-cityCenter-granary"
            }

            return nil

        case .campus:
            /*if city.has(building: .university) {
                return "district-campus-university"
            }*/
            return nil

        case .holySite:
            if city.has(building: .temple) {
                return "district-holySite-temple"
            }

            return nil

        case .harbor:
            if city.has(building: .shipyard) {
                return "district-harbor-shipyard"
            }

            return nil

        default:
            return nil
        }
    }

    private func thirdBuildingDistrictTexture(for district: DistrictType, city: AbstractCity) -> String? {

        switch district {

        case .cityCenter:
            if city.has(building: .waterMill) {
                return "district-cityCenter-waterMill"
            }

            return nil

        case .campus:
            /*if city.has(building: .researchLab) {
                return "district-campus-researchLab"
            }*/
            return nil

        case .holySite:
            /*if city.has(building: .cathedral) {
                return "district-holySite-cathedral"
            }*/

            return nil

        default:
            return nil
        }
    }

    func placeTileHex(for tile: AbstractTile, at position: CGPoint, alpha: CGFloat) {

        let district = tile.district()
        let buildingDistrict = tile.buildingDistrict()

        // place district
        if district != .none {

            var cityRef: AbstractCity? = tile.workingCity()

            if cityRef == nil {
                cityRef = gameModel?.city(at: tile.point)
            }

            guard let city: AbstractCity = cityRef else {
                fatalError("cant get city for tile with district")
            }

            let emptyDistrictTextureName: String = district.emptyDistrictTextureName()
            let image = ImageCache.shared.image(for: emptyDistrictTextureName)

            let districtSprite = SKSpriteNode(texture: SKTexture(image: image), size: DistrictLayer.kTextureSize)
            districtSprite.position = position
            districtSprite.zPosition = Globals.ZLevels.districtEmpty
            districtSprite.anchorPoint = CGPoint(x: 0, y: 0)
            districtSprite.color = .black
            districtSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(districtSprite)

            self.textureUtils?.set(emptyDistrictSprite: districtSprite, at: tile.point)

            if let firstBuildingDistrictTextureName = self.firstBuildingDistrictTexture(for: district, city: city) {

                let image = ImageCache.shared.image(for: firstBuildingDistrictTextureName)

                let districtSprite = SKSpriteNode(texture: SKTexture(image: image), size: DistrictLayer.kTextureSize)
                districtSprite.position = position
                districtSprite.zPosition = Globals.ZLevels.districtFirst
                districtSprite.anchorPoint = CGPoint(x: 0, y: 0)
                districtSprite.color = .black
                districtSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(districtSprite)

                self.textureUtils?.set(firstBuildingDistrictSprite: districtSprite, at: tile.point)
            }

            if let secondBuildingDistrictTextureName = self.secondBuildingDistrictTexture(for: district, city: city) {

                let image = ImageCache.shared.image(for: secondBuildingDistrictTextureName)

                let districtSprite = SKSpriteNode(texture: SKTexture(image: image), size: DistrictLayer.kTextureSize)
                districtSprite.position = position
                districtSprite.zPosition = Globals.ZLevels.districtSecond
                districtSprite.anchorPoint = CGPoint(x: 0, y: 0)
                districtSprite.color = .black
                districtSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(districtSprite)

                self.textureUtils?.set(secondBuildingDistrictSprite: districtSprite, at: tile.point)
            }

            if let thirdBuildingDistrictTextureName = self.thirdBuildingDistrictTexture(for: district, city: city) {

                let image = ImageCache.shared.image(for: thirdBuildingDistrictTextureName)

                let districtSprite = SKSpriteNode(texture: SKTexture(image: image), size: DistrictLayer.kTextureSize)
                districtSprite.position = position
                districtSprite.zPosition = Globals.ZLevels.districtThird
                districtSprite.anchorPoint = CGPoint(x: 0, y: 0)
                districtSprite.color = .black
                districtSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(districtSprite)

                self.textureUtils?.set(thirdBuildingDistrictSprite: districtSprite, at: tile.point)
            }

        } else if buildingDistrict != .none {

            let districtTextureName: String = buildingDistrict.emptyDistrictTextureName()
            let image = ImageCache.shared.image(for: districtTextureName)

            let districtBuildingSprite = SKSpriteNode(texture: SKTexture(image: image), size: DistrictLayer.kTextureSize)
            districtBuildingSprite.position = position
            districtBuildingSprite.zPosition = Globals.ZLevels.districtEmpty
            districtBuildingSprite.anchorPoint = CGPoint(x: 0, y: 0)
            districtBuildingSprite.color = .black
            districtBuildingSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(districtBuildingSprite)

            self.textureUtils?.set(emptyDistrictSprite: districtBuildingSprite, at: tile.point)

            // icon that this district is in the building
            let buildingImage = ImageCache.shared.image(for: DistrictLayer.buildingTextureName)

            let districtBuildingSprite2 = SKSpriteNode(texture: SKTexture(image: buildingImage), size: DistrictLayer.kTextureSize)
            districtBuildingSprite2.position = position
            districtBuildingSprite2.zPosition = Globals.ZLevels.districtFirst
            districtBuildingSprite2.anchorPoint = CGPoint(x: 0, y: 0)
            districtBuildingSprite2.color = .black
            districtBuildingSprite2.colorBlendFactor = 1.0 - alpha
            self.addChild(districtBuildingSprite2)

            self.textureUtils?.set(firstBuildingDistrictSprite: districtBuildingSprite2, at: tile.point)
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let districtSprite = textureUtils.emptyDistrictSprite(at: tile.point) {
                self.removeChildren(in: [districtSprite])
            }

            if let districtSprite = textureUtils.firstBuildingDistrictSprite(at: tile.point) {
                self.removeChildren(in: [districtSprite])
            }

            if let districtSprite = textureUtils.secondBuildingDistrictSprite(at: tile.point) {
                self.removeChildren(in: [districtSprite])
            }

            if let districtSprite = textureUtils.thirdBuildingDistrictSprite(at: tile.point) {
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

        var emptyDistrictTexture: String = ""
        var firstBuildingDistrictTexture: String = ""
        var secondBuildingDistrictTexture: String = ""
        var thirdBuildingDistrictTexture: String = ""

        let district = tile.district()
        let buildingDistrict = tile.buildingDistrict()

        if district != .none {

            var cityRef: AbstractCity? = tile.workingCity()

            if cityRef == nil {
                cityRef = gameModel?.city(at: tile.point)
            }

            guard let city: AbstractCity = cityRef else {
                fatalError("cant get city for tile with district")
            }

            emptyDistrictTexture = district.emptyDistrictTextureName()
            firstBuildingDistrictTexture = self.firstBuildingDistrictTexture(for: district, city: city) ?? ""
            secondBuildingDistrictTexture = self.secondBuildingDistrictTexture(for: district, city: city) ?? ""
            thirdBuildingDistrictTexture = self.thirdBuildingDistrictTexture(for: district, city: city) ?? ""

        } else if buildingDistrict != .none {

            emptyDistrictTexture = district.emptyDistrictTextureName()
            firstBuildingDistrictTexture = DistrictLayer.buildingTextureName
        }

        return DistrictLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            emptyDistrictTexture: emptyDistrictTexture,
            firstBuildingDistrictTexture: firstBuildingDistrictTexture,
            secondBuildingDistrictTexture: secondBuildingDistrictTexture,
            thirdBuildingDistrictTexture: thirdBuildingDistrictTexture
        )
    }
}
