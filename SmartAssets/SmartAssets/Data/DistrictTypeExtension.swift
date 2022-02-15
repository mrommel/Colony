//
//  DistrictTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension DistrictType {

    public func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let tokenizer = LabelTokenizer()
        let effectsText = self.effects().reduce("\n\n", { $0 + $1.localized() + "\n" })
        let effects = tokenizer.convert(text: effectsText, with: Globals.Attributs.tooltipContentAttributs)

        toolTipText.append(effects)

        return toolTipText
    }

    public func iconTexture() -> String {

        switch self {

        case .none: return "district-cityCenter"

        case .cityCenter: return "districtType-cityCenter"
        case .campus: return "districtType-campus"
        case .theatherSquare: return "districtType-theatherSquare"
        case .holySite: return "districtType-holySite"
        case .encampment: return "districtType-encampment"
        case .harbor: return "districtType-harbor"
        case .commercialHub: return "districtType-commercialHub"
        case .industrialZone: return "districtType-industrial"
        // preserve
        case .entertainmentComplex: return "districtType-entertainment"
        // waterPark
        case .aqueduct: return "districtType-aqueduct"
        case .neighborhood: return "districtType-neighborhood"
        // canal
        // dam
        // areodrome
        case .spaceport: return "districtType-spaceport"
        case .governmentPlaza: return "districtType-governmentPlaza"
        }
    }

    public func textureName() -> String {

        switch self {

        case .none: return "district-cityCenter"

        case .cityCenter: return "district-cityCenter"
        case .campus: return "district-campus"
        case .theatherSquare: return "district-theatherSquare"
        case .holySite: return "district-holySite"
        case .encampment: return "district-encampment"
        case .harbor: return "district-harbor"
        case .commercialHub: return "district-commercialHub"
        case .industrialZone: return "district-industrial"
        // preserve
        case .entertainmentComplex: return "district-entertainment"
        // waterPark
        case .aqueduct: return "district-aqueduct"
        case .neighborhood: return "district-neighborhood"
        // canal
        // dam
        // areodrome
        case .spaceport: return "district-spaceport"
        case .governmentPlaza: return "district-governmentPlaza"
        }
    }

    public func buildingTextureName() -> String {

        switch self {

        case .none: return "district-building-cityCenter"

        case .cityCenter: return "district-building-cityCenter"
        case .campus: return "district-building-campus"
        case .theatherSquare: return "district-building-theatherSquare"
        case .holySite: return "district-building-holySite"
        case .encampment: return "district-building-encampment"
        case .harbor: return "district-building-harbor"
        case .commercialHub: return "district-building-commercialHub"
        case .industrialZone: return "district-building-industrial"
        // preserve
        case .entertainmentComplex: return "district-building-entertainment"
        // waterPark
        case .aqueduct: return "district-building-aqueduct"
        case .neighborhood: return "district-building-neighborhood"
        // canal
        // dam
        // areodrome
        case .spaceport: return "district-building-spaceport"
        case .governmentPlaza: return "district-building-governmentPlaza"
        }
    }
}
