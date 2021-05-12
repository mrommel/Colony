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
    
    @ObservedObject
    private var governmentDialogViewModel: GovernmentDialogViewModel
    
    @ObservedObject
    private var policyDialogViewModel: PolicyDialogViewModel
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    public init(viewModel: GameViewModel) {
        
        self.viewModel = viewModel
        
        // dialogs
        self.governmentDialogViewModel = GovernmentDialogViewModel()
        self.policyDialogViewModel = PolicyDialogViewModel()
        
        self.governmentDialogViewModel.delegate = self.viewModel
        self.policyDialogViewModel.delegate = self.viewModel
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
            
            TopBarView(viewModel: self.viewModel.gameSceneViewModel)
            
            self.dialog
        }
    }
}

// MARK: - Loading Content

extension GameView {
    
    private var dialog: AnyView {
    
        switch self.viewModel.shownDialog {
        
        case .none:
            return AnyView(EmptyView())
        case .government:
            return AnyView(GovernmentDialogView(viewModel: self.governmentDialogViewModel))
        case .policy:
            return AnyView(PolicyDialogView(viewModel: self.policyDialogViewModel))
        }
    }
}

extension EdgeInsets {
    
    init(all metric: CGFloat) {
        self.init(
            top: metric,
            leading: metric,
            bottom: metric,
            trailing: metric
        )
    }
}
