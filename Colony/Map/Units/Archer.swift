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
    
    override func handleBeganState(in game: Game?) {
        
        assert(self.state.transitioning == .began, "method can only handle .begin")
        
        if self.state.state == .ambushed {
            fatalError("[Archer] handle began ambushed")
        }
    }
    
    override func handleEndedState(in game: Game?) {
        
        assert(self.state.transitioning == .ended, "method can only handle .ended")
        
        if self.state.state == .ambushed {
            fatalError("[Archer] handle ended ambushed")
        }
    }
}
