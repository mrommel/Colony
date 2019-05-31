//
//  IntegerExtension.swift
//  agents
//
//  Created by Michael Rommel on 25.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

extension Int {

	public func sign() -> Int {
		return (self < 0 ? -1 : 1)
	}
	/* or, use signature: func sign() -> Self */
}

extension Int {

	// Returns a random Int point number between 0 and Int.max.
	public static var random: Int {
		return Int.random(number: Int.max)
	}

	/**
	Random integer between 0 and n-1.
	
	- parameter number: Int
	
	- returns: Int
	*/
	public static func random(number: Int) -> Int {
		return Int(arc4random_uniform(UInt32(number)))
	}

	/**
	Random integer between min and max
	
	- parameter minimum: Int
	- parameter maximum: Int
	
	- returns: Int
	*/
	public static func random(minimum: Int = 0, maximum: Int) -> Int {
		return Int.random(number: maximum - minimum + 1) + minimum
	}
}
