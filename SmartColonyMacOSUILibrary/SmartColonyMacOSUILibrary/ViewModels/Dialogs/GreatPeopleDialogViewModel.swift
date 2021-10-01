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

            let playerPoints = greatPeople.value(for: greatPeopleType)
            let cost = gameModel.cost(of: greatPeopleType, for: gameModel.humanPlayer())

            if let greatPerson = gameModel.greatPerson(of: greatPeopleType) {

                let viewModel = GreatPersonViewModel(
                    greatPerson: greatPerson,
                    progress: CGFloat(playerPoints),
                    cost: CGFloat(cost)
                )

                tmpGovernorViewModels.append(viewModel)
            }
        }

        self.greatPersonViewModels = tmpGovernorViewModels
    }
}

extension GreatPeopleDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
