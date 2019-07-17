//
//  Coin.swift
//  Colony
//
//  Created by Michael Rommel on 01.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Coin: GameObject {
    
    init(at point: HexPoint) {
        
        let identifier = UUID()
        
        super.init(with: identifier.uuidString, type: .coin, at: point, spriteName: "coin1", anchorPoint: CGPoint(x: -1.0, y: -0.1), tribe: .reward, sight: 1)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "coin", textures: ["coin1", "coin2", "coin3", "coin4", "coin5", "coin6", "coin7", "coin8", "coin9", "coin10"])

        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.animationSpeed = 6.0
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
