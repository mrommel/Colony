//
//  UnitStrengthIndicator.swift
//  Colony
//
//  Created by Michael Rommel on 13.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class UnitStrengthIndicator: SKNode {
    
    private static let kProgressAnimationKey = "progressAnimationKey"
    
    var progressBar: SKCropNode?
    var barImageNode: SKSpriteNode?
    
    init(strength: Int) {
        
        let size = CGSize(width: 3, height: 20)
        let sizeDouble = CGSize(width: 6, height: 40)
        
        super.init()
        //self.colorBlendFactor = 0.5
        
        let frameTexture = SKTexture(imageNamed: "unit_strength_frame")
        let frameImageNode = SKSpriteNode(texture: frameTexture, color: .black, size: size)
        frameImageNode.position = CGPoint(x: 0.0, y: 0.0)
        frameImageNode.anchorPoint = CGPoint.lowerLeft
        frameImageNode.zPosition = self.zPosition + 1
        self.addChild(frameImageNode)
        
        self.progressBar = SKCropNode()
        self.progressBar?.position = CGPoint(x: 0.0, y: 0.0)
        self.progressBar?.zPosition = self.zPosition - 0.1
        
        let barTexture = SKTexture(imageNamed: "unit_strength_bar")
        self.barImageNode = SKSpriteNode(texture: barTexture, color: .green, size: size)
        self.barImageNode?.position = CGPoint(x: 0.0, y: 0.0)
        self.barImageNode?.anchorPoint = CGPoint.lowerLeft
        self.barImageNode?.colorBlendFactor = 0.9
        self.progressBar?.addChild(self.barImageNode!)
        
        let maskNode = SKSpriteNode(color: UIColor.white, size: sizeDouble)
        maskNode.position = CGPoint(x: 0, y: 0)
        maskNode.yScale = 0.0
        maskNode.xScale = 1.0
        self.progressBar?.maskNode = maskNode
        
        self.addChild(self.progressBar!)
        
        self.set(strength: strength)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(strength: Int) {
        
        self.progressBar?.maskNode?.removeAction(forKey: UnitStrengthIndicator.kProgressAnimationKey)
        
        let relStrength = CGFloat(strength) / 10.0
        let value = max(0.0, min(1.0, relStrength))
        
        let scaleAction = SKAction.scaleY(to: value, duration: 0.3)
        
        if strength >= 5 {
            self.barImageNode?.color = .green
        } else if strength >= 2 && strength <= 4 {
            self.barImageNode?.color = .yellow
        } else {
            self.barImageNode?.color = .red
        }
        
        self.progressBar?.maskNode?.run(scaleAction, withKey: UnitStrengthIndicator.kProgressAnimationKey)
    }
}
