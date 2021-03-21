//
//  CGPointExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 21.03.21.
//

import Foundation


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
