//
//  CombatModifierViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.09.21.
//

import SwiftUI
import SmartAILibrary

class CombatModifierViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    @Published
    var value: Int

    @Published
    var text: String

    init(modifier: CombatModifier) {

        self.value = modifier.value
        self.text = modifier.title.localized()
    }
}

extension CombatModifierViewModel: Hashable {

    static func == (lhs: CombatModifierViewModel, rhs: CombatModifierViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.text)
        hasher.combine(self.value)
        // hasher.combine(self.id)
    }
}
