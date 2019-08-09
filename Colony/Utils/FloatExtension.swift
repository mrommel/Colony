//
//  FloatExtension.swift
//  agents
//
//  Created by Michael Rommel on 25.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

extension Float {

	// Returns a random floating point number between 0.0 and 1.0, inclusive.
	public static var random: Float {
		return Float(arc4random()) / Float(UINT32_MAX)
	}

	/**
	Create a random num Float
	
	- parameter min: Float
	- parameter max: Float
	
	- returns: Float
	*/
	public static func random(minimum: Float, maximum: Float) -> Float {
		return Float.random * (maximum - minimum) + minimum
	}

	public static func reduceAngle(angle: Float) -> Float {

		var value = angle
		while value >= 360 { value -= 360 }
		while value < 0 { value += 360 }

		return value
	}

	public static func rad2Deg(angleInRad: Float) -> Float {

		return angleInRad * 180.0 / pi
	}
    
    public static func lerp(min: Float, max: Float, value: Float) -> Float {
        
        return min * value + max * (1.0 - value)
    }
}
