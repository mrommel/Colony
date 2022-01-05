//
//  DedicationViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.01.22.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class DedicationViewModel: ObservableObject, Identifiable {

    public let id: UUID = UUID()

    @Published
    var title: String

    @Published
    var summary: String

    @Published
    var selected: Bool

    let dedication: DedicationType

    init(dedication: DedicationType, goldenAge: Bool) {

        self.dedication = dedication

        self.title = dedication.name().localized()
        self.summary = dedication.normalEffect().localized()
        self.selected = false
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.dedication.iconTexture())
    }
}

extension DedicationViewModel: Hashable {

    public static func == (lhs: DedicationViewModel, rhs: DedicationViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
