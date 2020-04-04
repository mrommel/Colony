//
//  TouchableSpriteNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class TouchableSpriteNode : SKSpriteNode {
    
    var touchHandler: (()->Void)?
    
    convenience init(imageNamed imageName: String, size: CGSize) {
        let texture = SKTexture(imageNamed: imageName)
        self.init(texture: texture, size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let handler = self.touchHandler {
            handler()
        }
    }
}
