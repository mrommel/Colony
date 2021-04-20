//
//  RiverLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SmartAILibrary

class RiverLayerViewModel: BaseLayerViewModel {

    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {

        // river
        if let riverTexture = self.textures.riverTexture(at: tile.point) {
            context?.draw(ImageCache.shared.image(for: riverTexture).cgImage!, in: tileRect)
        }
    }
}
