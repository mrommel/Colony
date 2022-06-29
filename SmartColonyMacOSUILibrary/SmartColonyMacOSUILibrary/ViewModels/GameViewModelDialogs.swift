//
//  GameSceneDialogs.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SmartAILibrary

extension GameViewModel {

    func showGovernmentDialog() {

        if self.currentScreenType == .government {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.governmentDialogViewModel.update()
            self.currentScreenType = .government
        }
    }

    func showChangeGovernmentDialog() {

        if self.currentScreenType == .changeGovernment {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.changeGovernmentDialogViewModel.update()
            self.currentScreenType = .changeGovernment
        }
    }

    func showChangePoliciesDialog() {

        if self.currentScreenType == .changePolicies {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.changePolicyDialogViewModel.update()
            self.currentScreenType = .changePolicies
        }
    }

    func showGreatPeopleDialog() {

        if self.currentScreenType == .greatPeople {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.greatPeopleDialogViewModel.update()
            self.currentScreenType = .greatPeople
        }
    }

    func showGovernorsDialog() {

        if self.currentScreenType == .governors {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.governorsDialogViewModel.update()
            self.currentScreenType = .governors
        }
    }

    func showReligionDialog() {

        if self.currentScreenType == .religion {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.religionDialogViewModel.update()
            self.currentScreenType = .religion
        }
    }

    func showRankingDialog() {

        if self.currentScreenType == .ranking {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.rankingDialogViewModel.update()
            self.currentScreenType = .ranking
        }
    }

    func showVictoryDialog() {

        if self.currentScreenType == .victory {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.victoryDialogViewModel.update()
            self.currentScreenType = .victory
        }
    }

    func showTradeRouteDialog() {

        if self.currentScreenType == .tradeRoutes {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.tradeRoutesDialogViewModel.update()
            self.currentScreenType = .tradeRoutes
        }
    }

    func showTechTreeDialog() {

        if self.currentScreenType == .techTree {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.techDialogViewModel.update()
            self.currentScreenType = .techTree
        }
    }

    func showTechListDialog() {

        if self.currentScreenType == .techList {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.techDialogViewModel.update()
            self.currentScreenType = .techList
        }
    }

    func showCivicTreeDialog() {

        if self.currentScreenType == .civicTree {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.civicDialogViewModel.update()
            self.currentScreenType = .civicTree
        }
    }

    func showCivicListDialog() {

        if self.currentScreenType == .civicList {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.civicDialogViewModel.update()
            self.currentScreenType = .civicList
        }
    }

    private func showCityDialog(for city: AbstractCity?, detail: CityDetailViewType) {

        if self.currentScreenType == .city {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityDialogViewModel.update(for: city)
            self.cityDialogViewModel.show(detail: detail)
            self.currentScreenType = .city
        }
    }

    func showCityDialog(for city: AbstractCity?) {

        self.showCityDialog(for: city, detail: .production)
    }

    func showCityChooseProductionDialog(for city: AbstractCity?) {

        self.showCityDialog(for: city, detail: .production)
    }

    func showCityAquireTilesDialog(for city: AbstractCity?) {

        self.showCityDialog(for: city, detail: .citizen)
    }

    func showCityPurchaseGoldDialog(for city: AbstractCity?) {

        self.showCityDialog(for: city, detail: .goldPurchase)
    }

    func showCityPurchaseFaithDialog(for city: AbstractCity?) {

        self.showCityDialog(for: city, detail: .faithPurchase)
    }

    func showCityBuildingsDialog(for city: AbstractCity?) {

        self.showCityDialog(for: city, detail: .buildings)
    }

    func showCityStateDialog(for city: AbstractCity?) {

        if self.currentScreenType == .cityState {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityStateDialogViewModel.update(for: city)
            self.currentScreenType = .cityState
        }
    }

    func showConfirmationDialog(
        title: String,
        question: String,
        confirm: String,
        cancel: String,
        completion: @escaping (Bool) -> Void
    ) {

        if self.currentScreenType == .confirm {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.confirmationDialogViewModel.update(
                title: title,
                question: question,
                confirm: confirm,
                cancel: cancel,
                completion: completion
            )
            self.currentScreenType = .confirm
        }
    }

