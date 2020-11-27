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

class MapView: NSView {
    
    let GRID_RADIUS: Int = 150
    let unitSize: NSSize  = NSMakeSize(1.0, 1.0)
    
    var map: MapModel? = nil {
        didSet {
            
            if let size = map?.contentSize() {
                self.widthConstraints?.constant = size.width
                self.heightConstraints?.constant = size.height
            }
            
            self.needsDisplay = true
        }
    }
    
    var widthConstraints: NSLayoutConstraint?
    var heightConstraints: NSLayoutConstraint?
    
    override func viewDidMoveToSuperview() {
        
        print("-- viewDidMoveToSuperview")
        self.setup()
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        print("mouseDown: \(event.locationInWindow)")
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        
        print("mouseDragged: \(event.locationInWindow)")
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        print("mouseUp: \(event.locationInWindow)")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        NSColor.black.setFill()
        dirtyRect.fill()
        
        //  grid points
        /*let path:NSBezierPath = NSBezierPath()
        
        let rect = NSRect(x: 50.0, y: 50.0, width: 1000.0 - 100.0, height: 1000.0 - 100.0)
        path.appendRect(rect)
        path.stroke()
        
        for i in 1..<20 {
            for j in 1..<13 {
                
                // TRACK_RADIUS
                let x_pos = CGFloat(i * GRID_RADIUS)
                let y_pos = CGFloat(j * GRID_RADIUS)
                
                path.move(to: NSMakePoint(x_pos - 5,y_pos))
                path.line(to: NSMakePoint(x_pos + 5,y_pos))
                path.move(to: NSMakePoint(x_pos ,y_pos - 5))
                path.line(to: NSMakePoint(x_pos ,y_pos + 5))
                path.lineWidth = 1.0
                
                path.stroke()
                
            }
        }*/
        
        if let map = self.map {
              
            let context = NSGraphicsContext.current?.cgContext
            let mapSize = map.size
            
            for x in 0..<mapSize.width() {
            
                for y in 0..<mapSize.height() {
                
                    guard let tile = map.tile(x: x, y: y) else {
                        continue
                    }

                    let screenPoint = HexPoint.toScreen(hex: HexPoint(x: x, y: y))
                    let textureName: String
                    
                    if tile.hasHills() {
                        textureName = tile.terrain().textureNamesHills().item(from: tile.point)
                    } else {
                        textureName = tile.terrain().textureNames().item(from: tile.point)
                    }
                    
                    if let image = NSImage(named: textureName) {
                        context?.draw(image.cgImage!, in: CGRect(x: screenPoint.x + 600, y: screenPoint.y + 600, width: 48, height: 48))
                    } else {
                        print("texture \(textureName) not found")
                    }
                }
            }
        }
    }
    
    private func setup() {
    }
    
    func resetScaling() {
        self.scaleUnitSquare(to: self.convert(unitSize, from:nil))
    }
    
    /// setViewSize - sets the size of the view
    /// - parameter value: size
    ///
    func setViewSize(_ value:Double) {
        
        NSLog("setViewSize = %f",value)
        self.resetScaling()
        
        // First, match our scaling to the window's coordinate system
        self.scaleUnitSquare (to: NSMakeSize(CGFloat(value), CGFloat(value)))
        needsDisplay = true
    }
}
