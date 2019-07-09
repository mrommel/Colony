//
//  Direction.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import UIKit

enum HexDirection: Int {

	case north
	case northeast
	case southeast
	case south
	case southwest
	case northwest

	static var all: [HexDirection] {
		return [.north, .northeast, .southeast, .south, .southwest, .northwest]
	}

	var short: String {
		switch self {
		case .north:
			return "n"
		case .northeast:
			return "ne"
		case .southeast:
			return "se"
		case .south:
			return "s"
		case .southwest:
			return "sw"
		case .northwest:
			return "nw"
		}
	}

	var description: String {
		switch self {
		case .north:
			return "North"
		case .northeast:
			return "North East"
		case .southeast:
			return "South East"
		case .south:
			return "South"
		case .southwest:
			return "South West"
		case .northwest:
			return "North West"
		}
	}

	var pickerImage: String {
		switch self {
		case .north:
			return "hex_neighbors_n"
		case .northeast:
			return "hex_neighbors_ne"
		case .southeast:
			return "hex_neighbors_se"
		case .south:
			return "hex_neighbors_s"
		case .southwest:
			return "hex_neighbors_sw"
		case .northwest:
			return "hex_neighbors_nw"
		}
	}
}
