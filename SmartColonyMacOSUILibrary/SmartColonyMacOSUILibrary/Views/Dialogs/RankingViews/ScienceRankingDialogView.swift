//
//  ScienceRankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI

struct ScienceRankingDialogView: View {

    @ObservedObject
    var viewModel: ScienceRankingDialogViewModel

    public init(viewModel: ScienceRankingDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack {

            HStack {
                Image(nsImage: self.viewModel.image())
                    .resizable()
                    .frame(width: 42, height: 42)

                Text(self.viewModel.title)
                    .font(.title)
            }

            Text(self.viewModel.summary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            LazyVStack(spacing: 4) {

                ForEach(self.viewModel.scienceRankingViewModels, id: \.self) { scienceRankingViewModel in

                    ScienceRankingView(viewModel: scienceRankingViewModel)
                }
            }
            .padding(.top, 8)
        }
    }
}

#if DEBUG
struct ScienceRankingDialogView_Previews: PreviewProvider {

    static func viewModel() -> ScienceRankingDialogViewModel {

        let viewModel = ScienceRankingDialogViewModel()

        viewModel.gameEnvironment.game.value = DemoGameModel()
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ScienceRankingDialogView_Previews.viewModel()
        ScienceRankingDialogView(viewModel: viewModel)
    }
}
#endif
