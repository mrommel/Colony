//
//  UserInterface.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PopupType {
    
    case none
    
    case declareWarQuestion
}

class PopupData {
    
    let player: AbstractPlayer?
    
    init(player: AbstractPlayer?) {
        
        self.player = player
    }
}

enum ScreenType {
    
    case none // map
    
    case interimRanking
    case diplomatic
    case city
}

protocol UserInterfaceProtocol: class {
    
    func isDiplomaticScreenActive() -> Bool
    func isPopupShown() -> Bool
    
    func showPopup(popupType: PopupType, data: PopupData?)
    func showScreen(screenType: ScreenType)
    func showMessage(message: AbstractGameMessage)
}
