//
//  GovernorAbilityViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.09.21.
//

import SwiftUI
import SmartAssets

class GovernorAbilityViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var text: String

    @Published
    var enabled: Bool

    init(text: String, enabled: Bool) {

        self.text = text
        self.enabled = enabled
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: "promotion-default")
    }
}

extension GovernorAbilityViewModel: Hashable {

    static func == (lhs: GovernorAbilityViewModel, rhs: GovernorAbilityViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
