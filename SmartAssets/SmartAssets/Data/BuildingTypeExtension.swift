//
//  BuildingTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension BuildingType {

    public func toolTip() -> NSAttributedString {

        let toolTopText = NSMutableAttributedString()

        let title = NSAttributedString(string: self.name(), attributes: [NSAttributedString.Key.font: Globals.Fonts.tooltipTitleFont])
        toolTopText.append(title)

        let effects = NSAttributedString(string: self.effects().reduce("\n\n", { $0 + $1 + "\n" }))
        toolTopText.append(effects)

        return toolTopText
    }

    public func iconTexture() -> String {

        switch self {

        case .none: return "building-default"

            // ancient
        case .palace: return "building-palace"
        case .granary: return "building-granary"
        case .monument: return "building-monument"
        case .library: return "building-library"
        case .shrine: return "building-shrine"
        case .ancientWalls: return "building-ancientWalls"
        case .barracks: return "building-barracks"
        case .waterMill: return "building-waterMill"

            // classical
        case .amphitheater: return "building-amphitheater"
        case .lighthouse: return "building-lighthouse"
        case .stable: return "building-stable"
        case .arena: return "building-default" // <===
        case .market: return "building-market"
        case .temple: return "building-temple"

            // medieval
        case .medievalWalls: return "building-default" // <===
        case .workshop: return "building-default" // <===

            // renaissance
        case .renaissanceWalls: return "building-default" // <===
        case .shipyard: return "building-default" // <===

            //
        }
    }
}
