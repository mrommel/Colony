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

    // case lake

    static func fromCiv5String(value: String) -> Feature? {
        
        if value == "FEATURE_ICE" {
            return nil
        }
        
        if value == "FEATURE_FOREST" {
            return .forestMixed
        }
        
        if value == "FEATURE_JUNGLE" {
            return .forestRain
        }
        
        if value == "FEATURE_MARSH" {
            return .marsh
        }
        
        if value == "FEATURE_OASIS" {
            return .oasis
        }
        
        if value == "FEATURE_FLOOD_PLAINS" {
            return .oasis // FIXME
        }
        
        if value == "FEATURE_FALLOUT" {
            return .oasis // FIXME
        }
        
        return nil
    }

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
            
            return GameObjectMoveType.impassible
        }
        
    }
}
