//
//  GameView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SwiftUI

public struct GameView: View {
    
    private let viewModel: GameViewModel
    
    @State
    var cursor: CGPoint = .zero
    
    @State
    var scale: CGFloat = 1.0
    
    @State
    var contentOffset: CGPoint = .zero
    
    public init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack {
            TrackableScrollView(
                axes: [.horizontal, .vertical],
                showsIndicators: true,
                cursor: self.$cursor,
                scale: self.$scale,
                contentOffset: self.$contentOffset) {
                
                MapView(viewModel: self.viewModel.mapViewModel)
            }
            .background(Color.black.opacity(0.5))
            
            BottomLeftBarView(viewModel: self.viewModel.mapViewModel)
            
            BottomRightBarView(viewModel: self.viewModel.mapViewModel)
        }
    }
}
