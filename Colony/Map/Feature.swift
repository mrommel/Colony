//
//  Feature.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SceneKit

enum Feature: String, Codable {

	case forestMixed
	case forestPine
	case forestRain
	case oasis
    case marsh
    case ice

    // case lake
    
    static var all: [Feature] {
        return [.forestMixed, .forestPine, .forestRain, .oasis, .marsh, .ice]
    }
    
    var title: String {
        switch self {
        case .forestMixed:
            return "Mixed Forest"
        case .forestPine:
            return "Pine Forest"
        case .forestRain:
            return "Rain Forest"
        case .oasis:
            return "Oasis"
        case .marsh:
            return "Marsh"
        case .ice:
            return "Ice"
        }
    }

	var summary: String {
		switch self {
		case .forestMixed:
			return "Mixed Forest summary"
		case .forestPine:
			return "Pine Forest summary"
		case .forestRain:
			return "Rain Forest summary"
		case .oasis:
			return "Oasis summary"
        case .marsh:
            return "Marsh summary"
        case .ice:
            return "Ice summary"
		}
	}

	var textureNamesHex: [String] {
		switch self {
		case .forestMixed:
			return ["hex_forest_mixed_summer1"]
		case .forestPine:
			return ["hex_forest_pine_summer1", "hex_forest_pine_summer2", "hex_forest_pine_summer3"]
		case .forestRain:
			return ["hex_forest_rain", "hex_forest_rain2"]
		case .oasis:
			return ["hex_oasis1", "hex_oasis2"]
        case .marsh:
            return ["hex_marsh"]
        case .ice:
            return ["hex_ice1", "hex_ice2", "hex_ice3", "hex_ice4", "hex_ice5", "hex_ice6"]
		}
	}

	var zLevel: CGFloat {
		switch self {
		case .forestMixed:
			return GameScene.Constants.ZLevels.featureUpper
		case .forestPine:
			return GameScene.Constants.ZLevels.featureUpper
		case .forestRain:
			return GameScene.Constants.ZLevels.featureUpper
		case .oasis:
			return GameScene.Constants.ZLevels.feature
        case .marsh:
            return GameScene.Constants.ZLevels.feature
        case .ice:
            return GameScene.Constants.ZLevels.feature
		}
	}
    
    func movementCost(for movementType: MovementType) -> Float {
        
        switch movementType {
        case .immobile:
            return MovementType.impassible
            
        case .swimOcean:
            return MovementType.impassible
        
        case .walk:
            
            if self == .forestMixed {
                return 0.7
            }
            
            if self == .forestPine {
                return 0.5
            }
            
            if self == .forestRain {
                return 1.5
            }
            
            if self == .oasis {
                return 0.0
            }
            
            if self == .marsh {
                return 0.0
            }
            
            if self == .ice {
                return 0.0
            }
            
            return MovementType.impassible
        }
        
    }
}
