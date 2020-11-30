//
//  MapView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.11.20.
//

import Cocoa
import AppKit
import CoreGraphics
import SmartAILibrary

extension Array {

    public func item(from point: HexPoint) -> Element {
        //let index = Int.random(minimum: 0, maximum: self.count - 1)

        let index = (point.x + point.y) % self.count

        return self[index]
    }
}

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
    let unitSize: NSSize = NSMakeSize(1.0, 1.0)

    // properties
    var scale: CGFloat = 1.0
    var downPoint: CGPoint? = nil
    var initialPoint: CGPoint? = nil

    var cursor: HexPoint = HexPoint.zero
    
    var textures: Textures = Textures(map: nil)

    weak var delegate: MapViewDelegate?

    var map: MapModel? = nil {
        didSet {

            if let size = map?.contentSize() {
                
                self.frame = NSMakeRect(0, 0, (size.width + 10) * self.scale, size.height * self.scale)
                
                self.widthConstraint?.constant = (size.width + 10) * self.scale
                self.heightConstraint?.constant = size.height * self.scale

                print("set new size: \(size)")
            }
            
            self.textures = Textures(map: map)

            self.needsDisplay = true
        }
    }

    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    override func viewDidMoveToSuperview() {

        print("-- viewDidMoveToSuperview")
        self.setup()
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
                    self.needsDisplay = true
                }
            }
        }

        self.downPoint = nil
        self.initialPoint = nil
    }

    override func draw(_ dirtyRect: NSRect) {

        super.draw(dirtyRect)

        NSColor.lightGray.setFill()
        dirtyRect.fill()

        if let map = self.map {

            let context = NSGraphicsContext.current?.cgContext
            let mapSize = map.size

            for x in 0..<mapSize.width() {

                for y in 0..<mapSize.height() {

                    let pt = HexPoint(x: x, y: y)

                    guard let tile = map.tile(at: pt) else {
                        continue
                    }

                    let screenPoint = HexPoint.toScreen(hex: pt) + shift

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

                    if let image = NSImage(named: terrainTextureName) {
                        context?.draw(image.cgImage!, in: CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48))
                    } else {
                        print("terrain texture \(terrainTextureName) not found")
                    }
                    
                    // river
                    if let riverTexture = self.textures.riverTexture(at: tile.point) {
                        if let image = NSImage(named: riverTexture) {
                            context?.draw(image.cgImage!, in: CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48))
                        } else {
                            print("river texture \(riverTexture) not found")
                        }
                    }

                    // feature
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
                        if let image = NSImage(named: featureTextureName) {
                            context?.draw(image.cgImage!, in: CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48))
                        } else {
                            print("feature texture \(featureTextureName) not found")
                        }
                    }
                    
                    // resource
                    if tile.resource(for: nil) != .none {
                        let resourceTextureName = tile.resource(for: nil).textureName()
                        if let image = NSImage(named: resourceTextureName) {
                            context?.draw(image.cgImage!, in: CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48))
                        } else {
                            print("resource texture \(resourceTextureName) not found")
                        }
                    }

                    // cursor
                    if cursor == pt {
                        if let image = NSImage(named: "cursor") {
                            context?.draw(image.cgImage!, in: CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48))
                        }
                    }
                }
            }
        }
    }

    private func setup() {

        //self.widthConstraint = self.constraints.first(where: { $0.identifier == "canvas_width" })
        //self.heightConstraint = self.constraints.first(where: { $0.identifier == "canvas_height" })
        
        self.widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1000.0)
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1000.0)
        
        self.addConstraints([self.widthConstraint!, self.heightConstraint!])
    }

    /// setViewSize - sets the size of the view
    /// - parameter value: size
    ///
    func setViewSize(_ value: CGFloat) {

        //NSLog("setViewSize = %f",value)
        // self.scaleUnitSquare(to: self.convert(self.unitSize, from: nil))

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
