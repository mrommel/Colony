//
//  FieldObject.swift
//  Colony
//
//  Created by Michael Rommel on 28.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class FieldObject: GameObject {
    
    init(for field: Field?) {
        
        let identifier = UUID()
        let identifierString = "field-\(identifier.uuidString)"
        
        super.init(with: identifierString, mapItem: field, spriteName: "field", anchorPoint: CGPoint(x: -0.0, y: -0.0))
        
        self.atlasIdle = GameObjectAtlas(atlasName: "field", textures: ["field"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
    }
}
