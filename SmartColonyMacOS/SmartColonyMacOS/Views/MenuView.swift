//
// MenuView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct MenuView: View {

    @ObservedObject
    var viewModel: MenuViewModel

    var body: some View {

        VStack {

            Spacer(minLength: 1)

            Text("TXT_KEY_GAME".localized())
                .font(.largeTitle)

            Divider()

            GroupBox {

                VStack(alignment: .center, spacing: 10) {
                    Button("TXT_KEY_TUTORIALS".localized()) {
                        print("tutorials")
                    }.buttonStyle(GameButtonStyle())

                    Button("TXT_KEY_RESUME_GAME".localized()) {
                        print("resume game")
                    }.buttonStyle(GameButtonStyle())

                    Button("TXT_KEY_NEW_GAME".localized()) {
                        self.viewModel.startNewGame()
                    }
                    .buttonStyle(GameButtonStyle(state: .highlighted))

                    Button("TXT_KEY_LOAD_GAME".localized()) {
                        print("load game")
                    }.buttonStyle(GameButtonStyle())

                    Button("TXT_KEY_OPTIONS".localized()) {
                        print("options")
                    }.buttonStyle(GameButtonStyle())

                    Button("TXT_KEY_PEDIA".localized()) {
                        self.viewModel.startPedia()
                    }.buttonStyle(GameButtonStyle())

#if DEBUG
                    Button("TXT_KEY_DEBUG".localized()) {
                        self.viewModel.startDebug()
                    }.buttonStyle(GameButtonStyle())
#endif

                    Button("TXT_KEY_QUIT".localized()) {
                        self.viewModel.showingQuitConfirmationAlert = true
                    }
                    .buttonStyle(GameButtonStyle())
                    .padding(.top, 45)
                }
            }

            Spacer(minLength: 1)

        }.padding(.vertical, 25)

        .alert(isPresented: self.$viewModel.showingQuitConfirmationAlert) {
            Alert(
                title: Text("TXT_KEY_QUIT".localized()),
                message: Text("TXT_KEY_QUIT_CONFIRM".localized()),
                primaryButton: .destructive(Text("TXT_KEY_QUIT".localized())) {
                    NSApplication.shared.terminate(self)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct MenuView_Previews: PreviewProvider {

    //static var gameViewModel: GameViewModel = GameViewModel(game: DemoGameModel())
    static var viewModel = MenuViewModel()

    static var previews: some View {

        MenuView(viewModel: viewModel)
    }
}
