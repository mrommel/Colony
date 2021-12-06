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
}
