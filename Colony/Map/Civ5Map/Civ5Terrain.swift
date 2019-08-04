//
//  Civ5Terrain.swift
//  Colony
//
//  Created by Michael Rommel on 03.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

extension Terrain {

    static func fromCiv5String(value: String) -> Terrain? {

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
            return .plain
        case "TERRAIN_DESERT":
            return .desert
        case "TERRAIN_TUNDRA":
            return .tundra

        default:
            fatalError("unknown terrain: \(value)")
        }
    }
}
