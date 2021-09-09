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

                    Group {
                        Image(nsImage: self.viewModel.listImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: -80, y: -105)
                            .onTapGesture {
                                self.viewModel.listClicked()
                            }

                        Image(nsImage: self.viewModel.commandImage(at: 4))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: -40, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 4)
                            }

                        Image(nsImage: self.viewModel.commandImage(at: 3))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: -5, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 3)
                            }

                        Image(nsImage: self.viewModel.commandImage(at: 2))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: 30, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 2)
                            }

                        Image(nsImage: self.viewModel.commandImage(at: 1))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: 65, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 1)
                            }

                        Image(nsImage: self.viewModel.commandImage(at: 0))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .offset(x: 100, y: -105)
                            .onTapGesture {
                                self.viewModel.commandClicked(at: 0)
                            }
                    }

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

                    Group {

                        YieldValueView(viewModel: self.viewModel.foodYieldViewModel)
                            .offset(x: -116, y: -89)

                        YieldValueView(viewModel: self.viewModel.productionYieldViewModel)
                            .offset(x: -69, y: -89)

                        YieldValueView(viewModel: self.viewModel.goldYieldViewModel)
                            .offset(x: -22, y: -89)

                        YieldValueView(viewModel: self.viewModel.scienceYieldViewModel)
                            .offset(x: 25, y: -89)

                        YieldValueView(viewModel: self.viewModel.cultureYieldViewModel)
                            .offset(x: 72, y: -89)

                        YieldValueView(viewModel: self.viewModel.faithYieldViewModel)
                            .offset(x: 117, y: -89)
                    }
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
