//
//  Galleon.swift
//  Colony
//
//  Created by Michael Rommel on 26.11.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Galleon: Unit {
    
    init(position: HexPoint, civilization: Civilization) {
        super.init(position: position, civilization: civilization, unitType: .galleon)
    }
        
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func createGameObject() -> GameObject? {

        let gameObject = GalleonObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
}
