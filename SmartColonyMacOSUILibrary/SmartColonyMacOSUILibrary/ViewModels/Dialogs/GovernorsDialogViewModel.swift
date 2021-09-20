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

                let assigned = governor.isAssigned()

                let governorViewModel = GovernorViewModel(governor: governor, appointed: true, assigned: assigned)
                governorViewModel.delegate = self
                tmpGovernorViewModels.append(governorViewModel)
            } else {
                let governor = Governor(type: governorType)
                let governorViewModel = GovernorViewModel(governor: governor, appointed: false, assigned: false)
                governorViewModel.delegate = self
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

extension GovernorsDialogViewModel: GovernorViewModelDelegate {

    func appoint(governor: Governor?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let governors = gameModel.humanPlayer()?.governors else {
            fatalError("cant get governors")
        }

        governors.appoint(governor: governor!.type)

        self.updateGovernors()
    }

    func viewPromotions(governor: Governor?) {

        fatalError("not implemented")
    }

    func promote(governor: Governor?) {

        guard let promotions = governor?.possiblePromotions() else {
            fatalError("cant get promotion to choose")
        }

        // select promotion
        fatalError("not implemented")
        // governor?.promote(with: <#T##GovernorTitleType#>)
    }

    func assign(governor: Governor?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        let cityRefs = gameModel.cities(of: humanPlayer)

        guard !cityRefs.isEmpty else {
            fatalError("cant get cities of human player - he is dead")
        }

        // select city
        fatalError("not implemented")
    }

    func reassign(governor: Governor?) {

        // select city
        fatalError("not implemented")
    }
}
