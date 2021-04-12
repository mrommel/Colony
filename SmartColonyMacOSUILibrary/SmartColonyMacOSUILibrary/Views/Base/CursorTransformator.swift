//
//  CursorTransformator.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 05.04.21.
//

import SmartAILibrary
import Cocoa

class CursorTransformator {
    
    func transform(screenPoint: CGPoint, contentSize: CGSize, shift: CGPoint) -> HexPoint {
        
        // to get a better resolution everything is scale up (@3x assets)
        let factor: CGFloat = 3.0
        
        // first calculate the "real" screen coordinate and then the HexPoint
        let x = (screenPoint.x - shift.x) / factor
        let y = ((contentSize.height - screenPoint.y) - shift.y) / factor

        return HexPoint(screen: CGPoint(x: x, y: y))
    }
}
