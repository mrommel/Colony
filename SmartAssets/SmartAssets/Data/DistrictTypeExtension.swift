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

        case .none: return "districtType-cityCenter"

        case .cityCenter: return "districtType-cityCenter"
        case .campus: return "districtType-campus"
        case .theatherSquare: return "districtType-theatherSquare"
        case .holySite: return "districtType-holySite"
        case .encampment: return "districtType-encampment"
        case .harbor: return "districtType-harbor"
        case .commercialHub: return "districtType-commercialHub"
        case .industrialZone: return "districtType-industrial"
        case .preserve: return "districtType-preserve"
        case .entertainmentComplex: return "districtType-entertainment"
        case .waterPark: return "districtType-waterPark"
        case .aqueduct: return "districtType-aqueduct"
        case .neighborhood: return "districtType-neighborhood"
        // canal
        // dam
        // areodrome
        case .spaceport: return "districtType-spaceport"
        case .governmentPlaza: return "districtType-governmentPlaza"
        }
    }

    public func iconTextureName() -> String {

        switch self {

        case .none: return "district-cityCenter-icon"

        case .cityCenter: return "district-cityCenter-icon"
        case .campus: return "district-campus-icon"
        case .theatherSquare: return "district-theatherSquare-icon"
        case .holySite: return "district-holySite-icon"
        case .encampment: return "district-encampment-icon"
        case .harbor: return "district-harbor-icon"
        case .commercialHub: return "district-commercialHub-icon"
        case .industrialZone: return "district-industrialZone-icon"
        case .preserve: return "district-preserve-icon"
        case .entertainmentComplex: return "district-entertainment-icon"
        case .waterPark: return "district-waterPark-icon"
        case .aqueduct: return "district-aqueduct-icon"
        case .neighborhood: return "district-neighborhood-icon"
        // canal
        // dam
        // areodrome
        case .spaceport: return "district-spaceport-icon"
        case .governmentPlaza: return "district-governmentPlaza-icon"
        }
    }

    public func emptyDistrictTextureName() -> String {

        switch self {

        case .none: return "district-empty"

        case .cityCenter: return "district-empty"
        case .campus: return "district-campus-empty"
        case .theatherSquare: return "district-empty"
        case .holySite: return "district-holySite-empty"
        case .encampment: return "district-encampment-empty"
        case .harbor: return "district-empty" // this will stay empty - it's on water
        case .commercialHub: return "district-commercialHub-empty"
        case .industrialZone: return "district-industrialZone-empty"
        case .preserve: return "district-empty"
        case .entertainmentComplex: return "district-empty"
        case .waterPark: return "district-empty" // this will stay empty - it's on water
        case .aqueduct: return "district-empty"
        case .neighborhood: return "district-empty"
        // canal
        // dam
        // areodrome
        case .spaceport: return "district-empty"
        case .governmentPlaza: return "district-empty"
        }
    }
}
