//
//  SKNodeExtension.swift
//  Colony
//
//  Created by Michael Rommel on 25.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func anchored(value: CGPoint, target: SKNode? = .none) -> CGPoint {
        guard let target = target ?? parent else { return position }
        let targetMin = convert(CGPoint(x: target.frame.minX, y: target.frame.minY), to: self)
        let targetMax = convert(CGPoint(x: target.frame.maxX, y: target.frame.maxY), to: self)
        let xPos = (targetMax.x - targetMin.x) * value.x + targetMin.x
        let yPos = (targetMax.y - targetMin.y) * value.y + targetMin.y
        return CGPoint(x: xPos, y: yPos)
    }

    func anchor(local: CGPoint, other: CGPoint, target: SKNode? = .none) -> CGPoint {
        let targetPos = anchored(value: other, target: target)
        let xPos = (frame.maxX - frame.minX) * local.x + frame.minX
        let yPos = (frame.maxY - frame.minY) * local.y + frame.minY
        let offset = CGPoint(x: targetPos.x - xPos, y: targetPos.y - yPos)
        let result = offset + position
        return result
    }
}
