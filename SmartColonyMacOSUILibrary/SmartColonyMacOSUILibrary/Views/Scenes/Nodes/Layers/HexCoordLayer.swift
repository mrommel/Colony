//
//  HexCoordLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class HexCoordLayer: BaseLayer {

    // MARK: intern classes

    private class HexCoordLayerTile: BaseLayerTile {

        let visible: Bool
        let discovered: Bool
        let coordText: String

        init(point: HexPoint, visible: Bool, discovered: Bool, coordText: String) {

            self.visible = visible
            self.discovered = discovered
            self.coordText = coordText

            super.init(point: point)
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func hash(into hasher: inout Hasher) {

            hasher.combine(self.point)
            hasher.combine(self.visible)
            hasher.combine(self.discovered)
            hasher.combine(self.coordText)
        }
    }

    private class HexCoordLayerHasher: BaseLayerHasher<HexCoordLayerTile> {

    }

    // MARK: variables

    private var hasher: HexCoordLayerHasher?

    static let kName: String = "HexCoordLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.water
        self.name = HexCoordLayer.kName
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
        self.hasher = HexCoordLayerHasher(with: gameModel)

        self.rebuild()
    }

    func placeCoordHex(for point: HexPoint, at position: CGPoint) {

        let hexCoordSprite = SKLabelNode(text: "\(point.x), \(point.y)")
        hexCoordSprite.fontSize = 8.0
        hexCoordSprite.position = position + CGPoint(x: 24, y: 14)
        hexCoordSprite.zPosition = Globals.ZLevels.hexCoords
        hexCoordSprite.color = .black
        hexCoordSprite.colorBlendFactor = 0.0
        self.addChild(hexCoordSprite)

        self.textureUtils?.set(hexLabel: hexCoordSprite, at: point)
    }

    func clear(tile: AbstractTile?) {

        if let tile = tile {
            if let hexLabel = self.textureUtils?.hexLabel(at: tile.point) {
                self.removeChildren(in: [hexLabel])
            }
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {

            let currentHashValue = self.hash(for: tile)
            if !self.hasher!.has(hash: currentHashValue, at: tile.point) {

                self.clear(tile: tile)

                let screenPoint = HexPoint.toScreen(hex: tile.point)

                if tile.isVisible(to: self.player) || self.showCompleteMap {
                    self.placeCoordHex(for: tile.point, at: screenPoint)
                }

                self.hasher?.update(hash: currentHashValue, at: tile.point)
            }
        }
    }

    private func hash(for tile: AbstractTile?) -> HexCoordLayerTile {

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        let coordText: String = "\(tile.point.x), \(tile.point.y)"

        return HexCoordLayerTile(
            point: tile.point,
            visible: tile.isVisible(to: self.player) || self.showCompleteMap,
            discovered: tile.isDiscovered(by: self.player),
            coordText: coordText
        )
    }
}
