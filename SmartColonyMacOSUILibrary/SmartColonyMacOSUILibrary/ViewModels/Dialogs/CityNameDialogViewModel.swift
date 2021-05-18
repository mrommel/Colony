//
//  CityNameDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

class CityNameDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var cityName: String = "abc"
    
    weak var delegate: GameViewModelDelegate?
    
    init() {

        self.update()
    }
    
    func update() {
        
        guard let game = self.gameEnvironment.game.value else {
            return
        }
        
        guard let humanPlayer = game.humanPlayer() else {
            fatalError("cant get human player")
        }
        
        self.cityName = humanPlayer.newCityName(in: game)
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
    
    func closeAndFoundDialog() {
        
        self.delegate?.closeDialog()
        self.delegate?.foundCity(named: self.cityName)
    }
}
