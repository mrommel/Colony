//
//  Village.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Village: GameObject {
    
    init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay, tribe: GameObjectTribe) {
        
        super.init(with: identifier, at: point, spriteName: "village0", mapDisplay: mapDisplay, tribe: tribe)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        self.atlasUp = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        self.atlasLeft = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        self.atlasRight = GameObjectAtlas(atlasName: "village", textures: ["village0"])
        
        self.sprite.anchorPoint = CGPoint(x: -0.0, y: -0.0)
    }
    
    override func sight() -> Int {
        return 2
    }
}
