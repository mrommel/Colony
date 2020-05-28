//
//  GameSceneUserInterface.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

extension GameScene: UserInterfaceProtocol {
    
    func showPopup(popupType: PopupType, with data: PopupData?) {
        
        self.popups.append(GameScenePopupData(popupType: popupType, popupData: data))
    }

    func select(unit: AbstractUnit?) {

        self.mapNode?.unitLayer.showFocus(for: unit)
        self.selectedUnit = unit

        if let commands = unit?.commands(in: self.viewModel?.game) {
            self.bottomLeftBar?.selectedUnitChanged(to: unit, commands: commands)
        }
    }

    func unselect() {

        self.mapNode?.unitLayer.hideFocus()
        self.bottomLeftBar?.selectedUnitChanged(to: nil, commands: [])
        self.selectedUnit = nil
    }

    func showScreen(screenType: ScreenType, city: AbstractCity? = nil, other otherPlayer: AbstractPlayer? = nil) {

        switch screenType {
            
        
            
        case .interimRanking:
            self.showInterimRankingDialog()
        case .diplomatic:
            self.showDiplomaticDialog(with: otherPlayer)
        case .city:
            self.showCityDialog(for: city)
        case .techs:
            self.showTechDialog()
        case .civics:
            self.showCivicDialog()
        case .treasury:
            self.showTreasuryDialog()
        case .menu:
            self.showMenuDialog()
        default:
            print("screen: \(screenType) not handled")
        }
    }
    
    func isShown(screen screenType: ScreenType) -> Bool {
        
        return self.currentScreenType == screenType
    }

    func show(unit: AbstractUnit?) {

        // unit gets visible again
        self.mapNode?.unitLayer.show(unit: unit)
    }

    func hide(unit: AbstractUnit?) {

        // unit gets hidden
        DispatchQueue.main.async() {
            self.mapNode?.unitLayer.hide(unit: unit)
            self.unselect()
        }
    }

    func move(unit: AbstractUnit?, on points: [HexPoint]) {
        print("move")
        let costs: [Double] = [Double].init(repeating: 0.0, count: points.count)
        self.mapNode?.unitLayer.move(unit: unit, on: HexPath(points: points, costs: costs))
    }

    func show(city: AbstractCity?) {

        self.mapNode?.cityLayer.show(city: city)
    }
    
    func update(city: AbstractCity?) {
        
        self.mapNode?.cityLayer.update(city: city)
    }

    func showTooltip(at point: HexPoint, text: String, delay: Double) {
        print("tooltip")
    }

    func select(tech: TechType) {
        
        self.scienceProgressNode?.update(tech: tech, progress: 0, turnsRemaining: 0)
    }
    
    func select(civic: CivicType) {
        
        self.cultureProgressNode?.update(civic: civic, progress: 0, turnsRemaining: 0)
    }
    
    func add(notification: NotificationItem) {

        self.notificationsNode?.add(notification: notification)
    }

    func remove(notification: NotificationItem) {

        self.notificationsNode?.remove(notification: notification)
    }

    func refresh(tile: AbstractTile?) {
        
        DispatchQueue.main.async() {
            self.mapNode?.update(tile: tile)
            self.bottomRightBar?.update(tile: tile)
        }
    }
}
