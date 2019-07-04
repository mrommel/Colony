//
//  SizedNode.swift
//  Colony
//
//  Created by Michael Rommel on 03.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class SizedNode: SKNode {
    
    private var internalFrame: CGRect
    var anchorPoint: CGPoint = .middleCenter
    
    init(sized size: CGSize) {
        self.internalFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        return self.internalFrame
    }
    
    override var position: CGPoint {
        get {
            return self.internalFrame.origin
        }
        set {
            let offsetX = self.frame.width * self.anchorPoint.x
            let offsetY = self.frame.height * self.anchorPoint.y
            
            self.internalFrame.origin = CGPoint(x: newValue.x - offsetX, y: newValue.y - offsetY)
        }
    }
    
    func updateLayout() {
        
        for child in self.children {
            if let sizedChild = child as? SizedNode {
                sizedChild.updateLayout()
            }
        }
    }
}