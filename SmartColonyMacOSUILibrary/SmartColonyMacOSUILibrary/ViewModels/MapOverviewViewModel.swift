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

extension MapLensType: Identifiable {

    public var id: RawValue { rawValue }
}

protocol MapOverviewViewModelDelegate: AnyObject {

    func minimapClicked(on point: HexPoint)

    func selected(mapLens: MapLensType)
}

public class MapOverviewViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    private let dx = 9
    private let dy = 6
    private var buffer: PixelBuffer = PixelBuffer(width: MapSize.duel.width(),
                                                  height: MapSize.duel.height(),
                                                  color: Globals.Colors.overviewBackground)
    private var lineOffset = MapSize.duel.width() * 9
    private var mapSize: MapSize = MapSize.duel

    private weak var player: AbstractPlayer?

    @Published
    var image: Image = Image(systemName: "sun.max.fill")

    @Published
    var topLeft: CGPoint = CGPoint(x: 50, y: 50)

    @Published
    var topRight: CGPoint = CGPoint(x: 50, y: 50)

    @Published
    var bottomLeft: CGPoint = CGPoint(x: 50, y: 50)

    @Published
    var bottomRight: CGPoint = CGPoint(x: 50, y: 50)

    @Published
    var showMapLens: Bool {
        didSet {
            if !self.showMapLens {
                self.delegate?.selected(mapLens: .none)
            }
        }
    }

    @Published
    var selectedMapLens: MapLensType {
        didSet {
            self.delegate?.selected(mapLens: self.selectedMapLens)
            self.mapLensLegendViewModel.mapLens = self.selectedMapLens
        }
    }

    @Published
    var mapLensLegendViewModel: MapLensLegendViewModel

    weak var delegate: MapOverviewViewModelDelegate?

    public init() {

        self.showMapLens = false
        self.selectedMapLens = MapLensType.none
        self.mapLensLegendViewModel = MapLensLegendViewModel()

        if let game = gameEnvironment.game.value {

            self.player = game.humanPlayer()

            self.mapSize = game.mapSize()
            let contentSize: CGSize = game.contentSize() / 7.5
            self.buffer = PixelBuffer(width: Int(contentSize.width),
                                      height: Int(contentSize.height),
                                      color: Globals.Colors.overviewBackground)

            self.lineOffset = Int(contentSize.width)

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

    func canvasImage() -> NSImage {

        return ImageCache.shared.image(for: "map-overview-canvas")
    }

    func mapLensImage() -> NSImage {

        if self.showMapLens {
            return ImageCache.shared.image(for: "map-lens-active")
        } else {
            return ImageCache.shared.image(for: "map-lens")
        }
    }

    func mapLensClicked() {

        self.showMapLens = !self.showMapLens

        // if map lens is toogle on, we send the map lens to the view options again
        if self.showMapLens {
            self.delegate?.selected(mapLens: self.selectedMapLens)
        }
    }

    func mapMarkerImage() -> NSImage {

        return ImageCache.shared.image(for: "map-marker")
    }

    func mapMarkerClicked() {

        print("mapMarkerClicked")
    }

    func mapOptionImage() -> NSImage {

        return ImageCache.shared.image(for: "map-options")
    }

    func mapOptionClicked() {

        print("mapOptionClicked")
    }

    func assign(game: GameModel?) {

        var gameRef: GameModel?
        if self.gameEnvironment.game.value == nil {
            self.gameEnvironment.game.send(game)
            gameRef = game
        } else {
            gameRef = self.gameEnvironment.game.value
        }

        guard let game = gameRef else {
            fatalError("need to assign a valid game")
        }

        self.player = game.humanPlayer()

        self.mapSize = game.mapSize()
        let contentSize: CGSize = game.contentSize() / 7.5
        self.buffer = PixelBuffer(width: Int(contentSize.width),
                                  height: Int(contentSize.height),
                                  color: Globals.Colors.overviewBackground)

        self.lineOffset = Int(contentSize.width)

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
        let lineIndex = Int(-screenPoint.y) * self.lineOffset + Int(screenPoint.x - offset)

        for index in 0...6 {
            self.buffer.set(color: color, at: lineIndex + index)
            self.buffer.set(color: color, at: lineIndex + 5 * self.lineOffset + index)
        }

        for index in -1...7 {
            self.buffer.set(color: color, at: lineIndex + self.lineOffset + index)
            self.buffer.set(color: color, at: lineIndex + 4 * self.lineOffset + index)
        }

        for index in -2...8 {
            self.buffer.set(color: color, at: lineIndex + 2 * self.lineOffset + index)
            self.buffer.set(color: color, at: lineIndex + 3 * self.lineOffset + index)
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

    func clicked(on point: CGPoint) {

        guard let game = self.gameEnvironment.game.value else {
            fatalError("no map")
        }

        // overview image is scaled to .frame(width: 156, height: 94)
        let scaled: CGPoint = CGPoint(x: point.x / 156.0 + 0.05, y: 1.0 - (point.y / 94.0)) // 0..1 x 0..1

        var tmpPoint: CGPoint = CGPoint.zero
        var minX: CGFloat = CGFloat(Float.greatestFiniteMagnitude)
        var startX: CGFloat = CGFloat(Float.greatestFiniteMagnitude)
        var maxX: CGFloat = CGFloat(Float.leastNormalMagnitude)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: self.mapSize.width(), y: self.mapSize.height()))
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: 0, y: self.mapSize.height()))
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: self.mapSize.width(), y: 0))
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: 0, y: 0))
        startX = tmpPoint.x
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)

        let relNeg = (startX - minX) / (maxX - minX)
        let contentSize: CGSize = game.contentSize()
        let corrected: CGPoint = CGPoint(
            x: (scaled.x - relNeg) * contentSize.width,
            y: (scaled.y - 1.0) * contentSize.height
        )
        let mapPoint = HexPoint(screen: corrected)

        self.delegate?.minimapClicked(on: mapPoint)
    }

    func updateRect(at point: HexPoint, size: CGSize) {

        let centerScreen = HexPoint.toScreen(hex: point)

        var topLeftScreen = centerScreen
        topLeftScreen.x -= size.width / 2.0
        topLeftScreen.y -= size.height / 2.0

        var topRightScreen = centerScreen
        topRightScreen.x += size.width / 2.0
        topRightScreen.y -= size.height / 2.0

        var bottomLeftScreen = centerScreen
        bottomLeftScreen.x -= size.width / 2.0
        bottomLeftScreen.y += size.height / 2.0

        var bottomRightScreen = centerScreen
        bottomRightScreen.x += size.width / 2.0
        bottomRightScreen.y += size.height / 2.0

        self.topLeft = self.translateToMinimap(screen: topLeftScreen)
        self.topRight = self.translateToMinimap(screen: topRightScreen)
        self.bottomLeft = self.translateToMinimap(screen: bottomLeftScreen)
        self.bottomRight = self.translateToMinimap(screen: bottomRightScreen)
    }

    private func translateToMinimap(screen: CGPoint) -> CGPoint {

        // 156.0 / 94.0
        guard let game = self.gameEnvironment.game.value else {
            fatalError("no map")
        }

        let contentSize: CGSize = game.contentSize()
        let scalex = 156.0 / contentSize.width
        let scaley = 94.0 / contentSize.height
        return CGPoint(x: screen.x * scalex + 85.0, y: 94.0 - (screen.y * scaley) - 70.0)
    }
}
