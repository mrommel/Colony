//
//  WonderLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.11.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class WonderLayer: BaseLayer {

    static let kName: String = "WonderLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.wonder
        self.name = WonderLayer.kName
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

        let wonder = tile.wonder()
        let buildingWonder = tile.buildingWonder()

        // place wonder
        if wonder != .none {

            let wonderTextureName: String = wonder.textureName()
            let image = ImageCache.shared.image(for: wonderTextureName)

            let wonderSprite = SKSpriteNode(texture: SKTexture(image: image), size: WonderLayer.kTextureSize)
            wonderSprite.position = position
            wonderSprite.zPosition = Globals.ZLevels.wonder
            wonderSprite.anchorPoint = CGPoint(x: 0, y: 0)
            wonderSprite.color = .black
            wonderSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(wonderSprite)

            self.textureUtils?.set(wonderSprite: wonderSprite, at: tile.point)

        } else if buildingWonder != .none {

            // print("render \(buildingDistrict) pre building animation")
            let wonderTextureName: String = buildingWonder.buildingTextureName()
            let image = ImageCache.shared.image(for: wonderTextureName)

            let wonderBuildingSprite = SKSpriteNode(texture: SKTexture(image: image), size: WonderLayer.kTextureSize)
            wonderBuildingSprite.position = position
            wonderBuildingSprite.zPosition = Globals.ZLevels.wonder
            wonderBuildingSprite.anchorPoint = CGPoint(x: 0, y: 0)
            wonderBuildingSprite.color = .black
            wonderBuildingSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(wonderBuildingSprite)

            self.textureUtils?.set(wonderBuildingSprite: wonderBuildingSprite, at: tile.point)
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
