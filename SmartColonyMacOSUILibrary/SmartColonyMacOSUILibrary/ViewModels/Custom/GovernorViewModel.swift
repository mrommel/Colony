//
//  GovernorViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

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

    init(governor: Governor, appointed: Bool) {

        self.portraitTexture = governor.type.portraitTexture()
        self.name = governor.type.name()
        self.title = governor.type.title()

        self.appointed = appointed

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

        print("clickedAppoint()")
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
