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
    
    static var all: [Terrain] {
        return [.ocean, .shore, .plain, .grass, .desert, .tundra, .snow, .hill, .mountain]
    }

	var title: String {
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
    
    var summary: String {
        switch self {
        case .ocean:
            return "Ocean sum"
        case .shore:
            return "Shore sum"
        case .plain:
            return "Plain sum"
        case .grass:
            return "Grass sum"
        case .desert:
            return "Desert sum"
        case .tundra:
            return "Tundra sum"
        case .snow:
            return "Snow sum"
        case .hill:
            return "Hill sum"
        case .mountain:
            return "Mountain sum"
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
            return ["mountains1", "mountains2", "mountains3"]
		}
	}
    
    var zLevel: CGFloat {
        switch self {
        case .ocean:
            return GameScene.Constants.ZLevels.terrain
        case .shore:
            return GameScene.Constants.ZLevels.terrain
        case .plain:
            return GameScene.Constants.ZLevels.terrain
        case .grass:
            return GameScene.Constants.ZLevels.terrain
        case .desert:
            return GameScene.Constants.ZLevels.terrain
        case .tundra:
            return GameScene.Constants.ZLevels.terrain
        case .snow:
            return GameScene.Constants.ZLevels.snow
        case .hill:
            return GameScene.Constants.ZLevels.hill
        case .mountain:
            return GameScene.Constants.ZLevels.mountain
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
    
    func movementCost(for movementType: MovementType) -> Float {
        
        switch movementType {
            
        case .immobile:
            return MovementType.impassible
            
        case .swimOcean:
            if self == .ocean {
                return 1.5
            }
            
            if self == .shore {
                return 1.0
            }
            
            return MovementType.impassible
            
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
            
            return MovementType.impassible
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
    
    var maxInitiative: Int {
        
        switch self {
        case .ocean:
            return Int.max
        case .shore:
            return Int.max
        case .plain:
            return Int.max
        case .grass:
            return Int.max
        case .desert:
            return Int.max
        case .tundra:
            return Int.max
        case .snow:
            return Int.max
        case .hill:
            return Int.max
        case .mountain:
            return Int.max
        }
    }
}
