//
//  GameScrollContentViewModelExtended.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 24.03.21.
//

import SmartMacOSUILibrary
import SmartAILibrary

class GameScrollContentViewModelExtended: GameScrollContentViewModel {
    
    override func gameChanged() {
        
        self.game?.userInterface = self
    }
}

extension GameScrollContentViewModelExtended: UserInterfaceDelegate {
    
    func showPopup(popupType: PopupType, with data: PopupData?) {
        
    }
    
    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?) {
        
    }
    
    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {
        
    }
    
    func isShown(screen: ScreenType) -> Bool {
        
        return false
    }
    
    func add(notification: NotificationItem) {
        
    }
    
    func remove(notification: NotificationItem) {
        
    }
    
    func select(unit: AbstractUnit?) {
        
    }
    
    func unselect() {
        
    }
    
    func show(unit: AbstractUnit?) {
        
    }
    
    func hide(unit: AbstractUnit?) {
        
    }
    
    func refresh(unit: AbstractUnit?) {
        
    }
    
    func move(unit: AbstractUnit?, on points: [HexPoint]) {
        
    }
    
    func animate(unit: AbstractUnit?, animation: UnitAnimationType) {
        
    }
    
    func select(tech: TechType) {
        
    }
    
    func select(civic: CivicType) {
        
    }
    
    func askToDisband(unit: AbstractUnit?, completion: @escaping (Bool) -> ()) {
        
    }
    
    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> ()) {
        
    }
    
    func show(city: AbstractCity?) {
        
    }
    
    func update(city: AbstractCity?) {
        
    }
    
    func refresh(tile: AbstractTile?) {
        
    }
    
    func showTooltip(at point: HexPoint, text: String, delay: Double) {
        
    }
    
    func focus(on location: HexPoint) {
        
    }
}
