//
//  BaseLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.03.21.
//

import SwiftUI
import Cocoa
import SmartAILibrary
import SmartAssets

class BaseLayerViewModel: ObservableObject {
    
    var image: NSImage
    var textures: Textures = Textures(game: nil)
    var size: CGSize
    var shift: CGPoint
    let factor: CGFloat = 3.0
    
    init() {
        self.size = .zero
        self.image = NSImage(color: .navyBlue, size: NSSize(width: 100, height: 100))
        self.shift = .zero
    }
    
    func updateSizeAndShift(from game: GameModel?) {
        
        guard let game = game else {
            return
        }
        
        let contentSize = game.contentSize()
        let mapSize = game.mapSize()
        
        self.size = CGSize(width: (contentSize.width + 10) * factor, height: contentSize.height * factor)
        
        // change shift
        let p0 = HexPoint(x: 0, y: 0)
        let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
        let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
        let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
        let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
            
        self.shift = CGPoint(x: dx, y: dy) * factor
        
        self.image = NSImage(color: .navyBlue, size: NSSize(width: self.size.width, height: self.size.height))
        
        self.textures = Textures(game: game)
    }
    
    func update(from game: GameModel?, showCompleteMap: Bool = true) {
        
        guard let game = game else {
            return
        }
        
        guard let human = game.humanPlayer() else {
            return
        }

        if self.size == .zero {
            self.updateSizeAndShift(from: game)
        }
        
        let tmpImage = drawImageInCGContext(size: self.size) { (context) -> () in
            let mapSize = game.mapSize()

            for x in 0..<mapSize.width() {

                for y in 0..<mapSize.height() {

                    let pt = HexPoint(x: x, y: y)
                    let screenPoint = (HexPoint.toScreen(hex: pt) * self.factor) + self.shift
                    let tileRect = CGRect(x: screenPoint.x, y: screenPoint.y, width: 48 * self.factor, height: 48 * self.factor)
                    
                    guard let tile = game.tile(at: pt) else {
                        continue
                    }
                    
                    guard tile.isVisible(to: human) || showCompleteMap else {
                        continue
                    }
                    
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
