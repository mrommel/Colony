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
    var governorAbilityViewModels: [GovernorAbilityViewModel] = []

    @Published
    var appointed: Bool

    @Published
    var assigned: Bool

    weak var delegate: GovernorViewModelDelegate?

    private var governor: Governor?

    init(governor: Governor, appointed: Bool, assigned: Bool) {

        self.governor = governor

        self.portraitTexture = governor.type.portraitTexture()
        self.name = governor.type.name()
        self.title = governor.type.title()

        self.appointed = appointed
        self.assigned = assigned

        self.governorAbilityViewModels.append(GovernorAbilityViewModel(text: governor.type.defaultTitle().name()))
        self.governorAbilityViewModels.append(GovernorAbilityViewModel(text: governor.type.titles()[0].name()))
        self.governorAbilityViewModels.append(GovernorAbilityViewModel(text: governor.type.titles()[1].name()))
        self.governorAbilityViewModels.append(GovernorAbilityViewModel(text: governor.type.titles()[2].name()))
        self.governorAbilityViewModels.append(GovernorAbilityViewModel(text: governor.type.titles()[3].name()))
        self.governorAbilityViewModels.append(GovernorAbilityViewModel(text: governor.type.titles()[4].name()))
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
