//
//  GameSceneDialogs.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension GameScene {

    func showCityDialog(for city: AbstractCity?) {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        self.currentScreenType = .city
        self.prepareForCityScreen()

        let cityDialog = CityDialog(for: city, in: gameModel)
        cityDialog.zPosition = 250

        cityDialog.addResultHandler(handler: { _ in

            self.restoreFromCityScreen()
            cityDialog.close()
            self.currentScreenType = .none
        })

        cityDialog.addCancelAction(handler: {
            self.restoreFromCityScreen()
            cityDialog.close()
            self.currentScreenType = .none
        })

        self.cameraNode.add(dialog: cityDialog)
    }

    func showTechDialog() {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        self.currentScreenType = .techs

        let techDialog = TechDialog(with: humanPlayer.techs)
        techDialog.zPosition = 250

        techDialog.addCancelAction(handler: {
            techDialog.close()
            self.currentScreenType = .none
        })

        techDialog.addResultHandler(handler: { result in
            do {
                try humanPlayer.techs?.setCurrent(tech: result.toTech(), in: gameModel)
                techDialog.close()
                self.currentScreenType = .none
            } catch {
                print("cant select tech \(error)")
            }
        })

        self.cameraNode.add(dialog: techDialog)
    }

    func showCivicDialog() {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        self.currentScreenType = .civics

        let civicDialog = CivicDialog(with: humanPlayer.civics)
        civicDialog.zPosition = 250

        civicDialog.addCancelAction(handler: {
            civicDialog.close()
            self.currentScreenType = .none
        })

        civicDialog.addResultHandler(handler: { result in

            do {
                try humanPlayer.civics?.setCurrent(civic: result.toCivic(), in: gameModel)
                civicDialog.close()
                self.currentScreenType = .none
            } catch {
                print("cant select tech \(error)")
            }
        })

        self.cameraNode.add(dialog: civicDialog)
    }

    func showInterimRankingDialog() {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        self.currentScreenType = .interimRanking

        let interimRankingDialog = InterimRankingDialog(for: humanPlayer, with: gameModel.rankingData)
        interimRankingDialog.zPosition = 250

        interimRankingDialog.addOkayAction(handler: {
            interimRankingDialog.close()
            self.currentScreenType = .none
        })

        self.cameraNode.add(dialog: interimRankingDialog)
    }

    func showDiplomaticDialog(with otherPlayer: AbstractPlayer?, data: DiplomaticData?, deal: DiplomaticDeal?) {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard let data = data else {
            fatalError("cant get data")
        }

        self.currentScreenType = .diplomatic

        let viewModel = DiplomaticDialogViewModel(
            for: humanPlayer,
            and: otherPlayer,
            state: data.state,
            message: data.message,
            emotion: data.emotion,
            in: self.viewModel?.game
        )

        let diplomaticDialog = DiplomaticDialog(viewModel: viewModel)
        diplomaticDialog.zPosition = 250

        if let deal = deal {
            viewModel.add(deal: deal)
        }

        diplomaticDialog.addOkayAction(handler: {
            diplomaticDialog.close()
            self.currentScreenType = .none
        })

        self.cameraNode.add(dialog: diplomaticDialog)
    }

    func showTreasuryDialog() {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        self.currentScreenType = .treasury

        let treasuryViewModel = TreasuryDialogViewModel(treasury: humanPlayer.treasury, in: gameModel)

        let treasuryDialog = TreasuryDialog(with: treasuryViewModel)
        treasuryDialog.zPosition = 250

        treasuryDialog.addOkayAction(handler: {
            treasuryDialog.close()
            self.currentScreenType = .none
        })

        self.cameraNode.add(dialog: treasuryDialog)
    }

    func showGovernmentDialog() {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        self.currentScreenType = .government

        let governmentViewModel = GovernmentDialogViewModel(government: humanPlayer.government, in: gameModel)

        let governmentDialog = GovernmentDialog(with: governmentViewModel)
        governmentDialog.zPosition = 250

        governmentDialog.addResultHandler { result in

            governmentDialog.close()
            self.currentScreenType = .none

            if result == .changeGovernment {
                self.showChangeGovernmentDialog()
            } else if result == .changePolicies {
                self.showChangePoliciesDialog()
            } else {
                print("unhandled: \(result)")
            }
        }

        governmentDialog.addOkayAction(handler: {
            governmentDialog.close()
            self.currentScreenType = .none
        })

        self.cameraNode.add(dialog: governmentDialog)
    }

    func showChangeGovernmentDialog() {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let government = humanPlayer.government else {
            fatalError("cant get human gov")
        }

        self.currentScreenType = .changeGovernment

        let changeGovernmentViewModel = ChangeGovernmentDialogViewModel(government: government)

        let changeGovernmentDialog = ChangeGovernmentDialog(with: changeGovernmentViewModel)
        changeGovernmentDialog.zPosition = 250

        changeGovernmentDialog.addOkayAction(handler: {
            changeGovernmentDialog.close()
            self.currentScreenType = .none

            if let choosenGovernmentType = changeGovernmentViewModel.choosenGovernmentType {

                if choosenGovernmentType != government.currentGovernment() {
                    print("new choosenGovernmentType: \(choosenGovernmentType)")
                    gameModel.humanPlayer()?.government?.set(governmentType: choosenGovernmentType)
                }
            }

            self.showGovernmentDialog()
        })

        self.cameraNode.add(dialog: changeGovernmentDialog)
    }

    func showChangePoliciesDialog() {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let government = humanPlayer.government else {
            fatalError("cant get human gov")
        }

        self.currentScreenType = .changePolicies

        let changePoliciesViewModel = ChangePoliciesDialogViewModel(government: government)

        let changePoliciesDialog = ChangePoliciesDialog(with: changePoliciesViewModel)
        changePoliciesDialog.zPosition = 250

        changePoliciesDialog.addOkayAction(handler: {
            changePoliciesDialog.close()
            self.currentScreenType = .none

            self.showGovernmentDialog()
        })

        self.cameraNode.add(dialog: changePoliciesDialog)
    }

    func showMenuDialog() {

        self.currentScreenType = .menu

        let gameMenuDialog = GameMenuDialog()
        gameMenuDialog.zPosition = 250

        gameMenuDialog.addCancelAction(handler: {
            gameMenuDialog.close()
            self.currentScreenType = .none
        })

        gameMenuDialog.addResultHandler(handler: { result in

            gameMenuDialog.close()
            self.currentScreenType = .none

            if result == .gameQuickSave {
                self.handleGameQuickSave()
            } else if result == .gameSave {
                self.handleGameSave()
            } else if result == .gameLoad {
                self.handleGameLoad()
            } else if result == .gameRetire {
                self.handleGameRetire()
            } else if result == .gameRestart {
                self.handleGameRestart()
            } else if result == .gameExit {
                self.handleGameExit()
            } else {
                fatalError("unhandled result of GameMenuDialog: \(result)")
            }
        })

        self.cameraNode.add(dialog: gameMenuDialog)
    }

    func showSelectPromotionDialog(for unit: AbstractUnit?) {

        self.currentScreenType = .selectPromotion

        let selectPromotionViewModel = SelectPromotionDialogViewModel(for: unit)

        let selectPromotionDialog = SelectPromotionDialog(with: selectPromotionViewModel)
        selectPromotionDialog.zPosition = 250

        selectPromotionDialog.addResultHandler(handler: { result in

            if let selectedPromotion = result.toPromotionType() {
                unit?.doPromote(with: selectedPromotion)

                selectPromotionDialog.close()
                self.currentScreenType = .none
            }
        })

        selectPromotionDialog.addOkayAction(handler: {
            selectPromotionDialog.close()
            self.currentScreenType = .none
        })

        self.cameraNode.add(dialog: selectPromotionDialog)
    }

    func showDisbandDialog(for unit: AbstractUnit?, completion: @escaping (Bool) -> Void) {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        self.currentScreenType = .disbandConfirm

        let confirmDialogViewModel = ConfirmationDialogViewModel(
            question: NSMutableAttributedString()
                .normal("Do you really want to disband this ")
                .bold(unit.name())
                .normal("?")
        )

        let confirmDialog = ConfirmationDialog(with: confirmDialogViewModel)
        confirmDialog.zPosition = 250

        confirmDialog.addOkayAction(handler: {
            confirmDialog.close()
            self.currentScreenType = .none
            completion(true)
        })

        confirmDialog.addCancelAction(handler: {
            confirmDialog.close()
            self.currentScreenType = .none
            completion(false)
        })

        self.cameraNode.add(dialog: confirmDialog)
    }

    func showSelectCityDialog(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping (AbstractCity?) -> Void) {

        self.currentScreenType = .selectTradeCity

        let selectTradeCityDialogViewModel = SelectTradeCityDialogViewModel(start: startCity, cities: cities)

        let selectTradeCityDialog = SelectTradeCityDialog(with: selectTradeCityDialogViewModel)
        selectTradeCityDialog.zPosition = 250

        selectTradeCityDialog.addCityResultHandler(handler: { city in
            selectTradeCityDialog.close()
            self.currentScreenType = .none
            completion(city)
        })

        selectTradeCityDialog.addCancelAction(handler: {
            selectTradeCityDialog.close()
            self.currentScreenType = .none
            completion(nil)
        })

        self.cameraNode.add(dialog: selectTradeCityDialog)
    }
}

