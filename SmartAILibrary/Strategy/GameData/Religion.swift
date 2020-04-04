//
//  Religion.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractReligion {
    
    func add(faith faithDelta: Double)
}
 
class Religion: AbstractReligion {
    
    // user properties / values
    var player: Player?
    var faith: Double
    
    // MARK: constructor
    
    init(player: Player?) {
        
        self.player = player
        self.faith = 0.0
    }
    
    func add(faith faithDelta: Double) {
        
        self.faith += faithDelta
    }
}
