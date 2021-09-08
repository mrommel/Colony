//
//  CityBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI
import SmartAssets

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
                        .frame(width: 310, height: 112, alignment: .bottomTrailing)

                    Image(nsImage: self.viewModel.cityBannerBackground())
                        .resizable(capInsets: EdgeInsets(all: 5))
                        .renderingMode(.template)
                        .foregroundColor(Color(self.viewModel.main))
                        .frame(width: 120, height: 20, alignment: .bottomTrailing)
                        .offset(x: 0.0, y: -70.0)

                    Text(self.viewModel.name)
                        .font(.footnote)
                        .foregroundColor(Color(self.viewModel.accent))
                        .offset(x: 0.0, y: -72.0)

                    Image(nsImage: self.viewModel.cityCivilizationImage())
                        .resizable()
                        .frame(width: 57, height: 57)
                        .clipShape(Circle())
                        .offset(x: -109.4, y: -20.4)

                    Image(nsImage: self.viewModel.cityProductionImage())
                        .resizable()
                        .frame(width: 57, height: 57)
                        .clipShape(Circle())
                        .offset(x: 108.5, y: -20.4)
                }
                .frame(width: 310, height: 112, alignment: .bottomTrailing)
                .offset(x: 0, y: self.showBanner ? 0 : 150)
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
        let viewModel = CityBannerViewModel(name: "Berlin", civilization: .english)

        CityBannerView(viewModel: viewModel)
    }
}
#endif
