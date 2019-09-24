//
//  Castle.swift
//  Colony
//
//  Created by Michael Rommel on 26.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum CastleType: String, Codable {
    
    case normal
}

class Castle: MapItem {
    
    // MARK: properties
    
    let name: String
    let civilization: Civilization
    let type: CastleType
    
    // MARK: coding keys
    
    enum CastleCodingKeys: String, CodingKey {

        case name
        case civilization
        case type
    }
    
    init(named name: String, at position: HexPoint, civilization: Civilization, type: CastleType) {
        
        self.name = name
        self.civilization = civilization
        self.type = type
        
        super.init(at: position)
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CastleCodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.civilization = try values.decode(Civilization.self, forKey: .civilization)
        self.type = try values.decode(CastleType.self, forKey: .type)
        
        try super.init(from: decoder)
    }
}
