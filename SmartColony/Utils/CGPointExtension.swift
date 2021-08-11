//
//  CGPointExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

extension CGPoint {
    static var upperLeft: CGPoint {
        return CGPoint(x: 0, y: 1)
    }

    static var upperCenter: CGPoint {
        return CGPoint(x: 0.5, y: 1)
    }

    static var upperRight: CGPoint {
        return CGPoint(x: 1, y: 1)
    }

    static var middleLeft: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }

    static var middleCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0.5)
    }

    static var middleRight: CGPoint {
        return CGPoint(x: 1, y: 0.5)
    }

    static var lowerLeft: CGPoint {
        return CGPoint(x: 0, y: 0)
    }

    static var lowerCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0)
    }

    static var lowerRight: CGPoint {
        return CGPoint(x: 1, y: 0)
    }
}

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

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
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
