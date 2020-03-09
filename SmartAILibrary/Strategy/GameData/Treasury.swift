//
//  Treasury.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

protocol AbstractTreasury {
    
    func add(gold goldDelta: Double)
    func value() -> Double
}

class Treasury: AbstractTreasury {

    // user properties / values
    var player: Player?
    var gold: Double
    //var lastGoldEarned: Double = 1.0

    // MARK: constructor
    
    init(player: Player?) {
        
        self.player = player
        self.gold = 0.0
    }
    
    func value() -> Double {
        
        return self.gold
    }
    
    func add(gold goldDelta: Double) {
        
        self.gold += goldDelta
    }
}
