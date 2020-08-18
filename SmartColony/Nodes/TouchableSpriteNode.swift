//
//  TouchableSpriteNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol TouchableDelegate: class {
    
    func clicked(on identifier: String)
}

class TouchableSpriteNode : SKSpriteNode {
    
    var touchHandler: (()->Void)?
    weak var delegate: TouchableDelegate?
    var identifier: String?
    
    convenience init(imageNamed imageName: String, size: CGSize) {
        let texture = SKTexture(imageNamed: imageName)
        self.init(texture: texture, size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let handler = self.touchHandler {
            handler()
        } else if let identifier = self.identifier {
            self.delegate?.clicked(on: identifier)
        }
    }
}
