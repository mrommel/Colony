//
//  GameConditionCheck.swift
//  Colony
//
//  Created by Michael Rommel on 11.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class GameConditionCheck {
    
    var identifier: String {
        fatalError("any subclass must override")
    }
    
    weak var game: Game?
    
    func isWon() -> GameConditionType? {
        fatalError("any subclass must override")
    }
    
    func isLost() -> GameConditionType? {
        fatalError("any subclass must override")
    }
}
