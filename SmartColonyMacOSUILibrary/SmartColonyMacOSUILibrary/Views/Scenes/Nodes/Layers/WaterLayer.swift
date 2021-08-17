//
//  WaterLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class WaterLayer: BaseLayer {

    static let kName: String = "WaterLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.water
        self.name = WaterLayer.kName
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

        self.rebuild()
    }

    /// handles all terrain
    func placeWaterHex(for point: HexPoint, at position: CGPoint) {

        let image = ImageCache.shared.image(for: "water")

        let waterSprite = SKSpriteNode(texture: SKTexture(image: image), size: WaterLayer.kTextureSize)
        waterSprite.position = position
        waterSprite.zPosition = Globals.ZLevels.water
        waterSprite.anchorPoint = CGPoint(x: 0, y: 0)
        waterSprite.color = .black
        waterSprite.colorBlendFactor = 0.0
        self.addChild(waterSprite)

        self.textureUtils?.set(waterSprite: waterSprite, at: point)
    }

    func clear(tile: AbstractTile?) {

        if let tile = tile {
            if let waterSprite = self.textureUtils?.waterSprite(at: tile.point) {
                self.removeChildren(in: [waterSprite])
            }
        }
    }

    override func update(tile: AbstractTile?) {

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt)

            if tile.isVisible(to: self.player) && gameModel.isFreshWater(at: pt) || self.showCompleteMap {
                self.placeWaterHex(for: pt, at: screenPoint)
            }
        }
    }
}
