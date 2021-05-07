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
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @State
    var contentSize: CGSize = CGSize(width: 100, height: 100)
    
    public init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ZStack {
            
            GameSceneView(viewModel: self.viewModel.gameSceneViewModel,
                    magnification: self.$viewModel.magnification,
                    focus: self.$viewModel.focusPosition)
                .onReceive(self.gameEnvironment.game) { game in
                    
                    if let game = game {
                        // update viewport size
                        self.contentSize = game.contentSize()
                        self.viewModel.gameSceneViewModel.game = game
                    }
                }
                
            
            /*VStack {
                Spacer()
            
                Text("offset: \(String(format: "%.1f", self.$viewModel.contentOffset.wrappedValue.x)), \(String(format: "%.1f", self.$viewModel.contentOffset.wrappedValue.y)), zoom: \(String(format: "%.2f", self.$viewModel.magnification.wrappedValue))")
                    .background(Color.black.opacity(0.5))
            }*/
            
            BottomLeftBarView(viewModel: self.viewModel.gameSceneViewModel)
            
            BottomRightBarView()
        }
    }
}
