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
                        // print("about to set game")
                        self.viewModel.gameSceneViewModel.game = game
                    }
                }
            
            NotificationsView(viewModel: self.viewModel.notificationsViewModel)
                //.background(Color.green.opacity(0.2))
            
            BottomLeftBarView(viewModel: self.viewModel.gameSceneViewModel)
                //.background(Color.red.opacity(0.2))
            
            BottomRightBarView()
            
            TopBarView(viewModel: self.viewModel.gameSceneViewModel)
                //.background(Color.blue.opacity(0.2))
            
            HeaderView(viewModel: self.viewModel.gameSceneViewModel)

            self.dialog
            
            BannerView(viewModel: self.viewModel.gameSceneViewModel)
        }
    }
}

// MARK: - Loading Content

extension GameView {
    
    private var dialog: AnyView {
    
        switch self.viewModel.currentScreenType {
        
        case .none:
            return AnyView(EmptyView())
            
        case .techs:
            return AnyView(TechDialogView(viewModel: self.viewModel.techDialogViewModel))
        case .civics:
            return AnyView(CivicDialogView(viewModel: self.viewModel.civicDialogViewModel))
        case .interimRanking:
            return AnyView(EmptyView())
        case .diplomatic:
            return AnyView(EmptyView())
        case .city:
            return AnyView(EmptyView())
        case .treasury:
            return AnyView(EmptyView())
        case .government:
            return AnyView(GovernmentDialogView(viewModel: self.viewModel.governmentDialogViewModel))
        case .changeGovernment:
            return AnyView(ChangeGovernmentDialogView(viewModel: self.viewModel.changeGovernmentDialogViewModel))
        case .changePolicies:
            return AnyView(ChangePolicyDialogView(viewModel: self.viewModel.changePolicyDialogViewModel))
        case .selectPromotion:
            return AnyView(EmptyView())
        case .disbandConfirm:
            return AnyView(EmptyView())
        case .selectTradeCity:
            return AnyView(EmptyView())
        case .menu:
            return AnyView(EmptyView())
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
