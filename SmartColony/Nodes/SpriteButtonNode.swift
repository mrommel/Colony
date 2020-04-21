//
//  SpriteButtonNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class SpriteButtonNode: SKNode {
    
    var enabledButton: SKSpriteNode
    var hoverButton: SKSpriteNode
    var disabledButton: SKSpriteNode

    var buttonIcon: SKSpriteNode?
    var buttonLabel: SKLabelNode
    var action: () -> Void
    
    private var active: Bool = true
    
    init(titled title: String, enabledButtonImage: String, hoverButtonImage: String = "", disabledButtonImage: String, size: CGSize, isNineGrid: Bool = true, buttonAction: @escaping () -> Void) {
        
        // default button state
        self.enabledButton = NineGridTextureSprite(imageNamed: enabledButtonImage, size: size, isNineGrid: isNineGrid)
        
        // hover button state
        self.hoverButton = NineGridTextureSprite(imageNamed: hoverButtonImage.isEmpty ? enabledButtonImage : hoverButtonImage, size: size, isNineGrid: isNineGrid)
        self.hoverButton.isHidden = true
        
        // active button state
        self.disabledButton = NineGridTextureSprite(imageNamed: disabledButtonImage, size: size, isNineGrid: isNineGrid)
        self.disabledButton.isHidden = true
        
        self.action = buttonAction
        
        self.buttonLabel = SKLabelNode(text: title)
        self.buttonLabel.position = CGPoint(x: 0, y: 0)
        self.buttonLabel.fontColor = UIColor.white
        self.buttonLabel.fontSize = 18
        self.buttonLabel.fontName = Globals.Fonts.customFontFamilyname
        self.buttonLabel.verticalAlignmentMode = .center
        self.buttonLabel.name = "buttonLabel"
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.enabledButton.zPosition = self.zPosition
        self.addChild(self.enabledButton)
        
        self.disabledButton.zPosition = self.zPosition
        self.addChild(self.disabledButton)
        
        self.buttonLabel.zPosition = self.zPosition + 1
        self.addChild(self.buttonLabel)
    }
    
    init(imageNamed imageName: String, title: String, enabledButtonImage: String, hoverButtonImage: String = "", disabledButtonImage: String, size: CGSize, isNineGrid: Bool = true, buttonAction: @escaping () -> Void) {
        
        // default button state
        self.enabledButton = NineGridTextureSprite(imageNamed: enabledButtonImage, size: size, isNineGrid: isNineGrid)
        
        // hover button state
        self.hoverButton = NineGridTextureSprite(imageNamed: hoverButtonImage.isEmpty ? enabledButtonImage : hoverButtonImage, size: size, isNineGrid: isNineGrid)
        self.hoverButton.isHidden = true
        
        // active button state
        self.disabledButton = NineGridTextureSprite(imageNamed: disabledButtonImage, size: size, isNineGrid: isNineGrid)
        self.disabledButton.isHidden = true
        
        self.action = buttonAction
        
        let buttonIconTexture = SKTexture(imageNamed: imageName)
        let iconWidth = size.height - 8
        let iconHeight = buttonIconTexture.size().height * iconWidth / buttonIconTexture.size().width
        let iconSize = CGSize(width: iconWidth, height: iconHeight)
        self.buttonIcon = SKSpriteNode(texture: buttonIconTexture, color: .black, size: iconSize)
        let iconPosX = -size.half.width + 4 + iconSize.half.width
        self.buttonIcon?.position = CGPoint(x: iconPosX, y: 0)
        
        self.buttonLabel = SKLabelNode(text: title)
        self.buttonLabel.position = CGPoint(x: 0, y: 0)
        self.buttonLabel.fontColor = UIColor.white
        self.buttonLabel.fontSize = 18
        self.buttonLabel.fontName = Globals.Fonts.customFontFamilyname
        self.buttonLabel.verticalAlignmentMode = .center
        self.buttonLabel.horizontalAlignmentMode = .center // left
        self.buttonLabel.name = "buttonLabel"
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.enabledButton.zPosition = self.zPosition
        self.addChild(self.enabledButton)
        
        self.hoverButton.zPosition = self.zPosition
        self.addChild(self.hoverButton)
        
        self.disabledButton.zPosition = self.zPosition
        self.addChild(self.disabledButton)
        
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
    
    // properties
    
    var fontColor: UIColor? {
        set {
            self.buttonLabel.fontColor = newValue
        }
        get {
            return self.buttonLabel.fontColor
        }
    }
    
    var fontSize: CGFloat {
        set {
            self.buttonLabel.fontSize = newValue
        }
        get {
            return self.buttonLabel.fontSize
        }
    }
    
    var title: String {
        set {
            self.buttonLabel.text = newValue
        }
        get {
            return self.buttonLabel.text ?? "--"
        }
    }
    
    // state management
    
    func enable() {
        
        self.active = true
        /*self.enabledButton.colorBlendFactor = 0.0
        self.enabledButton.color = .black
        
        self.buttonIcon?.colorBlendFactor = 0.0
        self.buttonIcon?.color = .black
        self.buttonLabel.colorBlendFactor = 0.0
        self.buttonLabel.color = .black*/
        
        self.disabledButton.isHidden = true
        self.hoverButton.isHidden = true
        self.enabledButton.isHidden = false
    }
    
    func disable() {
        
        self.active = false
        /*self.enabledButton.colorBlendFactor = 0.8
        self.enabledButton.color = .gray
        
        self.buttonIcon?.colorBlendFactor = 0.4
        self.buttonIcon?.color = .black
        self.buttonLabel.colorBlendFactor = 0.4
        self.buttonLabel.color = .black*/
        
        self.disabledButton.isHidden = false
        self.hoverButton.isHidden = true
        self.enabledButton.isHidden = true
    }
    
    // action handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // skip action handling, when button is not active
        guard self.active else {
            self.disabledButton.isHidden = true
            self.hoverButton.isHidden = true
            self.enabledButton.isHidden = false
            return
        }
        
        self.disabledButton.isHidden = true
        self.hoverButton.isHidden = false
        self.enabledButton.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // skip action handling, when button is not active
        guard self.active else {
            self.disabledButton.isHidden = true
            self.hoverButton.isHidden = false
            self.enabledButton.isHidden = true
            return
        }
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            
            if enabledButton.contains(location) {
                self.disabledButton.isHidden = true
                self.hoverButton.isHidden = false
                self.enabledButton.isHidden = true
            } else {
                self.disabledButton.isHidden = true
                self.hoverButton.isHidden = true
                self.enabledButton.isHidden = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // skip action handling, when button is not active
        guard self.active else {
            self.disabledButton.isHidden = true
            self.hoverButton.isHidden = false
            self.enabledButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.disabledButton.isHidden = false
                self.hoverButton.isHidden = true
                self.enabledButton.isHidden = true
            })
            return
        }
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            
            if enabledButton.contains(location) {
                self.action()
            }
            
            self.disabledButton.isHidden = true
            self.hoverButton.isHidden = true
            self.enabledButton.isHidden = false
        }
    }
}
