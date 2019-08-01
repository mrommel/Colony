//
//  NotificationNode.swift
//  Colony
//
//  Created by Michael Rommel on 01.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class NotificationNode: NineGridTextureSprite {
    
    let messageLabelNode: SKLabelNode!
    
    init(message: String) {
        
        self.messageLabelNode = SKLabelNode(text: message)
        
        super.init(imageNamed: "background_notification", size: CGSize(width: 351, height: 30))
        
        self.messageLabelNode.zPosition = self.zPosition + 1
        self.messageLabelNode.position = CGPoint(x: 0, y: -6)
        self.messageLabelNode.fontSize = 18
        self.messageLabelNode.horizontalAlignmentMode = .center
        self.addChild(self.messageLabelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        
        self.messageLabelNode.position = CGPoint(x: 6, y: 6)
    }
}
