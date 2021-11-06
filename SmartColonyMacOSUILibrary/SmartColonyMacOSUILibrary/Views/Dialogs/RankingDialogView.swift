//
//  RankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI

struct RankingDialogView: View {

    @ObservedObject
    var viewModel: RankingDialogViewModel

    private var gridItemLayout = [
        GridItem(.fixed(100)), GridItem(.fixed(100)),
        GridItem(.fixed(100))
    ]

    public init(viewModel: RankingDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "World Ranking", mode: .portrait, viewModel: self.viewModel) {

            VStack(alignment: .center, spacing: 0) {

                LazyVGrid(columns: gridItemLayout, spacing: 4) {

                    ForEach(RankingViewType.all, id: \.self) { value in
                        Button(action: {
                            self.viewModel.show(detail: value)
                        }, label: {
                            Text(value.name())
                        })
                            .buttonStyle(DialogButtonStyle(state: value == self.viewModel.rankingViewType ? .highlighted : .normal))
                            .frame(width: 100)
                    }
                }
                .frame(height: 60, alignment: .center)
                .padding(.top, 4)

                Divider()
                    .padding(.all, 4)

                ScrollView(.vertical, showsIndicators: true, content: {

                    self.detailView
                })
            }
        }
    }

    var detailView: AnyView {

        switch self.viewModel.rankingViewType {

        case .overall:
            return AnyView(
                OverallRankingDialogView(
                    viewModel: self.viewModel.overallRankingDialogViewModel
                )
            )
        case .score:
            return AnyView(
                ScoreRankingDialogView(
                    viewModel: self.viewModel.scoreRankingDialogViewModel
                )
            )
        case .science:
            return AnyView(
                ScienceRankingDialogView(
                    viewModel: self.viewModel.scienceRankingDialogViewModel
                )
            )
        case .culture:
            return AnyView(
                CultureRankingDialogView(
                    viewModel: self.viewModel.cultureRankingDialogViewModel
                )
            )
        case .domination:
            return AnyView(
                DominationRankingDialogView(
                    viewModel: self.viewModel.dominationRankingDialogViewModel
                )
            )
        case .religion:
            return AnyView(
                ReligiousRankingDialogView(
                    viewModel: self.viewModel.religiousRankingDialogViewModel
                )
            )
        }
    }
}

#if DEBUG
struct RankingDialogView_Previews: PreviewProvider {

    static func viewModel() -> RankingDialogViewModel {

        let viewModel = RankingDialogViewModel()

        viewModel.gameEnvironment.game.value = DemoGameModel()
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = RankingDialogView_Previews.viewModel()
        RankingDialogView(viewModel: viewModel)
    }
}
#endif
