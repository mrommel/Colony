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

class Field: Codable {
    
    let name: String
    let position: HexPoint
    let civilization: Civilization
    let type: FieldType
    
    init(named name: String, at position: HexPoint, civilization: Civilization, type: FieldType) {
        
        self.name = name
        self.position = position
        self.civilization = civilization
        self.type = type
    }
}
