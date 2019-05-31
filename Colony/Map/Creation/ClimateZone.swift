//
//  ClimateZone.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

/// climate zone a `Tile` can be in
enum ClimateZone: Int {

	case polar
	case subpolar
	case temperate
	case subtropic
	case tropic

	/// get a more moderate `ClimateZone`
	var moderate: ClimateZone {
		switch self {
		case .polar:
			return .subpolar
		case .subpolar:
			return .temperate
		case .temperate:
			return .subtropic
		case .subtropic:
			return .subtropic
		case .tropic:
			return .tropic
		}
	}
}
