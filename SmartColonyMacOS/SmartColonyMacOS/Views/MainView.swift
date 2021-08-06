//
//  MainView.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 21.03.21.
//

import SwiftUI
import SmartMacOSUILibrary
import SmartAILibrary

struct MainView: View {
    
    @ObservedObject
    var viewModel: MainViewModel

    // debug
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @ObservedObject
    var diplomaticDialogViewModel: DiplomaticDialogViewModel
    let game = DemoGameModel()
    
    init(viewModel: MainViewModel) {
        
        self.viewModel = viewModel
        
        let _ = GameViewModel(preloadAssets: true)
        
        let playerOne = Player(leader: .barbarossa, isHuman: true)
        let playerTwo = Player(leader: .cyrus, isHuman: false)
        
        self.diplomaticDialogViewModel = DiplomaticDialogViewModel(for: playerOne, and: playerTwo, in: game)
        
        self.gameEnvironment.assign(game: game)
    }
    
    var body: some View {
        ZStack {
            Image("background_macos")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)

            self.content
                .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .topLeading)
                .padding(.all, 1)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    private var content: AnyView {
        
        switch self.viewModel.presentedView {
            
        case .menu:
            return AnyView(self.menuView)
        case .newGameMenu:
            return AnyView(self.createGameMenuView)
        case .loadingGame:
            return AnyView(self.generateGameView)
        case .game:
            return AnyView(self.gameView)
        case .pedia:
            return AnyView(DiplomaticDialogView(viewModel: self.diplomaticDialogViewModel))
        }
    }
}

// MARK: - Loading Content

extension MainView {
    
    private var menuView: some View {
        MenuView(viewModel: self.viewModel.menuViewModel)
    }
    
    private var createGameMenuView: some View {
        CreateGameMenuView(viewModel: self.viewModel.createGameMenuViewModel)
    }
    
    private var generateGameView: some View {
        GenerateGameView(viewModel: self.viewModel.generateGameViewModel)
    }
    
    private var gameView: some View {
        GameView(viewModel: self.viewModel.gameViewModel)
    }
    
    /*func failedView(_ error: Error) -> some View {
     ErrorView(error: error, retryAction: {
         // self.reloadCountries()
     })
     }*/
}

/*
struct MainView_Previews: PreviewProvider {

    static var gameViewModel: GameViewModel = GameViewModel(game: DemoGameModel())
    static var viewModel = MainViewModel(
        presentedView: .game,
        gameViewModel: gameViewModel)
    
    static var previews: some View {
        
        MainView(viewModel: viewModel)
    }
}
*/
