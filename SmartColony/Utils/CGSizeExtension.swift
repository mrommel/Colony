//
//  CGSizeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import CoreGraphics

extension CGSize {

    var half: CGSize {
        return CGSize(width: self.width / 2, height: self.height / 2)
    }
    
    var halfWidth: CGFloat {
        return self.width / 2.0
    }
    
    var halfHeight: CGFloat {
        return self.height / 2.0
    }
    
    func reduced(dx: Int, dy: Int) -> CGSize {
        
        return CGSize(width: self.width - CGFloat(dx), height: self.height - CGFloat(dy))
    }

    mutating func reduce(dx: Int, dy: Int) -> CGSize {

        self.width = self.width - CGFloat(dx)
        self.height = self.height - CGFloat(dy)

        return self
    }

    func aspectResized(to target: CGSize) -> CGSize {

        let baseAspect = self.width / self.height
        let targetAspect = target.width / target.height
        if baseAspect > targetAspect {
            return CGSize(width: (target.height * width) / height, height: target.height)
        } else {
            return CGSize(width: target.width, height: (target.width * height) / width)
        }
    }
}

// from https://gist.github.com/gurgeous/bc0c3d2e748c3b6fe7f2
func - (l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width - r, height: l.height - r) }
func + (l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width + r, height: l.height + r) }
func * (l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width * r, height: l.height * r) }
func / (l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width / r, height: l.height / r) }

// from https://gist.github.com/detomon/864a6b7c51f8bed7a022
/**
 * ...
 * a + c
 */
func + (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x + right.width, y: left.y + right.height)
}

/**
 * ...
 * a += c
 */
func += (left: inout CGPoint, right: CGSize) {
    left = left + right
}

/**
 * ...
 * a - c
 */
func - (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x - right.width, y: left.y - right.height)
}

/**
 * ...
 * a -= c
 */
func -= (left: inout CGPoint, right: CGSize) {
    left = left - right
}

/**
 * ...
 * a * c
 */
func * (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x * right.width, y: left.y * right.height)
}

/**
 * ...
 * a *= c
 */
func *= (left: inout CGPoint, right: CGSize) {
    left = left * right
}

/**
 * ...
 * a / c
 */
func / (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x / right.width, y: left.y / right.height)
}

/**
 * ...
 * a /= c
 */
func /= (left: inout CGPoint, right: CGSize) {
    left = left / right
}

/**
 * ...
 * -a
 */
prefix func - (left: CGPoint) -> CGPoint {
    return CGPoint(x: -left.x, y: -left.y)
}

