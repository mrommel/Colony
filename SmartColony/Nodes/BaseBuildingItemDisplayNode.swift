//
//  BaseBuildingItemDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BaseBuildingItemDisplayNode: SKNode {
    
    // nodes
    var backgroundNode: NineGridTextureSprite?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    var costNode: YieldDisplayNode?
    
    init(textureName: String, iconTexture: String, name: String, nameColor: SKColor, cost: Double, showCosts: Bool, size: CGSize) {
        
        super.init()
        
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        // icon
        let iconTexture = SKTexture(imageNamed: iconTexture)
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 20, height: 20))
        self.iconNode?.position = CGPoint(x: 10, y: -10)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)
        
        // name
        self.labelNode = SKLabelNode(text: name)
        self.labelNode?.position = CGPoint(x: 35, y: -12)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 16
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = nameColor
        self.labelNode?.numberOfLines = 1
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.preferredMaxLayoutWidth = size.width - 40
        self.addChild(self.labelNode!)
        
        // add costs
        if !showCosts {
            self.costNode = YieldDisplayNode(for: .production, value: cost, withBackground: false, size: CGSize(width: 70, height: 28))
            self.costNode?.position = CGPoint(x: 134, y: -3)
            self.costNode?.zPosition = self.zPosition + 2
            self.addChild(self.costNode!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
