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
    public var viewModel: HeaderViewModel // GameSceneViewModel

    public var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .center, spacing: 0) {

                self.leftButtons

                Spacer()

                self.rightButtons
            }
            .padding(.top, 24)

            TechProgressView(viewModel: self.viewModel.techProgressViewModel)

            CivicProgressView(viewModel: self.viewModel.civicProgressViewModel)

            Spacer()
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

                Image(nsImage: ImageCache.shared.image(for: "header-bar-left"))
                    .resizable()
                    .frame(width: 35, height: 47, alignment: .center)
            }
        )
    }

    private var rightButtons: AnyView {

        AnyView(
            HStack(alignment: .center, spacing: 0) {

                Image(nsImage: ImageCache.shared.image(for: "header-bar-right"))
                    .resizable()
                    .frame(width: 35, height: 47, alignment: .center)

                // ranking
                HeaderButtonView(viewModel: self.viewModel.rankingHeaderViewModel)

                // trade routes
                HeaderButtonView(viewModel: self.viewModel.tradeRoutesHeaderViewModel)
            }
        )
    }
}

#if DEBUG
struct HeaderView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = HeaderViewModel()

        HeaderView(viewModel: viewModel)
    }
}
#endif
