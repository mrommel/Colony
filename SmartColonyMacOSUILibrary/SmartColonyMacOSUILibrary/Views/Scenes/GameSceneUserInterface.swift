//
//  GameSceneUserInterface.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.05.21.
//

import SmartAILibrary
import SpriteKit

extension GameScene: UserInterfaceDelegate {
    
    func showPopup(popupType: PopupType, with data: PopupData?) {
        print("todo: showPopup()")
    }
    
    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?) {
        print("todo: showScreen")
    }
    
    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {
        print("todo: showLeaderMessage")
    }
    
    func isShown(screen: ScreenType) -> Bool {
        print("todo: isShown")
        return false
    }
    
    func add(notification: NotificationItem) {
        print("todo: add(notification: \(notification.message))")
    }
    
    func remove(notification: NotificationItem) {
        print("todo: remove(notification)")
    }
    
    func select(unit: AbstractUnit?) {
        
        self.mapNode?.unitLayer.showFocus(for: unit)
        self.viewModel?.selectedUnit = unit

        // TODO: self.updateCommands(for: unit)
    }
    
    func unselect() {
        
        self.mapNode?.unitLayer.hideFocus()
        //self.bottomLeftBar?.selectedUnitChanged(to: nil, commands: [], in: nil)
        self.viewModel?.selectedUnit = nil
    }
    
    func show(unit: AbstractUnit?) {
        print("todo: show(unit)")
    }
    
    func hide(unit: AbstractUnit?) {
        print("todo: hide(unit)")
    }
    
    func refresh(unit: AbstractUnit?) {
        print("todo: refresh(unit)")
    }
    
    // show non human unit moving
    func move(unit: AbstractUnit?, on points: [HexPoint]) {
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        let costs: [Double] = [Double].init(repeating: 0.0, count: points.count)
        self.mapNode?.unitLayer.move(unit: unit, on: HexPath(points: points, costs: costs))
    }
    
    func animate(unit: AbstractUnit?, animation: UnitAnimationType) {
        print("todo: animate(unit)")
    }
    
    func select(tech: TechType) {
        print("todo: select(tech)")
    }
    
    func select(civic: CivicType) {
        print("todo: select(civic)")
    }
    
    func askToDisband(unit: AbstractUnit?, completion: @escaping (Bool) -> ()) {
        print("todo: askToDisband(???)")
    }
    
    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> ()) {
        print("todo: askForCity(???)")
    }
    
    func show(city: AbstractCity?) {
        print("todo: show(city)")
    }
    
    func update(city: AbstractCity?) {
        print("todo: update(city)")
    }
    
    func refresh(tile: AbstractTile?) {
        print("todo: refresh(tile)")
    }
    
    func showTooltip(at point: HexPoint, text: String, delay: Double) {
        print("todo: showTooltip()")
    }
    
    func focus(on location: HexPoint) {
        print("todo: focus(on)")
    }
    
}
