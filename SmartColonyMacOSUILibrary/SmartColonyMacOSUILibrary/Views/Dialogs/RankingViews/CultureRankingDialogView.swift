//
//  CultureRankingDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.11.21.
//

import SwiftUI

struct CultureRankingDialogView: View {

    @ObservedObject
    var viewModel: CultureRankingDialogViewModel

    public init(viewModel: CultureRankingDialogViewModel) {

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

                ForEach(self.viewModel.cultureRankingViewModels, id: \.self) { cultureRankingViewModel in

                    CultureRankingView(viewModel: cultureRankingViewModel)
                }
            }
            .padding(.top, 8)
        }
    }
}

#if DEBUG
struct CultureRankingDialogView_Previews: PreviewProvider {

    static func viewModel() -> CultureRankingDialogViewModel {

        let viewModel = CultureRankingDialogViewModel()

        viewModel.gameEnvironment.game.value = DemoGameModel()
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = CultureRankingDialogView_Previews.viewModel()
        CultureRankingDialogView(viewModel: viewModel)
    }
}
#endif
