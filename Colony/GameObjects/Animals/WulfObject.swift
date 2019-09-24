//
//  Wulf.swift
//  Colony
//
//  Created by Michael Rommel on 30.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class WulfObject: GameObject {
    
    init(for animal: Animal?) {
        
        let identifier = UUID()
        let identifierString = "wulf-\(identifier.uuidString)"
        
        super.init(with: identifierString, animal: animal, spriteName: "wulf-left-0", anchorPoint: CGPoint(x: 0.0, y: 0.0))
        
        self.atlasIdle = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-left-0"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-down-0", "wulf-down-1", "wulf-down-2", "wulf-down-3", "wulf-down-4", "wulf-down-5", "wulf-down-6", "wulf-down-7", "wulf-down-8", "wulf-down-9"])
        self.atlasUp = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-up-0", "wulf-up-1", "wulf-up-2", "wulf-up-3", "wulf-up-4", "wulf-up-5", "wulf-up-6", "wulf-up-7", "wulf-up-8", "wulf-up-9"])
        self.atlasLeft = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-left-0", "wulf-left-1", "wulf-left-2", "wulf-left-3", "wulf-left-4", "wulf-left-5", "wulf-left-6", "wulf-left-7", "wulf-left-8", "wulf-left-9"])
        self.atlasRight = GameObjectAtlas(atlasName: "wulf", textures: ["wulf-right-0", "wulf-right-1", "wulf-right-2", "wulf-right-3", "wulf-right-4", "wulf-right-5", "wulf-right-6", "wulf-right-7", "wulf-right-8", "wulf-right-9"])
        
        self.set(zPosition: GameScene.Constants.ZLevels.featureUpper)
        self.animationSpeed = 2.5
    }
}
