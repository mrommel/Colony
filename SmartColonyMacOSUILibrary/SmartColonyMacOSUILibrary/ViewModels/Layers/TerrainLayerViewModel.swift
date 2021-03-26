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
                    context.draw(ImageCache.shared.image(for: terrainTextureName).cgImage!, in: tileRect)
                }
            }
        }

        self.image = tmpImage
    }
}
