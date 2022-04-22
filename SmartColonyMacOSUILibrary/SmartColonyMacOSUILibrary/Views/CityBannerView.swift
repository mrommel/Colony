//
//  CityBannerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI
import SmartAssets

struct CityBannerItemView: View {

    let value: String
    let text: String

    public init(value: String, text: String) {

        self.value = value
        self.text = text
    }

    public var body: some View {

        HStack(alignment: .center, spacing: 4) {
            Text(self.value)
                .font(.system(size: 8))
                .frame(minWidth: 16)

            Text(self.text)
                .font(.system(size: 5))
        }
        .frame(width: 70, height: 10, alignment: .leading)
        .padding(1)
        .background(Globals.Style.dialogBackground)
        .overlay(self.line, alignment: .bottom)
        .overlay(self.line, alignment: .top)
    }

    private var line: some View {

        let rectangle = Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.gray)

        return rectangle
    }
}

#if DEBUG
struct CityBannerItemView_Previews: PreviewProvider {

    static var previews: some View {

        VStack {
            CityBannerItemView(value: "A", text: "Some value")
            CityBannerItemView(value: "A/b", text: "Other value")
        }
    }
}
#endif

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
                        .frame(width: 120, height: 16, alignment: .bottomTrailing)
                        .offset(x: 0.0, y: -74.0)

                    Text(self.viewModel.name)
                        .font(.footnote)
                        .foregroundColor(Color(self.viewModel.accent))
                        .frame(width: 120, height: 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(self.viewModel.accent), lineWidth: 1)
                        )
                        .offset(x: 0.0, y: -74.0)

                    Group {
                        Image(nsImage: self.viewModel.cityCivilizationImage())
                            .resizable()
                            .frame(width: 57, height: 57)
                            .clipShape(Circle())
                            .offset(x: -109.4, y: -20.4)

                        CityBannerItemView(value: self.viewModel.loyalityLabel, text: "Loyalty")
                            .offset(x: -35.0, y: -59.0)

                        CityBannerItemView(value: self.viewModel.religiousLabel, text: "Religious citizen")
                            .offset(x: -35.0, y: -46.0)

                        CityBannerItemView(value: self.viewModel.amenitiesLabel, text: "Amenities")
                            .offset(x: -35.0, y: -33.0)

                        CityBannerItemView(value: self.viewModel.housingLabel, text: "Housing capacity")
                            .offset(x: -35.0, y: -20.0)

                        CityBannerItemView(value: self.viewModel.turnsUntilGrowthLabel, text: "Turns until growth")
                            .offset(x: -35.0, y: -7.0)
                    }

                    Group {
                        Image(nsImage: self.viewModel.cityProductionImage())
                            .resizable()
                            .frame(width: 57, height: 57)
                            .clipShape(Circle())
                            .offset(x: 108.5, y: -20.4)

                        ScrollView {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(self.viewModel.productionTitle)
                                    .font(.system(size: 8))
                                    .padding(.leading, 2)

                                ForEach(self.viewModel.productionEffects, id: \.self) { productionEffect in

                                    Label(productionEffect)
                                        .frame(width: 70, alignment: .leading)
                                        .padding(.leading, 2)
                                }
                            }
                        }
                        .frame(width: 70, height: 66)
                        .background(Globals.Style.dialogBackground)
                        .border(Color.gray)
                        .offset(x: 41, y: -5)
                    }

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
