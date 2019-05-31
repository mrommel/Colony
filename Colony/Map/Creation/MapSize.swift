//
//  MapSize.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum MapSize {

	case test // 5x5
	case duel // 10x8
	case tiny // 14x12
	case small // 18x16
	case standard // 22x20
	case large // 26x24
	case huge // 30x28

	public var width: Int {
		switch self {
		case .test:
			return 5
		case .duel:
			return 10
		case .tiny:
			return 14
		case .small:
			return 18
		case .standard:
			return 22
		case .large:
			return 26
		case .huge:
			return 30
		}
	}

	public var height: Int {
		switch self {
		case .test:
			return 5
		case .duel:
			return 8
		case .tiny:
			return 12
		case .small:
			return 16
		case .standard:
			return 20
		case .large:
			return 24
		case .huge:
			return 28
		}
	}
}
