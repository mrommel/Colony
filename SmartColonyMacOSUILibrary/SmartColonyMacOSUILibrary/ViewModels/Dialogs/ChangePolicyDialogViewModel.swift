//
//  ChangePolicyDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ChangePolicyDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    var selectedPolicyCards: [PolicyCardType] = []
    var possiblePolicyCards: [PolicyCardType] = []

    var choosenPolicyCardSet: AbstractPolicyCardSet = PolicyCardSet(cards: [])
    var slots: PolicyCardSlots = PolicyCardSlots(military: 0, economic: 0, diplomatic: 0, wildcard: 0)

    @Published
    var policyCardViewModels: [PolicyCardViewModel] = []

    @Published
    var hintText: String = "-"

    weak var delegate: GameViewModelDelegate?

    init() {

        self.update()
    }

    func update() {

        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            return
        }

        self.choosenPolicyCardSet = government.policyCardSet()
        self.slots = government.policyCardSlots()

        self.selectedPolicyCards = government.policyCardSet().cards()
        self.possiblePolicyCards = government.possiblePolicyCards()

        self.policyCardViewModels = PolicyCardType.all.map { policyCardType in

            var state: PolicyCardState = PolicyCardState.disabled

            if government.policyCardSet().cards().contains(policyCardType) {
                state = .selected
            } else if government.possiblePolicyCards().contains(policyCardType) {
                state = .active
            }

            let policyCardViewModel = PolicyCardViewModel(policyCardType: policyCardType, state: state)
            policyCardViewModel.delegate = self

            return policyCardViewModel
        }
    }

    func governmentName() -> String {

        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            fatalError("cant get government")
        }

        return government.currentGovernment()?.name() ?? "-"
    }

    func hint() -> String {

        return self.hintText
    }

    func policyCardSlotTypeText(of policyCardSlotType: PolicyCardSlotType) -> String {

        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            fatalError("cant get government")
        }

        let selected = self.choosenPolicyCardSet.cardsFilled(in: policyCardSlotType, of: self.slots).count
        let slots = government.policyCardSlots().numberOfSlots(in: policyCardSlotType)

        return "\(selected) / \(slots)"
    }

    func policyCardSlotTypeImage(of policyCardSlotType: PolicyCardSlotType) -> NSImage {

        return ImageCache.shared.image(for: policyCardSlotType.iconTexture())
    }

    func verify() -> Bool {

        return self.choosenPolicyCardSet.filled(in: self.slots)
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }

    func closeAndSaveDialog() {

        if !self.verify() {

            self.hintText = "The combination is not valid."
            return
        }

        self.hintText = ""
        self.delegate?.closeDialog()
    }
}

extension ChangePolicyDialogViewModel: PolicyCardViewModelDelegate {

    func updateSelection() {

        guard let government = self.gameEnvironment.game.value?.humanPlayer()?.government else {
            fatalError("cant get government")
        }

        self.choosenPolicyCardSet = government.policyCardSet()

        for policyCardViewModel in self.policyCardViewModels {

            if policyCardViewModel.selected {

                if !self.choosenPolicyCardSet.has(card: policyCardViewModel.policyCardType) {
                    self.choosenPolicyCardSet.add(card: policyCardViewModel.policyCardType)
                }
            } else {

                if self.choosenPolicyCardSet.has(card: policyCardViewModel.policyCardType) {
                    self.choosenPolicyCardSet.remove(card: policyCardViewModel.policyCardType)
                }
            }
        }

        self.selectedPolicyCards = self.choosenPolicyCardSet.cards()

        // hack to update policy dialog view model
        self.hintText = "update" + UUID().uuidString
        self.hintText = ""
    }
}
