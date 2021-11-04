//
//  DominationRankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.11.21.
//

import SwiftUI

struct DominationRankingDialogView: View {

    @ObservedObject
    var viewModel: DominationRankingDialogViewModel

    public init(viewModel: DominationRankingDialogViewModel) {

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

                ForEach(self.viewModel.dominationRankingViewModels, id: \.self) { dominationRankingViewModel in

                    DominationRankingView(viewModel: dominationRankingViewModel)
                }
            }
            .padding(.top, 8)
        }
    }
}

#if DEBUG
struct DominationRankingDialogView_Previews: PreviewProvider {

    static func viewModel() -> DominationRankingDialogViewModel {

        let viewModel = DominationRankingDialogViewModel()

        viewModel.gameEnvironment.game.value = DemoGameModel()
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = DominationRankingDialogView_Previews.viewModel()
        DominationRankingDialogView(viewModel: viewModel)
    }
}
#endif
