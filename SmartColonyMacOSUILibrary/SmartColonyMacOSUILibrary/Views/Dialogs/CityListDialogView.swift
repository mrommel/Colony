//
//  CityListDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 12.09.21.
//

import SwiftUI
import SmartAILibrary

struct CityListDialogView: View {

    @ObservedObject
    var viewModel: CityListDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(250))]

    public init(viewModel: CityListDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "Cities", viewModel: self.viewModel) {
            ScrollView(.vertical, showsIndicators: true, content: {

                LazyVStack(spacing: 4) {

                    ForEach(self.viewModel.cityViewModels, id: \.self) { cityViewModel in

                        CityView(viewModel: cityViewModel)
                            .onTapGesture {
                                cityViewModel.selectCity()
                            }
                            .padding(.top, 8)
                    }
                }
            })
        }
    }
}

#if DEBUG
struct CityListDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let player = Player(leader: .alexander)

        let city0 = City(name: "Berlin", at: HexPoint.invalid, capital: true, owner: player)
        let city1 = City(name: "Paris", at: HexPoint.invalid, capital: false, owner: player)

        let viewModel = CityListDialogViewModel(
            with: [city0, city1]
        )

        CityListDialogView(viewModel: viewModel)
    }
}
#endif
