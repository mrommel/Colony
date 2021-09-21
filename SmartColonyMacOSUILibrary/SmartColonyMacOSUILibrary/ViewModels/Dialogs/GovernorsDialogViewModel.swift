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

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let promotions = governor?.possiblePromotions() else {
            fatalError("cant get promotion to choose")
        }

        // build promotions
        let items: [SelectableItem] = promotions.map { governorTitleType in
            SelectableItem(
                iconTexture: "promotion-default",
                title: governorTitleType.name(),
                subtitle: governorTitleType.effects().joined(separator: "\n")
            )
        }

        // select promotion
        gameModel.userInterface?.askForSelection(title: "Select promotion", items: items, completion: { selectedIndex in
            print("selected \(selectedIndex)")
            let selectedPromotion = promotions[selectedIndex]

            governor?.promote(with: selectedPromotion)
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
                title: cityRef?.name ?? "city"
            )
        }

        // select city
        gameModel.userInterface?.askForSelection(title: "Select City", items: items, completion: { selectedIndex in
            print("selected \(selectedIndex)")
            let selectedCity = cityRefs[selectedIndex]

            governor?.assign(to: selectedCity)
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
                title: cityRef?.name ?? "city"
            )
        }

        // select city
        gameModel.userInterface?.askForSelection(title: "Select City", items: items, completion: { selectedIndex in
            print("selected \(selectedIndex)")
            let selectedCity = cityRefs[selectedIndex]

            governor?.unassign()
            governor?.assign(to: selectedCity)
            self.updateGovernors()
        })
    }
}
