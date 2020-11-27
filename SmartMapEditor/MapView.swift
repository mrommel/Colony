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
    let offset = CGPoint(x: 575, y: 1360)
    let unitSize: NSSize = NSMakeSize(1.0, 1.0)

    // properties
    var scale: CGFloat = 1.0
    var downPoint: CGPoint? = nil
    var initialPoint: CGPoint? = nil

    var cursor: HexPoint = HexPoint.zero

    weak var delegate: MapViewDelegate?

    var map: MapModel? = nil {
        didSet {

            if let size = map?.contentSize() {
                self.widthConstraint?.constant = (size.width + 10) * self.scale
                self.heightConstraint?.constant = size.height * self.scale

                print("set new size: \(size)")
            }

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

                let pointInView = convert(event.locationInWindow, from: nil) - self.offset
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

        NSColor.darkGray.setFill()
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

                    let screenPoint = HexPoint.toScreen(hex: pt) + offset
                    let textureName: String

                    if tile.hasHills() {
                        textureName = tile.terrain().textureNamesHills().item(from: tile.point)
                    } else {
                        textureName = tile.terrain().textureNames().item(from: tile.point)
                    }

                    if let image = NSImage(named: textureName) {
                        context?.draw(image.cgImage!, in: CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48))
                    } else {
                        print("texture \(textureName) not found")
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

        self.widthConstraint = self.constraints.first(where: { $0.identifier == "canvas_width" })
        self.heightConstraint = self.constraints.first(where: { $0.identifier == "canvas_height" })
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
