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

// taken from here: https://civilization-v-customisation.fandom.com/wiki/List_of_City-States
let cityNames = ["Almaty", "Antwerp", "Belgrade", "Bogota", "Bratislava", "Brussels", "Colombo", "Florence", "Geneva", "Genoa", "Jerusalem", "Lhasa", "Manila", "Melbourne", "Monaco", "Prague", "Riga", "Samarkand", "Sydney", "Tyre", "Vilnius", "Wittenberg", "Zurich"]

class CityObject: GameObject {
    
    var name: String = "City"
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
        
        self.name = name
        
        super.init(with: identifier, type: .city, at: point, spriteName: "city_1_no_walls", anchorPoint: CGPoint(x: -0.0, y: -0.0), civilization: civilization, sight: 2)
        
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
        
        self.showCity(named: self.name)
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
