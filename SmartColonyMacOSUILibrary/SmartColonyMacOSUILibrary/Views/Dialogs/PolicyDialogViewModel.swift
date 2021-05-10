//
//  PolicyDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.05.21.
//

import SwiftUI
import SmartAILibrary

class PolicyDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    var selectedPolicyCards: [PolicyCardType] = []
    var possiblePolicyCards: [PolicyCardType] = []
    
    var choosenPolicyCardSet: AbstractPolicyCardSet = PolicyCardSet(cards: [])
    var slots: PolicyCardSlots = PolicyCardSlots(military: 0, economic: 0, diplomatic: 0, wildcard: 0)
    
    weak var delegate: GameViewModelDelegate?
    
    init() {
        
        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            fatalError("cant get government")
        }
        
        self.choosenPolicyCardSet = government.policyCardSet()
        self.slots = government.policyCardSlots()
        
        self.selectedPolicyCards = government.policyCardSet().cards()
        self.possiblePolicyCards = government.possiblePolicyCards()
    }
    
    func state(of policyCardType: PolicyCardType) -> PolicyCardState {
        
        var state: PolicyCardState = PolicyCardState.disabled
        
        if self.selectedPolicyCards.contains(policyCardType) {
            state = .selected
        } else if self.possiblePolicyCards.contains(policyCardType) {
            state = .active
        }
        
        return state
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
