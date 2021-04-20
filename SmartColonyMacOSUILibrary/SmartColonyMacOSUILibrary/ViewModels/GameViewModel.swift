//
//  GameViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SmartAILibrary
import SmartAssets
import Cocoa
import SwiftUI

public class GameViewModel: ObservableObject {

    var mapViewModel: MapViewModel
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var clickPosition: CGPoint? = .zero  {
        didSet {
            self.clickPositionUpdated()
        }
    }
    
    @Published
    var scale: CGFloat = 1.0
    
    @Published
    var contentOffset: CGPoint = .zero
    
    @Published
    var scrollTarget: CGPoint? = nil
    
    public init(mapViewModel: MapViewModel) {
        
        self.mapViewModel = mapViewModel
    }
    
    public func loadAssets() {
        
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
        
        var unitTextures: Int = 0
        for unitType in UnitType.all {
            
            if let idleTextures = unitType.idleAtlas?.textures {
                for (index, texture) in idleTextures.enumerated() {
                    ImageCache.shared.add(image: texture, for: "\(unitType.name().lowercased())-idle-\(index)")
                    
                    unitTextures += 1
                }
            } else {
                print("cant get idle textures of \(unitType.name())")
            }
        }
        print("- load \(unitTextures) unit textures")

        print("-- all textures loaded --")
        
        // populate cache if needed
        if !ImageCache.shared.exists(key: "cursor") {
            ImageCache.shared.add(image: NSImage(named: "cursor"), for: "cursor")
        }
    }
    
    public func centerCapital() {
        
        guard let game = self.gameEnvironment.game.value else {
            print("cant center on capital: game not set")
            return
        }
        
        guard let human = game.humanPlayer() else {
            print("cant center on capital: human not set")
            return
        }
        
        if let capital = game.capital(of: human) {
            self.gameEnvironment.moveCursor(to: capital.location)
            self.centerOnCursor()
            return
        }
            
        if let unitRef = game.units(of: human).first, let unit = unitRef {
            self.gameEnvironment.moveCursor(to: unit.location)
            self.centerOnCursor()
            return
        }
        
        print("cant center on capital: no capital nor units")
    }
    
    public func centerOnCursor() {
        
        //self.mapViewModel.centerOnCursor()
        let cursor = self.gameEnvironment.cursor.value
            
        var screenPoint = HexPoint.toScreen(hex: cursor) * 3.0 + self.mapViewModel.shift

        screenPoint.y = self.mapViewModel.size.height - screenPoint.y - 144
            
        print("scroll to: \(screenPoint)")
        self.scrollTarget = screenPoint
    }
    
    public func zoomIn() {
        
        self.scale = self.scale * 1.5
    }
    
    public func zoomOut() {
        
        self.scale = self.scale * 0.75
    }
    
    public func zoomReset() {
        
        self.scale = 1.0
    }
    
    private func clickPositionUpdated() {
        
        guard let clickPosition = self.clickPosition else {
            return
        }
        
        // to get a better screen resolution everything is scaled up (@3x assets)
        let factor: CGFloat = 3.0
        
        // first calculate the "real" screen coordinate and then the HexPoint
        let x = (clickPosition.x - self.mapViewModel.shift.x) / factor
        let y = ((self.mapViewModel.size.height - clickPosition.y) - self.mapViewModel.shift.y) / factor

        // update the cursor
        let cursor = HexPoint(screen: CGPoint(x: x, y: y))
        
        self.gameEnvironment.moveCursor(to: cursor)
    }
}
