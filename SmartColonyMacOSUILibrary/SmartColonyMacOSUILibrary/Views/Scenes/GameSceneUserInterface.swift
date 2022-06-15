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

    func update(gameState: GameStateType) {

        self.viewModel?.delegate?.update(gameState: gameState)
    }

    func update(activePlayer: AbstractPlayer?) {

        guard let gameModel = self.viewModel?.gameModel else {
            fatalError("cant get game")
        }

        let maximum: Int = gameModel.players.count
        let current: Int = gameModel.players.firstIndex(where: { $0.isEqual(to: activePlayer) }) ?? 0

        self.viewModel?.delegate?.updateTurnProgress(current: current, maximum: maximum)
    }

    func showPopup(popupType: PopupType) {

        self.viewModel?.delegate?.showPopup(popupType: popupType)
    }

    func showScreen(screenType: ScreenType, city: AbstractCity?, other: AbstractPlayer?, data: DiplomaticData?) {

        self.viewModel?.delegate?.showScreen(screenType: screenType, city: city, other: other, data: data)
    }

    func showLeaderMessage(from fromPlayer: AbstractPlayer?, to toPlayer: AbstractPlayer?, deal: DiplomaticDeal?, state: DiplomaticRequestState, message: DiplomaticRequestMessage, emotion: LeaderEmotionType) {

        guard let gameModel = self.viewModel?.gameModel else {
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
            self.mapNode?.unitLayer.hideAttackFocus()
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

        switch animation {

        case .fortify:
            DispatchQueue.main.async {
                self.mapNode?.unitLayer.fortify(unit: unit)
            }

        case .attack(let from, let to):
            DispatchQueue.main.async {
                self.mapNode?.unitLayer.attack(unit: unit, from: from, towards: to)
            }

        case .rangeAttack(let from, let to):
            DispatchQueue.main.async {
                self.mapNode?.unitLayer.rangeAttack(unit: unit, from: from, towards: to)
            }

        default:
            print("cant show unknown animation: \(animation)")
        }
    }

    func animate(city: AbstractCity?, animation: CityAnimationType) {

        switch animation {

        case .rangeAttack(_, let to):
            DispatchQueue.main.async {
                self.mapNode?.cityLayer.rangeAttackUnit(at: to, by: city)
            }

        default:
            print("cant show unknown animation: \(animation)")
        }
    }

    func clearAttackFocus() {

        DispatchQueue.main.async {
            self.mapNode?.unitLayer.hideAttackFocus()
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

    func update(city cityRef: AbstractCity?) {

        DispatchQueue.main.async {
            self.mapNode?.cityLayer.update(city: cityRef)

            guard let cityCitizens = cityRef?.cityCitizens else {
                fatalError("cant get city citizens")
            }

            guard let gameModel = self.viewModel?.gameModel else {
                fatalError("cant get game")
            }

            for point in cityCitizens.workingTileLocations() {

                guard let tile = gameModel.tile(at: point) else {
                    continue
                }

                self.refresh(tile: tile)
            }
        }
    }

    func remove(city: AbstractCity?) {

        DispatchQueue.main.async {
            self.mapNode?.cityLayer.remove(city: city)
            self.mapNode?.boardLayer.rebuild()
        }
    }

    func refresh(tile: AbstractTile?) {

        guard let gameModel = self.viewModel?.gameModel else {
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

        guard let gameModel = self.viewModel?.gameModel else {
            return
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            return
        }

        var text: String?
        var toolTipType: TooltipNodeType = .yellow

        switch type {

        case .tileInfo(tile: let tile):
            guard tile.isDiscovered(by: humanPlayer) else {
                return
            }

            var tmpText = "\(tile.terrain().name().localized())"

            if let workingCity = tile.workingCity() {
                let civilization: CivilizationType = workingCity.leader.civilization()
                tmpText += "\nOwner: \(civilization.name().localized()) (\(workingCity.name.localized()))"
            }

            if tile.hasAnyFeature() {
                tmpText += "\n\(tile.feature().name().localized())"
            }

            if tile.hasAnyResource(for: humanPlayer) {
                let resource: ResourceType = tile.resource(for: humanPlayer)
                tmpText += "\n\(resource.name().localized())"
            }

            if tile.isRiver() {
                tmpText += "\nRiver"
            }

            if tile.isVisible(to: humanPlayer) && tile.hasAnyImprovement() {
                let improvement: ImprovementType = tile.improvement()
                tmpText += "\n\(improvement.name().localized())"
            }

            // Movement Cost
            // Defense Modifier

            if humanPlayer.isEqual(to: tile.owner()) {

                let appealLevel: AppealLevel = tile.appealLevel(in: gameModel)
                let appealValue: Int = tile.appeal(in: gameModel)
                tmpText += "\n\(appealLevel.name().localized()) (\(appealValue))"
            }

            if let continent = gameModel.continent(at: tile.point) {
                tmpText += "\nContinent: \(continent.type().name().localized())"
            }

            if humanPlayer.isEqual(to: tile.owner()) {
                tmpText += "\n-----------"
                let yields = tile.yields(for: humanPlayer, ignoreFeature: false)
                if yields.food > 0.0 {
                    tmpText += "\n\(yields.food) [Food] Food"
                }

                if yields.production > 0.0 {
                    tmpText += "\n\(yields.production) [Production] Production"
                }

                if yields.gold > 0.0 {
                    tmpText += "\n\(yields.gold) [Gold] Gold"
                }
            }

            toolTipType = .blue
            text = tmpText

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
            text = String(format: "TXT_KEY_MISC_YOU_UNIT_DIED_ATTACKING".localized(), attackerName.localized(), defenderName.localized(), defenderDamage)

        case .enemyUnitDiedAttacking(
            attackerName: let attackerName,
            attackerPlayer: let attackerPlayer,
            defenderName: let defenderName,
            defenderDamage: let defenderDamage):

            let attackerPlayerName: String = attackerPlayer?.leader.name() ?? "Unknown"
            text = String(format: "TXT_KEY_MISC_YOU_KILLED_ENEMY_UNIT".localized(), attackerName.localized(), attackerPlayerName.localized(), defenderName.localized(), defenderDamage)

        case .unitDestroyedEnemyUnit(
            attackerName: let attackerName,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName):

            text = String(format: "TXT_KEY_MISC_YOU_UNIT_DESTROYED_ENEMY".localized(), attackerName.localized(), attackerDamage, defenderName.localized())

        case .unitDiedDefending(
            attackerName: let attackerName,
            attackerPlayer: let attackerPlayer,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName):

            let attackerPlayerName: String = attackerPlayer?.leader.name() ?? "Unknown"
            text = String(format: "TXT_KEY_MISC_YOU_UNIT_WAS_DESTROYED".localized(), attackerName.localized(), attackerPlayerName.localized(), attackerDamage, defenderName.localized())

        case .unitAttackingWithdraw(
            attackerName: let attackerName,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName,
            defenderDamage: let defenderDamage):

            text = String(format: "TXT_KEY_MISC_YOU_UNIT_WITHDRAW".localized(), attackerName.localized(), attackerDamage, defenderName.localized(), defenderDamage)

        case .enemyAttackingWithdraw(
            attackerName: let attackerName,
            attackerDamage: let attackerDamage,
            defenderName: let defenderName,
            defenderDamage: let defenderDamage):

            text = String(format: "TXT_KEY_MISC_ENEMY_UNIT_WITHDRAW".localized(), attackerName.localized(), attackerDamage, defenderName.localized(), defenderDamage)

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
                self.mapNode?.tooltipLayer.show(text: text, at: point, type: toolTipType, for: delay)
            }
        }
    }

    func focus(on location: HexPoint) {

        self.viewModel?.focus(on: location)
    }

    func animationsAreRunning(for leader: LeaderType) -> Bool {

        guard let mapNode = self.mapNode else {
            return false
        }

        return mapNode.unitLayer.animationsAreRunning(for: leader)
    }
}
