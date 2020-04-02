//
//  Civ5Terrain.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.08.19.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension TerrainType {

    static func fromCiv5String(value: String) -> TerrainType? {

        switch value {
        case "TERRAIN_OCEAN":
            return .ocean
        case "TERRAIN_COAST":
            return .shore
        case "TERRAIN_SNOW":
            return .snow
        case "TERRAIN_GRASS":
            return .grass
        case "TERRAIN_PLAINS":
            return .plains
        case "TERRAIN_DESERT":
            return .desert
        case "TERRAIN_TUNDRA":
            return .tundra

        default:
            fatalError("unknown terrain: \(value)")
        }
    }
}
