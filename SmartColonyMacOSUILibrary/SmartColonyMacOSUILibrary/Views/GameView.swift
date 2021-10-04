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

    @ViewBuilder
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

            BottomLeftBarView(viewModel: self.viewModel.gameSceneViewModel)

            Group {

                CityBannerView(viewModel: self.viewModel.cityBannerViewModel)

                UnitBannerView(viewModel: self.viewModel.unitBannerViewModel)

                CombatBannerView(viewModel: self.viewModel.combatBannerViewModel)
            }

            BottomRightBarView(viewModel: self.viewModel.gameSceneViewModel)

            TopBarView(viewModel: self.viewModel.gameSceneViewModel.topBarViewModel)

            HeaderView(viewModel: self.viewModel.headerViewModel)

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

        case .techTree:
            return AnyView(TechTreeDialogView(viewModel: self.viewModel.techDialogViewModel))
        case .techList:
            return AnyView(TechListDialogView(viewModel: self.viewModel.techDialogViewModel))
        case .civicTree:
            return AnyView(CivicTreeDialogView(viewModel: self.viewModel.civicDialogViewModel))
        case .civicList:
            return AnyView(CivicListDialogView(viewModel: self.viewModel.civicDialogViewModel))
        case .interimRanking:
            return AnyView(EmptyView())
        case .diplomatic:
            return AnyView(DiplomaticDialogView(viewModel: self.viewModel.diplomaticDialogViewModel))

        case .city:
            return AnyView(CityDialogView(viewModel: self.viewModel.cityDialogViewModel))

        case .treasury:
            return AnyView(TreasuryDialogView(viewModel: self.viewModel.treasuryDialogViewModel))
        case .governors:
            return AnyView(GovernorsDialogView(viewModel: self.viewModel.governorsDialogViewModel))
        case .greatPeople:
            return AnyView(GreatPeopleDialogView(viewModel: self.viewModel.greatPeopleDialogViewModel))
        case .tradeRoutes:
            return AnyView(TradeRoutesDialogView(viewModel: self.viewModel.tradeRoutesDialogViewModel))
        case .government:
            return AnyView(GovernmentDialogView(viewModel: self.viewModel.governmentDialogViewModel))
        case .changeGovernment:
            return AnyView(ChangeGovernmentDialogView(viewModel: self.viewModel.changeGovernmentDialogViewModel))
        case .changePolicies:
            return AnyView(ChangePolicyDialogView(viewModel: self.viewModel.changePolicyDialogViewModel))
        case .selectPromotion:
            return AnyView(SelectPromotionDialogView(viewModel: self.viewModel.selectPromotionDialogViewModel))
        case .selectTradeCity:
            return AnyView(SelectTradeCityDialogView(viewModel: self.viewModel.selectTradeCityDialogViewModel))
        case .menu:
            return AnyView(EmptyView())
        case .cityName:
            return AnyView(CityNameDialogView(viewModel: self.viewModel.cityNameDialogViewModel))
        case .unitList:
            return AnyView(UnitListDialogView(viewModel: self.viewModel.unitListDialogViewModel))
        case .cityList:
            return AnyView(CityListDialogView(viewModel: self.viewModel.cityListDialogViewModel))

        case .selectPantheon:
            return AnyView(SelectPantheonDialogView(viewModel: self.viewModel.selectPantheonDialogViewModel))
        case .religion:
            return AnyView(ReligionDialogView(viewModel: self.viewModel.religionDialogViewModel))

        case .confirm:
            return AnyView(ConfirmationDialogView(viewModel: self.viewModel.confirmationDialogViewModel))
        case .selectItems:
            return AnyView(SelectItemsDialogView(viewModel: self.viewModel.selectItemsDialogViewModel))
        }
    }

    private var popup: AnyView {

        switch self.viewModel.currentPopupType {

        case .none:
            return AnyView(EmptyView())

        case .declareWarQuestion(player: _):
            return AnyView(Text("declareWarQuestion"))

        case .barbarianCampCleared(location: _, gold: _):
            return AnyView(Text("barbarianCampCleared"))

        case .goodyHutReward(goodyType: let goodyType, location: let location):
            let viewModel = GoodyHutRewardPopupViewModel(goodyHutType: goodyType, location: location)
            viewModel.delegate = self.viewModel
            return AnyView(GoodyHutRewardPopupView(viewModel: viewModel))

        case .techDiscovered(tech: let tech):
            let viewModel = TechDiscoveredPopupViewModel(techType: tech)
            viewModel.delegate = self.viewModel
            return AnyView(TechDiscoveredPopupView(viewModel: viewModel))

        case .civicDiscovered(civic: let civic):
            let viewModel = CivicDiscoveredPopupViewModel(civicType: civic)
            viewModel.delegate = self.viewModel
            return AnyView(CivicDiscoveredPopupView(viewModel: viewModel))

        case .eraEntered(era: let era):
            let viewModel = EraEnteredPopupViewModel(eraType: era)
            viewModel.delegate = self.viewModel
            return AnyView(EraEnteredPopupView(viewModel: viewModel))

        case .eurekaTechActivated(tech: let tech):
            let viewModel = EurekaTechActivatedPopupViewModel(techType: tech)
            viewModel.delegate = self.viewModel
            return AnyView(EurekaTechActivatedPopupView(viewModel: viewModel))

        case .eurekaCivicActivated(civic: let civic):
            let viewModel = EurekaCivicActivatedPopupViewModel(civicType: civic)
            viewModel.delegate = self.viewModel
            return AnyView(EurekaCivicActivatedPopupView(viewModel: viewModel))

        case .unitTrained(unit: _):
            return AnyView(EmptyView())

        case .buildingBuilt:
            return AnyView(EmptyView())

        case .wonderBuilt(wonder: let wonderType):
            let viewModel = WonderBuiltPopupViewModel(wonderType: wonderType)
            viewModel.delegate = self.viewModel
            return AnyView(WonderBuiltPopupView(viewModel: viewModel))

        case .religionByCityAdopted(religion: _, location: _):
            return AnyView(Text("religionByCityAdopted"))

        case .religionNewMajority(religion: _):
            return AnyView(Text("religionNewMajority"))

        case .religionCanBuyMissionary:
            return AnyView(Text("religionCanBuyMissionary"))

        case .canFoundPantheon:
            let viewModel = CanFoundPantheonPopupViewModel()
            viewModel.delegate = self.viewModel
            return AnyView(CanFoundPantheonPopupView(viewModel: viewModel))

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
