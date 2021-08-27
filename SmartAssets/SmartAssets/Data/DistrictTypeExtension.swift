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

        case .cityCenter: return "district-cityCenter"
        case .campus: return "district-campus"
        case .holySite: return "district-holySite"
        case .encampment: return "district-encampment"
        case .harbor: return "district-harbor"
        case .entertainment: return "district-entertainment"
        case .commercialHub: return "district-commercialHub"
        case .industrial: return "district-industrial"
        }
    }
}
