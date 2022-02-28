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

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 24, height: 24)

            Text(self.viewModel.name)
                .frame(width: 70, height: 24)
        }
        .frame(width: 280, height: 32)
        .border(Color.purple, width: 2, cornerRadius: 20)
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
