//
//  DiplomaticDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI
import SmartAILibrary

class DiplomaticDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    weak var delegate: GameViewModelDelegate?
    
    init() {
        
    }
    
    func update(for humanPlayer: AbstractPlayer?, and otherPlayer: AbstractPlayer?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType, in gameModel: GameModel?) {
        
        
    }
    
    func add(deal: DiplomaticDeal) {

        // self.deal = deal
        
        // self.presenter?.show(deal: deal)
    }
}
