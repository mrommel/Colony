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

            self.tutorialButtonsView

            Divider()

            HStack {
                Button("TXT_KEY_CANCEL".localized()) {
                    self.viewModel.cancel()
                }
                .buttonStyle(GameButtonStyle())
                .padding(.top, 20)
            }

            Spacer(minLength: 1)
        }
    }

    var tutorialButtonsView: some View {

        VStack {
            Button("TXT_KEY_TUTORIAL_MOVEMENT_EXPLORATION_TITLE".localized()) {
                self.viewModel.startMovementExploration()
            }
            .buttonStyle(GameButtonStyle(state: self.viewModel.canStartMovementExploration() ? .normal : .disabled))
            .padding(.top, 10)

            Button("TXT_KEY_TUTORIAL_FOUND_FIRST_CITY_TITLE".localized()) {
                self.viewModel.startFoundFirstCity()
            }
            .buttonStyle(GameButtonStyle(state: self.viewModel.canStartFoundFirstCity() ? .normal : .disabled))
            .padding(.top, 10)

            Button("TXT_KEY_TUTORIAL_IMPROVING_CITY_TITLE".localized()) {
                self.viewModel.startImprovingCity()
            }
            .buttonStyle(GameButtonStyle(state: self.viewModel.canStartImprovingCity() ? .normal : .disabled))
            .padding(.top, 10)

            // trade routes?

            Button("TXT_KEY_TUTORIAL_COMBAT_CONQUEST_TITLE".localized()) {
                self.viewModel.startCombatAndConquest()
            }
            .buttonStyle(GameButtonStyle())
            .padding(.top, 10)

            Button("TXT_KEY_TUTORIAL_BASIC_DIPLOMACY_TITLE".localized()) {
                self.viewModel.startBasicDiplomacy()
            }
            .buttonStyle(GameButtonStyle())
            .padding(.top, 10)
        }
    }
}

struct TutorialsView_Previews: PreviewProvider {

    static var viewModel = TutorialsViewModel()

    static var previews: some View {

        TutorialsView(viewModel: viewModel)
    }
}
