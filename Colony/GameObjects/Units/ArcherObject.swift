//
//  ArcherObject.swift
//  Colony
//
//  Created by Michael Rommel on 16.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class ArcherObject: GameObject {
    
    init(for archer: Archer?) {
        
        let identifier = UUID()
        let identifierString = "archer-\(identifier.uuidString)"
        
        super.init(with: identifierString, unit: archer, spriteName: "archer-idle-00", anchorPoint: CGPoint(x: 0.0, y: 0.0))
        
        self.atlasIdle = GameObjectAtlas(atlasName: "archer", textures: ["archer-idle-00", "archer-idle-01", "archer-idle-02", "archer-idle-03", "archer-idle-04", "archer-idle-05", "archer-idle-06", "archer-idle-07", "archer-idle-08", "archer-idle-09"])
        
        self.atlasDown = GameObjectAtlas(atlasName: "archer", textures: ["archer-down-00", "archer-down-01", "archer-down-02", "archer-down-03", "archer-down-04", "archer-down-05", "archer-down-06", "archer-down-07", "archer-down-08", "archer-down-09", "archer-down-10", "archer-down-11", "archer-down-12", "archer-down-13", "archer-down-14"])
        self.atlasUp = GameObjectAtlas(atlasName: "archer", textures: ["axemann-up-0", "axemann-up-1", "axemann-up-2", "axemann-up-3", "axemann-up-4", "axemann-up-5", "axemann-up-6", "axemann-up-7"])
        self.atlasLeft = GameObjectAtlas(atlasName: "archer", textures: ["axemann-left-0", "axemann-left-1", "axemann-left-2", "axemann-left-3", "axemann-left-4", "axemann-left-5", "axemann-left-6", "axemann-left-7"])
        self.atlasRight = GameObjectAtlas(atlasName: "archer", textures: ["axemann-right-0", "axemann-right-1", "axemann-right-2", "axemann-right-3", "axemann-right-4", "axemann-right-5", "axemann-right-6", "axemann-right-7"])
        
        self.animationSpeed = 3
        
        self.showUnitTypeIndicator()
        self.showUnitStrengthIndicator()
    }
}
