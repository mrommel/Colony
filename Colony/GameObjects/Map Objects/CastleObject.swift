//
//  CastleObject.swift
//  Colony
//
//  Created by Michael Rommel on 26.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class CastleObject: GameObject {
    
    let castle: Castle?
    
    var name: String {
        get {
            if let nameValue = self.dict[GameObject.keyDictName] as? String {
                return nameValue
            }
            
            return "Castle"
        }
        set {
            self.dict[GameObject.keyDictName] = newValue
        }
    }
    
    init(for castle: Castle?) {
        
        let identifier = UUID()
        let identifierString = "castle-\(identifier.uuidString)"
        
        self.castle = castle
        guard let position = castle?.position else { fatalError() }
        let civilization = castle?.civilization
        let name = castle?.name ?? "Castle"
        
        super.init(with: identifierString, type: .city, at: position, spriteName: "castle", anchorPoint: CGPoint(x: -0.0, y: -0.0), civilization: civilization, sight: 2)
        
        self.name = name
        
        self.atlasIdle = GameObjectAtlas(atlasName: "castle", textures: ["castle"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.movementType = .immobile
        
        self.showCity(named: self.name)
    }
    
    required init(from decoder: Decoder) throws {
        
        self.castle = nil
        
        try super.init(from: decoder)
        
        // city name not set when loaded from file
        //self.showCity(named: self.name)
    }
}
