//
//  FeatureLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.03.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

class FeatureLayerViewModel: BaseLayerViewModel {
    
    override init(game: GameModel?) {
        super.init(game: game)
    }
    
    override func update() {
        
        guard let game = self.game else {
            return
        }
        
        guard let human = self.game?.humanPlayer() else {
            return
        }
        
        let tmpImage = drawImageInCGContext(size: self.size) { (context) -> () in
            let mapSize = game.mapSize()
            //let options = GameDisplayOptions.standard

            for x in 0..<mapSize.width() {

                for y in 0..<mapSize.height() {

                    let pt = HexPoint(x: x, y: y)

                    let screenPoint = HexPoint.toScreen(hex: pt) + shift
                    let tileRect = CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48)
                    
                    guard let tile = game.tile(at: pt) else {
                        continue
                    }
                    
                    guard tile.isVisible(to: human) else {
                        continue
                    }

                    // place forests etc
                    if tile.feature() != .none {

                        let neighborTileN = game.tile(at: pt.neighbor(in: .north))
                        let neighborTileNE = game.tile(at: pt.neighbor(in: .northeast))
                        let neighborTileSE = game.tile(at: pt.neighbor(in: .southeast))
                        let neighborTileS = game.tile(at: pt.neighbor(in: .south))
                        let neighborTileSW = game.tile(at: pt.neighbor(in: .southwest))
                        let neighborTileNW = game.tile(at: pt.neighbor(in: .northwest))

                        let neighborTiles: [HexDirection: AbstractTile?] = [
                                .north: neighborTileN,
                                .northeast: neighborTileNE,
                                .southeast: neighborTileSE,
                                .south: neighborTileS,
                                .southwest: neighborTileSW,
                                .northwest: neighborTileNW
                        ]

                        if let featureTextureName = self.textures.featureTexture(for: tile, neighborTiles: neighborTiles) {
                            context.draw(ImageCache.shared.image(for: featureTextureName).cgImage!, in: tileRect)
                        }
                    }

                    if tile.feature() != .ice {

                        if let iceTextureName = self.textures.iceTexture(at: tile.point) {
                            context.draw(ImageCache.shared.image(for: iceTextureName).cgImage!, in: tileRect)
                        }
                    }
                }
            }
        }

        self.image = tmpImage
    }
}
