//
//  MainView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI
import SmartMacOSUILibrary

struct MainView: View {
    
    @ObservedObject
    var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            Image("background_macos")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if self.viewModel.presentedView == .menu {
                    MenuView(viewModel: self.viewModel.menuViewModel)
                }
                
                if self.viewModel.presentedView == .newGameMenu {
                    CreateGameMenuView(viewModel: self.viewModel.createGameMenuViewModel)
                }
                
                if self.viewModel.presentedView == .loadingGame {
                    GenerateGameView(viewModel: self.viewModel.generateGameViewModel)
                }

                if self.viewModel.presentedView == .game {
                    GameScrollContentView(viewModel: self.viewModel.gameViewModel)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .padding(.vertical, 25)
        }
        .toolbar {
            Button(action: self.viewModel.doTurn) {
                Label("Turn", systemImage: "arrow.right.circle.fill")
            }
        }
    }
    
    init() {
        
        self.viewModel = MainViewModel()
    }
}

/*struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
    }
}*/
