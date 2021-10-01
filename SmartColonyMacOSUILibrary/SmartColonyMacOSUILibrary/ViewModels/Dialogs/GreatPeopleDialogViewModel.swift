//
//  GreatPeopleDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 01.10.21.
//

import SwiftUI
import SmartAILibrary

class GreatPeopleDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var greatPersonViewModels: [GreatPersonViewModel]

    weak var delegate: GameViewModelDelegate?

    // MARK: constructors

    init() {

        self.greatPersonViewModels = []
    }

    // MARK: public methods

    func update() {

        self.updateGreatPeople()
    }

    // MARK: private methods

    private func updateGreatPeople() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let greatPeople = gameModel.humanPlayer()?.greatPeople else {
            fatalError("cant get greatPeople")
        }

        var tmpGovernorViewModels: [GreatPersonViewModel] = []

        for greatPeopleType in GreatPersonType.all {

            //let playerPoints = greatPeople.value(for: greatPeopleType)
            guard let greatPerson = gameModel.greatPerson(of: greatPeopleType) else {
                fatalError("cant get great person of \(greatPeopleType)")
            }

            let viewModel = GreatPersonViewModel(greatPerson: greatPerson)

            tmpGovernorViewModels.append(viewModel)
        }

        /*for governorType in GovernorType.all {

            if let governor = governors.governor(with: governorType) {

                let assigned: Bool = governor.isAssigned()
                let assignedCity: String = governor.assignedCity(in: gameModel)?.name ?? "-"

                let governorViewModel = GovernorViewModel(
                    governor: governor,
                    appointed: true,
                    assigned: assigned,
                    assignedCity: assignedCity,
                    hasTitles: self.availableTitles > 0
                )
                governorViewModel.delegate = self
                tmpGovernorViewModels.append(governorViewModel)
            } else {
                let governor = Governor(type: governorType)
                let governorViewModel = GovernorViewModel(
                    governor: governor,
                    appointed: false,
                    assigned: false,
                    assignedCity: "",
                    hasTitles: self.availableTitles > 0
                )
                governorViewModel.delegate = self
                tmpGovernorViewModels.append(governorViewModel)
            }
        }*/

        self.greatPersonViewModels = tmpGovernorViewModels
    }
}

extension GreatPeopleDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
