//
//  CityStateView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI

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

            Text(self.viewModel.name)
                .frame(width: 100, height: 24)

            Stepper("\(self.viewModel.envoys)", value: self.$viewModel.envoys)

            Spacer()

            Image(nsImage: self.viewModel.jumpToImage())
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    self.viewModel.centerClicked()
                }
        }
        .frame(width: 320, height: 32)
        .border(Color.gray, width: 1, cornerRadius: 8)
    }
}

#if DEBUG
import SmartAILibrary

struct CityStateView_Previews: PreviewProvider {

    private static func viewModel() -> CityStateViewModel {

        let viewModel = CityStateViewModel(cityState: .amsterdam)

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = CityStateView_Previews.viewModel()
        CityStateView(viewModel: viewModel)
    }
}
#endif
