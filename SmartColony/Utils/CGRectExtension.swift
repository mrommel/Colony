//
//  CGRectExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

extension CGRect {
    
    public init(center: CGPoint, size: CGSize) {
        self.init()
        self.origin = CGPoint(x: center.x + size.width / 2.0, y: center.y + size.height / 2.0)
        self.size = size
    }
    
    var halfWidth: CGFloat {
        return self.size.width / 2.0
    }
    
    var halfHeight: CGFloat {
        return self.size.height / 2.0
    }
}
