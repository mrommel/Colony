//
//  ResourceMarkerLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.04.21.
//

import SmartAILibrary

class ResourceMarkerLayerViewModel: BaseLayerViewModel {
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {

        if tile.resource(for: nil) != .none {

            let resourceMarkerTextureName = tile.resource(for: nil).textureMarkerName()
            context?.draw(ImageCache.shared.image(for: resourceMarkerTextureName).cgImage!, in: tileRect)
        }
    }
}
