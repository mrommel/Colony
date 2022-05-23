//
//  HeaderView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.05.21.
//

import SwiftUI
import SmartAssets

struct HeaderView: View {

    @ObservedObject
    public var viewModel: HeaderViewModel

    public var body: some View {

        HStack(alignment: .top, spacing: 0) {

            VStack(alignment: .leading, spacing: 0) {

                self.leftButtons
                    .zIndex(50)

                TechProgressView(viewModel: self.viewModel.techProgressViewModel)
                    .zIndex(49)

                CivicProgressView(viewModel: self.viewModel.civicProgressViewModel)
                    .zIndex(48)
            }
            .padding(.top, 24)

            Spacer()

            VStack(alignment: .trailing, spacing: 0) {

                self.rightButtons
                    .zIndex(50)

                self.leaderButtons
                    .zIndex(49)
                    .padding(.top, 8)
                    .padding(.trailing, 8)
            }
            .padding(.top, 24)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    private var leftButtons: AnyView {

        AnyView(
            HStack(alignment: .center, spacing: 0) {

                HeaderButtonView(viewModel: self.viewModel.scienceHeaderViewModel)

                HeaderButtonView(viewModel: self.viewModel.cultureHeaderViewModel)

                HeaderButtonView(viewModel: self.viewModel.governmentHeaderViewModel)

                HeaderButtonView(viewModel: self.viewModel.religionHeaderViewModel)

                HeaderButtonView(viewModel: self.viewModel.greatPeopleHeaderViewModel)

                HeaderButtonView(viewModel: self.viewModel.governorsHeaderViewModel)

                HeaderButtonView(viewModel: self.viewModel.momentsHeaderViewModel)

                Image(nsImage: ImageCache.shared.image(for: "header-bar-left"))
                    .resizable()
                    .frame(width: 35, height: 47, alignment: .center)
            }
        )
    }

    private var rightButtons: some View {

        HStack(alignment: .center, spacing: 0) {

            Image(nsImage: ImageCache.shared.image(for: "header-bar-right"))
                .resizable()
                .frame(width: 35, height: 47, alignment: .center)

            // ranking / victory
            HeaderButtonView(viewModel: self.viewModel.rankingHeaderViewModel)

            // city states
            HeaderButtonView(viewModel: self.viewModel.cityStateHeaderViewModel)

            // trade routes
            HeaderButtonView(viewModel: self.viewModel.tradeRoutesHeaderViewModel)

            // eraProgress
            HeaderButtonView(viewModel: self.viewModel.eraProgressHeaderViewModel)
        }
        .frame(height: 47)
    }

    private var leaderButtons: some View {

        LazyHStack(spacing: 4) {

            ForEach(self.viewModel.leaderViewModels, id: \.self) { leaderViewModel in

                LeaderView(viewModel: leaderViewModel)
                    .id("leader-\(leaderViewModel.id)")
            }
        }
        .frame(height: 52)
    }
}

#if DEBUG
struct HeaderView_Previews: PreviewProvider {

    static func viewModel() -> HeaderViewModel {

        let viewModel = HeaderViewModel()

        let game = DemoGameModel()

        let aiPlayer = game.players.first(where: { !$0.isBarbarian() && !$0.isHuman() })

        game.humanPlayer()?.doFirstContact(with: aiPlayer, in: game)

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = HeaderView_Previews.viewModel()

        HeaderView(viewModel: viewModel)
    }
}
#endif
