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
        case .debug:
            return AnyView(self.debugView)
        case .pedia:
            return AnyView(self.pediaView)
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

    private var debugView: some View {
        DebugView(viewModel: self.viewModel.debugViewModel)
    }

    private var pediaView: some View {
        PediaView(viewModel: self.viewModel.pediaViewModel)
    }
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
