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
    
    private let dx = 9
    private let dy = 6
    private var buffer: PixelBuffer = PixelBuffer(width: MapSize.duel.width(), height: MapSize.duel.height(), color: NSColor.black)
    private var line = MapSize.duel.width() * 9
    private var mapSize: MapSize = MapSize.duel
    
    private weak var player: AbstractPlayer?
    
    @Published
    var image: Image = Image(systemName: "sun.max.fill")
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    public init() {
        
        if let game = gameEnvironment.game.value {
        
            self.player = game.humanPlayer()
            
            self.mapSize = game.mapSize()
            let width = self.mapSize.width() * self.dx
            let height = self.mapSize.height() * self.dy + self.dy / 2
            self.buffer = PixelBuffer(width: width, height: height, color: NSColor.black)
            
            self.line = self.mapSize.width() * self.dx

            guard let bufferImage = self.buffer.toNSImage() else {
                fatalError("can't create image from buffer")
            }

            self.image = Image(nsImage: bufferImage)

            for y in 0..<self.mapSize.height() {
                for x in 0..<self.mapSize.width() {

                    self.updateBufferAt(pt: HexPoint(x: x, y: y))
                }
            }

            self.updateTextureFromBuffer()
        } else {
            // demo initialization
            self.player = nil

            guard let bufferImage = self.buffer.toNSImage() else {
                fatalError("can't create image from buffer")
            }

            self.image = Image(nsImage: bufferImage)
        }
    }
    
    func assign(game: GameModel?) {
        
        guard let game = self.gameEnvironment.game.value else {
            fatalError("need to assign a valid game")
        }
        
        self.player = game.humanPlayer()
        
        self.mapSize = game.mapSize()
        let width = self.mapSize.width() * self.dx
        let height = self.mapSize.height() * self.dy + self.dy / 2
        self.buffer = PixelBuffer(width: width, height: height, color: NSColor.black)
        
        self.line = self.mapSize.width() * self.dx

        guard let bufferImage = self.buffer.toNSImage() else {
            fatalError("can't create image from buffer")
        }

        self.image = Image(nsImage: bufferImage)
        
        for y in 0..<self.mapSize.height() {
            for x in 0..<self.mapSize.width() {

                self.updateBufferAt(pt: HexPoint(x: x, y: y))
            }
        }

        self.updateTextureFromBuffer()
    }
    
    private func updateBufferAt(pt: HexPoint) {

        guard let game = self.gameEnvironment.game.value else {
            fatalError("no map")
        }
        
        if pt.x < 0 || pt.y < 0 || pt.x >= self.mapSize.width() || pt.y >= self.mapSize.height() {
            return
        }

        if let tile = game.tile(at: pt) {
            
            if tile.isDiscovered(by: self.player) {
                
                if let owner = tile.owner() {
                    if tile.isCity() {
                        let color = owner.leader.civilization().accent
                        self.updateBufferAt(pt: pt, with: color)
                    } else {
                        let color = owner.leader.civilization().main
                        self.updateBufferAt(pt: pt, with: color)
                    }
                } else {
                    var color = tile.terrain().overviewColor()
                    
                    /*if tile.hasHills() {
                        color = UIColor(red: 237, green: 240, blue: 240)
                    }*/
                    
                    if tile.has(feature: .mountains) || tile.has(feature: .mountEverest) || tile.has(feature: .mountKilimanjaro) {
                        color = NSColor.Terrain.mountains
                    }
                    
                    self.updateBufferAt(pt: pt, with: color)
                }
                
            } else {
                self.updateBufferAt(pt: pt, with: NSColor.Terrain.background)
            }
        }
    }
    
    private func updateBufferAt(pt: HexPoint, with color: NSColor) {
        
        let index = pt.y * self.dy * self.line + (pt.x % 2 == 1 ? self.dy / 2 * self.line : 0) + (pt.x * self.dx)
        
        self.buffer.set(color: color, at: index)
        self.buffer.set(color: color, at: index + 1)
        self.buffer.set(color: color, at: index + 2)
        self.buffer.set(color: color, at: index + 3)
        self.buffer.set(color: color, at: index + 4)
        self.buffer.set(color: color, at: index + 5)
        self.buffer.set(color: color, at: index + 6)
        
        self.buffer.set(color: color, at: index + self.line - 1) // -1
        self.buffer.set(color: color, at: index + self.line)
        self.buffer.set(color: color, at: index + self.line + 1)
        self.buffer.set(color: color, at: index + self.line + 2)
        self.buffer.set(color: color, at: index + self.line + 3)
        self.buffer.set(color: color, at: index + self.line + 4)
        self.buffer.set(color: color, at: index + self.line + 5)
        self.buffer.set(color: color, at: index + self.line + 6)
        self.buffer.set(color: color, at: index + self.line + 7) // +1
        
        self.buffer.set(color: color, at: index + 2 * self.line - 2) // -2
        self.buffer.set(color: color, at: index + 2 * self.line - 1) // -1
        self.buffer.set(color: color, at: index + 2 * self.line)
        self.buffer.set(color: color, at: index + 2 * self.line + 1)
        self.buffer.set(color: color, at: index + 2 * self.line + 2)
        self.buffer.set(color: color, at: index + 2 * self.line + 3)
        self.buffer.set(color: color, at: index + 2 * self.line + 4)
        self.buffer.set(color: color, at: index + 2 * self.line + 5)
        self.buffer.set(color: color, at: index + 2 * self.line + 6)
        self.buffer.set(color: color, at: index + 2 * self.line + 7) // +1
        self.buffer.set(color: color, at: index + 2 * self.line + 8) // +2
        
        self.buffer.set(color: color, at: index + 3 * self.line - 2) // -2
        self.buffer.set(color: color, at: index + 3 * self.line - 1) // -1
        self.buffer.set(color: color, at: index + 3 * self.line)
        self.buffer.set(color: color, at: index + 3 * self.line + 1)
        self.buffer.set(color: color, at: index + 3 * self.line + 2)
        self.buffer.set(color: color, at: index + 3 * self.line + 3)
        self.buffer.set(color: color, at: index + 3 * self.line + 4)
        self.buffer.set(color: color, at: index + 3 * self.line + 5)
        self.buffer.set(color: color, at: index + 3 * self.line + 6)
        self.buffer.set(color: color, at: index + 3 * self.line + 7) // +1
        self.buffer.set(color: color, at: index + 3 * self.line + 8) // +2
        
        self.buffer.set(color: color, at: index + 4 * self.line - 1) // -1
        self.buffer.set(color: color, at: index + 4 * self.line)
        self.buffer.set(color: color, at: index + 4 * self.line + 1)
        self.buffer.set(color: color, at: index + 4 * self.line + 2)
        self.buffer.set(color: color, at: index + 4 * self.line + 3)
        self.buffer.set(color: color, at: index + 4 * self.line + 4)
        self.buffer.set(color: color, at: index + 4 * self.line + 5)
        self.buffer.set(color: color, at: index + 4 * self.line + 6)
        self.buffer.set(color: color, at: index + 4 * self.line + 7) // +1
        
        self.buffer.set(color: color, at: index + 5 * self.line)
        self.buffer.set(color: color, at: index + 5 * self.line + 1)
        self.buffer.set(color: color, at: index + 5 * self.line + 2)
        self.buffer.set(color: color, at: index + 5 * self.line + 3)
        self.buffer.set(color: color, at: index + 5 * self.line + 4)
        self.buffer.set(color: color, at: index + 5 * self.line + 5)
        self.buffer.set(color: color, at: index + 5 * self.line + 6)
    }

    private func updateTextureFromBuffer() {

        guard let bufferImage = self.buffer.toNSImage() else {
            fatalError("can't create image from buffer")
        }

        self.image = Image(nsImage: bufferImage)
    }
    
    func changed(at pt: HexPoint) {

        self.updateBufferAt(pt: pt)
        self.updateTextureFromBuffer()
    }
}
