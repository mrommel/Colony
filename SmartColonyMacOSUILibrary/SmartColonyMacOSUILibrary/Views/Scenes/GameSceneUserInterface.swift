//
//  GameSceneUserInterface.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.05.21.
//

import SmartAILibrary
import SpriteKit

// idea: UserInterfaceDelegate should conform GameViewModel
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

        self.viewModel?.delegate?.selectedCity = city
    }

    func select(unit: AbstractUnit?) {

        DispatchQueue.main.async {
            self.mapNode?.unitLayer.showFocus(for: unit)
            self.viewModel?.delegate?.selectedUnit = unit
            self.updateCommands(for: unit)
        }
    }

    func unselect() {

        DispatchQueue.main.async {
            self.mapNode?.unitLayer.hideFocus()
            self.mapNode?.unitLayer.clearPathSpriteBuffer()
            self.mapNode?.unitLayer.clearAttackFocus()
            self.viewModel?.delegate?.selectedCity = nil
            self.viewModel?.delegate?.selectedUnit = nil
            self.viewModel?.combatUnitTarget = nil
            self.viewModel?.delegate?.selectedUnitChanged(to: nil, commands: [], in: nil)
        }
    }

    func show(unit: AbstractUnit?, at location: HexPoint) {

        // unit gets visible again
        DispatchQueue.main.async {
            self.mapNode?.unitLayer.show(unit: unit, at: location)
        }
    }

    func hide(unit: AbstractUnit?, at location: HexPoint) {

        // unit gets hidden
        DispatchQueue.main.async {
            self.mapNode?.unitLayer.hide(unit: unit, at: location)
            self.unselect()
        }
    }

    func enterCity(unit: AbstractUnit?, at location: HexPoint) {

        // unit gets visible again
        DispatchQueue.main.async {
            self.mapNode?.unitLayer.enterCity(unit: unit, at: location)
        }
    }

    func leaveCity(unit: AbstractUnit?, at location: HexPoint) {

        // unit gets hidden
        DispatchQueue.main.async {
            self.mapNode?.unitLayer.leaveCity(unit: unit, at: location)
            self.unselect()
        }
    }

    func refresh(unit: AbstractUnit?) {

        if unit?.activityType() == .hold || unit?.activityType() == .sleep {
            DispatchQueue.main.async {
                self.animate(unit: unit, animation: .fortify)
            }
        }
    }

    // show non human unit moving
    func move(unit: AbstractUnit?, on points: [HexPoint]) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        let costs: [Double] = [Double].init(repeating: 0.0, count: points.count)
        DispatchQueue.main.async {
            self.mapNode?.unitLayer.move(unit: unit, on: HexPath(points: points, costs: costs))
        }
    }

    func animate(unit: AbstractUnit?, animation: UnitAnimationType) {

        /*if animation == .fortify {
            DispatchQueue.main.async {
                self.mapNode?.unitLayer.fortify(unit: unit)
            }
        } else {
            print("cant show unknown animation: \(animation)")
        }*/
    }

    func clearAttackFocus() {

        DispatchQueue.main.async {
            self.mapNode?.unitLayer.clearAttackFocus()
        }
    }

    func showAttackFocus(at point: HexPoint) {

        DispatchQueue.main.async {
            self.mapNode?.unitLayer.showAttackFocus(at: point)
        }
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

    func askForInput(
        title: String,
        summary: String,
        value: String,
        confirm: String,
        cancel: String,
        completion: @escaping (String) -> Void) {

        self.viewModel?.delegate?.showRenameDialog(
            title: title,
            summary: summary,
            value: value,
            confirm: confirm,
            cancel: cancel,
            completion: completion)
    }

    func show(city: AbstractCity?) {

        DispatchQueue.main.async {
            self.mapNode?.cityLayer.show(city: city)
        }
    }

    func update(city: AbstractCity?) {

        DispatchQueue.main.async {
            self.mapNode?.cityLayer.update(city: city)
        }
    }

    func remove(city: AbstractCity?) {

        DispatchQueue.main.async {
            self.mapNode?.cityLayer.remove(city: city)
            self.mapNode?.boardLayer.rebuild()
        }
    }

    func refresh(tile: AbstractTile?) {

        guard let gameModel = self.viewModel?.game else {
            return
        }

        DispatchQueue.main.async {

            self.mapNode?.update(tile: tile)
            self.viewModel?.delegate?.refreshTile(at: tile!.point)

            for unitRef in gameModel.units(at: tile!.point) {

                guard let unit = unitRef else {
                    continue
                }

                if unit.player?.isHuman() ?? true {
                    continue
                }

                self.mapNode?.unitLayer.show(unit: unit, at: unit.location)
            }
        }
    }

    func showTooltip(at point: HexPoint, type: TooltipType, delay: Double) {

        var text: String?

        switch type {

        case .barbarianCampCleared(gold: let gold):
            text = String(format: "TXT_KEY_MISC_DESTROYED_BARBARIAN_CAMP".localized(), gold)

        case .clearedFeature(feature: let feature, production: let production, cityName: let cityName):
            text = String(format: "TXT_KEY_MISC_CLEARING_FEATURE_RESOURCE".localized(), feature.name().localized(), production, cityName)

        case .capturedCity(cityName: let cityName):
            text = String(format: "TXT_KEY_MISC_CAPTURED_CITY".localized(), cityName)

        case .cultureFromKill(culture: let culture):
            text = String(format: "TXT_KEY_MISC_CULTURE_FROM_KILL".localized(), culture)

        case .goldFromKill(gold: let gold):
            text = String(format: "TXT_KEY_MISC_GOLD_FROM_KILL".localized(), gold)

        case .unitDiedAttacking(attackerName: let attackerName, defenderName: let defenderName, defenderDamage: let defenderDamage):
            text = String(format: "TXT_KEY_MISC_YOU_UNIT_DIED_ATTACKING".localized(), attackerName, defenderName, defenderDamage)

        case .enemyUnitDiedAttacking(
            attackerName: let attackerName,
            attackerPlayer: let attackerPlayer,
            defenderName: let defenderName,
            defenderDamage: let defenderDamage):

            let attackerPlayerName: String = attackerPlayer?.leader.name() ?? "Unknown"
            text = String(format: "TXT_KEY_MISC_YOU_KILLED_ENEMY_UNIT".localized(), attackerName, attackerPlayerName, defenderName, defenderDamage)

        case .unitDestroyedEnemyUnit(
            attackerName: let attackerName,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName):

            text = String(format: "TXT_KEY_MISC_YOU_UNIT_DESTROYED_ENEMY".localized(), attackerName, attackerDamage, defenderName)

        case .unitDiedDefending(
            attackerName: let attackerName,
            attackerPlayer: let attackerPlayer,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName):

            let attackerPlayerName: String = attackerPlayer?.leader.name() ?? "Unknown"
            text = String(format: "TXT_KEY_MISC_YOU_UNIT_WAS_DESTROYED".localized(), attackerName, attackerPlayerName, attackerDamage, defenderName)

        case .unitAttackingWithdraw(
            attackerName: let attackerName,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName,
            defenderDamage: let defenderDamage):

            text = String(format: "TXT_KEY_MISC_YOU_UNIT_WITHDRAW".localized(), attackerName, attackerDamage, defenderName, defenderDamage)

        case .enemyAttackingWithdraw(
            attackerName: let attackerName,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName,
            defenderDamage: let defenderDamage):

            text = String(format: "TXT_KEY_MISC_ENEMY_UNIT_WITHDRAW".localized(), attackerName, attackerDamage, defenderName, defenderDamage)

        case .conqueredEnemyCity(attackerName: let attackerName, attackerDamage: let attackerDamage, cityName: let cityName):
            text = String(format: "TXT_KEY_MISC_YOU_CONQUERED_ENEMY_CITY".localized(), attackerName, attackerDamage, cityName)

        case .cityCapturedByEnemy(
            attackerName: let attackerName,
            attackerPlayer: let attackerPlayer,
            attackerDamage: let attackerDamage,
            cityName: let cityName):

            let attackerPlayerName: String = attackerPlayer?.leader.name() ?? "Unknown"
            text = String(format: "TXT_KEY_MISC_YOU_CITY_WAS_CONQUERED".localized(), attackerName, attackerPlayerName, attackerDamage, cityName)
        }

        DispatchQueue.main.async {
            if let text = text {
                self.mapNode?.tooltipLayer.show(text: text, at: point, for: delay)
            }
        }
    }

    func focus(on location: HexPoint) {

        self.viewModel?.focus(on: location)
    }
}
