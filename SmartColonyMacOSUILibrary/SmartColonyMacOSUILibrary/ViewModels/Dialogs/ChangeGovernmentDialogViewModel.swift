//
//  ChangeGovernmentDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 11.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ChangeGovernmentSectionViewModel {

    let era: EraType
    let governmentCardViewModels: [GovernmentCardViewModel]

    init(era: EraType, governmentCardViewModels: [GovernmentCardViewModel]) {

        self.era = era
        self.governmentCardViewModels = governmentCardViewModels
    }

    func title() -> String {

        return self.era.title().localized()
    }
}

extension ChangeGovernmentSectionViewModel: Hashable {

    static func == (lhs: ChangeGovernmentSectionViewModel, rhs: ChangeGovernmentSectionViewModel) -> Bool {

        return lhs.era == rhs.era
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.era)
    }
}

class ChangeGovernmentDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var governmentSectionViewModels: [ChangeGovernmentSectionViewModel] = []

    weak var delegate: GameViewModelDelegate?

    init() {

        self.update()
    }

    func select(government: GovernmentType) {

        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }

        gameModel.humanPlayer()?.government?.set(governmentType: government, in: gameModel)

        self.delegate?.closeDialog()
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension ChangeGovernmentDialogViewModel: GovernmentCardViewModelDelegate {

    func update() {

        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            return
        }

        let currentGovernmentType = government.currentGovernment()
        let possibleGovernments = government.possibleGovernments()

        let governmentCardViewModels: [GovernmentCardViewModel] = GovernmentType.all.map { governmentType in

            var state: GovernmentState = GovernmentState.disabled

            if governmentType == currentGovernmentType {
                state = .selected
            } else if possibleGovernments.contains(governmentType) {
                state = .active
            }

            let governmentCardViewModel = GovernmentCardViewModel(governmentType: governmentType, state: state)
            governmentCardViewModel.delegate = self

            return governmentCardViewModel
        }

        let governmentEras = Array(Set(GovernmentType.all.map { $0.era() })).sorted()
        self.governmentSectionViewModels = governmentEras.map { era in

            let models = governmentCardViewModels.filter { $0.governmentType.era() == era }
            return ChangeGovernmentSectionViewModel(era: era, governmentCardViewModels: models)
        }
    }
}
