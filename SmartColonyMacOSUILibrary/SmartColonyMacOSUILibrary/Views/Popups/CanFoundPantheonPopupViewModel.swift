//
//  CanFoundPantheonPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 15.07.21.
//

import SwiftUI
import SmartAILibrary

class CanFoundPantheonPopupViewModel: ObservableObject {
    
    @Published
    var title: String
    
    @Published
    var text: String
    
    @Published
    var foundText: String
    
    weak var delegate: GameViewModelDelegate?
    
    init() {
        
        self.title = "Enough Faith"
        self.text = "You have enough faith to found a pantheon!" // TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_PANTHEON
        self.foundText = "Found a pantheon" // TXT_KEY_NOTIFICATION_SUMMARY_ENOUGH_FAITH_FOR_PANTHEON
    }
    
    func foundPantheon() {
        
        self.delegate?.showSelectPantheonDialog()
        self.delegate?.closePopup()
    }
    
    func closePopup() {
        
        self.delegate?.closePopup()
    }
}
