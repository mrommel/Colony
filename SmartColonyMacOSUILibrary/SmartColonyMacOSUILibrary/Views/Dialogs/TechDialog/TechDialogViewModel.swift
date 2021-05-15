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
    
    @Published
    var techViewModels: [TechViewModel] = []
    
    weak var delegate: GameViewModelDelegate?

    init(game: GameModel? = nil) {
        
        var gameRef: GameModel? = game
        
        if gameRef == nil {
            gameRef = self.gameEnvironment.game.value
        }
        
        guard let techs = gameRef?.humanPlayer()?.techs else {
            fatalError("cant get techs")
        }
        
        let possibleTechs = techs.possibleTechs()
        
        for y in 0..<7 {
            for x in 0..<8 {

                if let techType = TechType.all.first(where: { $0.indexPath() == IndexPath(item: x, section: y) }) {
                    
                    var state: TechTypeState = .disabled
                    var turns: Int = -1
                    
                    if techs.currentTech() == techType {
                        state = .selected
                        turns = techs.currentScienceTurnsRemaining()
                    } else if techs.has(tech: techType) {
                        state = .researched
                    } else if possibleTechs.contains(techType) {
                        state = .possible
                    }
                    
                    self.techViewModels.append(TechViewModel(techType: techType, state: state, boosted: techs.eurekaTriggered(for: techType), turns: turns))
                } else {
                    self.techViewModels.append(TechViewModel(techType: .none, state: .disabled, boosted: false, turns: -1))
                }
            }
        }
        
        /*for techType in TechType.all {
            
            var state: TechTypeState = .disabled
            
            if techs.currentTech() == techType {
                state = .selected
            } else if techs.has(tech: techType) {
                state = .researched
            } else if possibleTechs.contains(techType) {
                state = .possible
            }
            
            let techViewModel = TechViewModel(techType: techType, state: state)
            
            techViewModels.append(techViewModel)
        }*/
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
