//
//  NineGridTextureSprite.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class NineGridTextureSprite: SKSpriteNode {
    
    init(imageNamed name: String, size: CGSize) {
        let texture = SKTexture.init(imageNamed: name)
        super.init(texture: texture, color: UIColor.black, size: size)
        
        setupNineGrid()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        setupNineGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNineGrid() {
        
        if let textureSize = self.texture?.size() {
            let dx = 0.3333
            let dy = 0.3333
            
            self.centerRect = CGRect.init(x: dx, y: dy, width: dx, height: dy)
        }
    }
}
