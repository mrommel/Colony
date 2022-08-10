//
//  ConfirmationDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.06.21.
//

import SwiftUI
import SmartAILibrary

struct ConfirmationDialogView: View {

    @ObservedObject
    var viewModel: ConfirmationDialogViewModel

    public init(viewModel: ConfirmationDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding()

                Text(self.viewModel.question)

                HStack(alignment: .center, spacing: 0) {

                    if let cancelText = self.viewModel.cancelText {
                        Button(action: {
                            self.viewModel.closeDialog()
                        }, label: {
                            Text(cancelText)
                        })

                        Spacer()
                    }

                    Button(action: {
                        self.viewModel.closeDialogAndComfirm()
                    }, label: {
                        Text(self.viewModel.okayText)
                    })
                }
            }
            .padding(.bottom, 45)
            .padding(.leading, 45)
            .padding(.trailing, 45)
        }
        .frame(width: 300, height: 170, alignment: .top)
        .dialogBackground()
    }
}

#if DEBUG
struct ConfirmationDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)

        let viewModel = ConfirmationDialogViewModel(
            title: "Confirm",
            question: "Do you agree?",
            confirm: "Confirm",
            cancel: "Cancel"
        )
        ConfirmationDialogView(viewModel: viewModel)
    }
}
#endif
