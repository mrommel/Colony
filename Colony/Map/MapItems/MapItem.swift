//
//  MapItem.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class MapItem: Codable {
    
    // MARK: properties
    
    let position: HexPoint
    let type: MapItemType
    var dict: [String: Any]
    
    // MARK: UI connection
    
    var gameObject: GameObject? = nil
    
    // MARK: coding keys
    
    enum CodingKeys: String, CodingKey {

        case position
        case type
        case dict
    }
    
    init(at position: HexPoint, type: MapItemType) {
        
        self.position = position
        self.type = type
        self.dict = [:]
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.type = try values.decode(MapItemType.self, forKey: .type)
        self.dict = try values.decode([String: Any].self, forKey: .dict)
        
        self.loadFromDict()
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        self.saveToDict()
        
        try container.encode(self.position, forKey: .position)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.dict, forKey: .dict)
    }
    
    func saveToDict() {
        fatalError("must be overridden by subclass")
    }
    
    func loadFromDict() {
        //fatalError("must be overridden by subclass")
    }
}

