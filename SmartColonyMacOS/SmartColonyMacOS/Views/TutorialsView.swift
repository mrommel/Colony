//
//  TutorialsView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 30.06.22.
//

import SwiftUI
import SmartColonyMacOSUILibrary
import SmartAssets

struct TutorialsView: View {

    @ObservedObject
    var viewModel: TutorialsViewModel

    var body: some View {

        VStack {

            Spacer(minLength: 1)

            Text("TXT_KEY_TUTORIALS".localized())
                .font(.largeTitle)

            Divider()

            Button("TXT_KEY_FOUND_FIRST_CITY".localized()) {
                self.viewModel.startFoundFirstCity()
            }
            .buttonStyle(GameButtonStyle()).padding(.top, 20)

            Button("TXT_KEY_GOTO_WAR".localized()) {
                self.viewModel.startGotoWar()
            }
            .buttonStyle(GameButtonStyle()).padding(.top, 20)

            Divider()

            HStack {
                Button("TXT_KEY_CANCEL".localized()) {
                    self.viewModel.cancel()
                }
                .buttonStyle(GameButtonStyle()).padding(.top, 20)
            }

            Spacer(minLength: 1)
        }
    }
}

struct TutorialsView_Previews: PreviewProvider {

    static var viewModel = TutorialsViewModel()

    static var previews: some View {

        TutorialsView(viewModel: viewModel)
    }
}
