//
//  Ship.swift
//  Colony
//
//  Created by Michael Rommel on 31.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Ship: GameObject {
    
    init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay) {
        super.init(with: identifier, at: point, sprite: "ship060", mapDisplay: mapDisplay)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "ship", textures: ["ship060", "ship061", "ship062"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "ship", textures: ["ship048", "ship049", "ship050"])
        self.atlasUp = GameObjectAtlas(atlasName: "ship", textures: ["ship084", "ship085", "ship086"])
        self.atlasLeft = GameObjectAtlas(atlasName: "ship", textures: ["ship060", "ship061", "ship062"])
        self.atlasRight = GameObjectAtlas(atlasName: "ship", textures: ["ship072", "ship073", "ship074"])
        
        self.sprite.anchorPoint = CGPoint(x: -0.3, y: -0.1)
    }
    
    override func sight() -> Int {
        return 2
    }
}
