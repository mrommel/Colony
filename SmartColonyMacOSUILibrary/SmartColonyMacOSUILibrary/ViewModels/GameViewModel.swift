//
//  GameViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SmartAILibrary

class GameViewModel {
    
    var terrainLayerViewModel: TerrainLayerViewModel?
    // river
    var featureLayerViewModel: FeatureLayerViewModel?
    
    var game: GameModel? {
        didSet {
            self.terrainLayerViewModel = TerrainLayerViewModel(game: self.game)
            self.terrainLayerViewModel?.update()
            
            // river
            
            self.featureLayerViewModel = FeatureLayerViewModel(game: self.game)
            self.featureLayerViewModel?.update()
        }
    }
    
    func setViewSize(_ value: CGFloat) {

        /*if self.scale == value {
            // nothing to do
            return
        }
        
        let oldScale = self.scale
        self.scale = value
        
        let factor = value / oldScale
        print("from \(oldScale) to \(value) means \(factor)")

        if let size = self.game?.contentSize(), let mapSize = self.game?.mapSize() {
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
        }*/
    }
    
    init() {
        
        self.terrainLayerViewModel = nil
        self.featureLayerViewModel = nil
    }
}
