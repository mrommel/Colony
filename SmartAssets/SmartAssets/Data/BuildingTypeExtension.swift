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
        case .ancestralHall: return "building-ancestralHall"
        case .audienceChamber: return "building-audienceChamber"
        case .warlordsThrone: return "building-warlordsThrone"

            // medieval
        case .medievalWalls: return "building-medievalWalls"
        case .workshop: return "building-workshop"
        case .armory: return "building-armory"
        case .foreignMinistry: return "building-foreignMinistry"
        case .grandMastersChapel: return "building-grandMastersChapel"
        case .intelligenceAgency: return "building-intelligenceAgency"
        case .university: return "building-university"

            // renaissance
        case .renaissanceWalls: return "building-renaissanceWalls"
        case .shipyard: return "building-shipyard"
        case .bank: return "building-bank"
        case .artMuseum: return "building-artMuseum"
        case .archaeologicalMuseum: return "building-archaeologicalMuseum"

            // industrial
        case .aquarium: return "building-aquarium"
        case .coalPowerPlant: return "building-coalPowerPlant"
        case .factory: return "building-factory"
        case .ferrisWheel: return "building-ferrisWheel"
        case .militaryAcademy: return "building-militaryAcademy"
        case .sewer: return "building-sewer"
        case .stockExchange: return "building-stockExchange"
        case .zoo: return "building-zoo"
        }
    }
}
