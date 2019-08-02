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
    
    var active: Bool = true
    
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
        let iconPosX = -size.half.width + 4 + iconSize.half.width
        self.buttonIcon?.position = CGPoint(x: iconPosX, y: 0)
        
        self.buttonLabel = SKLabelNode(text: title)
        self.buttonLabel.position = CGPoint(x: 0, y: 0)
        self.buttonLabel.fontColor = UIColor.white
        self.buttonLabel.fontSize = 18
        self.buttonLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        self.buttonLabel.verticalAlignmentMode = .center
        self.buttonLabel.horizontalAlignmentMode = .center // left
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
    
    // state management
    
    func enable() {
        
        self.active = true
        self.defaultButton.colorBlendFactor = 0.0
        self.defaultButton.color = .black
        
        self.buttonIcon?.colorBlendFactor = 0.0
        self.buttonIcon?.color = .black
        self.buttonLabel.colorBlendFactor = 0.0
        self.buttonLabel.color = .black
        
        self.activeButton.isHidden = true
        self.defaultButton.isHidden = false
    }
    
    func disable() {
        
        self.active = false
        self.defaultButton.colorBlendFactor = 0.8
        self.defaultButton.color = .gray
        
        self.buttonIcon?.colorBlendFactor = 0.4
        self.buttonIcon?.color = .black
        self.buttonLabel.colorBlendFactor = 0.4
        self.buttonLabel.color = .black
    }
    
    // action handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // skip action handling, when button is not active
        guard self.active else {
            activeButton.isHidden = true
            defaultButton.isHidden = false
            return
        }
        
        activeButton.isHidden = false
        defaultButton.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // skip action handling, when button is not active
        guard self.active else {
            activeButton.isHidden = true
            defaultButton.isHidden = false
            return
        }
        
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
        
        // skip action handling, when button is not active
        guard self.active else {
            activeButton.isHidden = true
            defaultButton.isHidden = false
            return
        }
        
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

