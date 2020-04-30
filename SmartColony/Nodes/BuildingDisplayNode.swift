//
//  BuildingDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 20.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class BuildingDisplayNode: SKNode {
    
    // vairables
    let buildingType: BuildingType
    
    // nodes
    var backgroundNode: NineGridTextureSprite?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    var costNode: YieldDisplayNode?
    
    // callback
    var action: (_ buildingType: BuildingType) -> Void
    
    // MARK: constructors
    
    init(buildingType: BuildingType, size: CGSize, buttonAction: @escaping (_ buildingType: BuildingType) -> Void) {
        
        self.buildingType = buildingType
        self.action = buttonAction
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        // background
        let textureName = "grid9_button_active"
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        // icon
        let iconTexture = SKTexture(imageNamed: buildingType.iconTexture())
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 20, height: 20))
        self.iconNode?.position = CGPoint(x: 10, y: -10)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)
        
        // name
        self.labelNode = SKLabelNode(text: buildingType.name())
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
        
        // add costs
        self.costNode = YieldDisplayNode(for: .production, value: Double(buildingType.productionCost()), withBackground: false, size: CGSize(width: 70, height: 28))
        self.costNode?.position = CGPoint(x: 134, y: -3)
        self.costNode?.zPosition = self.zPosition + 2
        self.addChild(self.costNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propagate back to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propagate back to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            
            // propagate back to scrollview
            if let scrollView = self.parent?.parent as? ScrollNode {
                
                if !scrollView.backgroundNode!.contains(location) {
                    return
                }
                
                if self.backgroundNode!.contains(location) {
                    self.action(self.buildingType)
                }
            }
        }
    }
}