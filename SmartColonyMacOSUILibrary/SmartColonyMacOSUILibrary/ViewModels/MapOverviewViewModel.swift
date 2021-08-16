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
    private var buffer: PixelBuffer = PixelBuffer(width: MapSize.duel.width(),
                                                  height: MapSize.duel.height(),
                                                  color: Globals.Colors.overviewBackground)
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
            let contentSize: CGSize = game.contentSize() / 7.5
            self.buffer = PixelBuffer(width: Int(contentSize.width),
                                      height: Int(contentSize.height),
                                      color: Globals.Colors.overviewBackground)

            self.line = Int(contentSize.width)

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
        let contentSize: CGSize = game.contentSize() / 7.5
        self.buffer = PixelBuffer(width: Int(contentSize.width),
                                  height: Int(contentSize.height),
                                  color: Globals.Colors.overviewBackground)

        self.line = Int(contentSize.width)

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
                        color = NSColor.Feature.mountains
                    }

                    if tile.has(feature: .ice) {
                        color = NSColor.Feature.ice
                    }

                    self.updateBufferAt(pt: pt, with: color)
                }

            } else {
                self.updateBufferAt(pt: pt, with: NSColor.Terrain.background)
            }
        }
    }

    private func updateBufferAt(pt: HexPoint, with color: NSColor) {

        let offset = HexPoint.toScreen(hex: HexPoint(x: 0, y: self.mapSize.height() - 1)).x / 7.5
        let screenPoint = HexPoint.toScreen(hex: pt) / 7.5
        let index = Int(-screenPoint.y) * self.line + Int(screenPoint.x - offset)

        for i in 0...6 {
            self.buffer.set(color: color, at: index + i)
            self.buffer.set(color: color, at: index + 5 * self.line + i)
        }

        for i in -1...7 {
            self.buffer.set(color: color, at: index + self.line + i)
            self.buffer.set(color: color, at: index + 4 * self.line + i)
        }

        for i in -2...8 {
            self.buffer.set(color: color, at: index + 2 * self.line + i)
            self.buffer.set(color: color, at: index + 3 * self.line + i)
        }
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
