//
//  BannerNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 15.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class BannerNode: SKNode {
    
    var backgroundNode: SKSpriteNode?
    var messageLabelNode: SKLabelNode?

    init(text: String) {
        
        super.init()
        
        let backgroundTexture = SKTexture(imageNamed: "banner_message")
        self.backgroundNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: CGSize(width: 370, height: 122))
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.addChild(self.backgroundNode!)
        
        self.messageLabelNode = SKLabelNode(text: text)
        self.messageLabelNode?.position = CGPoint(x: 0, y: -5)
        self.messageLabelNode?.zPosition = self.zPosition + 1
        self.messageLabelNode?.fontSize = 14
        self.messageLabelNode?.fontName = Globals.Fonts.customFontFamilyname
        //self.messageLabelNode?.fontColor =
        self.messageLabelNode?.numberOfLines = 0
        self.messageLabelNode?.horizontalAlignmentMode = .center
        self.messageLabelNode?.preferredMaxLayoutWidth = 370 - 20
        self.addChild(self.messageLabelNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
