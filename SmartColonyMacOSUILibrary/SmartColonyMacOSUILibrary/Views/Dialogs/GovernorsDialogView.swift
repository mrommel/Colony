//
//  GovernorsDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI

struct GovernorView: View {

    @ObservedObject
    var viewModel: GovernorViewModel

    public init(viewModel: GovernorViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        VStack(alignment: .center, spacing: 8) {
            Text(self.viewModel.name)
            Text(self.viewModel.title)
        }
        .frame(width: 90, height: 300, alignment: .center)
        .background(Color.red)
    }
}

struct GovernorsDialogView: View {

    @ObservedObject
    var viewModel: GovernorsDialogViewModel

    private var gridItemLayout = [GridItem(.fixed(300))]

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
