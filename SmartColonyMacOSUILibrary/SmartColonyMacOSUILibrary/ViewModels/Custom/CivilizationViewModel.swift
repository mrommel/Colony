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
    var toolTip: NSMutableAttributedString

    private let civilization: CivilizationType

    init(civilization: CivilizationType) {

        self.civilization = civilization

        let tooltipText = NSMutableAttributedString()

        let leaderName = NSAttributedString(
            string: civilization.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        tooltipText.append(leaderName)

        self.toolTip = tooltipText
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.civilization.iconTexture())
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
