//
//  ResourceLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SmartAILibrary
import SmartAssets

class ResourceLayerViewModel: BaseLayerViewModel {
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {

        if tile.resource(for: nil) != .none {

            let resourceTextureName = tile.resource(for: nil).textureName()
            context?.draw(ImageCache.shared.image(for: resourceTextureName).cgImage!, in: tileRect)
        }
    }
}
