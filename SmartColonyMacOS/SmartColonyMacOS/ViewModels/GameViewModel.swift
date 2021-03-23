//
//  GameViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartMacOSUILibrary

class GameViewModel: ObservableObject {
    
    @Published
    var showMenu: Bool

    @Published
    var showNewGameMenu: Bool
    
    @Published
    var showMap: Bool
    
    var menuViewModel: MenuViewModel
    var mapViewModel: MapScrollContentViewModel
    var createGameMenuViewModel: CreateGameMenuViewModel
    
    init() {
        self.showMenu = true
        self.showNewGameMenu = false
        self.showMap = false
        
        self.menuViewModel = MenuViewModel()
        self.createGameMenuViewModel = CreateGameMenuViewModel()
        
        self.mapViewModel = MapScrollContentViewModel()
        
        // connect delegates
        self.menuViewModel.delegate = self
        self.createGameMenuViewModel.delegate = self
    }
}

extension GameViewModel: MenuViewModelDelegate {
    
    func newGameStarted() {
        
        self.showMenu = false
        self.showNewGameMenu = true
    }
}

extension GameViewModel: CreateGameMenuViewModelDelegate {
    
    func started() {
        
    }
    
    func canceled() {
        self.showMenu = true
        self.showNewGameMenu = false
    }
}
