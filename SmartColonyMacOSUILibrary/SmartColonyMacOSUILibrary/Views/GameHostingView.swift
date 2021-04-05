//
//  GameHostingView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

class GameHostingView: NSHostingView<GameView> {
    
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    var downPoint: CGPoint? = nil
    var initialPoint: CGPoint? = nil
    var rightDownPoint: CGPoint? = nil
    var shift: CGPoint = CGPoint(x: 0, y: 0)
    
    init(viewModel: GameViewModel) {

        // load assets into image cache
        print("-- pre-load images --")
        let bundle = Bundle.init(for: Textures.self)
        let textures: Textures = Textures(game: nil)

        print("- load \(textures.allTerrainTextureNames.count) terrain, \(textures.allRiverTextureNames.count) river and \(textures.allCoastTextureNames.count) coast textures")
        for terrainTextureName in textures.allTerrainTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: terrainTextureName), for: terrainTextureName)
        }

        for coastTextureName in textures.allCoastTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: coastTextureName), for: coastTextureName)
        }

        for riverTextureName in textures.allRiverTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: riverTextureName), for: riverTextureName)
        }

        print("- load \(textures.allFeatureTextureNames.count) feature (+ \(textures.allIceFeatureTextureNames.count) ice) textures")
        for featureTextureName in textures.allFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: featureTextureName), for: featureTextureName)
        }

        for iceFeatureTextureName in textures.allIceFeatureTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: iceFeatureTextureName), for: iceFeatureTextureName)
        }

        print("- load \(textures.allResourceTextureNames.count) resource textures")
        for resourceTextureName in textures.allResourceTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: resourceTextureName), for: resourceTextureName)
        }
        
        print("- load \(textures.allBorderTextureNames.count) border textures")
        for borderTextureName in textures.allBorderTextureNames {
            ImageCache.shared.add(image: bundle.image(forResource: borderTextureName), for: borderTextureName)
        }

        print("-- all textures loaded --")
        
        // populate cache if needed
        if !ImageCache.shared.exists(key: "cursor") {
            ImageCache.shared.add(image: NSImage(named: "cursor"), for: "cursor")
        }
        
        /*if !ImageCache.shared.exists(key: "flag") {
            ImageCache.shared.add(image: NSImage(named: "flag"), for: "flag")
        }
        
        if !ImageCache.shared.exists(key: "capital") {
            ImageCache.shared.add(image: NSImage(named: "capital"), for: "capital")
        }
        
        if !ImageCache.shared.exists(key: "bars_veryhigh") {
            ImageCache.shared.add(image: NSImage(named: "bars_veryhigh"), for: "bars_veryhigh")
        }
        if !ImageCache.shared.exists(key: "bars_high") {
            ImageCache.shared.add(image: NSImage(named: "bars_high"), for: "bars_high")
        }
        if !ImageCache.shared.exists(key: "bars_medium") {
            ImageCache.shared.add(image: NSImage(named: "bars_medium"), for: "bars_medium")
        }
        if !ImageCache.shared.exists(key: "bars_small") {
            ImageCache.shared.add(image: NSImage(named: "bars_small"), for: "bars_small")
        }
        if !ImageCache.shared.exists(key: "bars_verysmall") {
            ImageCache.shared.add(image: NSImage(named: "bars_verysmall"), for: "bars_verysmall")
        }*/
        
        print("-- all icons loaded --")
            
        super.init(rootView: GameView(viewModel: viewModel))
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)

        self.addConstraints([self.widthConstraint!, self.heightConstraint!])
        
        viewModel.delegate = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(rootView: GameView) {
        fatalError("init(rootView:) has not been implemented")
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
        
        print("rightMouseDown \(pt)")
        //self.delegate?.draw(at: pt)
    }
    
    override func mouseDragged(with event: NSEvent) {

        super.mouseDragged(with: event)

        if let point = self.downPoint {
            //self.delegate?.moveBy(dx: event.locationInWindow.x - point.x, dy: event.locationInWindow.y - point.y)
            self.downPoint = event.locationInWindow
        }
    }

    override func rightMouseDragged(with event: NSEvent) {
        
        super.rightMouseDragged(with: event)
        
        let pointInView = self.convert(event.locationInWindow, from: nil) - self.shift
        let pt = HexPoint(screen: pointInView)
        
        print("rightMouseDragged \(pt)")
        //self.delegate?.draw(at: pt)
    }
    
    override func mouseUp(with event: NSEvent) {

        super.mouseUp(with: event)

        if let point = self.initialPoint {
            if abs(event.locationInWindow.x - point.x) < 0.001 && abs(event.locationInWindow.y - point.y) < 0.001 {

                // reverse
                // let screenPoint = (HexPoint.toScreen(hex: pt) * 3.0) + self.shift
                // =>
                // HexPoint.toScreen(hex: pt) * 3.0 = screenPoint - self.shift
                // HexPoint.toScreen(hex: pt) = (screenPoint - self.shift) / 3.0
                
                var tmp = event.locationInWindow
                tmp.y = self.frame.height - tmp.y
                let pointInView = self.convert(tmp, from: nil) - self.shift
                
                let scrollView = self.superview?.superview as? GameScrollView
                var zoom: CGFloat = 1.0 // (scrollView?.magnification ?? 1.0)
                zoom /= 3.0 // for upscale
                
                let finalScreenPoint = pointInView * zoom
                
                let pt = HexPoint(screen: finalScreenPoint)
                
                print("mouseUp \(pt) at magnification: \((scrollView?.magnification ?? 1.0)) => \(zoom)")
                print("finalScreenPoint: \(finalScreenPoint) --- ")

                /*if let tile = self.game?.tile(at: pt) {

                    self.delegate?.focus(on: tile as! Tile)
                    self.cursor = pt

                    self.redrawTile(at: pt)
                }*/
            }
        }

        self.downPoint = nil
        self.initialPoint = nil
    }
    
    override func magnify(with event: NSEvent) {
        
        super.magnify(with: event)
        // print("magnification \(event.magnification)")
    }

    func redrawTile(at point: HexPoint) {

        let screenPoint = HexPoint.toScreen(hex: point) + shift
        let tileRect = CGRect(x: screenPoint.x, y: screenPoint.y, width: 48, height: 48)

        self.setNeedsDisplay(tileRect)
        self.needsDisplay = true
    }
}

extension GameHostingView: GameViewModelDelegate {
    
    func sizeChanged(to size: CGSize) {
        
        self.frame = NSMakeRect(0, 0, size.width, size.height)
        
        self.widthConstraint?.constant = size.width
        self.heightConstraint?.constant = size.height
        
        self.needsDisplay = true
    }
    
    func shiftChanged(to shift: CGPoint) {
        
        self.shift = shift
        
        self.needsDisplay = true
    }
}
