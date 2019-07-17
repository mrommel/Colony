//
//  ShipWreck.swift
//  Colony
//
//  Created by Michael Rommel on 07.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

import SpriteKit

class ShipWreck: GameObject {
    
    init(at point: HexPoint) {
        
        let identifier = UUID()
        let identifierString = "shipwreck-\(identifier.uuidString)"
        
        super.init(with: identifierString, type: .obstacle, at: point, spriteName: "shipwreck01", anchorPoint: CGPoint(x: -0.0, y: -0.0), tribe: .decoration, sight: 1)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "shipwreck", textures: ["shipwreck01", "shipwreck01", "shipwreck01"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.canMoveByUserInput = false
        self.movementType = .immobile
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
