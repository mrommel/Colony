//
//  BannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.05.21.
//

import SwiftUI

struct BannerView: View {

    @ObservedObject
    public var viewModel: GameSceneViewModel

    public var body: some View {

        VStack(alignment: .center) {

            Spacer()

            HStack(alignment: .center, spacing: 10) {

                Spacer()

                if self.viewModel.showBanner {
                    VStack(alignment: .center, spacing: 0) {

                        Image(nsImage: ImageCache.shared.image(for: "banner"))
                            .resizable()
                            .frame(width: 208, height: 89, alignment: .center)

                        Text("Other players are taking their turns, please wait ...")
                            .frame(width: 360, height: 40, alignment: .center)
                            .background(
                                Image(nsImage: ImageCache.shared.image(for: "grid9-button-active"))
                                    .resizable(capInsets: EdgeInsets(all: 15))
                            )
                    }
                }

                Spacer()
            }

            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct BannerView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = GameSceneViewModel()

        BannerView(viewModel: viewModel)
    }
}
#endif
