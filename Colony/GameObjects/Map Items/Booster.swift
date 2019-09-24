//
//  Booster.swift
//  Colony
//
//  Created by Michael Rommel on 11.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

/*class Booster: GameObject {
    
    static let keyDictBoosterType = "boosterType"
    
    var boosterType: BoosterType {
        get {
            if let boosterTypeStringValue = self.dict[Booster.keyDictBoosterType] as? String {
                if let boosterTypeValue = BoosterType(rawValue: boosterTypeStringValue) {
                    return boosterTypeValue
                }
            }
            
            fatalError("Can't parse booster type")
        }
        set {
            self.dict[Booster.keyDictBoosterType] = newValue.rawValue
        }
    }
    
    init(at point: HexPoint, boosterType: BoosterType) {
        
        let identifier = UUID()
        let identifierString = "booster-\(identifier.uuidString)"
        
        super.init(with: identifierString, type: .booster, at: point, spriteName: boosterType.textureName, anchorPoint: CGPoint(x: -1.0, y: -0.1), civilization: nil, sight: 1)
        
        self.boosterType = boosterType
        
        self.atlasIdle = GameObjectAtlas(atlasName: "booster", textures: [type.indicatorTextureName])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil

        self.animationSpeed = 8.0
    }
    
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
    }
    
    override func idle() {
        
        self.clearPathSpriteBuffer()
        self.state = AIUnitState.idleState()
        
        let pulseUp = SKAction.scale(to: 1.0, duration: 1.0)
        let pulseDown = SKAction.scale(to: 0.8, duration: 1.0)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let idleAnimation = SKAction.repeatForever(pulse)

        self.run(idleAnimation, withKey: GameObject.idleActionKey, completion: {})
    }
}*/
