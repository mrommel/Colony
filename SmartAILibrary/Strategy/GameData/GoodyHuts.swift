//
//  GoodyHuts.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 08.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GoodyHuts {
    
    let player: AbstractPlayer?
    var recentGoody: [GoodyType] = []
    
    init(player: AbstractPlayer?) {
        
        self.player = player
    }
    
    /// Are we allowed to get this Goody right now?
    /// Have we gotten this type of Goody lately? (in the last 3 Goodies, defined by NUM_GOODIES_REMEMBERED)
    func canReceive(goody: GoodyType) -> Bool {
        
        if self.recentGoody.contains(goody) {
            return false
        }
        
        return true
    }
}
