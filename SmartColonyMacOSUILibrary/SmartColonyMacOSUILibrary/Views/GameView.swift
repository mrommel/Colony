//
//  GameView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.04.21.
//

import SwiftUI
import SmartAILibrary

public struct GameView: View {

    var mouseLocation: NSPoint { NSEvent.mouseLocation }

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
                .onReceive(self.gameEnvironment.game) { gameModel in

                    if let gameModel = gameModel {
                        print("about to set game to GameSceneViewModel")
                        self.viewModel.gameSceneViewModel.gameModel = gameModel
                        self.viewModel.gameSceneViewModel.rebuild()
                    }
                }
                .onReceive(self.gameEnvironment.displayOptions) { options in
                    self.viewModel.gameSceneViewModel.update(with: options)
                }

            Group {

                CityBannerView(viewModel: self.viewModel.cityBannerViewModel)

                UnitBannerView(viewModel: self.viewModel.unitBannerViewModel)

                CombatBannerView(viewModel: self.viewModel.combatBannerViewModel)
            }

            Group {

                HeaderView(viewModel: self.viewModel.headerViewModel)

                TopBarView(viewModel: self.viewModel.topBarViewModel)

                NotificationsView(viewModel: self.viewModel.notificationsViewModel)

                BottomRightBarView(viewModel: self.viewModel.bottomRightBarViewModel)

                BottomLeftBarView(viewModel: self.viewModel.bottomLeftBarViewModel)
            }

            Group {
                self.dialog

                self.popup
            }

            BannerView(viewModel: self.viewModel.bannerViewModel)

            if self.viewModel.gameMenuVisible {

                GameMenuView(viewModel: self.viewModel.gameMenuViewModel)
            }
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
        case .cityState:
            return AnyView(CityStateDialogView(viewModel: self.viewModel.cityStateDialogViewModel))
        case .razeOrReturnCity:
            return AnyView(RazeOrReturnCityDialogView(viewModel: self.viewModel.razeOrReturnCityDialogViewModel))

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
        case .selectName:
            return AnyView(NameInputDialogView(viewModel: self.viewModel.nameInputDialogViewModel))
        case .unitList:
            return AnyView(UnitListDialogView(viewModel: self.viewModel.unitListDialogViewModel))
        case .cityList:
            return AnyView(CityListDialogView(viewModel: self.viewModel.cityListDialogViewModel))

        case .selectPantheon:
            return AnyView(SelectPantheonDialogView(viewModel: self.viewModel.selectPantheonDialogViewModel))
        case .religion:
            return AnyView(ReligionDialogView(viewModel: self.viewModel.religionDialogViewModel))
        case .ranking:
            return AnyView(RankingDialogView(viewModel: self.viewModel.rankingDialogViewModel))
        case .cityStates:
            return AnyView(CityStatesDialogView(viewModel: self.viewModel.cityStatesDialogViewModel))
        case .victory:
            return AnyView(VictoryDialogView(viewModel: self.viewModel.victoryDialogViewModel))
        case .eraProgress:
            return AnyView(EraProgressDialogView(viewModel: self.viewModel.eraProgressDialogViewModel))
        case .selectDedication:
            return AnyView(SelectDedicationDialogView(viewModel: self.viewModel.selectDedicationDialogViewModel))
        case .moments:
            return AnyView(MomentsDialogView(viewModel: self.viewModel.momentsDialogViewModel))

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

        case .goodyHutReward(goodyType: _, location: _):
            return AnyView(GoodyHutRewardPopupView(viewModel: self.viewModel.goodyHutRewardPopupViewModel))

        case .techDiscovered(tech: _):
            return AnyView(TechDiscoveredPopupView(viewModel: self.viewModel.techDiscoveredPopupViewModel))

        case .civicDiscovered(civic: _):
            return AnyView(CivicDiscoveredPopupView(viewModel: self.viewModel.civicDiscoveredPopupViewModel))

        case .eraEntered(era: _):
            return AnyView(EraEnteredPopupView(viewModel: self.viewModel.eraEnteredPopupViewModel))

        case .eurekaTriggered(tech: _):
            return AnyView(EurekaTechActivatedPopupView(viewModel: self.viewModel.eurekaTechActivatedPopupViewModel))

        case .inspirationTriggered(civic: _):
            return AnyView(InspirationTriggeredPopupView(viewModel: self.viewModel.inspirationTriggeredPopupViewModel))

        case .unitTrained(unit: _):
            return AnyView(EmptyView())

        case .buildingBuilt:
            return AnyView(EmptyView())

        case .wonderBuilt(wonder: _):
            return AnyView(WonderBuiltPopupView(viewModel: self.viewModel.wonderBuiltPopupViewModel))

        case .religionByCityAdopted(religion: _, location: _):
            return AnyView(Text("religionByCityAdopted"))

        case .religionNewMajority(religion: _):
            return AnyView(Text("religionNewMajority"))

        case .religionCanBuyMissionary:
            return AnyView(Text("religionCanBuyMissionary"))

        case .canFoundPantheon:
            return AnyView(CanFoundPantheonPopupView(viewModel: self.viewModel.canFoundPantheonPopupViewModel))

        case .religionNeedNewAutomaticFaithSelection:
            return AnyView(Text("religionNeedNewAutomaticFaithSelection"))

        case .religionEnoughFaithForMissionary:
            return AnyView(Text("religionEnoughFaithForMissionary"))

        case .cityRevolted(city: _):
            return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))

        case .foreignCityRevolted(city: _):
            return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))

        case .lostOwnCapital:
            return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))

        case .lostCapital(leader: _):
            return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))

        case .questFulfilled(cityState: _, quest: _):
            return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))

        case .tutorialStart(tutorial: let tutorial):
            if tutorial == .none {
                return AnyView(EmptyView())
            } else {
                return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))
            }

        case .tutorialCityAttack(attacker: _, city: _):
            return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))

        case .tutorialBadUnitAttack(attacker: _, defender: _):
            return AnyView(GenericPopupView(viewModel: self.viewModel.genericPopupViewModel))
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

extension View {
    func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
        TrackinAreaView(onMove: onMove) { self }
    }
}

struct TrackinAreaView<Content>: View where Content: View {
    let onMove: (NSPoint) -> Void
    let content: () -> Content

    init(onMove: @escaping (NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.onMove = onMove
        self.content = content
    }

    var body: some View {
        TrackingAreaRepresentable(onMove: onMove, content: self.content())
    }
}

struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
    let onMove: (NSPoint) -> Void
    let content: Content

    func makeNSView(context: Context) -> NSHostingView<Content> {
        return TrackingNSHostingView(onMove: onMove, rootView: self.content)
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
    }
}

class TrackingNSHostingView<Content>: NSHostingView<Content> where Content: View {
    let onMove: (NSPoint) -> Void

    init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
        self.onMove = onMove

        super.init(rootView: rootView)

        setupTrackingArea()
    }

    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
        self.addTrackingArea(NSTrackingArea.init(rect: .zero, options: options, owner: self, userInfo: nil))
    }

    override func mouseMoved(with event: NSEvent) {
        self.onMove(self.convert(event.locationInWindow, from: nil))
    }
}
