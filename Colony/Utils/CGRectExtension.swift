//
//  CGRectExtension.swift
//  Colony
//
//  Created by Michael Rommel on 25.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
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
