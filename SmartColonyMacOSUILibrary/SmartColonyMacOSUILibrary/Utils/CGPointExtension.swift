//
//  CGPointExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 21.03.21.
//

import Foundation

extension CGPoint {
    public static var upperLeft: CGPoint {
        return CGPoint(x: 0, y: 1)
    }

    public static var upperCenter: CGPoint {
        return CGPoint(x: 0.5, y: 1)
    }

    public static var upperRight: CGPoint {
        return CGPoint(x: 1, y: 1)
    }

    public static var middleLeft: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }

    static var middleCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0.5)
    }

    public static var middleRight: CGPoint {
        return CGPoint(x: 1, y: 0.5)
    }

    public static var lowerLeft: CGPoint {
        return CGPoint(x: 0, y: 0)
    }

    public static var lowerCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0)
    }

    public static var lowerRight: CGPoint {
        return CGPoint(x: 1, y: 0)
    }
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
