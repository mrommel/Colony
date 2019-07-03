//
//  SpriteButtonNode.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class SpriteButtonNode: SKNode {
    
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var buttonIcon: SKSpriteNode?
    var buttonLabel: SKLabelNode
    var action: () -> Void
    
    init(titled title: String, defaultButtonImage: String, activeButtonImage: String, size: CGSize, isNineGrid: Bool = true, buttonAction: @escaping () -> Void) {
        
        // default button state
        self.defaultButton = NineGridTextureSprite(imageNamed: defaultButtonImage, size: size, isNineGrid: isNineGrid)
        
        // active button state
        self.activeButton = NineGridTextureSprite(imageNamed: activeButtonImage, size: size, isNineGrid: isNineGrid)
        self.activeButton.isHidden = true
        
        self.action = buttonAction
        
        self.buttonLabel = SKLabelNode(text: title)
        self.buttonLabel.position = CGPoint(x: 0, y: 0)
        self.buttonLabel.fontColor = UIColor.white
        self.buttonLabel.fontSize = 18
        self.buttonLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        self.buttonLabel.verticalAlignmentMode = .center
        self.buttonLabel.name = "buttonLabel"
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.defaultButton.zPosition = self.zPosition
        self.addChild(self.defaultButton)
        
        self.activeButton.zPosition = self.zPosition
        self.addChild(self.activeButton)
        
        self.buttonLabel.zPosition = self.zPosition + 1
        self.addChild(self.buttonLabel)
    }
    
    init(imageNamed imageName: String, title: String, defaultButtonImage: String, activeButtonImage: String, size: CGSize, isNineGrid: Bool = true, buttonAction: @escaping () -> Void) {
        
        // default button state
        self.defaultButton = NineGridTextureSprite(imageNamed: defaultButtonImage, size: size, isNineGrid: isNineGrid)
        
        // active button state
        self.activeButton = NineGridTextureSprite(imageNamed: activeButtonImage, size: size, isNineGrid: isNineGrid)
        self.activeButton.isHidden = true
        
        self.action = buttonAction
        
        let buttonIconTexture = SKTexture(imageNamed: imageName)
        let iconSize = CGSize(width: size.height - 8, height: size.height - 8)
        self.buttonIcon = SKSpriteNode(texture: buttonIconTexture, color: .black, size: iconSize)
        let iconPosX = -(size.width / 2) + 4 + (iconSize.width / 2)
        self.buttonIcon?.position = CGPoint(x: iconPosX, y: 0)
        
        self.buttonLabel = SKLabelNode(text: title)
        let labelPosX = -(size.width / 2) + 4 + iconSize.width + 4
        self.buttonLabel.position = CGPoint(x: labelPosX, y: 0)
        self.buttonLabel.fontColor = UIColor.white
        self.buttonLabel.fontSize = 18
        self.buttonLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        self.buttonLabel.verticalAlignmentMode = .center
        self.buttonLabel.horizontalAlignmentMode = .left
        self.buttonLabel.name = "buttonLabel"
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.defaultButton.zPosition = self.zPosition
        self.addChild(self.defaultButton)
        
        self.activeButton.zPosition = self.zPosition
        self.addChild(self.activeButton)
        
        if let buttonIcon = self.buttonIcon {
            buttonIcon.zPosition = self.zPosition + 1
            self.addChild(buttonIcon)
        }
        
        self.buttonLabel.zPosition = self.zPosition + 1
        self.addChild(self.buttonLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        activeButton.isHidden = false
        defaultButton.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            
            if defaultButton.contains(location) {
                activeButton.isHidden = false
                defaultButton.isHidden = true
            } else {
                activeButton.isHidden = true
                defaultButton.isHidden = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            
            if defaultButton.contains(location) {
                action()
            }
            
            activeButton.isHidden = true
            defaultButton.isHidden = false
        }
    }
}

