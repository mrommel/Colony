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
    case interimRanking
}

enum ScreenType {
    
    case none
}

protocol UserInterfaceProtocol: class {
    
    func isDiplomaticScreenActive() -> Bool
    func isPopupShown() -> Bool
    
    func showPopup(popupType: PopupType)
    func showScreen(screenType: ScreenType)
}
