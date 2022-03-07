//
//  EnvoyEffectViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 03.03.22.
//

import Foundation
import SwiftUI
import SmartAILibrary
import SmartAssets

class EnvoyEffectViewModel: ObservableObject {

    @Published
    var title: String

    @Published
    var titleColor: NSColor

    @Published
    var name: String

    private let envoyEffect: EnvoyEffect

    init(envoyEffect: EnvoyEffect) {

        self.envoyEffect = envoyEffect

        switch self.envoyEffect.level {

        case .first:
            self.title = "\(self.envoyEffect.cityState.category().name().localized()) Bonus 1:"
        case .third:
            self.title = "\(self.envoyEffect.cityState.category().name().localized()) Bonus 3:"
        case .sixth:
            self.title = "\(self.envoyEffect.cityState.category().name().localized()) Bonus 6:"
        case .suzerain:
            self.title = "Suzerain Bonuses of \(self.envoyEffect.cityState.name().localized()):"
        }

        self.titleColor = self.envoyEffect.enabled ? self.envoyEffect.cityState.color() : .gray
        self.name = self.envoyEffect.cityState.bonus(for: self.envoyEffect.level).localized()
    }

    func image() -> NSImage {

        let imageColor = self.envoyEffect.enabled ? self.envoyEffect.cityState.color() : .gray

        switch self.envoyEffect.level {

        case .first, .third, .sixth:
            return ImageCache.shared.image(for: self.envoyEffect.cityState.envoysTexture())
                .tint(with: imageColor)
        case .suzerain:
            return ImageCache.shared.image(for: self.envoyEffect.cityState.suzerainTexture())
                .tint(with: imageColor)
        }
    }
}

extension EnvoyEffectViewModel: Hashable {

    static func == (lhs: EnvoyEffectViewModel, rhs: EnvoyEffectViewModel) -> Bool {

        return lhs.envoyEffect.cityState == rhs.envoyEffect.cityState &&
            lhs.envoyEffect.level == rhs.envoyEffect.level
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.envoyEffect.cityState)
        hasher.combine(self.envoyEffect.level)
    }
}
