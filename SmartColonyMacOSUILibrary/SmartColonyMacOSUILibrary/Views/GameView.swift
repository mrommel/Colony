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
                        self.viewModel.gameSceneViewModel.game = game
                    }
                }
            
            BottomLeftBarView(viewModel: self.viewModel.gameSceneViewModel)
            
            BottomRightBarView()
            
            self.dialog
        }
    }
}

extension GameView {
    
    private var dialog: AnyView {
    
        switch self.viewModel.shownDialog {
        
        case .none:
            return AnyView(EmptyView())
        case .policy:
            return AnyView(self.policyDialog)
        }
    }
}

// MARK: - Loading Content

extension GameView {
    
    private var policyDialog: some View {
        Text("Policy")
    }
}
