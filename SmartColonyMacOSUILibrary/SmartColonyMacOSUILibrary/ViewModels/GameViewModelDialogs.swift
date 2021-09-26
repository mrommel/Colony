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
        } else {
            fatalError("cant show government dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show change government dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show change policy dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showTreasuryDialog() {

        if self.currentScreenType == .treasury {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.treasuryDialogViewModel.update()
            self.currentScreenType = .treasury
        } else {
            fatalError("cant show treasury dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show governors dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show trade routes dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showChangeTechDialog() {

        if self.currentScreenType == .techs {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.techDialogViewModel.update()
            self.currentScreenType = .techs
        } else {
            fatalError("cant show tech dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showChangeCivicDialog() {

        if self.currentScreenType == .civics {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.civicDialogViewModel.update()
            self.currentScreenType = .civics
        } else {
            fatalError("cant show civic dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showCityNameDialog() {

        if self.currentScreenType == .cityName {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityNameDialogViewModel.update()
            self.currentScreenType = .cityName
        } else {
            fatalError("cant show city name dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showCityDialog(for city: AbstractCity?) {

        if self.currentScreenType == .city {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityDialogViewModel.update(for: city)
            self.currentScreenType = .city
        } else {
            fatalError("cant show city dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showCityChooseProductionDialog(for city: AbstractCity?) {

        if self.currentScreenType == .city {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityDialogViewModel.update(for: city)
            self.cityDialogViewModel.cityDetailViewType = .production
            self.currentScreenType = .city
        } else {
            fatalError("cant show city choose production dialog, \(self.currentScreenType) is currently shown")
        }
    }

    func showCityBuildingsDialog(for city: AbstractCity?) {

        if self.currentScreenType == .city {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.cityDialogViewModel.update(for: city)
            self.cityDialogViewModel.cityDetailViewType = .buildings
            self.currentScreenType = .city
        } else {
            fatalError("cant show city buildings dialog, \(self.currentScreenType) is currently shown")
        }
    }

}
