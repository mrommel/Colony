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

        self.title = "Dedication"
        self.summaryText = "Make your dedication for the XXX era"
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

        self.summaryText = "Make your dedication for the \(currentEra.title()) era"

        self.dedicationViewModels = DedicationType.all
            .filter { $0.eras().contains(currentEra) }
            .map { DedicationViewModel(dedication: $0, goldenAge: nextAge == .golden) }

        if nextAge == .heroic {
            self.dedicationsText = "Because you earned a Heroic Age, you may make three Dedication."
        } else {
            self.dedicationsText = "Because you earned a \(nextAge.name()) Age, you may make one Dedication."
        }
    }
}

extension SelectDedicationDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        let nextAge = humanPlayer.estimateNextAge(in: gameModel)
        let numDedicationsSelectable = nextAge.numDedicationsSelectable()

        fatalError("need to save dedication")
        self.delegate?.closeDialog()
    }
}
