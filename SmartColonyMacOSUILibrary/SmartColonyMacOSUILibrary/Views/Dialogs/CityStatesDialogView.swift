//
//  CityStatesDialogView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

struct CityStatesDialogView: View {

    @ObservedObject
    var viewModel: CityStatesDialogViewModel

    public init(viewModel: CityStatesDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(
            title: self.viewModel.title,
            mode: .portrait,
            buttonText: "TXT_KEY_CANCEL",
            viewModel: self.viewModel) {

                VStack {
                    self.headerView
                        .frame(height: 72)

                    ScrollView {

                        if self.viewModel.cityStateViewModels.isEmpty {
                            Text("TXT_KEY_CITY_STATE_NONE_MET_YET".localized())
                        } else {
                            // list of known city states
                            LazyVStack(alignment: .leading) {

                                ForEach(self.viewModel.cityStateViewModels, id: \.self) { cityStateViewModel in

                                    CityStateView(viewModel: cityStateViewModel)
                                }
                            }

                            // list of enabled bonuses
                            LazyVStack(alignment: .leading) {

                                ForEach(self.viewModel.envoyEffectViewModels, id: \.self) { envoyEffectViewModel in

                                    EnvoyEffectView(viewModel: envoyEffectViewModel)
                                }
                            }
                        }
                    }
                }
                .frame(width: 350, height: 330)
                .background(
                    Globals.Style.dialogBackground
                )
            }
    }

    var headerView: some View {

        HStack {

            Image(nsImage: self.viewModel.cityStateIcon())
                .resizable()
                .frame(width: 36, height: 36)

            VStack(spacing: 4) {
                Text("TXT_KEY_CITY_STATE_OVERVIEW".localized())
                    .font(.title3)

                Label(self.viewModel.influencePointsText)
            }
        }
        .frame(width: 300)
    }
}

#if DEBUG
struct CityStatesDialogView_Previews: PreviewProvider {

    static func viewModel() -> CityStatesDialogViewModel {

        let viewModel = CityStatesDialogViewModel()
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = CityStatesDialogView_Previews.viewModel()
        CityStatesDialogView(viewModel: viewModel)
    }
}
#endif
