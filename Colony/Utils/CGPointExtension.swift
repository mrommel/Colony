//
//  CGPointExtension.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
	return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
	return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
	return CGFloat(hypotf(Float(point1.x) - Float(point2.x), Float(point1.y) - Float(point2.y)))
}

func round(point: CGPoint) -> CGPoint {
	return CGPoint(x: round(point.x), y: round(point.y))
}

func floor(point: CGPoint) -> CGPoint {
	return CGPoint(x: floor(point.x), y: floor(point.y))
}

func ceil(point: CGPoint) -> CGPoint {
	return CGPoint(x: ceil(point.x), y: ceil(point.y))
}
