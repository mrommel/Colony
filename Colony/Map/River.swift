//
//  River.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation
//import JSONCodable

// taken from here: https://en.wikipedia.org/wiki/List_of_rivers_by_length
let riverNames = ["Amazon", "Nile", "Yangtze", "Mississippi", "Yenisei", "Huang He", "Ob", "Río de la Plata", "Congo", "Amur", "Lena", "Mekong", "Mackenzie", "Niger", "Murray", "Tocantins", "Volga", "Euphrates", "Madeira", "Purús", "Yukon", "Indus", "São Francisco", "Syr Darya", "Salween", "Saint Lawrence", "Rio Grande", "Lower Tunguska", "Brahmaputra", "Donau"]

/// a `River` holds the complete list of `RiverEdge`s and his name
class River {

	var name: String = ""
	var points: [RiverEdge] = []

	/// constructor of the `River`
	///
	/// - Parameters:
	///   - name: name of the `River`
	///   - cornerPoints: list of corners that generate the edges of the river
	init(with name: String, and cornerPoints: [HexPointWithCorner]) {

		self.name = name

		if !cornerPoints.isEmpty {
			var prev = cornerPoints.first
			for point in cornerPoints.suffix(from: 1) {

				self.points.append(self.generateRiverEdge(from: prev!, to: point))

				prev = point
			}
		}
	}

	/// generates a RiverEdge
	///
	/// - Parameters:
	///   - from: start point of the edge
	///   - to: end point of the edge
	/// - Returns: `RiverPoint`, which is the edge of point `from` and `to`
	private func generateRiverEdge(from: HexPointWithCorner, to: HexPointWithCorner) -> RiverEdge {

		if from.point == to.point {
			return self.generateRiverEdgeSameTile(from: from, to: to)
		} else {
			return self.generateRiverEdgeForeignTile(from: from, to: to)
		}
	}

	/// generates a RiverEdge, when points are on the same tile
	///
	/// - Parameters:
	///   - from: start point of the edge
	///   - to: end point of the edge
	/// - Returns: `RiverPoint`, which is the edge of point `from` and `to`
	private func generateRiverEdgeSameTile(from: HexPointWithCorner, to: HexPointWithCorner) -> RiverEdge {

		if from.corner == .northeast && to.corner == .east {
			return RiverEdge(with: from.point, and: .southEast)
		} else if from.corner == .east && to.corner == .northeast {
			return RiverEdge(with: from.point, and: .northWest)
		}

		if from.corner == .east && to.corner == .southeast {
			return RiverEdge(with: from.point, and: .southWest)
		} else if from.corner == .southeast && to.corner == .east {
			return RiverEdge(with: from.point, and: .northEast)
		}

		if from.corner == .northeast && to.corner == .northwest {
			return RiverEdge(with: from.point, and: .west)
		} else if from.corner == .northwest && to.corner == .northeast {
			return RiverEdge(with: from.point, and: .east)
		}

		// we need to move to the northWest neighboring tile
		let northWestNeighbor = from.point.neighbor(in: .northwest)
		if from.corner == .northwest && to.corner == .west {
			return RiverEdge(with: northWestNeighbor, and: .southWest)
		} else if from.corner == .west && to.corner == .northwest {
			return RiverEdge(with: northWestNeighbor, and: .northEast)
		}

		// we need to move to the south neighboring tile
		let southNeighbor = from.point.neighbor(in: .south)
		if from.corner == .southwest && to.corner == .southeast {
			return RiverEdge(with: southNeighbor, and: .east)
		} else if from.corner == .southeast && to.corner == .southwest {
			return RiverEdge(with: southNeighbor, and: .west)
		}

		// we need to move to the southWest neighboring tile
		let southWestNeighbor = from.point.neighbor(in: .southwest)
		if from.corner == .west && to.corner == .southwest {
			return RiverEdge(with: southWestNeighbor, and: .southEast)
		} else if from.corner == .southwest && to.corner == .west {
			return RiverEdge(with: southWestNeighbor, and: .northWest)
		}

		assert(false, "Condition from: \(from), to: \(to) not handled")
	}

	/// generates a RiverEdge, when points are not on the same tile
	///
	/// - Parameters:
	///   - from: start point of the edge
	///   - to: end point of the edge
	/// - Returns: `RiverPoint`, which is the edge of point `from` and `to`
	private func generateRiverEdgeForeignTile(from: HexPointWithCorner, to: HexPointWithCorner) -> RiverEdge {

		let direction = from.point.direction(towards: to.point)

		switch direction! {
		case .northeast:
			if from.corner == .east && to.corner == .southeast {
				let southEastNeighbor = from.point.neighbor(in: .southeast)
				return RiverEdge(with: southEastNeighbor, and: .east)
			}
		case .southeast:
			if from.corner == .southeast && to.corner == .southwest {
				let southNeighbor = from.point.neighbor(in: .south)
				return RiverEdge(with: southNeighbor, and: .southEast)
			}
		case .south:
			if from.corner == .southwest && to.corner == .west {
				let southWestNeighbor = from.point.neighbor(in: .southwest)
				return RiverEdge(with: southWestNeighbor, and: .southWest)
			}
		case .southwest:
			if from.corner == .west && to.corner == .northwest {
				return RiverEdge(with: to.point, and: .west)
			}
		case .northwest:
			if from.corner == .northwest && to.corner == .northeast {
				return RiverEdge(with: to.point, and: .northWest)
			}
		case .north:
			if from.corner == .northeast && to.corner == .east {
				return RiverEdge(with: to.point, and: .northEast)
			}
		}

		assert(false, "Condition from: \(from), to: \(to) not handled")
	}
}
