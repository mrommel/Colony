//
//  CivilizationViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CivilizationViewModel: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var toolTip: String

    private let civilization: CivilizationType

    init(civilization: CivilizationType) {

        self.civilization = civilization
        self.toolTip = civilization.name()
    }

    func image() -> NSImage {

        ImageCache.shared.image(for: self.civilization.iconTexture())
    }
}

extension CivilizationViewModel: Hashable {

    static func == (lhs: CivilizationViewModel, rhs: CivilizationViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
