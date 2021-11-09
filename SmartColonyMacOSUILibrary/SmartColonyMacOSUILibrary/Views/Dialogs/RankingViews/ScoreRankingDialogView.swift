//
//  ScoreRankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI

struct ScoreRankingDialogView: View {

    @ObservedObject
    var viewModel: ScoreRankingDialogViewModel

    public init(viewModel: ScoreRankingDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack {

            HStack {
                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: 42, height: 42)

                VStack(alignment: .leading) {
                    Text(self.viewModel.title)
                        .font(.title)

                    Text(self.viewModel.subtitle)
                }
            }

            Text(self.viewModel.summary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            LazyVStack(spacing: 4) {

                ForEach(self.viewModel.scoreRankingViewModels, id: \.self) { scoreRankingViewModel in

                    ScoreRankingView(viewModel: scoreRankingViewModel)
                }
            }
            .padding(.top, 8)
        }
    }
}

#if DEBUG
struct ScoreRankingDialogView_Previews: PreviewProvider {

    static func viewModel() -> ScoreRankingDialogViewModel {

        let viewModel = ScoreRankingDialogViewModel()

        viewModel.gameEnvironment.game.value = DemoGameModel()
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ScoreRankingDialogView_Previews.viewModel()
        ScoreRankingDialogView(viewModel: viewModel)
    }
}
#endif
