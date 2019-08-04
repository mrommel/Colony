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

	var description: String {
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

	var textureNamesHex: [String] {
		switch self {
		case .forestMixed:
			return ["hex_forest_mixed_summer1"]
		case .forestPine:
			return ["hex_forest_pine_summer1", "hex_forest_pine_summer2", "hex_forest_pine_summer3"]
		case .forestRain:
			return ["hex_forest_rain", "hex_forest_rain2"]
		case .oasis:
			return ["hex_oasis"]
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
    
    func movementCost(for movementType: GameObjectMoveType) -> Float {
        
        switch movementType {
        case .immobile:
            return GameObjectMoveType.impassible
            
        case .swimOcean:
            return GameObjectMoveType.impassible
        
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
            
            return GameObjectMoveType.impassible
        }
        
    }
}
