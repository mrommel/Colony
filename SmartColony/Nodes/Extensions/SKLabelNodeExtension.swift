//
//  SKLabelNodeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 08.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

extension SKLabelNode {
    
    func fitToWidth(maxWidth: CGFloat) {
        
        while frame.size.width >= maxWidth {
            self.fontSize -= 1.0
        }
    }
}
