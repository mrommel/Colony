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
    var buttonLabel: SKLabelNode
    var action: () -> Void
    
    init(titled title: String, defaultButtonImage: String, activeButtonImage: String, buttonAction: @escaping () -> Void) {
        
        // default button state
        self.defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        self.defaultButton.zPosition = 25
        
        // active button state
        self.activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        self.activeButton.zPosition = 25
        self.activeButton.isHidden = true
        
        self.action = buttonAction
        
        self.buttonLabel = SKLabelNode(text: title)
        self.buttonLabel.fontColor = UIColor.white
        self.buttonLabel.position = CGPoint(x: 0, y: 0)
        self.buttonLabel.fontSize = 18
        self.buttonLabel.zPosition = 30
        self.buttonLabel.fontName = "Helvetica-Bold"
        self.buttonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode(rawValue: 1)!
        self.buttonLabel.name = "buttonLabel"
        
        super.init()
        
        self.isUserInteractionEnabled = true
        self.addChild(self.defaultButton)
        self.addChild(self.activeButton)
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

