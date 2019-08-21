//
//  Axeman.swift
//  Colony
//
//  Created by Michael Rommel on 11.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Axeman: GameObject {
    
    init(with identifier: String, at point: HexPoint, civilization: Civilization) {
        
        super.init(with: identifier, type: .axeman, at: point, spriteName: "axemann-idle-0", anchorPoint: CGPoint(x: 0.0, y: 0.0), civilization: civilization, sight: 2)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "axeman", textures: ["axemann-idle-0", "axemann-idle-1", "axemann-idle-2", "axemann-idle-3"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "axeman", textures: ["axemann-down-0", "axemann-down-1", "axemann-down-2", "axemann-down-3", "axemann-down-4", "axemann-down-5", "axemann-down-6", "axemann-down-7"])
        self.atlasUp = GameObjectAtlas(atlasName: "axeman", textures: ["axemann-up-0", "axemann-up-1", "axemann-up-2", "axemann-up-3", "axemann-up-4", "axemann-up-5", "axemann-up-6", "axemann-up-7"])
        self.atlasLeft = GameObjectAtlas(atlasName: "axeman", textures: ["axemann-left-0", "axemann-left-1", "axemann-left-2", "axemann-left-3", "axemann-left-4", "axemann-left-5", "axemann-left-6", "axemann-left-7"])
        self.atlasRight = GameObjectAtlas(atlasName: "axeman", textures: ["axemann-right-0", "axemann-right-1", "axemann-right-2", "axemann-right-3", "axemann-right-4", "axemann-right-5", "axemann-right-6", "axemann-right-7"])

        self.canMoveByUserInput = true
        self.movementType = .walk
        self.animationSpeed = 3
        
        self.showUnitTypeIndicator()
        self.showUnitStrengthIndicator()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func handleBeganState(in game: Game?) {
        assert(self.state.transitioning == .began, "method can only handle .begin")
        
        if self.state.state == .ambushed {
            fatalError("[Axeman] handle began ambushed")
        }
    }
    
    override func handleEndedState(in game: Game?) {
        
        assert(self.state.transitioning == .ended, "method can only handle .ended")
        
        if self.state.state == .ambushed {
            fatalError("[Axeman] handle ended ambushed")
        }
    }
}
