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
    
    private let viewModel: MapViewModel
    private let contentSize: CGSize
    
    public init(viewModel: MapViewModel) {
        
        self.viewModel = viewModel
        self.contentSize = self.viewModel.game?.contentSize() ?? CGSize(width: 100, height: 100)
    }
    
    public var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            TerrainLayerView(viewModel: self.viewModel.terrainLayerViewModel)
            RiverLayerView(viewModel: self.viewModel.riverLayerViewModel)
            BorderLayerView(viewModel: self.viewModel.borderLayerViewModel)
            RoadLayerView(viewModel: self.viewModel.roadLayerViewModel)
            // cursor?
            FeatureLayerView(viewModel: self.viewModel.featureLayerViewModel)
            ResourceLayerView(viewModel: self.viewModel.resourceLayerViewModel)
            ImprovementLayerView(viewModel: self.viewModel.improvementLayerViewModel)
            CityLayerView(viewModel: self.viewModel.cityLayerViewModel)
            UnitLayerView(viewModel: self.viewModel.unitLayerViewModel ?? UnitLayerViewModel(game: nil))
            
            // -- debug --
            // yield
            // water
            HexCoordLayerView(viewModel: self.viewModel.hexCoordLayerViewModel)
            // citizen
            // tooltip ?
        }
        .frame(width: self.contentSize.width * 3.0, height: self.contentSize.height * 3.0, alignment: .topLeading)
    }
    
    func assign(game: GameModel?) {
        
        // forward to model
        self.viewModel.game = game
    }
}
