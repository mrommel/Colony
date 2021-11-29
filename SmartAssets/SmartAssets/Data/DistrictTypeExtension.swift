//
//  DistrictTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension DistrictType {

    public func toolTip() -> NSAttributedString {

        let toolTopText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTopText.append(title)

        let effects = NSAttributedString(
            string: self.effects().reduce("\n\n", { $0 + $1 + "\n" }),
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTopText.append(effects)

        return toolTopText
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
        case .industrial: return "districtType-industrial"
        // preserve
        case .entertainment: return "districtType-entertainment"
        // waterPark
        case .aqueduct: return "districtType-aqueduct"
        case .neighborhood: return "districtType-neighborhood"
        // canal
        // dam
        // areodrome
        case .spaceport: return "districtType-spaceport"
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
        case .industrial: return "district-industrial"
        // preserve
        case .entertainment: return "district-entertainment"
        // waterPark
        case .aqueduct: return "district-aqueduct"
        case .neighborhood: return "district-neighborhood"
        // canal
        // dam
        // areodrome
        case .spaceport: return "district-spaceport"
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
        case .industrial: return "district-building-industrial"
        // preserve
        case .entertainment: return "district-building-entertainment"
        // waterPark
        case .aqueduct: return "district-building-aqueduct"
        case .neighborhood: return "district-building-neighborhood"
        // canal
        // dam
        // areodrome
        case .spaceport: return "district-building-spaceport"
        }
    }
}
