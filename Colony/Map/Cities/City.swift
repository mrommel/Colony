//
//  City.swift
//  Colony
//
//  Created by Michael Rommel on 14.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class City: Decodable {
    
    // MARK: properties
    
    let name: String
    let position: HexPoint
    let civilization: Civilization
    let population: Float
    
    // MARK: UI connection
    
    var gameObject: GameObject? = nil
    
    // MARK: coding keys
    
    enum CodingKeys: String, CodingKey {

        case name
        case position
        case civilization
        case population
    }
    
    init(named name: String, at position: HexPoint, civilization: Civilization) {
        
        self.name = name
        self.position = position
        self.civilization = civilization
        self.population = 1.0
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try values.decode(String.self, forKey: .name)
        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.civilization = try values.decode(Civilization.self, forKey: .civilization)
        self.population = try values.decode(Float.self, forKey: .population)
    }
    
    func createGameObject() -> GameObject? {

        let gameObject = CityObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
}

extension City: Encodable {
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.civilization, forKey: .civilization)
        try container.encode(self.population, forKey: .population)
    }
}
