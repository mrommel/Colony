//
//  Terrain.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

struct Yields {
    
    let food: Int
}

enum Terrain: String, Codable {

	case plain
	case grass
	case desert
	case tundra
	case snow
	case ocean
	case shore
    case hill
    case mountain

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
        case .hill:
            return "Hill"
        case .mountain:
            return "Mountain"
		}
	}

    var textureNameHex: [String] {
		switch self {
		case .ocean:
			return ["hex_ocean"]
		case .shore:
			return ["hex_shore"]
		case .plain:
			return ["hex_plain"]
		case .grass:
			return ["hex_grass"]
		case .desert:
			return ["hex_desert"]
		case .tundra:
			return ["hex_tundra"]
		case .snow:
			return ["hex_snow"]
        case .hill:
            return ["hex_hill"]
        case .mountain:
            return ["hex_mountain"]
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
        case .hill:
            return UIColor(red: 237, green: 240, blue: 240) // FIXME
        case .mountain:
            return UIColor(red: 237, green: 240, blue: 240)
        }
    }
    
    func movementCost(for movementType: GameObjectMoveType) -> Float {
        
        switch movementType {
            
        case .immobile:
            return GameObjectMoveType.impassible
            
        case .swimOcean:
            if self == .ocean {
                return 2.2
            }
            
            if self == .shore {
                return 1.0
            }
            
            return GameObjectMoveType.impassible
            
        case .walk:
            if self == .plain {
                return 1.0
            }
            
            if self == .grass {
                return 1.1
            }
            
            if self == .desert {
                return 1.2
            }
            
            if self == .tundra {
                return 1.1
            }
            
            if self == .snow {
                return 1.5
            }
            
            if self == .hill {
                return 0.7
            }
            
            if self == .mountain {
                return 2.5
            }
            
            return GameObjectMoveType.impassible
        }
    }

    var yields: Yields {
        
        switch self {
        case .grass:
            return Yields(food: 2)
        case .plain:
            return Yields(food: 2)
        case .desert:
            return Yields(food: 0)
        case .tundra:
            return Yields(food: 1)
        case .snow:
            return Yields(food: 0)
        case .ocean:
            return Yields(food: 1)
        case .shore:
            return Yields(food: 1)
        case .hill:
            return Yields(food: 1)
        case .mountain:
            return Yields(food: 0)
        }
        
    }
}
