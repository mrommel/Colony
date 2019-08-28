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
    
    static let keyDictWalls: String = "walls"
    static let keyDictSize: String = "size"
    
    weak var city: City? = nil
    
    var size: CitySize {
        get {
            if let wallsValue = self.dict[CityObject.keyDictSize] as? CitySize {
                return wallsValue
            }
            
            return .small
        }
        set {
            self.dict[CityObject.keyDictSize] = newValue
            self.updateAssets()
        }
    }
    
    var walls: Bool {
        get {
            if let wallsValue = self.dict[CityObject.keyDictWalls] as? Bool {
                return wallsValue
            }
            
            return false
        }
        set {
            self.dict[CityObject.keyDictWalls] = newValue
            self.updateAssets()
        }
    }
    
    var name: String {
        get {
            if let nameValue = self.dict[GameObject.keyDictName] as? String {
                return nameValue
            }
            
            return "City"
        }
        set {
            self.dict[GameObject.keyDictName] = newValue
        }
    }
    
    init(for city: City?) {
        
        let identifier = UUID()
        let identifierString = "city-\(identifier.uuidString)"
        
        self.city = city
        guard let position = city?.position else { fatalError() }
        let civilization = city?.civilization
        let name = city?.name ?? "City"
        
        super.init(with: identifierString, type: .city, at: position, spriteName: "city_1_no_walls", anchorPoint: CGPoint(x: -0.0, y: -0.0), civilization: civilization, sight: 2)
        
        self.name = name

        self.atlasIdle = GameObjectAtlas(atlasName: "city", textures: ["city_1_no_walls"])
        
        self.atlasDown = nil
        self.atlasUp = nil
        self.atlasLeft = nil
        self.atlasRight = nil
        
        self.movementType = .immobile
        
        self.showCity(named: self.name)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        // city name not set when loaded from file
        self.showCity(named: self.name)
    }
    
    // MARK: methods
    
    func updateAssets() {
        
        let textureName = self.size.textureName + (self.walls ? "_walls" : "_no_walls")
        
        self.atlasIdle = GameObjectAtlas(atlasName: "city", textures: [textureName])
        self.idle()
    }
}
