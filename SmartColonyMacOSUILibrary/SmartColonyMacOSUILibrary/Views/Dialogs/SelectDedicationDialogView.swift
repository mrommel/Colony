//
//  SelectDedicationDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.01.22.
//

import SwiftUI
import SmartAssets

// https://static.wikia.nocookie.net/civilization/images/8/82/Dedications_%28Civ6%29.jpg/revision/latest/scale-to-width-down/1280?cb=20180930035357
struct SelectDedicationDialogView: View {

    @ObservedObject
    var viewModel: SelectDedicationDialogViewModel

    public init(viewModel: SelectDedicationDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        BaseDialogView(
            title: self.viewModel.title,
            mode: .portrait,
            buttonText: "Confirm",
            viewModel: self.viewModel) {

                VStack(alignment: .center) {

                    Text(self.viewModel.summaryText)

                    ScrollView(.vertical, showsIndicators: true, content: {

                        LazyHStack(spacing: 4) {

                            ForEach(self.viewModel.dedicationViewModels, id: \.self) { dedicationViewModel in

                                DedicationView(viewModel: dedicationViewModel)
                            }
                        }
                        .padding(.top, 8)
                    })

                    Text(self.viewModel.dedicationsText)

                    Spacer()
                }
                .frame(width: 350, height: 330)
                .background(
                    Globals.Style.dialogBackground
                )
            }
    }
}

#if DEBUG
import SmartAILibrary

struct SelectDedicationDialogView_Previews: PreviewProvider {

    static func viewModel() -> SelectDedicationDialogViewModel {

        let viewModel = SelectDedicationDialogViewModel()

        let game = DemoGameModel()
        //game.humanPlayer()?.add(moment: Moment(type: .metNew(civilization: .english), turn: 28))

        viewModel.gameEnvironment.game.value = game
        viewModel.update()

        return viewModel
    }

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = SelectDedicationDialogView_Previews.viewModel()
        SelectDedicationDialogView(viewModel: viewModel)
    }
}
#endif
