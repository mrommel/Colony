//
//  Field.swift
//  Colony
//
//  Created by Michael Rommel on 26.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum FieldType: String, Codable {
    
    case wheat
}

class Field: MapItem {
    
    // MARK: properties
    
    let civilization: Civilization
    let type: FieldType
    
    // MARK: coding keys
    
    enum FieldCodingKeys: String, CodingKey {

        case civilization
        case type
    }
    
    // MARK: constructors
    
    init(at position: HexPoint, civilization: Civilization, type: FieldType) {

        self.civilization = civilization
        self.type = type
        
        super.init(at: position)
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: FieldCodingKeys.self)
        
        self.civilization = try values.decode(Civilization.self, forKey: .civilization)
        self.type = try values.decode(FieldType.self, forKey: .type)
        
        try super.init(from: decoder)
    }
}