extension GameScene {

    func displayPopups() {

        if let firstPopup = self.popups.first {

            print("show popup: \(firstPopup.popupType)")

            switch firstPopup.popupType {

            case .none:
                // NOOP
                break
            case .declareWarQuestion:
                // NOOP
                break
            case .barbarianCampCleared:
                // NOOP
                break

            case .techDiscovered:
                if let techType = firstPopup.popupData?.tech {
                    self.showTechDiscoveredPopup(for: techType)
                } else {
                    fatalError("popup data did not provide tech")
                }

            case .civicDiscovered:
                if let civicType = firstPopup.popupData?.civic {
                    self.showCivicDiscoveredPopup(for: civicType)
                } else {
                    fatalError("popup data did not provide tech")
                }

            case .eraEntered:
                if let era = firstPopup.popupData?.era {
                    self.showEnteredEraPopup(for: era)
                } else {
                    fatalError("popup data did not provide era")
                }

            case .eurekaActivated:
                if let popupData = firstPopup.popupData {
                    if popupData.tech != .none {
                        self.showEurekaActivatedPopup(for: popupData.tech)
                    } else if popupData.civic != .none {
                        self.showEurekaActivatedPopup(for: popupData.civic)
                    }
                } else {
                    fatalError("popup data did not provide tech nor civic")
                }

            case .goodyHutReward:
                if let goodyType = firstPopup.popupData?.goodyType {
                    let cityName = firstPopup.popupData?.cityName
                    self.showGoodyHutRewardPopup(for: goodyType, in: cityName)
                } else {
                    fatalError("popup data did not provide goodyType")
                }

            case .unitTrained:
                // NOOP
                break

            case .buildingBuilt:
                // NOOP
                break

            }

            self.popups.removeFirst()
            return
        }
    }

