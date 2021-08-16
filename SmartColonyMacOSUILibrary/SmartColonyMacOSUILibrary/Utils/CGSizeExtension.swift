//
//  CGSizeExtension.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.05.21.
//

import Foundation
import CoreGraphics

public extension CGSize {

    init(fromPoint point: CGPoint) {
        self.init(width: point.x, height: point.y)
    }

    func rounded() -> CGSize {
        return CGSize(width: width.rounded(), height: height.rounded())
    }
}

public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}

public func * (scale: CGFloat, rhs: CGSize) -> CGSize {
    return CGSize(width: scale * rhs.width, height: scale * rhs.height)
}

public func * (scale: Double, rhs: CGSize) -> CGSize {
    return CGFloat(scale) * rhs
}

public func * (scale: Float, rhs: CGSize) -> CGSize {
    return CGFloat(scale) * rhs
}

public func * (lhs: CGSize, scale: CGFloat) -> CGSize {
    return CGSize(width: scale * lhs.width, height: scale * lhs.height)
}

public func * (lhs: CGSize, scale: Float) -> CGSize {
    return lhs * CGFloat(scale)
}

public func * (lhs: CGSize, scale: Double) -> CGSize {
    return lhs * CGFloat(scale)
}

public func / (lhs: CGSize, scale: CGFloat) -> CGSize {
    return lhs * (1.0 / scale)
}

public func / (lhs: CGSize, scale: Float) -> CGSize {
    return lhs * (1.0 / scale)
}

public func / (lhs: CGSize, scale: Double) -> CGSize {
    return lhs * (1.0 / scale)
}
