//
//  GovernmentDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class GovernmentDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var governmentCardViewModels: [GovernmentCardViewModel] = []
    
    weak var delegate: GameViewModelDelegate?

    init() {
        
        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            fatalError("cant get government")
        }
        
        let currentGovernmentType = government.currentGovernment()
        let possibleGovernments = government.possibleGovernments()
        
        self.governmentCardViewModels = GovernmentType.all.map { governmentType in
            
            var state: GovernmentState = GovernmentState.disabled
            
            if governmentType == currentGovernmentType {
                state = .selected
            } else if possibleGovernments.contains(governmentType) {
                state = .active
            }
            
            let governmentCardViewModel = GovernmentCardViewModel(governmentType: governmentType, state: state)
            governmentCardViewModel.delegate = self
            
            return governmentCardViewModel
        }
        
        print("created vms")
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}

extension GovernmentDialogViewModel: GovernmentCardViewModelDelegate {
    
    func update() {
    }
}
