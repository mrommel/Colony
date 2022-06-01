//
//  BuildingTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension BuildingType {

    public func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)
        toolTipText.append(NSAttributedString(string: "\n"))

        let tokenizer = LabelTokenizer()
        for effect in self.effects() {
            let effectText = tokenizer.convert(text: effect.localized(), with: Globals.Attributs.tooltipContentAttributs)
            toolTipText.append(NSAttributedString(string: "\n"))
            toolTipText.append(effectText)
        }

        return toolTipText
    }

    public func iconTexture() -> String {

        switch self {

        case .none: return "building-default"

            // ancient
        case .ancientWalls: return "building-ancientWalls"
        case .barracks: return "building-barracks"
        case .granary: return "building-granary"
        case .grove: return "building-grove"
        case .library: return "building-library"
        case .monument: return "building-monument"
        case .palace: return "building-palace"
        case .shrine: return "building-shrine"
        case .waterMill: return "building-waterMill"

            // classical
        case .amphitheater: return "building-amphitheater"
        case .lighthouse: return "building-lighthouse"
        case .stable: return "building-stable"
        case .arena: return "building-arena"
        case .market: return "building-market"
        case .temple: return "building-temple"

            // medieval
        case .medievalWalls: return "building-medievalWalls"
        case .workshop: return "building-workshop"
        case .armory: return "building-armory"

            // renaissance
        case .renaissanceWalls: return "building-renaissanceWalls"
        case .shipyard: return "building-shipyard"
        case .bank: return "building-bank"

            //
        }
    }
}
