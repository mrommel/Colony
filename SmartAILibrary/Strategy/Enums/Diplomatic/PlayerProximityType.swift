//
//  PlayerProximityType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PlayerProximityType: Int, Comparable, Codable {
    
    case none
    
    case neighbors
    case close
    case far
    case distant
    
    static func < (lhs: PlayerProximityType, rhs: PlayerProximityType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
