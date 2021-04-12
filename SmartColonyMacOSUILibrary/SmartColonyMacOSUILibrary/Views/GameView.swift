//
//  GameView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SwiftUI

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
                cursor: self.$viewModel.cursor,
                scale: self.$viewModel.scale,
                contentOffset: self.$viewModel.contentOffset) {
                
                MapView(viewModel: self.viewModel.mapViewModel)
            }
            .background(Color.black.opacity(0.5))
            
            BottomLeftBarView(viewModel: self.viewModel.mapViewModel)
            
            BottomRightBarView(viewModel: self.viewModel.mapViewModel)
        }
    }
}
