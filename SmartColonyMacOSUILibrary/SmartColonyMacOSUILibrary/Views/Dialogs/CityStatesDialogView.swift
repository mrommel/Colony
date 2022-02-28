//
//  CityStatesDialogView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 28.02.22.
//

import SwiftUI
import SmartAssets

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
            buttonText: "Cancel",
            viewModel: self.viewModel) {

                VStack {
                    self.headerView
                        .frame(height: 72)

                    ScrollView {

                        Text("city states")
                        // list of known city states
                        /* LazyVStack(alignment: .center) {
                            CityStateView()
                        } */

                        // list of enabled bonuses
                        /* LazyVStack(alignment: .center) {

                        } */
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

            VStack {
                Text("Overview")
                    .font(.title)

                Label("1 [Envoy] at X Influence points")
            }
        }
        .frame(width: 300)
    }
}

struct CityStatesDialogView_Previews: PreviewProvider {

    static func viewModel() -> CityStatesDialogViewModel {

        let viewModel = CityStatesDialogViewModel()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = CityStatesDialogView_Previews.viewModel()
        CityStatesDialogView(viewModel: viewModel)
    }
}
