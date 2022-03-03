//
//  EnvoyEffectViewModel.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 03.03.22.
//

import Foundation
import SwiftUI
import SmartAILibrary

class EnvoyEffectViewModel: ObservableObject {

    @Published
    var name: String

    private let envoyEffect: EnvoyEffect

    init(envoyEffect: EnvoyEffect) {

        self.envoyEffect = envoyEffect
        self.name = envoyEffect.cityState.bonus(for: envoyEffect.level)
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
