//
//  CityLoyaltyView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct CityLoyaltyView: View {

    @ObservedObject
    var viewModel: CityLoyaltyViewModel

    public init(viewModel: CityLoyaltyViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        ScrollView(.vertical, showsIndicators: true, content: {

            Text("Loyalty")
                .font(.headline)
                .padding(.top, 10)

            ProgressBar(value: self.$viewModel.loyaltyValue, maxValue: 100, foregroundColor: .green)
                .frame(width: 348, height: 8, alignment: .top)

            HStack(alignment: .center) {
                GroupBox {
                    VStack(alignment: .center, spacing: 4) {
                        Text("\(Int(self.viewModel.loyaltyValue)) Loyalty")
                        Text("of")
                        Text("100 Possible")
                    }
                    .frame(width: 150, height: 60, alignment: .top)
                    .padding(.all, 4)
                }
                .frame(width: 170, height: 70, alignment: .top)

                GroupBox {
                    VStack(alignment: .center, spacing: 4) {
                        Text("Status")
                        Text(self.viewModel.loyaltyState)
                    }
                    .frame(width: 150, height: 60, alignment: .top)
                    .padding(.all, 4)
                }
                .frame(width: 170, height: 70, alignment: .top)
            }
            .padding(.bottom, 8)

            GroupBox {
                VStack(alignment: .center, spacing: 4) {
                    Text(self.viewModel.loyaltyEffect)
                }
                .frame(width: 330, alignment: .top)
                .padding(.all, 4)
            }
            .frame(width: 348, height: 50, alignment: .top)

            GroupBox {
                VStack(alignment: .center, spacing: 4) {

                    HStack {
                        Text("Pressure from nearby Citizen")
                        Spacer()
                        Text("27")
                    }

                    if self.viewModel.hasGovernor {
                        HStack {
                            Text("Governor placed here")
                            Spacer()
                            Text("8")
                        }
                    }

                    HStack {
                        Text("Happyness level")
                        Spacer()
                        Text("27")
                    }

                    HStack {
                        Text("Trade routes")
                        Spacer()
                        Text("2")
                    }

                    HStack {
                        Text("Other effects")
                        Spacer()
                        Text("2")
                    }

                    HStack {
                        Text("Loyalty per turn")
                        Spacer()
                        Text("2")
                    }
                }
                .frame(width: 330, alignment: .top)
                .padding(.all, 4)
            }
            .frame(width: 348, alignment: .top)

            Divider()
                .frame(width: 348)
                .padding(.top, 10)

            Text("Governor")
                .font(.headline)

            GroupBox {
                VStack(alignment: .center, spacing: 4) {
                    if !self.viewModel.hasGovernor {
                        Text("No governor assigned")
                    } else {
                        Text(self.viewModel.governorName)
                        Text(self.viewModel.governorSummary)
                    }
                }
                .frame(width: 330, alignment: .top)
                .padding(.all, 4)
            }
            .frame(width: 348, height: 50, alignment: .top)

        })
        .frame(width: 700, height: 300, alignment: .top)
        .background(Globals.Style.dialogBackground)
    }
}

#if DEBUG
struct CityLoyaltyView_Previews: PreviewProvider {

    static var previews: some View {

        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)
        let city = City(name: "Berlin", at: HexPoint(x: 7, y: 4), capital: true, owner: game.humanPlayer())
        let viewModel = CityLoyaltyViewModel(city: city)

        CityLoyaltyView(viewModel: viewModel)
            .environment(\.gameEnvironment, environment)
    }
}
#endif
