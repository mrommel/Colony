//
//  Feature.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SceneKit

enum Feature {

	case forestMixed
	case forestPine
	case forestRain
	case oasis

	case hill
	case mountain

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
		case .hill:
			return "Hill"
		case .mountain:
			return "Mountain"
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
		case .hill:
			return ["hex_hill"]
		case .mountain:
			return ["hex_mountain"]
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
		case .hill:
			return GameScene.Constants.ZLevels.feature
		case .mountain:
			return GameScene.Constants.ZLevels.feature
		}
	}
}
