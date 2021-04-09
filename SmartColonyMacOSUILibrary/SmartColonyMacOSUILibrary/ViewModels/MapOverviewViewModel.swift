//
//  MapOverviewViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 08.04.21.
//

import AppKit
import SwiftUI
import SmartAILibrary
import SmartAssets

public class MapOverviewViewModel: ObservableObject {
    
    private var buffer: PixelBuffer
    
    private weak var game: GameModel?
    private weak var player: AbstractPlayer?
    
    @Published
    var image: Image = Image(systemName: "sun.max.fill")
    
    public init(with game: GameModel?) {
        
        self.game = game
        
        guard let game = self.game else {
            fatalError("no game given")
        }
        
        self.player = game.humanPlayer()
        
        let mapSize = game.mapSize()
        self.buffer = PixelBuffer(width: mapSize.width(), height: mapSize.height(), color: NSColor.black)

        guard let bufferImage = self.buffer.toNSImage() else {
            fatalError("can't create image from buffer")
        }

        self.image = Image(nsImage: bufferImage)

        for y in 0..<mapSize.height() {
            for x in 0..<mapSize.width() {

                self.updateBufferAt(x: x, y: y)
            }
        }

        self.updateTextureFromBuffer()
    }
    
    private func updateBufferAt(x: Int, y: Int) {

        guard let game = self.game else {
            fatalError("no map")
        }

        let index = y * game.mapSize().width() + x

        if let tile = game.tile(x: x, y: y) {
            
            if true || tile.isDiscovered(by: self.player) {
                
                if let owner = tile.owner() {
                    if tile.isCity() {
                        let color = owner.leader.civilization().accent
                        self.buffer.set(color: color, at: index)
                    } else {
                        let color = owner.leader.civilization().main
                        self.buffer.set(color: color, at: index)
                    }
                } else {
                    var color = tile.terrain().overviewColor()
                    
                    /*if tile.hasHills() {
                        color = UIColor(red: 237, green: 240, blue: 240)
                    }*/
                    
                    if tile.has(feature: .mountains) || tile.has(feature: .mountEverest) || tile.has(feature: .mountKilimanjaro) {
                        color = NSColor.Terrain.mountains
                    }
                    
                    self.buffer.set(color: color, at: index)
                }
                
            } else {
                self.buffer.set(color: NSColor.Terrain.background, at: index)
            }
        }
    }

    private func updateTextureFromBuffer() {

        guard let bufferImage = self.buffer.toNSImage() else {
            fatalError("can't create image from buffer")
        }
        
        /*if bufferImage.size.width < self.size.width {
            if let tmpImage = bufferImage.resizeRasterizedTo(targetSize: CGSize(width: self.size.width, height: self.size.height)) {
                bufferImage = tmpImage
            }
        }*/
        
        /*let deltaHeight = self.size.height - image.size.height
        if deltaHeight > 0 {
            let insets = UIEdgeInsets(top: deltaHeight / 2, left: 0, bottom: deltaHeight / 2, right: 0)
            if let tmpImage = image.imageWithInsets(insets: insets){
                image = tmpImage
            }
        }*/

        self.image = Image(nsImage: bufferImage)
    }
    
    func changed(at pt: HexPoint) {

        self.updateBufferAt(x: pt.x, y: pt.y)
        self.updateTextureFromBuffer()
    }
}
