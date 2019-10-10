//
//  Random.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

public func clamp<T>(_ value: T, from minValue: T, to maxValue: T) -> T where T : Comparable {
    return min(max(value, minValue), maxValue)
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
