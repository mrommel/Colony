//
//  Terrain.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

enum Terrain: String, Codable {

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
    
    var overviewColor: UIColor {
        switch self {
        case .ocean:
            return UIColor(red: 79, green: 112, blue: 141) 
        case .shore:
            return UIColor(red: 91, green: 129, blue: 166)
        case .plain:
            return UIColor(red: 98, green: 122, blue: 32)
        case .grass:
            return UIColor(red: 75, green: 113, blue: 21)
        case .desert:
            return UIColor(red: 197, green: 174, blue: 108)
        case .tundra:
            return UIColor(red: 140, green: 106, blue: 68)
        case .snow:
            return UIColor(red: 237, green: 240, blue: 240)
            
        // -------
        case .water:
            return UIColor(red: 79, green: 112, blue: 141)
        case .ground:
            return UIColor(red: 75, green: 113, blue: 21)
        }
    }
}
