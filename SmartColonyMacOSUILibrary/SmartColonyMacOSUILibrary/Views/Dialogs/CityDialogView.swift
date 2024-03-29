//
//  CityDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityDialogView: View {

    @ObservedObject
    var viewModel: CityDialogViewModel

    public init(viewModel: CityDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 0) {

                Text(self.viewModel.cityName)
                    .font(.title2)
                    .bold()
                    .padding(.top, 13)
                    .padding(.bottom, 10)

                VStack(spacing: 10) {

                    Text("TXT_KEY_CITY_POPULATION_COUNT".localizedWithFormat(with: [self.viewModel.population]))

                    HStack(alignment: .center) {
                        YieldValueView(viewModel: self.viewModel.scienceYieldViewModel)

                        YieldValueView(viewModel: self.viewModel.cultureYieldViewModel)

                        YieldValueView(viewModel: self.viewModel.foodYieldViewModel)

                        YieldValueView(viewModel: self.viewModel.productionYieldViewModel)

                        YieldValueView(viewModel: self.viewModel.goldYieldViewModel)

                        YieldValueView(viewModel: self.viewModel.faithYieldViewModel)
                    }
                    .zIndex(600)

                    Divider()
                        .zIndex(500)

                    self.detailView
                        .frame(width: 700, height: 300, alignment: .top)
                        .zIndex(500)

                    Spacer(minLength: 0)

                    HStack(spacing: 8) {

                        ForEach(CityDetailViewType.all, id: \.self) { value in
                            Button(action: {
                                self.viewModel.show(detail: value)
                            }, label: {
                                Label(value.name())
                                    .font(.system(size: 15))
                                    .foregroundColor(value == self.viewModel.cityDetailViewType
                                        ? Color.accentColor
                                        : Color.gray)
                                    .animation(nil)
                            })
                        }
                    }
                    .zIndex(400)

                    Divider()

                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text("TXT_KEY_CANCEL".localized())
                    })
                    .padding(.bottom, 8)
                }
                .padding(.top, 10)
                .background(Color(Globals.Colors.dialogBackground))
            }
            .padding(.bottom, 43)
            .padding(.leading, 19)
            .padding(.trailing, 19)
        }
        .frame(width: 750, height: 550, alignment: .top)
        .dialogBackground()
    }

    var detailView: AnyView {

        switch self.viewModel.cityDetailViewType {

        case .production:
            return AnyView(CityProductionView(viewModel: self.viewModel.productionViewModel))
        case .goldPurchase:
            return AnyView(CityGoldPurchaseView(viewModel: self.viewModel.goldPurchaseViewModel))
        case .faithPurchase:
            return AnyView(Text("Faith Purchase"))
        case .buildings:
            return AnyView(CityBuildingsView(viewModel: self.viewModel.buildingsViewModel))
        case .growth:
            return AnyView(CityGrowthView(viewModel: self.viewModel.growthViewModel))
        case .citizen:
            return AnyView(CityCitizenView(viewModel: self.viewModel.citizenViewModel))
        case .religion:
            return AnyView(CityReligionView(viewModel: self.viewModel.religionViewModel))
        case .loyalty:
            return AnyView(CityLoyaltyView(viewModel: self.viewModel.loyaltyViewModel))
        }
    }
}

#if DEBUG
struct CityDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        CityDialogView(viewModel: CityDialogViewModel(city: City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())))
            .environment(\.gameEnvironment, environment)
    }
}
#endif
