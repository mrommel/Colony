//
//  Ship.swift
//  Colony
//
//  Created by Michael Rommel on 31.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class ShipObject: GameObject {
    
    init(with identifier: String, at point: HexPoint, civilization: Civilization) {
        super.init(with: identifier, type: .ship, at: point, spriteName: "ship060", anchorPoint: CGPoint(x: -0.3, y: -0.1), civilization: civilization, sight: 2)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "ship", textures: ["ship060", "ship061", "ship062"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "ship", textures: ["ship048", "ship049", "ship050"])
        self.atlasUp = GameObjectAtlas(atlasName: "ship", textures: ["ship084", "ship085", "ship086"])
        self.atlasLeft = GameObjectAtlas(atlasName: "ship", textures: ["ship060", "ship061", "ship062"])
        self.atlasRight = GameObjectAtlas(atlasName: "ship", textures: ["ship072", "ship073", "ship074"])
        
        self.canMoveByUserInput = true
        self.movementType = .swimOcean
        
        self.showUnitIndicator()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
