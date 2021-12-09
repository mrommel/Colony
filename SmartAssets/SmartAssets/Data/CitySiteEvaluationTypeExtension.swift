//
//  CitySiteEvaluationTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.12.21.
//

import SmartAILibrary

extension CitySiteEvaluationType {

    public func legendColor() -> TypeColor {

        switch self {

        case .freshWater: return Globals.Colors.freshWater
        case .coastalWater: return Globals.Colors.coastalWater
        case .noWater: return Globals.Colors.noWater
        case .tooCloseToAnotherCity: return Globals.Colors.tooCloseToAnotherCity
        case .invalidTerrain: return Globals.Colors.invalidTerrain
        }
    }

    public func legendText() -> String {

        switch self {

        case .freshWater: return "Fresh Water +3 [Housing]"
        case .coastalWater: return "Coastal Water +3 [Housing]"
        case .noWater: return "No Water"
        case .tooCloseToAnotherCity: return "Too close to\nanother city"
        case .invalidTerrain: return "Invalid Terrain"
        }
    }
}
