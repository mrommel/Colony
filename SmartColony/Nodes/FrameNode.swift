//
//  FrameNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 21.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class FrameNode: SKNode {
    
    // nodes
    var backgroundNode: SKSpriteNode?
    
    init(size: CGSize) {
        
        super.init()
        
        // background
        let textureName = "tech_background" // <= replace
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
