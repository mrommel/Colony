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
                    magnification: self.$viewModel.magnification)
                .onReceive(self.gameEnvironment.game) { game in
                    
                    if let game = game {
                        print("about to set game to GameSceneViewModel")
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
            
            self.popup
            
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
            return AnyView(CityDialogView(viewModel: self.viewModel.cityDialogViewModel))
            
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
        case .cityName:
            return AnyView(CityNameDialogView(viewModel: self.viewModel.cityNameDialogViewModel))
        }
    }
    
    private var popup: AnyView {
        
        switch self.viewModel.currentPopupType {
        
        case .none:
            return AnyView(EmptyView())
 
        case .declareWarQuestion(player: let player):
            return AnyView(Text("declareWarQuestion"))
            
        case .barbarianCampCleared(location: let location, gold: let gold):
            return AnyView(Text("barbarianCampCleared"))
            
        case .goodyHutReward(goodyType: let goodyType, location: let location):
            return AnyView(Text("goodyHutReward"))
            
        case .techDiscovered(tech: let tech):
            return AnyView(Text("techDiscovered"))
            
        case .civicDiscovered(civic: let civic):
            return AnyView(Text("civicDiscovered"))
            
        case .eraEntered(era: let era):
            return AnyView(Text("eraEntered"))
            
        case .eurekaTechActivated(tech: let tech):
            return AnyView(Text("eurekaTechActivated"))
            
        case .eurekaCivicActivated(civic: let civic):
            return AnyView(Text("eurekaCivicActivated"))
            
        case .unitTrained(unit: let unit):
            return AnyView(Text("unitTrained"))
            
        case .buildingBuilt:
            return AnyView(Text("buildingBuilt"))
            
        case .religionByCityAdopted(religion: let religion, location: let location):
            return AnyView(Text("religionByCityAdopted"))
            
        case .religionNewMajority(religion: let religion):
            return AnyView(Text("religionNewMajority"))
            
        case .religionCanBuyMissionary:
            return AnyView(Text("religionCanBuyMissionary"))
            
        case .religionCanFoundPantheon:
            return AnyView(Text("religionCanFoundPantheon"))
            
        case .religionNeedNewAutomaticFaithSelection:
            return AnyView(Text("religionNeedNewAutomaticFaithSelection"))
            
        case .religionEnoughFaithForMissionary:
            return AnyView(Text("religionEnoughFaithForMissionary"))
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
