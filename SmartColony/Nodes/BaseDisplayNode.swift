//
//  BaseDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 19.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class BaseDisplayNode: SKNode {
    
    // nodes
    var backgroundNode: NineGridTextureSprite?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    var costNode: SpriteButtonNode?
    
    var touchHandler: (()->Void)?
    
    init(texture: String, name: String, cost: Int, size: CGSize) {
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        // background
        let textureName = "tech_background"
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        // icon
        let iconTexture = SKTexture(imageNamed: texture)
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 22, height: 22))
        self.iconNode?.position = CGPoint(x: 10, y: -10)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)
        
        // name
        self.labelNode = SKLabelNode(text: name)
        self.labelNode?.position = CGPoint(x: 35, y: -7)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 14
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = .lightGray
        self.labelNode?.numberOfLines = 2
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.preferredMaxLayoutWidth = size.width - 40
        self.addChild(self.labelNode!)
        
        // cost
        self.costNode = SpriteButtonNode(titled: "\(cost)", enabledButtonImage: "tech_blue", disabledButtonImage: "tech_blue", size: CGSize(width: 32, height: 24), buttonAction: {})
        self.costNode?.position = CGPoint(x: 92, y: -43)
        self.costNode?.zPosition = self.zPosition + 1
        self.costNode?.fontSize = 14
        self.costNode?.fontColor = .white
        self.addChild(self.costNode!)
        
        // icons
        // eureka
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let handler = self.touchHandler {
            handler()
        }
    }
    
    func select() {
        
        let textureName = "tech_blue"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)
        
        self.touchHandler = nil
    }
    
    func disable() {
        
        let textureName = "tech_disabled"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)
        
        self.touchHandler = nil
    }
    
    func activate() {
        
        let textureName = "tech_active"
        self.backgroundNode?.texture = SKTexture(imageNamed: textureName)
        
        self.touchHandler = nil
    }
}
