//
//  CGSizeExtension.swift
//  Colony
//
//  Created by Michael Rommel on 08.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import CoreGraphics

extension CGSize {
    
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
