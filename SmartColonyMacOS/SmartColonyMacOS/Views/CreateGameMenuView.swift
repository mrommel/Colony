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
            
            Text("SmartColony")
                .font(.largeTitle)
            
            Divider()
            
            Form {
                Section {
                    DataPicker(title: "Choose Leader",
                               data: self.viewModel.leaders,
                               selection: $viewModel.selectedLeaderIndex)
                    
                    DataPicker(title: "Choose Difficulty",
                               data: self.viewModel.handicaps,
                               selection: $viewModel.selectedDifficultyIndex)
                    
                    DataPicker(title: "Choose Map Type",
                               data: self.viewModel.mapTypes,
                               selection: $viewModel.selectedMapTypeIndex)
                    
                    DataPicker(title: "Choose Map Size",
                               data: self.viewModel.mapSizes,
                               selection: $viewModel.selectedMapSizeIndex)
                }
            }
            
            Divider()
            
            HStack {
                Button("Cancel") {
                    self.viewModel.cancel()
                }.buttonStyle(GameButtonStyle()).padding(.top, 20).padding(.trailing, 20)
                
                Button("Start") {
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
