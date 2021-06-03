//
//  EraEnteredPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary

class EraEnteredPopupViewModel: ObservableObject {
    
    @Published
    var title: String
    
    @Published
    var summaryText: String
    
    private let eraType: EraType
    
    weak var delegate: GameViewModelDelegate?
    
    init(eraType: EraType) {
        
        self.eraType = eraType
        
        self.title = "New Era"
        self.summaryText = "The XXX empire entered the \(eraType) era."
    }
    
    func closePopup() {
        
        self.delegate?.closePopup()
    }
}
