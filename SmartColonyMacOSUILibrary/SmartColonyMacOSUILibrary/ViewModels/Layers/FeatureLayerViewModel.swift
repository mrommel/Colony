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
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {

        let pt = tile.point
        
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
                context?.draw(ImageCache.shared.image(for: featureTextureName).cgImage!, in: tileRect)
            }
        }

        if tile.feature() != .ice {

            if let iceTextureName = self.textures.iceTexture(at: tile.point) {
                context?.draw(ImageCache.shared.image(for: iceTextureName).cgImage!, in: tileRect)
            }
        }
    }
}
