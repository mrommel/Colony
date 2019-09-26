//
//  HutObject.swift
//  Colony
//
//  Created by Michael Rommel on 26.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class HutObject: GameObject {
    
    init(for hut: Hut?) {
        
        let identifier = UUID()
        let identifierString = "hut-\(identifier.uuidString)"
        
        super.init(with: identifierString, mapItem: hut, spriteName: "hut", anchorPoint: CGPoint(x: -0.0, y: -0.0))
        
        self.atlasIdle = GameObjectAtlas(atlasName: "hut", textures: ["hut"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
    }
}
