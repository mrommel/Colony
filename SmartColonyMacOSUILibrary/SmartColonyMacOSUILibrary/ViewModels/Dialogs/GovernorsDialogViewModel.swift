//
//  GovernorsDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI
import SmartAILibrary

class GovernorsDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var governorViewModels: [GovernorViewModel]

    weak var delegate: GameViewModelDelegate?

    // MARK: constructors

    init() {

        self.governorViewModels = []
    }

    // MARK: public methods

    func update() {

        self.updateGovernors()
    }

    // MARK: private methods

    private func updateGovernors() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let governors = gameModel.humanPlayer()?.governors else {
            fatalError("cant get governors")
        }

        var tmpGovernorViewModels: [GovernorViewModel] = []

        for governorType in GovernorType.all {

            if let governor = governors.governor(with: governorType) {

                let governorViewModel = GovernorViewModel(governor: governor, appointed: true)
                tmpGovernorViewModels.append(governorViewModel)
            } else {
                let governor = Governor(type: governorType)
                let governorViewModel = GovernorViewModel(governor: governor, appointed: false)
                tmpGovernorViewModels.append(governorViewModel)
            }
        }

        self.governorViewModels = tmpGovernorViewModels
    }
}

extension GovernorsDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
