//
//  BoosterTypeNode.swift
//  Colony
//
//  Created by Michael Rommel on 28.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BoosterTypeNode: SKSpriteNode {
    
    var boosterTypeNode: SKSpriteNode?
    
    init(for boosterType: BoosterType) {
        
        let texture = SKTexture(imageNamed: "unit_frame")
        super.init(texture: texture, color: .black, size: CGSize(width: 48, height: 48))
        
        let boosterTypeTexture = SKTexture(imageNamed: boosterType.textureName)
        self.boosterTypeNode = SKSpriteNode(texture: boosterTypeTexture, color: .black, size: CGSize(width: 42, height: 42))
        self.boosterTypeNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.boosterTypeNode?.zPosition = self.zPosition + 0.1
        //self.boosterTypeNode.anchorPoint = .lowerLeft
        
        if let boosterTypeNode = self.boosterTypeNode {
            self.addChild(boosterTypeNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
