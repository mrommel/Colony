//
//  GovernorAbilityViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.09.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

class GovernorAbilityViewModel: ObservableObject {

    let id: UUID = UUID()

    @Published
    var text: String

    @Published
    var enabled: Bool

    private let governorTitle: GovernorTitleType

    init(governorTitle: GovernorTitleType, enabled: Bool) {

        self.governorTitle = governorTitle
        self.text = governorTitle.name().localized()
        self.enabled = enabled
    }

    func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.text,
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let tokenizer = LabelTokenizer()

        for effect in governorTitle.effects() {
            toolTipText.append(NSAttributedString(string: "\n"))
            toolTipText.append(tokenizer.convert(text: effect.localized(), with: Globals.Attributs.tooltipContentAttributs))
        }

        return toolTipText
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.governorTitle.iconTexture())
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
