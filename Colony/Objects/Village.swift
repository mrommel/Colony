//
//  Village.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

enum VillageSize {
    
    case small
    case medium
    case large
    
    static let all: [VillageSize] = [.small, .medium, .large]
    
    var textureName: String {
        
        switch self {
            
        case .small:
            return "city_1"
        case .medium:
            return "city_2"
        case .large:
            return "city_3"
        }
    }
}

class Village: GameObject {
    
    var name: String = "City"
    var size: VillageSize = .small {
        didSet {
            self.updateAssets()
        }
    }
    var walls: Bool = false {
        didSet {
            self.updateAssets()
        }
    }
    
    init(with identifier: String, at point: HexPoint, tribe: GameObjectTribe) {
        
        super.init(with: identifier, type: .village, at: point, spriteName: "city_1_no_walls", tribe: tribe, sight: 2)
        
        self.atlasIdle = GameObjectAtlas(atlasName: "village", textures: ["city_1_no_walls"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.sprite.anchorPoint = CGPoint(x: -0.0, y: -0.0)
        
        self.movementType = .immobile
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    // MARK: methods
    
    func updateAssets() {
        
        let textureName = self.size.textureName + (self.walls ? "_walls" : "_no_walls")
        
        self.atlasIdle = GameObjectAtlas(atlasName: "village", textures: [textureName])
        self.idle()
    }
    
    override func update(in game: Game?) {
        self.show(name: self.name)
    }
}
