//
//  Random.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

extension BinaryInteger {

	public func sign() -> Int {
		return (self < 0 ? -1 : 1)
	}
	/* or, use signature: func sign() -> Self */
}

extension Double {

	// Returns a random floating point number between 0.0 and 1.0, inclusive.
	public static var random: Double {
		return Double(arc4random()) / 0xFFFFFFFF
	}

	/**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
	public static func random(minimum: Double, maximum: Double) -> Double {
		return Double.random * (maximum - minimum) + minimum
	}

	public static func rad2Deg(angleInRad: Double) -> Double {

		return angleInRad * 180.0 / pi
	}
}
