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
    var availableTitles: Int

    @Published
    var spentTitles: Int

    @Published
    var governorViewModels: [GovernorViewModel]

    weak var delegate: GameViewModelDelegate?

    // MARK: constructors

    init() {

        self.availableTitles = 0
        self.spentTitles = 0
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

        self.availableTitles = governors.numTitlesAvailable()
        self.spentTitles = governors.numTitlesSpent()

        var tmpGovernorViewModels: [GovernorViewModel] = []

        for governorType in GovernorType.all {

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

        governors.appoint(governor: governor!.type, in: gameModel)

        self.updateGovernors()
    }

    func viewPromotions(governor: Governor?) {

        fatalError("not implemented")
    }

    func promote(governor: Governor?) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let promotions = governor?.possiblePromotions() else {
            fatalError("cant get promotion to choose")
        }

        // build promotions
        let items: [SelectableItem] = promotions.map { governorTitleType in
            SelectableItem(
                iconTexture: governorTitleType.iconTexture(),
                title: governorTitleType.name(),
                subtitle: governorTitleType.effects().joined(separator: "\n")
            )
        }

        // select promotion
        gameModel.userInterface?.askForSelection(title: "Select promotion", items: items, completion: { selectedIndex in

            let selectedPromotion: GovernorTitleType = promotions[selectedIndex]

            humanPlayer.governors?.promote(governor: governor, with: selectedPromotion, in: gameModel)

            self.updateGovernors()
        })
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

        // build cities
        let items: [SelectableItem] = cityRefs.map { cityRef in
            SelectableItem(
                iconTexture: (cityRef as? City)?.iconTexture() ?? nil,
                title: cityRef?.name ?? "-"
            )
        }

        // select city
        gameModel.userInterface?.askForSelection(title: "Select City", items: items, completion: { selectedIndex in

            let selectedCity: AbstractCity? = cityRefs[selectedIndex]

            humanPlayer.governors?.assign(governor: governor, to: selectedCity, in: gameModel)

            self.updateGovernors()
        })
    }

    func reassign(governor: Governor?) {

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

        // build cities
        let items: [SelectableItem] = cityRefs.map { cityRef in
            SelectableItem(
                title: cityRef?.name ?? "-"
            )
        }

        // select city
        gameModel.userInterface?.askForSelection(title: "Select City", items: items, completion: { selectedIndex in

            let selectedCity: AbstractCity? = cityRefs[selectedIndex]

            humanPlayer.governors?.assign(governor: governor, to: selectedCity, in: gameModel)

            self.updateGovernors()
        })
    }
}
