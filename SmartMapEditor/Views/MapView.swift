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
    func focus(on tile: AbstractTile)
}

class MapView: NSView {

    // constants
    let shift = CGPoint(x: 575, y: 1360)

    // properties
    private var scale: CGFloat = 1.0
    var downPoint: CGPoint? = nil
    var initialPoint: CGPoint? = nil

    var cursor: HexPoint = HexPoint.zero
    
    var textures: Textures = Textures(map: nil)
    var imageCache: ImageCache = ImageCache()

    weak var delegate: MapViewDelegate?

    var map: MapModel? = nil {
        didSet {

            if let size = map?.contentSize() {
                
                self.frame = NSMakeRect(0, 0, (size.width + 10) * self.scale, size.height * self.scale)
                
                self.widthConstraint?.constant = (size.width + 10) * self.scale
                self.heightConstraint?.constant = size.height * self.scale

                print("set new size: \(size)")
            }
            
            let iceFeatureTiles = map?.points().filter({ map?.tile(at: $0)?.feature() == .ice})
            print("ice tiles: \(iceFeatureTiles?.count)")
            
            self.textures = Textures(map: map)

            self.needsDisplay = true
        }
    }

    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidMoveToSuperview() {

        if self.superview != nil {
            print("-- viewDidMoveToSuperview")
            self.setup()
        }
    }

    override func mouseDown(with event: NSEvent) {

        super.mouseDown(with: event)

        self.downPoint = event.locationInWindow
        self.initialPoint = event.locationInWindow
    }

    override func mouseDragged(with event: NSEvent) {

        super.mouseDragged(with: event)

        if let point = self.downPoint {
            self.delegate?.moveBy(dx: event.locationInWindow.x - point.x, dy: event.locationInWindow.y - point.y)
            self.downPoint = event.locationInWindow
        }
    }

    override func mouseUp(with event: NSEvent) {

        super.mouseUp(with: event)

        if let point = self.initialPoint {
            if abs(event.locationInWindow.x - point.x) < 0.001 && abs(event.locationInWindow.y - point.y) < 0.001 {

                let pointInView = convert(event.locationInWindow, from: nil) - self.shift
                let pt = HexPoint(screen: pointInView)

                if let tile = self.map?.tile(at: pt) {

                    // print("click at \(pt)")
                    self.delegate?.focus(on: tile)
                    self.cursor = pt
                    //self.needsDisplay = true
                    self.setNeedsDisplay(NSMakeRect(pointInView.x, pointInView.y, 48, 48))
                    self.needsDisplay = true
                }
            }
        }

        self.downPoint = nil
        self.initialPoint = nil
    }

    override func draw(_ dirtyRect: NSRect) {

        // print("draw(\(dirtyRect))")
        
        super.draw(dirtyRect)

        NSColor.systemGray.setFill()
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
                    
                    // populate cache if needed
                    if !self.imageCache.exists(key: terrainTextureName) {
                        self.imageCache.add(image: Bundle.init(for: Textures.self).image(forResource: terrainTextureName), for: terrainTextureName)
                        // self.imageCache.add(image: NSImage(named: terrainTextureName), for: terrainTextureName)
                    }

                    // fetch from cache
                    context?.draw(self.imageCache.image(for: terrainTextureName).cgImage!, in: tileRect)

                    continue
                    
                    // river
                    if let riverTexture = self.textures.riverTexture(at: tile.point) {
                        
                        // populate cache if needed
                        if !self.imageCache.exists(key: riverTexture) {
                            self.imageCache.add(image: NSImage(named: riverTexture), for: riverTexture)
                        }
                        
                        // fetch from cache
                        context?.draw(self.imageCache.image(for: riverTexture).cgImage!, in: tileRect)
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
                        
                        let neighborTiles: [HexDirection: AbstractTile?]  = [
                            .north: neighborTileN,
                            .northeast: neighborTileNE,
                            .southeast: neighborTileSE,
                            .south: neighborTileS,
                            .southwest: neighborTileSW,
                            .northwest: neighborTileNW
                        ]
                        
                        if let featureTextureName = self.textures.featureTexture(for: tile, neighborTiles: neighborTiles) {
                            
                            // populate cache if needed
                            if !self.imageCache.exists(key: featureTextureName) {
                                self.imageCache.add(image: NSImage(named: featureTextureName), for: featureTextureName)
                            }
                            
                            // fetch from cache
                            context?.draw(self.imageCache.image(for: featureTextureName).cgImage!, in: tileRect)
                        }
                    }
                    
                    if tile.feature() != .ice {
                        
                        if let iceTextureName = self.textures.iceTexture(at: tile.point) {

                            // populate cache if needed
                            if !self.imageCache.exists(key: iceTextureName) {
                                self.imageCache.add(image: Bundle.main.image(forResource: iceTextureName), for: iceTextureName)
                                //self.imageCache.add(image: NSImage(named: iceTextureName), for: iceTextureName)
                            }
                            
                            // fetch from cache
                            context?.draw(self.imageCache.image(for: iceTextureName).cgImage!, in: tileRect)
                        }
                    }
                    
                    // resource
                    if tile.resource(for: nil) != .none {
                        
                        let resourceTextureName = tile.resource(for: nil).textureName()
                        
                        // populate cache if needed
                        if !self.imageCache.exists(key: resourceTextureName) {
                            self.imageCache.add(image: NSImage(named: resourceTextureName), for: resourceTextureName)
                        }
                        
                        // fetch from cache
                        context?.draw(self.imageCache.image(for: resourceTextureName).cgImage!, in: tileRect)
                    }

                    // cursor
                    if cursor == pt {
                        
                        // populate cache if needed
                        if !self.imageCache.exists(key: "cursor") {
                            self.imageCache.add(image: NSImage(named: "cursor"), for: "cursor")
                        }
                        
                        // fetch from cache
                        context?.draw(self.imageCache.image(for: "cursor").cgImage!, in: tileRect)
                    }
                }
            }
        }
    }

    private func setup() {

        self.frame = NSMakeRect(0, 0, 1000.0, 1000.0)
        
        self.widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1000.0)
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1000.0)
        
        self.addConstraints([self.widthConstraint!, self.heightConstraint!])
        
        // pre load assets
    }

    /// setViewSize - sets the size of the view
    /// - parameter value: size
    ///
    func setViewSize(_ value: CGFloat) {

        self.scale = value

        if let size = self.map?.contentSize() {
            self.widthConstraint?.constant = (size.width + 10) * self.scale
            self.heightConstraint?.constant = size.height * self.scale

            print("set new size: \(size)")
        }

        // First, match our scaling to the window's coordinate system
        self.scaleUnitSquare(to: NSMakeSize(CGFloat(value), CGFloat(value)))
        self.needsDisplay = true
    }
}
