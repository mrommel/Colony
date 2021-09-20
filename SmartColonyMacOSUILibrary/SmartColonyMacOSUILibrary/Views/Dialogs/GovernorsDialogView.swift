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

            ScrollView(.vertical, showsIndicators: true, content: {

                LazyHStack(spacing: 10) {

                    ForEach(self.viewModel.governorViewModels, id: \.self) { governorViewModel in

                        GovernorView(viewModel: governorViewModel)
                    }
                }
            })
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
