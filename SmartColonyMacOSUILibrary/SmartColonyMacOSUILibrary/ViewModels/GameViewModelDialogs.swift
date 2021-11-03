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

    func showGreatPeopleDialog() {

        if self.currentScreenType == .greatPeople {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.greatPeopleDialogViewModel.update()
            self.currentScreenType = .greatPeople
        } else {
            fatalError("cant show great people dialog, \(self.currentScreenType) is currently shown")
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

    func showReligionDialog() {

        if self.currentScreenType == .religion {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.religionDialogViewModel.update()
            self.currentScreenType = .religion
        } else {
            fatalError("cant show religion dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show ranking dialog, \(self.currentScreenType) is currently shown")
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

    func showTechTreeDialog() {

        if self.currentScreenType == .techTree {
            // already shown
            return
        }

        if self.currentScreenType == .none {
            self.techDialogViewModel.update()
            self.currentScreenType = .techTree
        } else {
            fatalError("cant show tech tree dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show tech list dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show civic tree dialog, \(self.currentScreenType) is currently shown")
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
        } else {
            fatalError("cant show civic list dialog, \(self.currentScreenType) is currently shown")
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
