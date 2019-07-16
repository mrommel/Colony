//
//  UnitIndicator.swift
//  Colony
//
//  Created by Michael Rommel on 16.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class UnitIndicator: SKSpriteNode {
    
    let tribe: GameObjectTribe
    let unitType: GameObjectType
    
    init(tribe: GameObjectTribe, unitType: GameObjectType) {
        self.tribe = tribe
        self.unitType = unitType
        
        let texture = SKTexture(imageNamed: unitType.textureName)
        super.init(texture: texture, color: tribe.color, size: CGSize(width: 48, height: 48))
        self.colorBlendFactor = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
