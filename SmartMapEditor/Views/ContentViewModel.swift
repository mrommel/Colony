//
//  ContentViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 06.12.20.
//

import Foundation
import SmartAILibrary

class ContentViewModel: ObservableObject {

    @Published var zoom: CGFloat
    
    private var focus: AbstractTile? // input, leads to:
    @Published var focusedPoint: String
    @Published var focusedTerrainName: String
    @Published var focusedHillsValue: String
    @Published var focusedFeatureName: String {
        didSet {
            print("change: \(focusedFeatureName)")
        }
    }
    @Published var focusedResourceName: String
    
    var didChange: ((HexPoint) -> ())? = nil

    init() {
        
        self.zoom = 1.0
        self.focus = Tile(point: HexPoint(x: -1, y: -1), terrain: TerrainType.ocean)
        self.focusedPoint = "---"
        self.focusedTerrainName = "Ocean"
        self.focusedHillsValue = "false"
        self.focusedFeatureName = "---"
        self.focusedResourceName = "---"
    }
    
    func setZoom(to value: CGFloat) {
        
        self.zoom = value
    }
    
    func setFocus(to tile: AbstractTile?) {
        
        self.focus = tile
        
        if let tile = tile {
            
            self.focusedPoint = "\(tile.point.x), \(tile.point.y)"
            
            self.focusedTerrainName = tile.terrain().name()
            
            self.focusedHillsValue = tile.hasHills() ? "true" : "false"
            
            if tile.feature() == .none {
                self.focusedFeatureName = "---"
            } else {
                self.focusedFeatureName = tile.feature().name()
            }
            
            if tile.resource(for: nil) == .none {
                self.focusedResourceName = "---"
            } else {
                self.focusedResourceName = tile.resource(for: nil).name()
            }
        }
    }
    
    func setTerrain(to terrainName: String) {
        
        if let newTerrain = TerrainType.from(name: terrainName) {
            if let focusTile = self.focus {
                focusTile.set(terrain: newTerrain)
                
                // trigger redraw
                self.didChange?(focusTile.point)
            }
        }
    }
    
    func setHills(to value: String) {
        
        let newHills = value == "true"
        if let focusTile = self.focus {
            focusTile.set(hills: newHills)
            
            // trigger redraw
            self.didChange?(focusTile.point)
        }
    }
    
    func setFeature(to featureName: String) {
        
        if let newFeature = FeatureType.from(name: featureName) {
            if let focusTile = self.focus {
                focusTile.set(feature: newFeature)
                
                // trigger redraw
                self.didChange?(focusTile.point)
            }
        } else {
            if let focusTile = self.focus {
                focusTile.set(feature: .none)
                
                // trigger redraw
                self.didChange?(focusTile.point)
            }
        }
    }
    
    func setResource(to resourceName: String) {
        
        if let newResource = ResourceType.from(name: resourceName) {
            if let focusTile = self.focus {
                focusTile.set(resource: newResource)
                
                // trigger redraw
                self.didChange?(focusTile.point)
            }
        } else {
            if let focusTile = self.focus {
                focusTile.set(resource: .none)
                
                // trigger redraw
                self.didChange?(focusTile.point)
            }
        }
    }
}
