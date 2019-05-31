//
//  Terrain.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Terrain {

	case plain
	case grass
	case desert
	case tundra
	case snow
	case ocean
	case shore

	// types for map generation
	case water
	case ground

	var description: String {
		switch self {
		case .ocean:
			return "Ocean"
		case .shore:
			return "Shore"
		case .plain:
			return "Plain"
		case .grass:
			return "Grass"
		case .desert:
			return "Desert"
		case .tundra:
			return "Tundra"
		case .snow:
			return "Snow"

			// -------
		case .water:
			return "Water"
		case .ground:
			return "Ground"
		}
	}

	var textureNameHex: String {
		switch self {
		case .ocean:
			return "hex_ocean"
		case .shore:
			return "hex_shore"
		case .plain:
			return "hex_plain"
		case .grass:
			return "hex_grass"
		case .desert:
			return "hex_desert"
		case .tundra:
			return "hex_tundra"
		case .snow:
			return "hex_snow"

			// -------
		case .water:
			return "hex_water"
		case .ground:
			return "hex_ground"
		}
	}
}
