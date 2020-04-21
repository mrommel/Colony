//
//  UnitDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 21.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class UnitDisplayNode: SKNode {
    
    let unitType: UnitType
    
    // nodes
    var backgroundNode: NineGridTextureSprite?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    
    var action: (_ unitType: UnitType) -> Void
    
    init(unitType: UnitType, size: CGSize, buttonAction: @escaping (_ unitType: UnitType) -> Void) {
        
        self.unitType = unitType
        self.action = buttonAction
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        // background
        let textureName = "grid9_button_active"
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        // icon
        let iconTexture = SKTexture(imageNamed: "unit_default")
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 20, height: 20))
        self.iconNode?.position = CGPoint(x: 10, y: -10)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)
        
        // name
        self.labelNode = SKLabelNode(text: unitType.name())
        self.labelNode?.position = CGPoint(x: 35, y: -7)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 16
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = .white
        self.labelNode?.numberOfLines = 2
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.preferredMaxLayoutWidth = size.width - 40
        self.addChild(self.labelNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            
            if self.backgroundNode!.contains(location) {
                self.action(self.unitType)
            }
        }
    }
}
