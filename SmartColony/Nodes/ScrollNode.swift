//
//  ScrollNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 21.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import UIKit

class ScrollNode: SKCropNode {
    
    // variables
    let size: CGSize
    var contentSize: CGSize
    
    // nodes
    var backgroundNode: SKSpriteNode?
    var scrollNode: SKNode?
    
    init(size: CGSize, contentSize: CGSize) {
        
        self.size = size
        self.contentSize = contentSize
        
        super.init()
        
        self.maskNode = SKSpriteNode(color: SKColor.black, size: self.size)
        
        self.isUserInteractionEnabled = true
        
        // background
        let textureName = "scroll_background" // <= replace?
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: 0.0, y: 0.0)
        self.backgroundNode?.zPosition = self.zPosition
        self.addChild(self.backgroundNode!)
        
        self.scrollNode = SKNode()
        self.scrollNode?.position = CGPoint(x: 0, y: 0)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        
        let touchLocation = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        let deltaY = (touchLocation.y) - (previousLocation.y)
        
        if abs(deltaY) < 0.1 {
            return
        }
        
        var newPositionY = self.scrollNode!.position.y + deltaY
        
        //print("swipe by: \(deltaY) to \(newPositionY)")
        
        if newPositionY > self.contentSize.height - self.size.height {
            newPositionY = self.contentSize.height - self.size.height
        }
        
        if newPositionY < 0.0 {
            newPositionY = 0.0
        }
        
        self.scrollNode?.position.y = newPositionY
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }

    func addScrolling(child: SKNode) {
        
        self.scrollNode?.addChild(child)
    }
}
