//
//  TerrainLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.03.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

class TerrainLayerViewModel: BaseLayerViewModel {
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {
        
        // terrain
        let terrainTextureName: String
        if let coastTexture = self.textures.coastTexture(at: tile.point) {
            terrainTextureName = coastTexture
        } else {
            if tile.hasHills() {
                terrainTextureName = tile.terrain().textureNamesHills().item(from: tile.point)
            } else {
                terrainTextureName = tile.terrain().textureNames().item(from: tile.point)
            }
        }
        
        // fetch from cache
        context?.draw(ImageCache.shared.image(for: terrainTextureName).cgImage!, in: tileRect)
    }
}
