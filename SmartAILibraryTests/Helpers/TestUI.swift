//
//  TestUI.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 21.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

@testable import SmartAILibrary

class TestUI: UserInterfaceProtocol {
    
    func isDiplomaticScreenActive() -> Bool {
        return false
    }
    
    func isPopupShown() -> Bool {
        return false
    }
    
    func showPopup(popupType: PopupType, data: PopupData?) {
        
    }
    
    func showScreen(screenType: ScreenType) {
        
    }
    
    func showMessage(message: AbstractGameMessage) {
        
    }
}
