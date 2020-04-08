//
//  UserInterface.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum PopupType {
    
    case none
    
    case declareWarQuestion
    case barbarianCampCleared
}

public class PopupData {
    
    let player: AbstractPlayer?
    let money: Int
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        self.money = -1
    }
    
    init(money: Int) {
        
        self.player = nil
        self.money = money
    }
}

public enum ScreenType {
    
    case none // map
    
    case interimRanking
    case diplomatic
    case city
}

public protocol UserInterfaceProtocol: class {
    
    func isDiplomaticScreenActive() -> Bool
    func isPopupShown() -> Bool
    
    func showPopup(popupType: PopupType, data: PopupData?)
    func showScreen(screenType: ScreenType)
    func showMessage(message: AbstractGameMessage)
    
    func show(unit: AbstractUnit?) // unit gets visible
    func hide(unit: AbstractUnit?) // unit gets hidden
    func move(unit: AbstractUnit?, on points: [HexPoint])
    
    func showTooltip(at point: HexPoint, text: String, delay: Double)
}
