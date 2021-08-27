//
//  GameSceneUserInterface.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

extension GameScene: UserInterfaceDelegate {

    func showPopup(popupType: PopupType, with data: PopupData?) {

        self.popups.append(GameScenePopupData(popupType: popupType, popupData: data))
    }

    func select(unit: AbstractUnit?) {

        self.mapNode?.unitLayer.showFocus(for: unit)
        self.selectedUnit = unit

        self.updateCommands(for: selectedUnit)
    }

    func unselect() {

        self.mapNode?.unitLayer.hideFocus()
        self.bottomLeftBar?.selectedUnitChanged(to: nil, commands: [], in: nil)
        self.selectedUnit = nil
    }

    func showScreen(screenType: ScreenType, city: AbstractCity? = nil, other otherPlayer: AbstractPlayer? = nil, data: DiplomaticData? = nil) {

        switch screenType {

        case .interimRanking:
            self.showInterimRankingDialog()
        case .diplomatic:
            self.showDiplomaticDialog(with: otherPlayer, data: data, deal: nil)
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
        case .government:
            self.showGovernmentDialog()
        case .selectPromotion:

            guard let humanPlayer = self.viewModel?.game?.humanPlayer() else {
                fatalError("cant get human player")
            }

            if let promotableUnit = humanPlayer.firstPromotableUnit(in: self.viewModel?.game) {

                self.handleUnitPromotion(at: promotableUnit.location)
            }
        default:
            print("screen: \(screenType) not handled")
        }
    }

    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        let dialogPlayer = humanPlayer.isEqual(to: fromPlayer) ? toPlayer : fromPlayer

        print("showLeaderMessage:")
        print("state=\(state), message=\(message)")
        print("deal=\(String(describing: deal))")
        let data = DiplomaticData(state: state, message: message, emotion: emotion)
        self.showDiplomaticDialog(with: dialogPlayer, data: data, deal: deal)
    }

    func isShown(screen screenType: ScreenType) -> Bool {

        return self.currentScreenType == screenType
    }

    func show(unit: AbstractUnit?) {

        // unit gets visible again
        DispatchQueue.main.async {
            self.mapNode?.unitLayer.show(unit: unit)
        }
    }

    func hide(unit: AbstractUnit?) {

        // unit gets hidden
        DispatchQueue.main.async {
            self.mapNode?.unitLayer.hide(unit: unit)
            self.unselect()
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

    func refresh(unit: AbstractUnit?) {

        /*if let refreshUnit = unit {
            print("refresh unit: \(refreshUnit.type) at \(refreshUnit.location)")
        }*/

        if unit?.activityType() == .hold || unit?.activityType() == .sleep {
            self.animate(unit: unit, animation: .fortify)
        }
    }

    func show(city: AbstractCity?) {

        self.mapNode?.cityLayer.show(city: city)
    }

    func update(city: AbstractCity?) {

        self.mapNode?.cityLayer.update(city: city)
    }

    func showTooltip(at point: HexPoint, text: String, delay: Double) {

        self.mapNode?.tooltipLayer.show(text: text, at: point, for: delay)
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

    func askToDisband(unit: AbstractUnit?, completion: @escaping (Bool) -> Void) {

        self.showDisbandDialog(for: unit, completion: completion)
    }

    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> Void) {

        self.showSelectCityDialog(start: startCity, of: cities, completion: completion)
    }

    func refresh(tile: AbstractTile?) {

        DispatchQueue.main.async {
            self.mapNode?.update(tile: tile)
            self.bottomRightBar?.update(tile: tile)
        }
    }
}
