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
    let shift: CGPoint
    
    init(game: GameModel?) {
        self.game = game
        
        if let contentSize = self.game?.contentSize(),
           let mapSize = self.game?.mapSize() {

            self.size = CGSize(width: (contentSize.width + 10), height: contentSize.height)
            
            // change shift
            let p0 = HexPoint(x: 0, y: 0)
            let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
            let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
            let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
            let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
                
            self.shift = CGPoint(x: dx, y: dy)
        } else {
            self.size = CGSize(width: 2500, height: 2500)
            self.shift = CGPoint(x: 575, y: 1360)
        }
        
        self.image = NSImage(color: .navyBlue, size: NSSize(width: self.size.width, height: self.size.height))
        
        self.textures = Textures(game: self.game)
    }
    
    func update() {
    }
}
