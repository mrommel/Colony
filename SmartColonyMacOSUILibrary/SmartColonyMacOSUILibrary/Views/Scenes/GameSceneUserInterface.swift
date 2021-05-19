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

        self.viewModel?.delegate?.showPopup(popupType: popupType, with: data)
    }
    
    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?) {
        
        self.viewModel?.delegate?.showScreen(screenType: screenType, city: city, other: other, data: data)
    }
    
    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {
        print("todo: showLeaderMessage")
    }
    
    func isShown(screen: ScreenType) -> Bool {
        
        return self.viewModel?.delegate?.isShown(screen: screen) ?? false
    }
    
    func add(notification: NotificationItem) {
        
        self.viewModel?.delegate?.add(notification: notification)
    }
    
    func remove(notification: NotificationItem) {
        
        self.viewModel?.delegate?.remove(notification: notification)
    }
    
    func select(unit: AbstractUnit?) {
        
        self.mapNode?.unitLayer.showFocus(for: unit)
        self.viewModel?.selectedUnit = unit
        self.updateCommands(for: unit)
    }
    
    func unselect() {
        
        self.mapNode?.unitLayer.hideFocus()
        self.viewModel?.selectedUnit = nil
        self.viewModel?.selectedUnitChanged(commands: [], in: nil)
    }
    
    func show(unit: AbstractUnit?) {
        
        // unit gets visible again
        DispatchQueue.main.async() {
            self.mapNode?.unitLayer.show(unit: unit)
        }
    }
    
    func hide(unit: AbstractUnit?) {
        
        // unit gets hidden
        DispatchQueue.main.async() {
            self.mapNode?.unitLayer.hide(unit: unit)
            self.unselect()
        }
    }
    
    func refresh(unit: AbstractUnit?) {
        
        if unit?.activityType() == .hold || unit?.activityType() == .sleep {
            self.animate(unit: unit, animation: .fortify)
        }
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
        
        if animation == .fortify {
            self.mapNode?.unitLayer.fortify(unit: unit)
        } else {
            print("cant show unknown animation: \(animation)")
        }
    }
    
    func select(tech: TechType) {
        print("select tect \(tech)")
    }
    
    func select(civic: CivicType) {
        print("select civic \(civic)")
    }
    
    func askToDisband(unit: AbstractUnit?, completion: @escaping (Bool) -> ()) {
        print("todo: askToDisband(???)")
    }
    
    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> ()) {
        print("todo: askForCity(???)")
    }
    
    func show(city: AbstractCity?) {
        
        self.mapNode?.cityLayer.show(city: city)
    }
    
    func update(city: AbstractCity?) {
        
        self.mapNode?.cityLayer.update(city: city)
    }
    
    func refresh(tile: AbstractTile?) {
        
        DispatchQueue.main.async() {
            self.mapNode?.update(tile: tile)
            // self.bottomRightBar?.update(tile: tile)
        }
    }
    
    func showTooltip(at point: HexPoint, text: String, delay: Double) {
        print("todo: showTooltip()")
    }
    
    func focus(on location: HexPoint) {
        print("todo: focus(on)")
    }
}
