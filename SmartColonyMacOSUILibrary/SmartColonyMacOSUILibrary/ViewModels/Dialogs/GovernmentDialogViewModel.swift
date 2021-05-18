//
//  GovernmentDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class GovernmentDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var governmentViewModel: GovernmentCardViewModel = GovernmentCardViewModel(governmentType: .chiefdom, state: .selected)
    
    @Published
    var policyCardViewModels: [PolicyCardViewModel] = []
    
    weak var delegate: GameViewModelDelegate?

    init() {
        
        self.update()
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
    
    func viewPolicies() {
        
        self.delegate?.closeDialog()
        self.delegate?.showChangePoliciesDialog()
    }
    
    func viewGovernments() {
        
        self.delegate?.closeDialog()
        self.delegate?.showChangeGovernmentDialog()
    }
}

extension GovernmentDialogViewModel: GovernmentCardViewModelDelegate {
    
    func update() {
        
        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            return
        }
        
        guard let currentGovernmentType = government.currentGovernment() else {
            fatalError("cant get current government type")
        }
        
        self.governmentViewModel = GovernmentCardViewModel(governmentType: currentGovernmentType, state: .selected)
        
        self.policyCardViewModels = government.policyCardSet().cards().map { policyCardType in
            let policyCardViewModel = PolicyCardViewModel(policyCardType: policyCardType, state: .selected)
            return policyCardViewModel
        }
    }
}