    func showEnteredEraPopup(for eraType: EraType) {

        self.currentPopupType = .eraEntered

        let enteredEraPopupViewModel = EnteredEraPopupViewModel(eraType: eraType)

        let enteredEraPopup = EnteredEraPopup(viewModel: enteredEraPopupViewModel)
        enteredEraPopup.zPosition = 250

        enteredEraPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            enteredEraPopup.close()
        })

        self.cameraNode.add(dialog: enteredEraPopup)
    }

    func showTechDiscoveredPopup(for techType: TechType) {

        self.currentPopupType = .techDiscovered

        let techDiscoveredPopupViewModel = TechDiscoveredPopupViewModel(techType: techType)

        let techDiscoveredPopup = TechDiscoveredPopup(viewModel: techDiscoveredPopupViewModel)
        techDiscoveredPopup.zPosition = 250

        techDiscoveredPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            techDiscoveredPopup.close()
        })

        self.cameraNode.add(dialog: techDiscoveredPopup)
    }

    func showCivicDiscoveredPopup(for civicType: CivicType) {

        self.currentPopupType = .civicDiscovered

        let civicDiscoveredPopupPopupViewModel = CivicDiscoveredPopupViewModel(civicType: civicType)

        let civicDiscoveredPopupPopup = CivicDiscoveredPopup(viewModel: civicDiscoveredPopupPopupViewModel)
        civicDiscoveredPopupPopup.zPosition = 250

        civicDiscoveredPopupPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            civicDiscoveredPopupPopup.close()
        })

        self.cameraNode.add(dialog: civicDiscoveredPopupPopup)
    }

    func showEurekaActivatedPopup(for techType: TechType) {

        self.currentPopupType = .eurekaActivated

        let eurekaActivatedPopupViewModel = EurekaActivatedPopupViewModel(techType: techType)

        let eurekaActivatedPopup = EurekaActivatedPopup(viewModel: eurekaActivatedPopupViewModel)
        eurekaActivatedPopup.zPosition = 250

        eurekaActivatedPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            eurekaActivatedPopup.close()
        })

        self.cameraNode.add(dialog: eurekaActivatedPopup)
    }

    func showEurekaActivatedPopup(for civicType: CivicType) {

        self.currentPopupType = .eurekaActivated

        let eurekaActivatedPopupViewModel = EurekaActivatedPopupViewModel(civicType: civicType)

        let eurekaActivatedPopup = EurekaActivatedPopup(viewModel: eurekaActivatedPopupViewModel)
        eurekaActivatedPopup.zPosition = 250

        eurekaActivatedPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            eurekaActivatedPopup.close()
        })

        self.cameraNode.add(dialog: eurekaActivatedPopup)
    }

    func showGoodyHutRewardPopup(for goodyType: GoodyType, in cityName: String?) {

        self.currentPopupType = .goodyHutReward

        let goodyHutRewardPopupViewModel = GoodyHutRewardPopupViewModel(goodyType: goodyType, in: cityName)

        let goodyHutRewardPopup = GoodyHutRewardPopup(viewModel: goodyHutRewardPopupViewModel)
        goodyHutRewardPopup.zPosition = 250

        goodyHutRewardPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            goodyHutRewardPopup.close()
        })

        self.cameraNode.add(dialog: goodyHutRewardPopup)
    }
}
