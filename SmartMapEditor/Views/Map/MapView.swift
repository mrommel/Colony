//
//  MapView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.11.20.
//

import Cocoa
import AppKit
import CoreGraphics
import SwiftUI
import SmartAILibrary
import SmartAssets

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

protocol MapViewDelegate: class {

    func moveBy(dx: CGFloat, dy: CGFloat)
    func focus(on tile: Tile)
    func draw(at point: HexPoint)
}

class MapView: NSView {

    // constants
    var shift = CGPoint(x: 575, y: 1360)

    // properties
    private var scale: CGFloat = 1.0
    var downPoint: CGPoint? = nil
    var initialPoint: CGPoint? = nil
    var rightDownPoint: CGPoint? = nil

    var cursor: HexPoint = HexPoint.zero

    var textures: Textures = Textures(game: nil)

    weak var delegate: MapViewDelegate?

    var map: MapModel? = nil {
        didSet {
            print("--- map has been set ---")
            if let size = map?.contentSize(), let mapSize = map?.size {

                self.frame = NSMakeRect(0, 0, (size.width + 10) * self.scale, size.height * self.scale)

                self.widthConstraint?.constant = (size.width + 10) * self.scale
                self.heightConstraint?.constant = size.height * self.scale
                
                // change shift
                let p0 = HexPoint(x: 0, y: 0)
                let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
                let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
                let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
                let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
                    
                self.shift = CGPoint(x: dx, y: dy)
            }

            // create a dummy game
            if let m = map {
                let barbarian = Player(leader: .barbar)
                let game = GameModel(victoryTypes: [.cultural], handicap: .chieftain, turnsElapsed: 0, players: [barbarian], on: m)
                self.textures = Textures(game: game)
            }

            self.needsDisplay = true
        }
    }

    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    override func viewDidMoveToSuperview() {

        if self.superview != nil {
            self.setup()
        }
    }
    
