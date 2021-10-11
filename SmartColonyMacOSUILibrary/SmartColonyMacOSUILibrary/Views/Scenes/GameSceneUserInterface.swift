//
//  GameSceneUserInterface.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.05.21.
//

import SmartAILibrary
import SpriteKit

extension GameScene: UserInterfaceDelegate {

    func showPopup(popupType: PopupType) {

        self.viewModel?.delegate?.showPopup(popupType: popupType)
    }

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?) {

        self.viewModel?.delegate?.showScreen(screenType: screenType, city: city, other: other, data: data)
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
        self.viewModel?.delegate?.showDiplomaticDialog(with: dialogPlayer, data: data, deal: deal)
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

    func select(city: AbstractCity?) { // todo: add to interface

        self.viewModel?.selectedCity = city
    }

    func select(unit: AbstractUnit?) {

        self.mapNode?.unitLayer.showFocus(for: unit)
        self.viewModel?.selectedUnit = unit
        self.updateCommands(for: unit)
    }

    func unselect() {

        self.mapNode?.unitLayer.hideFocus()
        self.mapNode?.unitLayer.clearPathSpriteBuffer()
        self.mapNode?.unitLayer.clearAttackFocus()
        self.viewModel?.selectedCity = nil
        self.viewModel?.selectedUnit = nil
        self.viewModel?.combatUnitTarget = nil
        self.viewModel?.delegate?.selectedUnitChanged(to: nil, commands: [], in: nil)
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

    func clearAttackFocus() {

        self.mapNode?.unitLayer.clearAttackFocus()
    }

    func showAttackFocus(at point: HexPoint) {

        self.mapNode?.unitLayer.showAttackFocus(at: point)
    }

    func select(tech: TechType) {
        // print("select tect \(tech)")
    }

    func select(civic: CivicType) {
        // print("select civic \(civic)")
    }

    func askForConfirmation(title: String, question: String, confirm: String = "Yes", cancel: String = "No", completion: @escaping (Bool) -> Void) {

        self.viewModel?.delegate?.showConfirmationDialog(
            title: title,
            question: question,
            confirm: confirm,
            cancel: cancel,
            completion: completion
        )
    }

    func askForCity(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> Void) {

        self.viewModel?.delegate?.showSelectCityDialog(start: startCity, of: cities, completion: completion)
    }

    func askForSelection(title: String, items: [SelectableItem], completion: @escaping (Int) -> Void) {

        self.viewModel?.delegate?.showSelectionDialog(titled: title, items: items, completion: completion)
    }

    func show(city: AbstractCity?) {

        self.mapNode?.cityLayer.show(city: city)
    }

    func update(city: AbstractCity?) {

        self.mapNode?.cityLayer.update(city: city)
    }

    func refresh(tile: AbstractTile?) {

        guard let gameModel = self.viewModel?.game else {
            return
        }

        DispatchQueue.main.async {
            self.mapNode?.update(tile: tile)
            self.viewModel?.mapOverviewViewModel.changed(at: tile!.point)

            for unitRef in gameModel.units(at: tile!.point) {

                guard let unit = unitRef else {
                    continue
                }

                if unit.player?.isHuman() ?? true {
                    continue
                }

                self.mapNode?.unitLayer.show(unit: unit)
            }
        }
    }

    func showTooltip(at point: HexPoint, text: String, delay: Double) {

        self.mapNode?.tooltipLayer.show(text: text, at: point, for: delay)
    }

    func focus(on location: HexPoint) {
        print("todo: focus(on)")
    }
}