    func showSelectCityDialog(start startCity: AbstractCity?,
                              of cities: [AbstractCity?],
                              completion: @escaping (AbstractCity?) -> Void) {

        if self.currentScreenType == .selectTradeCity {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.selectTradeCityDialogViewModel.update(start: startCity, of: cities, completion: completion)
            self.currentScreenType = .selectTradeCity
        }
    }

    func showSelectionDialog(titled title: String,
                             items: [SelectableItem],
                             completion: @escaping (Int) -> Void) {

        if self.currentScreenType == .selectItems {
            // already shown
            return
        }

        let previousScreenType: ScreenType = self.currentScreenType

        let tmpCompletion: SelectItemsDialogViewModel.SelectItemsCompletionBlock = { selectedIndex in

            // switch back to previous screen, ...
            self.currentScreenType = previousScreenType

            // ... before calling the completion handler of that screen
            completion(selectedIndex)
        }

        if self.currentScreenType == .none || self.currentScreenType == .governors {
            self.selectItemsDialogViewModel.update(title: title, items: items, completion: tmpCompletion)
            self.currentScreenType = .selectItems
        }
    }

    func showRenameDialog(
        title: String,
        summary: String,
        value: String, // not localized
        confirm: String = "TXT_KEY_RENAME".localized(),
        cancel: String = "TXT_KEY_CANCEL".localized(),
        completion: @escaping (String) -> Void
    ) {

        if self.currentScreenType == .selectName {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.nameInputDialogViewModel.update(
                title: title,
                summary: summary,
                value: value,
                confirm: confirm,
                cancel: cancel,
                completion: completion
            )
            self.currentScreenType = .selectName
        }
    }

    func showDiplomaticDialog(with otherPlayer: AbstractPlayer?, data: DiplomaticData?, deal: DiplomaticDeal?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard let data = data else {
            fatalError("cant get data")
        }

        if self.currentScreenType == .diplomatic {
            // already shown
            return
        }

        if !humanPlayer.isTurnActive() {
            return
        }

        if self.currentScreenType == .none {
            self.diplomaticDialogViewModel.update(
                for: humanPlayer,
                and: otherPlayer,
                state: data.state,
                message: data.message,
                emotion: data.emotion
            )

            if let deal = deal {
                diplomaticDialogViewModel.add(deal: deal)
            }

            DispatchQueue.main.async {
                self.currentScreenType = .diplomatic
            }
        }
    }

    func showUnitListDialog() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.currentScreenType == .unitList {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.unitListDialogViewModel.update(for: humanPlayer)
            self.currentScreenType = .unitList
        }
    }

    func showCityListDialog() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        if self.currentScreenType == .cityList {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityListDialogViewModel.update(for: humanPlayer)
            self.currentScreenType = .cityList
        }
    }

    func showSelectPromotionDialog(for unit: AbstractUnit?) {

        if self.currentScreenType == .selectPromotion {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.selectPromotionDialogViewModel.update(for: unit)
            self.currentScreenType = .selectPromotion
        }
    }

    func showSelectPantheonDialog() {

        if self.currentScreenType == .selectPantheon {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.selectPantheonDialogViewModel.update()
            self.currentScreenType = .selectPantheon
        }
    }

    func showEraProgressDialog() {

        if self.currentScreenType == .eraProgress {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.eraProgressDialogViewModel.update()
            self.currentScreenType = .eraProgress
        }
    }

    func showSelectDedicationDialog() {

        if self.currentScreenType == .selectDedication {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.selectDedicationDialogViewModel.update()
            self.currentScreenType = .selectDedication
        }
    }

    func showMomentsDialog() {

        if self.currentScreenType == .moments {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.momentsDialogViewModel.update()
            self.currentScreenType = .moments
        }
    }

    func showCityStateDialog() {

        if self.currentScreenType == .cityStates {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityStatesDialogViewModel.update()
            self.currentScreenType = .cityStates
        }
    }

    func showRazeOrReturnCity(for city: AbstractCity?) {

        if self.currentScreenType == .razeOrReturnCity {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.razeOrReturnCityDialogViewModel.update(for: city)
            self.currentScreenType = .razeOrReturnCity
        }
    }
}
