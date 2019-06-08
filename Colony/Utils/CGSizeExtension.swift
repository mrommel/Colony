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
}
