//
//  GovernorsDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI

struct GovernorsDialogView: View {

    @ObservedObject
    var viewModel: GovernorsDialogViewModel

    public init(viewModel: GovernorsDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "Governors", mode: .landscape, viewModel: self.viewModel) {

            VStack(alignment: .center, spacing: 0) {

                HStack {

                    Text("Titles available: \(self.viewModel.availableTitles)")
                        .font(.system(size: 7))

                    Text("Spent: \(self.viewModel.spentTitles)")
                        .font(.system(size: 7))
                }
                .frame(height: 12, alignment: .center)

                HStack(spacing: 4) {

                    ForEach(Array(self.viewModel.governorViewModels.enumerated()), id: \.element) { index, governorViewModel in

                        GovernorView(viewModel: governorViewModel)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

#if DEBUG
struct GovernorsDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = GovernorsDialogViewModel()

        GovernorsDialogView(viewModel: viewModel)
    }
}
#endif
