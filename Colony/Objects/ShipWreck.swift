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
    
    init(with identifier: String, at point: HexPoint) {
        super.init(with: identifier, type: .shipwreck, at: point, spriteName: "shipwreck01", tribe: .reward, sight: 1) // FIXME: new type obstacle
        
        self.atlasIdle = GameObjectAtlas(atlasName: "shipwreck", textures: ["shipwreck01", "shipwreck01", "shipwreck01"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.sprite.anchorPoint = CGPoint(x: -0.0, y: -0.0)
        
        self.canMoveByUserInput = false
        self.movementType = .immobile
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
