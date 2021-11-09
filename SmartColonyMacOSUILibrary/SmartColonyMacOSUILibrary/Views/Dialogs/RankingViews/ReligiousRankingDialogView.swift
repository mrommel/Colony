//
//  ReligiousRankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI

struct ReligiousRankingDialogView: View {

    @ObservedObject
    var viewModel: ReligiousRankingDialogViewModel

    public init(viewModel: ReligiousRankingDialogViewModel) {

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

                ForEach(self.viewModel.religiousRankingViewModels, id: \.self) { religiousRankingViewModel in

                    ReligiousRankingView(viewModel: religiousRankingViewModel)
                }
            }
            .padding(.top, 8)
        }
    }
}

#if DEBUG
struct ReligiousRankingDialogView_Previews: PreviewProvider {

    static func viewModel() -> ReligiousRankingDialogViewModel {

        let viewModel = ReligiousRankingDialogViewModel()

        viewModel.gameEnvironment.game.value = DemoGameModel()
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ReligiousRankingDialogView_Previews.viewModel()
        ReligiousRankingDialogView(viewModel: viewModel)
    }
}
#endif
