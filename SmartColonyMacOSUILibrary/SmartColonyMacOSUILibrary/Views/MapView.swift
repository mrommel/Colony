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

public struct MapView: View {
        
    @ObservedObject
    var viewModel: MapViewModel
    
    @State
    var contentSize: CGSize = CGSize(width: 100, height: 100)
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @State
    var showWater: Bool = false
    
    @State
    var showYields: Bool = false
    
    @State
    var showResourceMarkers: Bool = false
    
    @State
    var showCitizen: Bool = false
    
    @State
    var showHexCoordinates: Bool = false
    
    public var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Group {
                TerrainLayerView(viewModel: self.viewModel.terrainLayerViewModel)
                RiverLayerView(viewModel: self.viewModel.riverLayerViewModel)
                BorderLayerView(viewModel: self.viewModel.borderLayerViewModel)
                RoadLayerView(viewModel: self.viewModel.roadLayerViewModel)
                FeatureLayerView(viewModel: self.viewModel.featureLayerViewModel)
                // todo: split into lower feature
                CursorLayerView(viewModel: self.viewModel.cursorLayerViewModel ?? CursorLayerViewModel())
                // todo: and upper feature
                ResourceLayerView(viewModel: self.viewModel.resourceLayerViewModel)
                ImprovementLayerView(viewModel: self.viewModel.improvementLayerViewModel)
                CityLayerView(viewModel: self.viewModel.cityLayerViewModel)
                UnitLayerView(viewModel: self.viewModel.unitLayerViewModel ?? UnitLayerViewModel())
            }
            
            Group {
                if self.showWater {
                // water
                }
                
                if self.showYields {
                // yield
                }
                
                if self.showResourceMarkers {
                    ResourceMarkerLayerView(viewModel: self.viewModel.resourceMarkerLayerViewModel)
                }
                
                if self.showCitizen {
                // citizen
                }
                
                // -- debug --
                if self.showHexCoordinates {
                    HexCoordLayerView(viewModel: self.viewModel.hexCoordLayerViewModel)
                }
                
                // tooltip ?
            }
        }
        .frame(width: self.contentSize.width * 3.0, height: self.contentSize.height * 3.0, alignment: .topLeading)
        .onReceive(gameEnvironment.game) { game in
            print("received a new game")
            
            // update viewport size
            self.contentSize = game?.contentSize() ?? CGSize(width: 100, height: 100)
            
            // notify redraw & update size and offset?
            self.viewModel.gameUpdated()
        }
        .onReceive( self.gameEnvironment.displayOptions) { options in
            self.showWater = options.showWater
            self.showYields = options.showYields
            self.showResourceMarkers = options.showResourceMarkers
            self.showCitizen = options.showCitizen
            
            self.showHexCoordinates = options.showHexCoordinates
        }
    }
}
