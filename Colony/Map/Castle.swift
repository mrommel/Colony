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

class Castle: Codable {
    
    let name: String
    let position: HexPoint
    let civilization: Civilization
    let type: CastleType
    
    init(named name: String, at position: HexPoint, civilization: Civilization, type: CastleType) {
        
        self.name = name
        self.position = position
        self.civilization = civilization
        self.type = type
    }
}
