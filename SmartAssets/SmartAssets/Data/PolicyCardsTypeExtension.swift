//
//  PolicyCardsTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.05.21.
//

import SmartAILibrary

extension PolicyCardType {

    public func toolTip() -> NSAttributedString {

        let toolTopText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name(),
            attributes: [
                NSAttributedString.Key.font: Globals.Fonts.tooltipTitleFont,
                NSAttributedString.Key.foregroundColor: Globals.Colors.tooltipTitleColor
            ]
        )
        toolTopText.append(title)

        let effects = NSAttributedString(
            string: "\n\n" + self.bonus(),
            attributes: [
                NSAttributedString.Key.font: Globals.Fonts.tooltipContentFont,
                NSAttributedString.Key.foregroundColor: Globals.Colors.tooltipContentColor
            ]
        )
        toolTopText.append(effects)

        return toolTopText
    }

    public func iconTexture() -> String {

        if self == .slot {
            return "policyCard-slot"
        }

        switch self.slot() {

        case .military: return "policyCard-military"
        case .economic: return "policyCard-economic"
        case .diplomatic: return "policyCard-diplomatic"
        case .wildcard: return "policyCard-wildcard"
        }
    }
}

extension PolicyCardSlotType {

    public func iconTexture() -> String {

        switch self {

        case .military: return "policyCard-military"
        case .economic: return "policyCard-economic"
        case .diplomatic: return "policyCard-diplomatic"
        case .wildcard: return "policyCard-wildcard"
        }
    }
}
