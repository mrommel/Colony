//
//  Monster.swift
//  Colony
//
//  Created by Michael Rommel on 30.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Monster: GameObject {
    
    init(with identifier: String, at point: HexPoint, tribe: GameObjectTribe) {
        super.init(with: identifier, at: point, spriteName: "tile004", tribe: tribe, sight: 1)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "monster", textures: ["tile004", "tile005", "tile006", "tile007"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "monster", textures: ["tile000", "tile001", "tile002", "tile003"])
        self.atlasUp = GameObjectAtlas(atlasName: "monster", textures: ["tile012", "tile013", "tile014", "tile015"])
        self.atlasLeft = GameObjectAtlas(atlasName: "monster", textures: ["tile004", "tile005", "tile006", "tile007"])
        self.atlasRight = GameObjectAtlas(atlasName: "monster", textures: ["tile008", "tile009", "tile010", "tile011"])
        
        self.sprite.anchorPoint = CGPoint(x: 0.0, y: -0.3)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
