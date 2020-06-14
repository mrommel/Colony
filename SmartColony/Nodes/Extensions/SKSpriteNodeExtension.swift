//
//  SKSpriteNodeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    
    func aspectFillTo(size fillSize: CGSize) {
        
        if let texture = self.texture {

            let textureSize = texture.size()
            
            let textureAspectRatio = textureSize.width / textureSize.height
            let fillAspectRatio = fillSize.width / fillSize.height
            
            var newWidth = fillSize.width
            var newHeight = fillSize.height
            
            if textureAspectRatio > fillAspectRatio {
                newWidth = fillSize.width / fillAspectRatio * textureAspectRatio
            } else {
                newHeight = fillSize.height * fillAspectRatio / textureAspectRatio
            }
            self.size = CGSize(width: newWidth, height: newHeight)
        }
    }
}

extension SKSpriteNode: SizableNode {
    
    func width() -> CGFloat {
        
        return self.size.width
    }
    
    func height() -> CGFloat {
        
        return self.size.height
    }
}
