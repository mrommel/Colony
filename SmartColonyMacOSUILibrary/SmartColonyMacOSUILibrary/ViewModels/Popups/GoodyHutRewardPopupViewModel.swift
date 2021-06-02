//
//  GoodyHutRewardPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary

class GoodyHutRewardPopupViewModel: ObservableObject {
    
    @Published
    var title: String
    
    @Published
    var text: String
    
    weak var delegate: GameViewModelDelegate?
    
    init(goodyHutType: GoodyType, location: HexPoint) {
        
        self.title = "Received Goodies"
        self.text = "Goody: \(goodyHutType)"
    }
    
    func closePopup() {
        
        self.delegate?.closePopup()
    }
}
