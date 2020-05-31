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

        cityDialog.addResultHandler(handler: { commandResult in

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

    func showDiplomaticDialog(with otherPlayer: AbstractPlayer?) {

        guard let gameModel = self.viewModel?.game else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        self.currentScreenType = .diplomatic

        let diplomaticDialog = DiplomaticDialog(for: humanPlayer, and: otherPlayer)
        diplomaticDialog.zPosition = 250

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
}

extension GameScene {

    func displayPopups() {

        if let fistPopup = self.popups.first {

            print("show popup: \(fistPopup.popupType)")

            switch fistPopup.popupType {

            case .none:
                // NOOP
                break
            case .declareWarQuestion:
                // NOOP
                break
            case .barbarianCampCleared:
                // NOOP
                break
            case .featureGivesProduction:
                // Das Entfernen der Geländeart {@1_FeatName} hat {2_Num} [ICON_PRODUCTION] für die Stadt {@3_CityName} eingebracht.
                break
            case .techDiscovered:
                if let techType = fistPopup.popupData?.tech {
                    self.showTechDiscoveredPopup(for: techType)
                } else {
                    fatalError("popup data did not provide tech")
                }
            case .civicDiscovered:
                if let civicType = fistPopup.popupData?.civic {
                    self.showCivicDiscoveredPopup(for: civicType)
                } else {
                    fatalError("popup data did not provide tech")
                }
            case .eraEntered:
                if let era = fistPopup.popupData?.era {
                    self.showEnteredEraPopup(for: era)
                } else {
                    fatalError("popup data did not provide era")
                }
            case .eurekaActivated:
                if let popupData = fistPopup.popupData {
                    if popupData.tech != .none {
                        self.showEurekaActivatedPopup(for: popupData.tech)
                    } else if popupData.civic != .none {
                        self.showEurekaActivatedPopup(for: popupData.civic)
                    }
                } else {
                    fatalError("popup data did not provide tech nor civic")
                }
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
}
