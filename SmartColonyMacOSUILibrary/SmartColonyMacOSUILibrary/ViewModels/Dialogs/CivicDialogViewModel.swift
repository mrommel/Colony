//
//  CivicDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

class CivicDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var civicViewModels: [CivicViewModel] = []
    
    weak var delegate: GameViewModelDelegate?
    
    init(game: GameModel? = nil) {
        
        self.update(game: game)
    }
    
    func update(game: GameModel? = nil) {
        
        var gameRef: GameModel? = game
        
        if gameRef == nil {
            gameRef = self.gameEnvironment.game.value
        }
        
        self.rebuildCivics(for: gameRef)
    }
    
    private func rebuildCivics(for game: GameModel?) {
        
        guard let civics = game?.humanPlayer()?.civics else {
            return
        }
        
        self.civicViewModels = []
        
        let possibleCivics: [CivicType] = civics.possibleCivics()
        
        for y in 0..<7 {
            for x in 0..<8 {

                if let civicType = CivicType.all.first(where: { $0.indexPath() == IndexPath(item: x, section: y) }) {
                    
                    var state: CivicTypeState = .disabled
                    var turns: Int = -1
                    
                    if civics.currentCivic() == civicType {
                        state = .selected
                        turns = civics.currentCultureTurnsRemaining()
                    } else if civics.has(civic: civicType) {
                        state = .researched
                    } else if possibleCivics.contains(civicType) {
                        state = .possible
                    }
                    
                    let civicViewModel = CivicViewModel(civicType: civicType, state: state, boosted: civics.eurekaTriggered(for: civicType), turns: turns)
                    civicViewModel.delegate = self
                    
                    self.civicViewModels.append(civicViewModel)
                } else {
                    self.civicViewModels.append(CivicViewModel(civicType: .none, state: .disabled, boosted: false, turns: -1))
                }
            }
        }
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}

extension CivicDialogViewModel: CivicViewModelDelegate {
    
    func selected(civic: CivicType) {
        
        let game = self.gameEnvironment.game.value
        
        guard let civics = game?.humanPlayer()?.civics else {
            fatalError("cant get civics")
        }
        
        let nothingSelected = civics.currentCivic() == nil
        
        do {
            try civics.setCurrent(civic: civic, in: game)
        
            self.rebuildCivics(for: game)
        } catch {
            print("cant select: \(civic)")
        }
        
        // close dialog, when user has selected a civic
        if nothingSelected {
            self.delegate?.closeDialog()
        }
    }
}
