//
//  TacticalCity.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// Object stored in the list of current move cities (currentMoveCities)
class TacticalCity: Comparable {

    let attackStrength: Int
    var expectedTargetDamage: Int
    let city: AbstractCity?
    
    init(attackStrength: Int = 0, expectedTargetDamage: Int = 0, city: AbstractCity? = nil) {
        
        self.attackStrength = attackStrength
        self.expectedTargetDamage = expectedTargetDamage
        self.city = city
    }
    
    static func < (lhs: TacticalCity, rhs: TacticalCity) -> Bool {
        
        return lhs.attackStrength > rhs.attackStrength
    }
    
    static func == (lhs: TacticalCity, rhs: TacticalCity) -> Bool {
        
        return false
    }
}
