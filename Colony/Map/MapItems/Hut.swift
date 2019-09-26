//
//  Hut.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class Hut: MapItem {
    
    // MARK: constructors
    
    init(at position: HexPoint) {
        
        super.init(at: position, type: .hut)
    }
    
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
    }
    
    // MARK: methods
    
    func createGameObject() -> GameObject? {

        let gameObject = HutObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
    
    override func saveToDict() {
        
        // NOOP
    }
    
    override func loadFromDict() {
        
        // NOOP
    }
}
