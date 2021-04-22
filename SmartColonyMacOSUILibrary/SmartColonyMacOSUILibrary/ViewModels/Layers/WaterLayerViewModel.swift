//
//  WaterLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.04.21.
//

import SmartAILibrary

class WaterLayerViewModel: BaseLayerViewModel {
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {

        if game.isFreshWater(at: tile.point) {
            context?.draw(ImageCache.shared.image(for: "water").cgImage!, in: tileRect)
        }
    }
}
