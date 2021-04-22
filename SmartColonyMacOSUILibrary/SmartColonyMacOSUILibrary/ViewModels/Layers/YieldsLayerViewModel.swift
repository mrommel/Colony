//
//  YieldsLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.04.21.
//

import SmartAILibrary

class YieldsLayerViewModel: BaseLayerViewModel {
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {

        let yields = tile.yields(for: game.humanPlayer(), ignoreFeature: false)
        
        if let textureName = self.textures.yieldTexture(for: yields) {
            context?.draw(ImageCache.shared.image(for: textureName).cgImage!, in: tileRect)
        }
    }
}
