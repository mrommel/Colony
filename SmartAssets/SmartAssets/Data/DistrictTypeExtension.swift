//
//  DistrictTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension DistrictType {

    public func iconTexture() -> String {

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
}
