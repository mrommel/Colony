//
//  GreatPeopleDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.10.21.
//

import SwiftUI

struct GreatPeopleDialogView: View {

    @ObservedObject
    var viewModel: GreatPeopleDialogViewModel

    public init(viewModel: GreatPeopleDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "Great People", mode: .landscape, viewModel: self.viewModel) {

            VStack(alignment: .center, spacing: 0) {

                HStack {

                    Text("Great People")
                        .font(.system(size: 7))

                    Text("Previously Recruited")
                        .font(.system(size: 7))
                }
                .frame(height: 12, alignment: .center)

                ScrollView(.vertical, showsIndicators: true, content: {

                    LazyHStack(spacing: 4) {

                        ForEach(self.viewModel.greatPersonViewModels, id: \.self) { greatPersonViewModel in

                            GreatPersonView(viewModel: greatPersonViewModel)
                        }
                    }
                    .padding(.top, 8)
                })
            }
        }
    }
}

#if DEBUG
struct GreatPeopleDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let viewModel = GreatPeopleDialogViewModel()

        GreatPeopleDialogView(viewModel: viewModel)
    }
}
#endif
