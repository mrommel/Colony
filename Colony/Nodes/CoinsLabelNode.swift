//
//  CoinsLabelNode.swift
//  Colony
//
//  Created by Michael Rommel on 02.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class CoinsLabelNode: SKNode {

    var coins: Int = 0 {
        didSet {
            self.coinsLabelNode.text = "\(coins)"
            self.coinsLabelNode.fontColor = coins < 0 ? .red : .white
        }
    }
    
    // nodes
    let coinsLabelNode: SKLabelNode!
    let coinsIconNode: SKSpriteNode!
    
    init(coins: Int) {
        
        let coinTexture = SKTexture(imageNamed: "coin1")
        self.coinsIconNode = SKSpriteNode(texture: coinTexture, size: CGSize(width: 24, height: 24))
        self.coinsLabelNode = SKLabelNode(text: "0")
        
        super.init() //sized: CGSize(width: 100, height: 24))
        
        self.coinsLabelNode.zPosition = self.zPosition + 1
        self.coinsLabelNode.position = CGPoint(x: 0, y: 0)
        self.coinsLabelNode.fontSize = 18
        self.coinsLabelNode.horizontalAlignmentMode = .right
        self.addChild(self.coinsLabelNode)
        
        self.coinsIconNode.zPosition = self.zPosition + 1
        self.coinsIconNode.position = CGPoint(x: 20, y: 6)
        self.addChild(self.coinsIconNode)

        self.coins = coins
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
