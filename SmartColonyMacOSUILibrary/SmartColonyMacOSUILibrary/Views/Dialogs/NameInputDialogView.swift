//
//  NameInputDialogView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI

struct NameInputDialogView: View {

    @ObservedObject
    var viewModel: NameInputDialogViewModel

    public init(viewModel: NameInputDialogViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        Group {
            VStack(spacing: 10) {
                Text(self.viewModel.title)
                    .font(.title2)
                    .bold()
                    .padding(.top)

                Text(self.viewModel.summary)

                TextField("name ...", text: self.$viewModel.value)

                HStack(alignment: .center, spacing: 0) {

                    Button(action: {
                        self.viewModel.closeDialog()
                    }, label: {
                        Text(self.viewModel.cancel)
                    })
                        .buttonStyle(DialogButtonStyle())

                    Spacer()

                    Button(action: {
                        self.viewModel.closeAndConfirmDialog()
                    }, label: {
                        Text(self.viewModel.confirm)
                    })
                        .buttonStyle(DialogButtonStyle(state: .highlighted))
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
struct NameInputDialogView_Previews: PreviewProvider {

    static var previews: some View {
        // swiftlint:disable:next redundant_discardable_let
        let _ = GameViewModel(preloadAssets: true)
        let game = DemoGameModel()
        let environment = GameEnvironment(game: game)

        NameInputDialogView(viewModel: NameInputDialogViewModel())
            .environment(\.gameEnvironment, environment)
    }
}
#endif
