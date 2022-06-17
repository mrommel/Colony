//
//  CombatPromotionViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.09.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class CombatPromotionViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    private let promotionType: UnitPromotionType

    init(promotion: UnitPromotionType) {

        self.promotionType = promotion
    }

    func icon() -> NSImage {

        return ImageCache.shared.image(for: self.promotionType.iconTexture())
    }

    func toolTip() -> NSAttributedString {

        let labelTokenizer = LabelTokenizer()
        let toolTipText = NSMutableAttributedString(string: "")

        let title = NSAttributedString(
            string: self.promotionType.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        toolTipText.append(NSAttributedString(string: "\n"))

        let effects = labelTokenizer.convert(
            text: self.promotionType.effect().localized(),
            with: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        return toolTipText
    }
}

extension CombatPromotionViewModel: Hashable {

    static func == (lhs: CombatPromotionViewModel, rhs: CombatPromotionViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
