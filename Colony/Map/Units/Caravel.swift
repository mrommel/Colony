//
//  Caravel.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class Caravel: Unit {
    
    init(position: HexPoint, civilization: Civilization) {
        super.init(position: position, civilization: civilization, unitType: .caravel)
    }
        
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func createGameObject() -> GameObject? {

        let gameObject = CaravelObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
}
