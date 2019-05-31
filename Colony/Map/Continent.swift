//
//  Continent.swift
//  agents
//
//  Created by Michael Rommel on 02.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

struct ContinentConstants {

	static let kNotAnalyzed: Int = 254
	static let kNoContinent: Int = 255
}

class Continent {

	var identifier: Int
	var name: String
	var points: [HexPoint]
	var map: HexagonTileMap?

	init() {
		self.identifier = ContinentConstants.kNotAnalyzed
		self.name = "NoName"
		self.points = []
		self.map = nil
	}

	init(identifier: Int, name: String, on map: HexagonTileMap?) {
		self.identifier = identifier
		self.name = name
		self.points = []
		self.map = map
	}

	func add(point: HexPoint) {
		self.points.append(point)
	}
}
