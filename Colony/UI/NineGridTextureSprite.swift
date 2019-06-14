//
//  NineGridTextureSprite.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class NineGridTextureSprite: SKSpriteNode {
    
    init(imageNamed imageName: String, size: CGSize, isNineGrid: Bool = true) {
        let texture = SKTexture.init(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.black, size: size)
        
        if isNineGrid {
            setupNineGrid()
        }
    }
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, isNineGrid: Bool = true) {
        super.init(texture: texture, color: color, size: size)
        
        if isNineGrid {
            setupNineGrid()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNineGrid() {
        
        guard self.texture != nil else {
            return
        }

        self.centerRect = CGRect.init(x: 0.3333, y: 0.3333, width: 0.3333, height: 0.3333)
    }
}
