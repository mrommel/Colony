//
//  CitySiteEvaluationTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.12.21.
//

import SmartAILibrary

extension CitySiteEvaluationType {

    public func textureName() -> String {

        switch self {

        case .freshWater: return "settler-tile-freshWater"
        case .coastalWater: return "settler-tile-coastalWater"
        case .noWater: return "settler-tile-noWater"
        case .tooCloseToAnotherCity: return "settler-tile-tooCloseToAnotherCity"
        case .invalidTerrain: return "settler-tile-invalidTerrain"
        }
    }

    public func legendText() -> String {

        switch self {

        case .freshWater: return "Fresh Water +3 [Housing]"
        case .coastalWater: return "Coastal Water +3 [Housing]"
        case .noWater: return "No Water"
        case .tooCloseToAnotherCity: return "Too close to another city"
        case .invalidTerrain: return "Invalid Terrain"
        }
    }
}
