//
//  ImprovementLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class ImprovementLayer: BaseLayer {
    
    // MARK: constructor
    
    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.improvement
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

        let improvement = tile.improvement()

        // place farms/mines, ...
        if improvement != .none {
            
            let improvementTextureName = improvement.textureNames().item(from: tile.point)
            let image = ImageCache.shared.image(for: improvementTextureName)

            let improvementSprite = SKSpriteNode(texture: SKTexture(image: image), size: CGSize(width: 144, height: 144))
            improvementSprite.position = position
            improvementSprite.zPosition = Globals.ZLevels.improvement
            improvementSprite.anchorPoint = CGPoint(x: 0, y: 0)
            improvementSprite.color = .black
            improvementSprite.colorBlendFactor = 1.0 - alpha
            self.addChild(improvementSprite)

            self.textureUtils?.set(improvementSprite: improvementSprite, at: tile.point)
        } else {
            for buildType in BuildType.allImprovements {
                if tile.buildProgress(of: buildType) > 0 {
                    print("render \(buildType) pre building animation")
                }
            }
        }

        let route = tile.route()

        if route != .none {

            if let roadTextureName = self.textures?.roadTexture(at: tile.point) {
                
                let image = ImageCache.shared.image(for: roadTextureName)

                let routeSprite = SKSpriteNode(texture: SKTexture(image: image), size: CGSize(width: 144, height: 144))
                routeSprite.position = position
                routeSprite.zPosition = Globals.ZLevels.route
                routeSprite.anchorPoint = CGPoint(x: 0, y: 0)
                routeSprite.color = .black
                routeSprite.colorBlendFactor = 1.0 - alpha
                self.addChild(routeSprite)

                self.textureUtils?.set(routeSprite: routeSprite, at: tile.point)
            }
        }
    }

    func clear(tile: AbstractTile?) {

        guard let textureUtils = self.textureUtils else {
            fatalError("cant get textureUtils")
        }

        if let tile = tile {
            if let improvementSprite = textureUtils.improvementSprite(at: tile.point) {
                self.removeChildren(in: [improvementSprite])
            }

            if let routeSprite = textureUtils.routeSprite(at: tile.point) {
                self.removeChildren(in: [routeSprite])
            }
        }
    }

    override func update(tile: AbstractTile?) {

        if let tile = tile {
            let pt = tile.point

            self.clear(tile: tile)

            let screenPoint = HexPoint.toScreen(hex: pt) * 3.0

            if tile.isVisible(to: self.player) || self.showCompleteMap {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 1.0)
            } else if tile.isDiscovered(by: self.player) {
                self.placeTileHex(for: tile, at: screenPoint, alpha: 0.5)
            }
        }
    }
}
