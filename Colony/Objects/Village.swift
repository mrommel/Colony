//
//  Village.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Village: GameObject {
    
    init(with identifier: String, at point: HexPoint, tribe: GameObjectTribe) {
        
        super.init(with: identifier, at: point, spriteName: "village0", tribe: tribe, sight: 2)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        self.atlasUp = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        self.atlasLeft = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        self.atlasRight = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        
        self.sprite.anchorPoint = CGPoint(x: -0.0, y: -0.0)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
