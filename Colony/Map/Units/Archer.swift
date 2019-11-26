//
//  Archer.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Archer: Unit {
    
    init(position: HexPoint, civilization: Civilization) {
        super.init(position: position, civilization: civilization, unitType: .archer)
    }
        
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func createGameObject() -> GameObject? {
        
        let gameObject = ArcherObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
}
