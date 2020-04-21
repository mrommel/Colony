//
//  BannerNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 15.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

// shown when the AI turns
class BannerNode: SKNode {
    
    var backgroundNode: SKSpriteNode?
    var logoBannerNode: SKSpriteNode?
    var messageLabelNode: SKLabelNode?

    init(text: String) {
        
        super.init()
        
        self.backgroundNode = NineGridTextureSprite(imageNamed: "grid9_button_active", size: CGSize(width: 340, height: 40))
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.logoBannerNode?.zPosition = self.zPosition + 1
        self.addChild(self.backgroundNode!)
        
        let bannerTexture = SKTexture(imageNamed: "banner") // 831x355 -> 208x89
        self.logoBannerNode = SKSpriteNode(texture: bannerTexture, color: .black, size: CGSize(width: 208, height: 89))
        self.logoBannerNode?.position = CGPoint(x: 0, y: 8)
        self.logoBannerNode?.zPosition = self.zPosition
        self.logoBannerNode?.anchorPoint = CGPoint.lowerCenter
        self.addChild(self.logoBannerNode!)
        
        self.messageLabelNode = SKLabelNode(text: text)
        self.messageLabelNode?.position = CGPoint(x: 0, y: -8)
        self.messageLabelNode?.zPosition = self.zPosition + 2
        self.messageLabelNode?.fontSize = 14
        self.messageLabelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.messageLabelNode?.numberOfLines = 0
        self.messageLabelNode?.horizontalAlignmentMode = .center
        self.messageLabelNode?.preferredMaxLayoutWidth = 340 - 10
        self.addChild(self.messageLabelNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
