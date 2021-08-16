//
//  CityBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI

struct CityBannerView: View {

    @ObservedObject
    public var viewModel: CityBannerViewModel

    @State
    var showBanner: Bool = false

    public var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            Spacer()

            HStack(alignment: .center, spacing: 0) {

                Spacer()

                ZStack(alignment: .bottom) {

                    Image(nsImage: ImageCache.shared.image(for: "city-canvas"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 112, alignment: .bottomTrailing)

                    Text(self.viewModel.name)
                        .font(.footnote)
                        .padding(.bottom, 76)
                }
                .frame(width: 300, height: 112, alignment: .bottomTrailing)
                .offset(x: 0, y: self.showBanner ? 0 : 300)
                .onReceive(self.viewModel.$showBanner, perform: { value in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.showBanner = value
                    }
                })

                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct CityBannerView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = CityBannerViewModel(name: "Berlin")

        CityBannerView(viewModel: viewModel)
    }
}
#endif
