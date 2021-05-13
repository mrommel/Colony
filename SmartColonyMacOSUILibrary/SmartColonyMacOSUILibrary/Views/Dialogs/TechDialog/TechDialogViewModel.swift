//
//  TechDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

class TechDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    //@Published
    //var governmentSectionViewModels: [GovernmentSectionViewModel] = []
    
    weak var delegate: GameViewModelDelegate?

    init(game: GameModel? = nil) {
        
        var gameRef: GameModel? = game
        
        if gameRef == nil {
            gameRef = self.gameEnvironment.game.value
        }
        
        guard let techs = gameRef?.humanPlayer()?.techs else {
            fatalError("cant get techs")
        }
        
        //techs.
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
