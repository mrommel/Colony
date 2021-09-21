//
//  GovernorViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol GovernorViewModelDelegate: AnyObject {

    func appoint(governor: Governor?)
    func viewPromotions(governor: Governor?)
    func promote(governor: Governor?)
    func assign(governor: Governor?)
    func reassign(governor: Governor?)
}

class GovernorViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var portraitTexture: String

    @Published
    var name: String

    @Published
    var title: String

    @Published
    var loyalty: String

    @Published
    var assignmentTime: String

    @Published
    var governorAbilityViewModels: [GovernorAbilityViewModel] = []

    @Published
    var appointed: Bool

    @Published
    var assigned: Bool

    @Published
    var assignedCity: String

    weak var delegate: GovernorViewModelDelegate?

    private var governor: Governor?

    init(governor: Governor, appointed: Bool, assigned: Bool, assignedCity: String) {

        self.governor = governor

        self.portraitTexture = governor.type.portraitTexture()
        self.name = governor.type.name()
        self.title = governor.type.title()

        self.loyalty = "8"
        self.assignmentTime = "\(governor.type.turnsToEstablish())"

        self.appointed = appointed
        self.assigned = assigned
        self.assignedCity = assignedCity

        let defaultGovernorAbilityViewModel = GovernorAbilityViewModel(
            text: governor.type.defaultTitle().name(),
            enabled: true
        )
        self.governorAbilityViewModels.append(defaultGovernorAbilityViewModel)

        for titleItem in governor.type.titles() {

            let governorAbilityViewModel = GovernorAbilityViewModel(
                text: titleItem.name(),
                enabled: governor.has(title: titleItem)
            )
            self.governorAbilityViewModels.append(governorAbilityViewModel)
        }
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.portraitTexture)
    }

    func clickedAppoint() {

        self.delegate?.appoint(governor: self.governor)
    }

    func clickedAssign() {

        self.delegate?.assign(governor: self.governor)
    }

    func clickedReassign() {

        self.delegate?.reassign(governor: self.governor)
    }

    func clickedPromote() {

        self.delegate?.promote(governor: self.governor)
    }

    func clickedViewPromotions() {

        self.delegate?.viewPromotions(governor: self.governor)
    }
}

extension GovernorViewModel: Hashable {

    static func == (lhs: GovernorViewModel, rhs: GovernorViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
