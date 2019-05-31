//
//  ContinentFinder.swift
//  agents
//
//  Created by Michael Rommel on 02.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
//import Buckets

class ContinentFinder {

	private var continentIdentifiers: Array2D<Int>

	init(width: Int, height: Int) {

		self.continentIdentifiers = Array2D<Int>(columns: width, rows: height)
		self.continentIdentifiers.fill(with: ContinentConstants.kNotAnalyzed)
	}

	func evaluated(value: Int) -> Bool {

		return value != ContinentConstants.kNotAnalyzed && value != ContinentConstants.kNoContinent
	}

	@discardableResult
	func execute(on map: HexagonTileMap) -> [Continent] {

		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {

				self.evaluate(x: x, y: y, on: map)
			}
		}

		var continents = [Continent]()

		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {

				let continentIdentifier = self.continentIdentifiers[x, y]

				if self.evaluated(value: continentIdentifier!) {

					var continent = continents.first(where: { $0.identifier == continentIdentifier })

					if continent == nil {
						continent = Continent(identifier: continentIdentifier!, name: "Continent \(continentIdentifier ?? -1)", on: map)
						continents.append(continent!)
					}

					map.set(continent: continent, at: HexPoint(x: x, y: y))

					continent?.add(point: HexPoint(x: x, y: y))
				}
			}
		}

		return continents
	}

	func evaluate(x: Int, y: Int, on map: HexagonTileMap) {

		let currentPoint = HexPoint(x: x, y: y)

		if map.tile(at: currentPoint)?.terrain != .ocean {

			let northPoint = currentPoint.neighbor(in: .north)
			let nortwestPoint = currentPoint.neighbor(in: .northwest)
			let southPoint = currentPoint.neighbor(in: .southwest)

			let northContinent = map.valid(point: northPoint) ? self.continentIdentifiers[northPoint.x, northPoint.y] : ContinentConstants.kNotAnalyzed
			let nortwestContinent = map.valid(point: nortwestPoint) ? self.continentIdentifiers[nortwestPoint.x, nortwestPoint.y] : ContinentConstants.kNotAnalyzed
			let southContinent = map.valid(point: southPoint) ? self.continentIdentifiers[southPoint.x, southPoint.y] : ContinentConstants.kNotAnalyzed

			if self.evaluated(value: northContinent!) {
				self.continentIdentifiers[x, y] = northContinent
			} else if self.evaluated(value: nortwestContinent!) {
				self.continentIdentifiers[x, y] = nortwestContinent
			} else if self.evaluated(value: southContinent!) {
				self.continentIdentifiers[x, y] = southContinent
			} else {
				let freeIdentifier = self.firstFreeIdentifier()
				self.continentIdentifiers[x, y] = freeIdentifier
			}

			// handle continent joins
			if self.evaluated(value: northContinent!) && self.evaluated(value: nortwestContinent!) && northContinent != nortwestContinent {
				self.replace(oldIdentifier: nortwestContinent!, withIdentifier: northContinent!)
			} else if self.evaluated(value: nortwestContinent!) && self.evaluated(value: southContinent!) && nortwestContinent != southContinent {
				self.replace(oldIdentifier: nortwestContinent!, withIdentifier: southContinent!)
			} else if self.evaluated(value: northContinent!) && self.evaluated(value: southContinent!) && northContinent != southContinent {
				self.replace(oldIdentifier: northContinent!, withIdentifier: southContinent!)
			}

		} else {
			self.continentIdentifiers[x, y] = ContinentConstants.kNoContinent
		}
	}

	func firstFreeIdentifier() -> Int {

		/*var freeIdentifiers = BitArray(repeating: true, count: 256)

		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {

				if let continentIndex = self.continentIdentifiers[x, y] {
					if continentIndex >= 0 && continentIndex < 256 {
						freeIdentifiers[continentIndex] = false
					}
				}
			}
		}

		if let firstIndex = freeIdentifiers.index(where: { $0 == true }) {
			return firstIndex
		}*/

		return ContinentConstants.kNoContinent
	}

	func replace(oldIdentifier: Int, withIdentifier newIdentifier: Int) {

		for x in 0..<self.continentIdentifiers.columns {
			for y in 0..<self.continentIdentifiers.rows {

				if self.continentIdentifiers[x, y] == oldIdentifier {
					self.continentIdentifiers[x, y] = newIdentifier
				}
			}
		}
	}
}
