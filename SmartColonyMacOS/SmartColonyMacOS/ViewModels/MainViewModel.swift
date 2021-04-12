//
//  MainViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartMacOSUILibrary
import SmartAILibrary

enum PresentedViewType {
    
    case menu
    case newGameMenu
    case loadingGame
    case game
}

class MainViewModel: ObservableObject {
    
    @Published
    var presentedView: PresentedViewType
    
    // sub view models
    var menuViewModel: MenuViewModel
    var createGameMenuViewModel: CreateGameMenuViewModel
    var generateGameViewModel: GenerateGameViewModel
    var gameViewModel: GameViewModel
    
    init(presentedView: PresentedViewType = .menu,
         menuViewModel: MenuViewModel = MenuViewModel(),
         createGameMenuViewModel: CreateGameMenuViewModel = CreateGameMenuViewModel(),
         generateGameViewModel: GenerateGameViewModel = GenerateGameViewModel(),
         gameViewModel: GameViewModel = GameViewModel()) {
        
        self.presentedView = presentedView
        
        self.menuViewModel = menuViewModel
        self.createGameMenuViewModel = createGameMenuViewModel
        self.generateGameViewModel = generateGameViewModel
        self.gameViewModel = gameViewModel
        
        // connect delegates
        self.menuViewModel.delegate = self
        self.createGameMenuViewModel.delegate = self
        self.generateGameViewModel.delegate = self
    }
}

extension MainViewModel: MenuViewModelDelegate {
    
    func newGameStarted() {
        
        self.presentedView = .newGameMenu
    }
}

extension MainViewModel: CreateGameMenuViewModelDelegate {
    
    func started(with leaderType: LeaderType, on handicapType: HandicapType, with mapType: MapType, and mapSize: MapSize) {
        
        self.generateGameViewModel.start(with: leaderType, on: handicapType, with: mapType, and: mapSize)
        self.presentedView = .loadingGame
    }
    
    func canceled() {
        
        self.presentedView = .menu
    }
}

extension MainViewModel: GenerateGameViewModelDelegate {
    
    func created(game: GameModel?) {

        self.gameViewModel.loadAssets()
        self.gameViewModel.assign(game: game)
        
        self.presentedView = .game
    }
}
