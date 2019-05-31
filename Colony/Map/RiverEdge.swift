//
//  RiverPoint.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 16.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

/// a `RiverEdge` is one part of a `River` defined by his location and relative flow
class RiverEdge {

	var point: HexPoint
	var flowDirection: FlowDirection

	/// constructs a new `RiverEdge` from a `point` and a `flowDirection`
	///
	/// - Parameters:
	///   - point: locations of the `RiverEdge`
	///   - flowDirection: relative flow of the `RiverEdge`
	public init(with point: HexPoint, and flowDirection: FlowDirection) {

		self.point = point
		self.flowDirection = flowDirection
	}
}
