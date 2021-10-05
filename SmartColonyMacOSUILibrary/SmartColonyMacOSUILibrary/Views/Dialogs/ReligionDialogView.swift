//
//  ReligionDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.10.21.
//

import SwiftUI

struct ReligionDialogView: View {

    @ObservedObject
    var viewModel: ReligionDialogViewModel

    public init(viewModel: ReligionDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(title: "Religion", mode: .landscape, viewModel: self.viewModel) {

            VStack(alignment: .center, spacing: 0) {

                HStack {

                    Text("My Religion")
                        .font(.system(size: 7))

                    Text("???")
                        .font(.system(size: 7))
                }
                .frame(height: 12, alignment: .center)

                if self.viewModel.hasFoundedPantheon {
                    PantheonView(viewModel: self.viewModel.pantheonViewModel)
                } else {
                    Text("Gain more faith and found a pantheon")
                }

                Divider()

                /*ScrollView(.vertical, showsIndicators: true, content: {

                    LazyHStack(spacing: 4) {

                        ForEach(self.viewModel.greatPersonViewModels, id: \.self) { greatPersonViewModel in

                            GreatPersonView(viewModel: greatPersonViewModel)
                        }
                    }
                    .padding(.top, 8)
                })*/
            }
        }
    }
}

#if DEBUG
struct ReligionDialogView_Previews: PreviewProvider {

    static func viewModel(hasFoundedPantheon: Bool) -> ReligionDialogViewModel {

        let viewModel = ReligionDialogViewModel()

        viewModel.hasFoundedPantheon = hasFoundedPantheon

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModelWithoutPantheon = ReligionDialogView_Previews.viewModel(hasFoundedPantheon: false)
        ReligionDialogView(viewModel: viewModelWithoutPantheon)

        let viewModelWithPantheon = ReligionDialogView_Previews.viewModel(hasFoundedPantheon: true)
        ReligionDialogView(viewModel: viewModelWithPantheon)
    }
}
#endif
