//
//  PolicyCardNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class PolicyCardNode: SKNode {

    // nodes
    var backgroundNode: SKSpriteNode?
    var nameLabel: SKLabelNode?
    
    // MARK: constructors
    
    init(policyCard: PolicyCardType) {
        
        super.init()
        
        let size = CGSize(width: 100, height: 100)
        
        let texture = SKTexture(imageNamed: policyCard.iconTexture())
        self.backgroundNode = SKSpriteNode(texture: texture, color: .black, size: size)
        //self.backgroundNode?.anchorPoint = CGPoint.upperLeft
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        self.nameLabel = SKLabelNode(text: policyCard.name())
        self.nameLabel?.fontSize = 10
        self.nameLabel?.verticalAlignmentMode = .center
        self.nameLabel?.position = CGPoint(x: size.halfWidth, y: -20)
        self.addChild(self.nameLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
