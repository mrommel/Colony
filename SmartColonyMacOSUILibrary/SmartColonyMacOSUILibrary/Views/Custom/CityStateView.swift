//
//  CityStateView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI
import SmartAssets

struct CityStateView: View {

    @ObservedObject
    var viewModel: CityStateViewModel

    public init(viewModel: CityStateViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(spacing: 2) {

            Image(nsImage: self.viewModel.cityStateImage())
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 8)

            Text(self.viewModel.name)
                .frame(width: 100, height: 24, alignment: .leading)

            Stepper("\(self.viewModel.envoys)", value: self.$viewModel.envoys)
                .frame(width: 48, height: 24)

            VStack(spacing: 0) {
                Text("1")
                    .font(.system(size: 6))

                Image(nsImage: self.viewModel.bonusImage1())
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .frame(width: 16, height: 24)
            .toolTip(self.viewModel.bonusText1())

            VStack(spacing: 0) {
                Text("3")
                    .font(.system(size: 6))

                Image(nsImage: self.viewModel.bonusImage3())
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .frame(width: 16, height: 24)
            .toolTip(self.viewModel.bonusText3())

            VStack(spacing: 0) {
                Text("6")
                    .font(.system(size: 6))

                Image(nsImage: self.viewModel.bonusImage6())
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .frame(width: 16, height: 24)
            .toolTip(self.viewModel.bonusText6())

            Image(nsImage: self.viewModel.suzerainImage())
                .resizable()
                .frame(width: 20, height: 20)
                .toolTip(self.viewModel.suzerainText())

            VStack(alignment: .leading, spacing: 0) {
                Text("Suzerain")
                    .font(.system(size: 6))

                Text(self.viewModel.suzerainName)
                    .font(.system(size: 6))
            }
            .frame(width: 42, height: 24)

            Image(nsImage: self.viewModel.jumpToImage())
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 6)
                .onTapGesture {
                    self.viewModel.centerClicked()
                }
        }
        .frame(width: 340, height: 32)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-row"))
                .resizable(capInsets: EdgeInsets(all: 15))
        )
    }
}

#if DEBUG
import SmartAILibrary

struct CityStateView_Previews: PreviewProvider {

    private static func viewModel(
        cityState: CityStateType,
        suzerainName: String,
        quest: CityStateQuestType,
        envoys: Int) -> CityStateViewModel {

        let viewModel = CityStateViewModel(
            cityState: cityState,
            suzerainName: suzerainName,
            quest: quest,
            envoys: envoys
        )

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel0 = CityStateView_Previews.viewModel(
            cityState: .amsterdam,
            suzerainName: "none",
            quest: .trainUnit(type: .builder),
            envoys: 1
        )
        CityStateView(viewModel: viewModel0)

        let viewModel1 = CityStateView_Previews.viewModel(
            cityState: .akkad,
            suzerainName: "Alexander",
            quest: .none,
            envoys: 4
        )
        CityStateView(viewModel: viewModel1)
    }
}
#endif
