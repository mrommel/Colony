//
//  PolicyCardsTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.05.21.
//

import SmartAILibrary

extension PolicyCardType {

    public func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let effects = NSAttributedString(
            string: "\n\n" + self.bonus().localized(),
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        return toolTipText
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
