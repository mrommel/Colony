//
//  CastleObject.swift
//  Colony
//
//  Created by Michael Rommel on 26.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class CastleObject: GameObject {
    
    init(for castle: Castle?) {
        
        let identifier = UUID()
        let identifierString = "castle-\(identifier.uuidString)"
        
        super.init(with: identifierString, mapItem: castle, spriteName: "castle", anchorPoint: CGPoint(x: -0.0, y: -0.0))
        
        self.atlasIdle = GameObjectAtlas(atlasName: "castle", textures: ["castle"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        //self.showCity(named: self.name)
    }
}
