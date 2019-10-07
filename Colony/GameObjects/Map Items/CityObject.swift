//
//  CityObject.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class CityObject: GameObject {
    
    init(for city: City?) {
        
        let identifier = UUID()
        let identifierString = "city-\(identifier.uuidString)"
        
        super.init(with: identifierString, city: city, spriteName: "hex_city", anchorPoint: CGPoint(x: -0.0, y: -0.0))

        self.atlasIdle = GameObjectAtlas(atlasName: "city", textures: ["hex_city"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
    }
}
