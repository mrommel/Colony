//
//  GalleonObject.swift
//  Colony
//
//  Created by Michael Rommel on 26.11.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class GalleonObject: GameObject {
    
    init(for unit: Unit?) {
        
        let identifier = UUID()
        let identifierString = "galleon-\(identifier.uuidString)"
        
        super.init(with: identifierString, unit: unit, spriteName: "galleon-left-1", anchorPoint: CGPoint(x: -0.0, y: -0.0))
        
        self.atlasIdle = GameObjectAtlas(atlasName: "galleon", textures: ["galleon-left-1", "galleon-left-2", "galleon-left-3"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "galleon", textures: ["galleon-down-1", "galleon-down-2", "galleon-down-3"])
        self.atlasUp = GameObjectAtlas(atlasName: "galleon", textures: ["galleon-up-1", "galleon-up-2", "galleon-up-3"])
        self.atlasLeft = GameObjectAtlas(atlasName: "galleon", textures: ["galleon-left-1", "galleon-left-2", "galleon-left-3"])
        self.atlasRight = GameObjectAtlas(atlasName: "galleon", textures: ["galleon-right-1", "galleon-right-2", "galleon-right-3"])
        
        self.showUnitTypeIndicator()
        self.showUnitStrengthIndicator()
    }
}
