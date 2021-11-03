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

    public init(viewModel: RankingDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "World Ranking", mode: .landscape, viewModel: self.viewModel) {

            VStack(alignment: .center, spacing: 0) {

                HStack {

                    ForEach(RankingViewType.all, id: \.self) { value in
                        Button(action: {
                            self.viewModel.show(detail: value)
                        }) {
                            Text(value.name())
                                .font(.system(size: 15))
                                .foregroundColor(value == self.viewModel.rankingViewType
                                    ? Color.accentColor
                                    : Color.gray)
                                .animation(nil)
                        }
                    }
                }
                .frame(height: 20, alignment: .center)
                .padding(.top, 4)

                Divider()
                    .padding(.all, 8)

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
            return AnyView(Text("Science"))
        case .culture:
            return AnyView(Text("Culture"))
        case .domination:
            return AnyView(Text("Domination"))
        case .religion:
            return AnyView(Text("Religion"))
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
