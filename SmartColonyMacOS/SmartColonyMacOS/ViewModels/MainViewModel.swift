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
    
    @Published
    var mapMenuDisabled: Bool
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    // sub view models
    var menuViewModel: MenuViewModel
    var createGameMenuViewModel: CreateGameMenuViewModel
    var generateGameViewModel: GenerateGameViewModel
    var gameViewModel: GameViewModel
    
    init(presentedView: PresentedViewType = .menu,
         menuViewModel: MenuViewModel = MenuViewModel(),
         createGameMenuViewModel: CreateGameMenuViewModel = CreateGameMenuViewModel(),
         generateGameViewModel: GenerateGameViewModel = GenerateGameViewModel(),
         gameViewModel: GameViewModel = GameViewModel(mapViewModel: MapViewModel())) {
        
        self.presentedView = presentedView
        self.mapMenuDisabled = true
        
        self.menuViewModel = menuViewModel
        self.createGameMenuViewModel = createGameMenuViewModel
        self.generateGameViewModel = generateGameViewModel
        self.gameViewModel = gameViewModel
        
        // connect delegates
        self.menuViewModel.delegate = self
        self.createGameMenuViewModel.delegate = self
        self.generateGameViewModel.delegate = self
        // self.gameViewModel.delegate = self <== close game?
    }
    
    func centerCapital() {
        
        guard self.presentedView == .game else {
            return
        }
        
        // add center on capital (or start location)
        self.gameViewModel.centerCapital()
    }
    
    func centerOnCursor() {
        
        guard self.presentedView == .game else {
            return
        }
        
        // add center on cursor
        self.gameViewModel.centerOnCursor()
    }
    
    func zoomIn() {
        
        guard self.presentedView == .game else {
            return
        }
        
        self.gameViewModel.zoomIn()
    }
    
    func zoomOut() {
        
        guard self.presentedView == .game else {
            return
        }
        
        self.gameViewModel.zoomOut()
    }
    
    func zoomReset() {
        
        guard self.presentedView == .game else {
            return
        }
        
        self.gameViewModel.zoomReset()
    }
}

extension MainViewModel: MenuViewModelDelegate {
    
    func newGameStarted() {
        
        self.presentedView = .newGameMenu
        self.mapMenuDisabled = true
    }
}

extension MainViewModel: CreateGameMenuViewModelDelegate {
    
    func started(with leaderType: LeaderType, on handicapType: HandicapType, with mapType: MapType, and mapSize: MapSize) {
        
        self.generateGameViewModel.start(with: leaderType, on: handicapType, with: mapType, and: mapSize)
        self.presentedView = .loadingGame
        self.mapMenuDisabled = true
    }
    
    func canceled() {
        
        self.presentedView = .menu
        self.mapMenuDisabled = true
    }
}

extension MainViewModel: GenerateGameViewModelDelegate {
    
    func created(game: GameModel?) {

        self.gameViewModel.loadAssets()
        
        self.gameEnvironment.assign(game: game)
        
        self.presentedView = .game
        self.mapMenuDisabled = false
    }
}
