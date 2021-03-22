//
//  MenuViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI

protocol MenuViewModelDelegate: class {
    
    func newGameStarted()
}

class MenuViewModel: ObservableObject {
    
    @Published
    var showingQuitConfirmationAlert: Bool
    
    weak var delegate: MenuViewModelDelegate?
    
    init() {
        self.showingQuitConfirmationAlert = false
    }
    
    func startNewGame() {
        
        self.delegate?.newGameStarted()
    }
}
