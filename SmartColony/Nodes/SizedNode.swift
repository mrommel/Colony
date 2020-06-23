//
//  SizedNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
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
    
    var size: CGSize {
        
        return self.frame.size
    }
    
    override func contains(_ p: CGPoint) -> Bool {
        
        let offsetX = self.frame.width * self.anchorPoint.x
        let offsetY = self.frame.height * self.anchorPoint.y
        
        let pointToCheck = p + CGPoint(x: offsetX, y: offsetY)
        
        return self.internalFrame.contains(pointToCheck)
    }
    
    func updateLayout() {
        
        for child in self.children {
            if let sizedChild = child as? SizedNode {
                sizedChild.updateLayout()
            }
        }
    }
}
