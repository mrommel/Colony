//
//  MessageBoxNode.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MessageBoxNode: SKNode {
    
    var backgroundNode: SKSpriteNode
    var titleLabel: SKLabelNode
    //var action: () -> Void
    
    init(titled title: String) {
        
        // default button state
        self.backgroundNode = SKSpriteNode(imageNamed: "messageBox")
        self.backgroundNode.zPosition = 10
        
        self.titleLabel = SKLabelNode(text: title)
        self.titleLabel.fontColor = UIColor.white
        self.titleLabel.position = CGPoint(x: 0, y: 0)
        self.titleLabel.fontSize = 18
        self.titleLabel.zPosition = 30
        self.titleLabel.fontName = "Helvetica-Bold"
        self.titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode(rawValue: 1)!
        self.titleLabel.name = "titleLabel"
        
        super.init()
        
        self.isUserInteractionEnabled = true
        self.addChild(self.backgroundNode)
        self.addChild(self.titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