    private func setup() {

        self.frame = NSMakeRect(0, 0, 1000.0, 1000.0)

        self.widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1000.0)
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1000.0)

        self.addConstraints([self.widthConstraint!, self.heightConstraint!])

        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)

        print("- load \(self.textures.allTerrainTextureNames.count) terrain, \(self.textures.allRiverTextureNames.count) river and \(self.textures.allCoastTextureNames.count) coast textures")
        for terrainTextureName in self.textures.allTerrainTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: terrainTextureName), for: terrainTextureName)
        }

        for coastTextureName in self.textures.allCoastTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: coastTextureName), for: coastTextureName)
        }

        for riverTextureName in self.textures.allRiverTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: riverTextureName), for: riverTextureName)
        }

        print("- load \(self.textures.allFeatureTextureNames.count) feature (+ \(self.textures.allIceFeatureTextureNames.count) ice) textures")
        for featureTextureName in self.textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: featureTextureName), for: featureTextureName)
        }

        for iceFeatureTextureName in self.textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: iceFeatureTextureName), for: iceFeatureTextureName)
        }

        print("- load \(self.textures.allResourceTextureNames.count) resource textures")
        for resourceTextureName in self.textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceTextureName), for: resourceTextureName)
        }

        print("-- all textures loaded --")
    }

    // left button down
    override func mouseDown(with event: NSEvent) {

        super.mouseDown(with: event)

        self.downPoint = event.locationInWindow
        self.initialPoint = event.locationInWindow
    }

    override func rightMouseDown(with event: NSEvent) {
        
        super.rightMouseDown(with: event)
        
        let pointInView = convert(event.locationInWindow, from: nil) - self.shift
        let pt = HexPoint(screen: pointInView)
        
        self.delegate?.draw(at: pt)
    }
    
    override func mouseDragged(with event: NSEvent) {

        super.mouseDragged(with: event)

        if let point = self.downPoint {
            self.delegate?.moveBy(dx: event.locationInWindow.x - point.x, dy: event.locationInWindow.y - point.y)
            self.downPoint = event.locationInWindow
        }
    }

    override func rightMouseDragged(with event: NSEvent) {
        
        super.rightMouseDragged(with: event)
        
        let pointInView = convert(event.locationInWindow, from: nil) - self.shift
        let pt = HexPoint(screen: pointInView)
        
        self.delegate?.draw(at: pt)
    }
    
    override func mouseUp(with event: NSEvent) {

        super.mouseUp(with: event)

        if let point = self.initialPoint {
            if abs(event.locationInWindow.x - point.x) < 0.001 && abs(event.locationInWindow.y - point.y) < 0.001 {

                let pointInView = convert(event.locationInWindow, from: nil) - self.shift
                let pt = HexPoint(screen: pointInView)

                if let tile = self.map?.tile(at: pt) {

                    self.delegate?.focus(on: tile as! Tile)
                    self.cursor = pt

                    self.redrawTile(at: pt)
                }
            }
        }

        self.downPoint = nil
        self.initialPoint = nil
    }

    func redrawTile(at point: HexPoint) {

        let screenPoint = HexPoint.toScreen(hex: point) + shift
        let tileRect = CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48)

        self.setNeedsDisplay(tileRect)
        self.needsDisplay = true
    }
    
    func redrawAll() {
        
        self.needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {

        super.draw(dirtyRect)

        NSColor.darkGray.setFill()
        dirtyRect.fill()

        if let map = self.map {

            let context = NSGraphicsContext.current?.cgContext
            let mapSize = map.size

            for x in 0..<mapSize.width() {

                for y in 0..<mapSize.height() {

                    let pt = HexPoint(x: x, y: y)

                    let screenPoint = HexPoint.toScreen(hex: pt) + shift
                    let tileRect = CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48)

                    if !self.needsToDraw(tileRect) {
                        continue
                    }

                    guard let tile = map.tile(at: pt) else {
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
                    context?.draw(ImageCache.shared.image(for: terrainTextureName).cgImage!, in: tileRect)

                    // river
                    if let riverTexture = self.textures.riverTexture(at: tile.point) {

                        // fetch from cache
                        context?.draw(ImageCache.shared.image(for: riverTexture).cgImage!, in: tileRect)
                    }

                    // feature
                    // place forests etc
                    if tile.feature() != .none {

                        let neighborTileN = map.tile(at: pt.neighbor(in: .north))
                        let neighborTileNE = map.tile(at: pt.neighbor(in: .northeast))
                        let neighborTileSE = map.tile(at: pt.neighbor(in: .southeast))
                        let neighborTileS = map.tile(at: pt.neighbor(in: .south))
                        let neighborTileSW = map.tile(at: pt.neighbor(in: .southwest))
                        let neighborTileNW = map.tile(at: pt.neighbor(in: .northwest))

                        let neighborTiles: [HexDirection: AbstractTile?] = [
                                .north: neighborTileN,
                                .northeast: neighborTileNE,
                                .southeast: neighborTileSE,
                                .south: neighborTileS,
                                .southwest: neighborTileSW,
                                .northwest: neighborTileNW
                        ]

                        if let featureTextureName = self.textures.featureTexture(for: tile, neighborTiles: neighborTiles) {

                            // fetch from cache
                            context?.draw(ImageCache.shared.image(for: featureTextureName).cgImage!, in: tileRect)
                        }
                    }

                    if tile.feature() != .ice {

                        if let iceTextureName = self.textures.iceTexture(at: tile.point) {

                            // fetch from cache
                            context?.draw(ImageCache.shared.image(for: iceTextureName).cgImage!, in: tileRect)
                        }
                    }

                    // resource
                    if tile.resource(for: nil) != .none {

                        let resourceTextureName = tile.resource(for: nil).textureName()

                        // fetch from cache
                        context?.draw(ImageCache.shared.image(for: resourceTextureName).cgImage!, in: tileRect)
                    }
                    
                    // draw start position
                    if map.startLocations.first(where: { $0.point == pt }) != nil {
                        
                        if !ImageCache.shared.exists(key: "flag") {
                            ImageCache.shared.add(image: NSImage(named: "flag"), for: "flag")
                        }
        
                        context?.draw(ImageCache.shared.image(for: "flag").cgImage!, in: tileRect)
                    }
                    
                    // inhabitants
                    let inhabitants = map.inhabitants(at: pt)
                        
                    if inhabitants > 0 {
                        
                        /*if !ImageCache.shared.exists(key: "flag") {
                            ImageCache.shared.add(image: NSImage(named: "flag"), for: "flag")
                        }*/
                        
                        if inhabitants > 10000 {
                            context?.draw(NSImage(named: "bars_veryhigh")!.cgImage!, in: tileRect)
                        } else if inhabitants > 5000 {
                            context?.draw(NSImage(named: "bars_high")!.cgImage!, in: tileRect)
                        } else if inhabitants > 2000 {
                            context?.draw(NSImage(named: "bars_medium")!.cgImage!, in: tileRect)
                        } else if inhabitants > 1000 {
                            context?.draw(NSImage(named: "bars_small")!.cgImage!, in: tileRect)
                        } else {
                            context?.draw(NSImage(named: "bars_verysmall")!.cgImage!, in: tileRect)
                        }
                    }

                    // cursor
                    if cursor == pt {

                        // populate cache if needed
                        if !ImageCache.shared.exists(key: "cursor") {
                            ImageCache.shared.add(image: NSImage(named: "cursor"), for: "cursor")
                        }

                        // fetch from cache
                        context?.draw(ImageCache.shared.image(for: "cursor").cgImage!, in: tileRect)
                    }
                }
            }
        }
    }

    /// setViewSize - sets the size of the view
    /// - parameter value: size
    ///
    func setViewSize(_ value: CGFloat) {

        if self.scale == value {
            // nothing to do
            return
        }
        
        let oldScale = self.scale
        self.scale = value
        
        let factor = value / oldScale
        print("from \(oldScale) to \(value) means \(factor)")

        if let size = self.map?.contentSize(), let mapSize = self.map?.size {
            self.widthConstraint?.constant = (size.width + 10) * self.scale
            self.heightConstraint?.constant = size.height * self.scale

            self.frame = NSMakeRect(0, 0, (size.width + 10) * self.scale, size.height * self.scale)

            // change shift
            let p0 = HexPoint(x: 0, y: 0)
            let p1 = HexPoint(x: 0, y: mapSize.height() - 1)
            let p2 = HexPoint(x: mapSize.width() - 1, y: mapSize.height() - 1)
            let dx = HexPoint.toScreen(hex: p0).x - HexPoint.toScreen(hex: p1).x
            let dy = HexPoint.toScreen(hex: p0).y - HexPoint.toScreen(hex: p2).y
                
            self.shift = CGPoint(x: dx, y: dy)
            
            // First, match our scaling to the window's coordinate system
            self.scaleUnitSquare(to: NSMakeSize(CGFloat(factor), CGFloat(factor)))
            // self.setNeedsDisplay(NSMakeRect(0, 0, (size.width + 10) * self.scale, size.height * self.scale))
            self.needsDisplay = true
        }
    }
}
