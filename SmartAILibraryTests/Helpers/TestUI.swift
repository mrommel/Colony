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
    
    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?) { }
    
    func update(city: AbstractCity?) { }

    func showPopup(popupType: PopupType, with data: PopupData?) { }

    func showScreen(screenType: ScreenType, city: AbstractCity?) { }
    
    func isShown(screen: ScreenType) -> Bool {
        return false
    }
    
    func add(notification: NotificationItem) {}
    func remove(notification: NotificationItem) {}
    
    func select(unit: AbstractUnit?) {}
    func unselect() {}
    
    func show(unit: AbstractUnit?) {}
    func hide(unit: AbstractUnit?) {}
    func move(unit: AbstractUnit?, on points: [HexPoint]) {}
    
    func select(tech: TechType) {}
    func select(civic: CivicType) {}
    
    func show(city: AbstractCity?) { }
    
    func refresh(tile: AbstractTile?) { }
    
    func showTooltip(at point: HexPoint, text: String, delay: Double) { }
    
    func focus(on location: HexPoint) { }
}
