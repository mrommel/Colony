//
//  CaravelObject.swift
//  Colony
//
//  Created by Michael Rommel on 31.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class CaravelObject: GameObject {
    
    init(for unit: Unit?) {
        
        let identifier = UUID()
        let identifierString = "caravel-\(identifier.uuidString)"
        
        super.init(with: identifierString, unit: unit, spriteName: "caravel-left-1", anchorPoint: CGPoint(x: -0.0, y: -0.0))
        
        self.atlasIdle = GameObjectAtlas(atlasName: "caravel", textures: ["caravel-left-1", "caravel-left-2", "caravel-left-3"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "caravel", textures: ["caravel-down-1", "caravel-down-2", "caravel-down-3"])
        self.atlasUp = GameObjectAtlas(atlasName: "caravel", textures: ["caravel-up-1", "caravel-up-2", "caravel-up-3"])
        self.atlasLeft = GameObjectAtlas(atlasName: "caravel", textures: ["caravel-left-1", "caravel-left-2", "caravel-left-3"])
        self.atlasRight = GameObjectAtlas(atlasName: "caravel", textures: ["caravel-right-1", "caravel-right-2", "caravel-right-3"])
        
        self.showUnitTypeIndicator()
        self.showUnitStrengthIndicator()
    }
}
