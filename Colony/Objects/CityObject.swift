//
//  CityObject.swift
//  Colony
//
//  Created by Michael Rommel on 07.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

enum CitySize {
    
    case small
    case medium
    case large
    
    static let all: [CitySize] = [.small, .medium, .large]
    
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

class CityObject: GameObject {
    
    var size: CitySize = .small {
        didSet {
            self.updateAssets()
        }
    }
    var walls: Bool = false {
        didSet {
            self.updateAssets()
        }
    }
    
    init(with identifier: String, named name: String, at point: HexPoint, civilization: Civilization) {
        
        super.init(with: identifier, type: .city, at: point, spriteName: "city_1_no_walls", anchorPoint: CGPoint(x: -0.0, y: -0.0), civilization: civilization, sight: 2)
        
        self.name = name
        
        self.atlasIdle = GameObjectAtlas(atlasName: "city", textures: ["city_1_no_walls"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.movementType = .immobile
        
        self.showCity(named: self.name ?? "City")
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        self.showCity(named: self.name ?? "City")
    }
    
    // MARK: methods
    
    func updateAssets() {
        
        let textureName = self.size.textureName + (self.walls ? "_walls" : "_no_walls")
        
        self.atlasIdle = GameObjectAtlas(atlasName: "city", textures: [textureName])
        self.idle()
    }
    
    override func update(in game: Game?) {
        
    }
}
