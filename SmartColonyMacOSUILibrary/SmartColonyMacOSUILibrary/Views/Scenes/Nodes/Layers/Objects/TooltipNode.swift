//
//  TooltipNode.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.06.21.
//

import SpriteKit

class TooltipNode: SKNode {
    
    var backgroundNode: SKSpriteNode?
    var messageLabelNode: SKLabelNode?

    init(text: String) {
        
        super.init()
        
        let preferredLabelWidth = CGFloat(text.count * 4)
        let preferredBackgroundWidth = preferredLabelWidth + 8
        
        let box_texture = SKTexture(image: ImageCache.shared.image(for: "box-gold"))
        self.backgroundNode = NineGridTextureSprite(texture: box_texture, color: .black, size: CGSize(width: preferredBackgroundWidth, height: 20))
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = self.zPosition + 1
        self.addChild(self.backgroundNode!)
        
        self.messageLabelNode = SKLabelNode(text: text)
        self.messageLabelNode?.position = CGPoint(x: 0, y: 0)
        self.messageLabelNode?.zPosition = self.zPosition + 2
        self.messageLabelNode?.fontSize = 8
        // self.messageLabelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.messageLabelNode?.numberOfLines = 0
        self.messageLabelNode?.horizontalAlignmentMode = .center
        self.messageLabelNode?.fitToWidth(maxWidth: preferredLabelWidth)
        self.addChild(self.messageLabelNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
