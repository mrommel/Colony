//
//  FieldObject.swift
//  Colony
//
//  Created by Michael Rommel on 28.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class FieldObject: GameObject {
    
    let field: Field?
    
    init(for field: Field?) {
        
        let identifier = UUID()
        let identifierString = "feild-\(identifier.uuidString)"
        
        self.field = field
        guard let position = field?.position else { fatalError() }
        let civilization = field?.civilization
        
        super.init(with: identifierString, type: .field, at: position, spriteName: "field", anchorPoint: CGPoint(x: -0.0, y: -0.0), civilization: civilization, sight: 0)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "field", textures: ["field"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.movementType = .immobile
    }
    
    required init(from decoder: Decoder) throws {
        
        self.field = nil
        
        try super.init(from: decoder)
        
        // city name not set when loaded from file
        //self.showCity(named: self.name)
    }
}
