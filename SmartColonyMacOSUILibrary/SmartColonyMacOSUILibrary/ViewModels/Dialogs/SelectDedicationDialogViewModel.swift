//
//  SelectDedicationDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.01.22.
//

import SwiftUI
import SmartAILibrary

class SelectDedicationDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var summaryText: String

    @Published
    var dedicationsText: String

    @Published
    var dedicationViewModels: [DedicationViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_DEDICATION".localized()
        self.summaryText = "TXT_KEY_MAKE_DEDICATION".localizedWithFormat(with: [EraType.ancient.title().localized()])
        self.dedicationViewModels = []
        self.dedicationsText = ""
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        let currentEra = humanPlayer.currentEra()
        let nextAge = humanPlayer.estimateNextAge(in: gameModel)

        self.summaryText = "TXT_KEY_MAKE_DEDICATION".localizedWithFormat(with: [currentEra.title().localized()])

        self.dedicationViewModels = currentEra.dedications()
            .map { DedicationViewModel(dedication: $0, goldenAge: nextAge == .golden || nextAge == .heroic) }

        self.dedicationsText = nextAge.earnedText().localized()
    }
}

extension SelectDedicationDialogViewModel: BaseDialogViewModel {

    // when confirm is clicked
    func closeDialog() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        let nextAge = humanPlayer.estimateNextAge(in: gameModel)
        let numDedicationsSelectable: Int = nextAge.numDedicationsSelectable()
        let selectedDedicationViewModels = self.dedicationViewModels.filter({ $0.selected })

        if selectedDedicationViewModels.count == numDedicationsSelectable {

            let dedications: [DedicationType] = selectedDedicationViewModels.map { $0.dedication }
            humanPlayer.select(dedications: dedications)

            self.delegate?.closeDialog()
        } else {
            print("wrong number of dedications: \(selectedDedicationViewModels.count) selected / \(numDedicationsSelectable) needed")
        }
    }
}
