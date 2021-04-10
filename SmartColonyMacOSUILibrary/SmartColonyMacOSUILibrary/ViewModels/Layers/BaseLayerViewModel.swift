//
//  BaseLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.03.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

class BaseLayerViewModel {
    
    var image: NSImage
    let game: GameModel?
    let textures: Textures
    let size: CGSize
    var shift: CGPoint
    let factor: CGFloat = 3.0
    
    init(game: GameModel?) {
        self.game = game
        
        if let contentSize = self.game?.contentSize(), let mapSize = self.game?.mapSize() {
        
            self.size = CGSize(width: (contentSize.width + 10) * factor, height: contentSize.height * factor)
            
            // change shift
            let p0 = HexPoint(x: 0, y: 0)
            let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
            let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
            let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
            let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
                
            self.shift = CGPoint(x: dx, y: dy) * factor
            
            self.image = NSImage(color: .navyBlue, size: NSSize(width: self.size.width, height: self.size.height))
            
            self.textures = Textures(game: self.game)
        } else {
            // dummy
            self.size = CGSize(width: 200, height: 150)
            self.shift = CGPoint.zero
            self.image = NSImage(color: .navyBlue, size: NSSize(width: self.size.width, height: self.size.height))
            self.textures = Textures(game: self.game)
        }
    }
    
    func update() {
        
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

                    //let screenPoint = HexPoint.toScreen(hex: pt) + self.shift
                    //let tileRect = CGRect(x: screenPoint.x , y: screenPoint.y, width: 48, height: 48)
                    let screenPoint = (HexPoint.toScreen(hex: pt) * self.factor) + self.shift
                    let tileRect = CGRect(x: screenPoint.x, y: screenPoint.y, width: 48 * self.factor, height: 48 * self.factor)
                    
                    guard let tile = game.tile(at: pt) else {
                        continue
                    }
                    
                    /*guard tile.isVisible(to: human) else {
                        continue
                    }*/
                    
                    self.render(tile: tile, into: context, at: tileRect, in: game)
                }
            }
        }

        self.image = tmpImage
    }
    
    func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {
        
        // draw should be overwritten by Layer implementation
    }
}
