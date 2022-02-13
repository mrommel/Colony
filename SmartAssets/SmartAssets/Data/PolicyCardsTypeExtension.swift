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

        let tokenizer = LabelTokenizer()
        let effectsText = "\n\n" + self.bonus().localized()
        let effects = tokenizer.convert(text: effectsText, with: Globals.Attributs.tooltipContentAttributs)
        toolTipText.append(effects)

        return toolTipText
    }

    public func iconTexture() -> String {

        if self == .slot {
            return "policyCard-slot"
        }

        if self.requiresDarkAge() {
            return "policyCard-darkAge"
        }

        switch self.slot() {

        case .military: return "policyCard-military"
        case .economic: return "policyCard-economic"
        case .diplomatic: return "policyCard-diplomatic"
        case .wildcard: return "policyCard-wildcard"
        case .darkAge: return "policyCard-darkAge"
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
        case .darkAge: return "policyCard-darkAge"
        }
    }
}
