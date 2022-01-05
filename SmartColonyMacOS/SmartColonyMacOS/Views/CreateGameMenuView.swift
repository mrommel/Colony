//
//  CreateGameMenuView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import Foundation
import SwiftUI
import SmartAssets
import SmartMacOSUILibrary

struct CreateGameMenuView: View {

    @ObservedObject
    var viewModel: CreateGameMenuViewModel

    var body: some View {

        VStack {

            Spacer(minLength: 1)

            Text("TXT_KEY_GAME".localized())
                .font(.largeTitle)

            Divider()

            Form {
                Section {
                    DataPicker(title: "TXT_KEY_CHOOSE_LEADER".localized(),
                               data: self.viewModel.leaders,
                               selection: $viewModel.selectedLeaderIndex)

                    DataPicker(title: "TXT_KEY_CHOOSE_DIFFICULTY".localized(),
                               data: self.viewModel.handicaps,
                               selection: $viewModel.selectedDifficultyIndex)

                    DataPicker(title: "TXT_KEY_CHOOSE_MAP_TYPE".localized(),
                               data: self.viewModel.mapTypes,
                               selection: $viewModel.selectedMapTypeIndex)

                    DataPicker(title: "TXT_KEY_CHOOSE_MAP_SIZE".localized(),
                               data: self.viewModel.mapSizes,
                               selection: $viewModel.selectedMapSizeIndex)
                }
            }

            Divider()

            HStack {
                Button("TXT_KEY_CANCEL".localized()) {
                    self.viewModel.cancel()
                }.buttonStyle(GameButtonStyle()).padding(.top, 20).padding(.trailing, 20)

                Button("TXT_KEY_START".localized()) {
                    self.viewModel.start()
                }.buttonStyle(GameButtonStyle(state: .highlighted)).padding(.top, 20)
            }

            Spacer(minLength: 1)
        }
    }
}

struct CreateGameMenuView_Previews: PreviewProvider {

    //static var gameViewModel: GameViewModel = GameViewModel(game: DemoGameModel())
    static var viewModel = CreateGameMenuViewModel()

    static var previews: some View {

        CreateGameMenuView(viewModel: viewModel)
    }
}
