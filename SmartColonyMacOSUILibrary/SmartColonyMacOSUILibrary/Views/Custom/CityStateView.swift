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

        HStack {

            Image(nsImage: self.viewModel.cityStateImage())
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 8)

            Text(self.viewModel.name)
                .frame(width: 100, height: 24, alignment: .leading)

            Stepper("\(self.viewModel.envoys)", value: self.$viewModel.envoys)

            VStack(spacing: 0) {
                Text("1")
                    .font(.footnote)

                Image(nsImage: self.viewModel.bonusImage1())
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            .frame(width: 24, height: 24)

            VStack(spacing: 0) {
                Text("3")
                    .font(.footnote)

                Image(nsImage: self.viewModel.bonusImage3())
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            .frame(width: 24, height: 24)

            VStack(spacing: 0) {
                Text("6")
                    .font(.footnote)

                Image(nsImage: self.viewModel.bonusImage6())
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            .frame(width: 24, height: 24)

            Image(nsImage: self.viewModel.suzerainImage())
                .resizable()
                .frame(width: 24, height: 24)

            Spacer()

            Image(nsImage: self.viewModel.jumpToImage())
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 6)
                .onTapGesture {
                    self.viewModel.centerClicked()
                }
        }
        .frame(width: 320, height: 32)
        .background(
            Image(nsImage: ImageCache.shared.image(for: "grid9-row"))
                .resizable(capInsets: EdgeInsets(all: 15))
        )
    }
}

#if DEBUG
import SmartAILibrary

struct CityStateView_Previews: PreviewProvider {

    private static func viewModel(cityState: CityStateType, quest: CityStateQuestType) -> CityStateViewModel {

        let viewModel = CityStateViewModel(cityState: cityState, quest: quest, envoys: 1)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel0 = CityStateView_Previews.viewModel(cityState: .amsterdam, quest: .trainUnit(type: .builder))
        CityStateView(viewModel: viewModel0)

        let viewModel1 = CityStateView_Previews.viewModel(cityState: .akkad, quest: .none)
        CityStateView(viewModel: viewModel1)
    }
}
#endif
