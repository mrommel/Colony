//
//  GameView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SwiftUI
import SmartAILibrary

public struct GameView: View {
    
    @ObservedObject
    private var viewModel: GameViewModel
    
    @State
    private var mapViewModel: MapViewModel = MapViewModel()
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    public init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack {
            
            ScrollableView(scrollTo: self.$viewModel.scrollTarget,
                           clickOn: self.$viewModel.clickPosition,
                           magnification: self.$viewModel.scale) {
                
                MapView(viewModel: self.mapViewModel)
            }
            .background(Color.black.opacity(0.5))
            
            //Text("focus: \(self.viewModel.scrollTarget?.x ?? 0.0), \(self.viewModel.scrollTarget?.y ?? 0.0)")
            
            BottomLeftBarView(viewModel: self.viewModel.mapViewModel)
            
            BottomRightBarView(viewModel: self.viewModel.mapViewModel)
        }
    }
}
