//
//  CGFloatExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import CoreGraphics

public extension CGFloat {
    
    // Converts degrees to radians
    func degreesToRadians() -> CGFloat {
        return CGFloat.pi * self / 180.0
    }
    
}
