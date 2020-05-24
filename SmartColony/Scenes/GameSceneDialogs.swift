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
                break
            case .civicDiscovered:
                break
            case .eraEntered:
                break
            case .eurekaActivated:
                if let techType = fistPopup.popupData?.tech {
                    self.showEurekaActivatedPopup(for: techType)
                } else if let civicType = fistPopup.popupData?.civic {
                    self.showEurekaActivatedPopup(for: civicType)
                } else {
                    fatalError("popup data did not provide tech nor civic")
                }
            }
            
            self.popups.removeFirst()
            return
        }
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
