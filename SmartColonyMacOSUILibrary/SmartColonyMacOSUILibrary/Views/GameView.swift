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
    
    public init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack {
            TrackableScrollView(
                axes: [.horizontal, .vertical],
                showsIndicators: true,
                clickPosition: self.$viewModel.clickPosition,
                scale: self.$viewModel.scale,
                scrollTarget: self.$viewModel.scrollTarget,
                contentOffset: self.$viewModel.contentOffset) {
                
                MapView(viewModel: self.viewModel.mapViewModel)
            }
            .background(Color.black.opacity(0.5))
            
            Text("focus: \(self.viewModel.scrollTarget ?? 0)")
            
            BottomLeftBarView(viewModel: self.viewModel.mapViewModel)
            
            BottomRightBarView(viewModel: self.viewModel.mapViewModel)
        }
    }
}
