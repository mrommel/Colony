//
//  PlayerTargetValueType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PlayerTargetValueType: Int, Comparable {
    
    case none
    
    case impossible
    case bad
    case average
    case favorable
    case soft
    
    static func < (lhs: PlayerTargetValueType, rhs: PlayerTargetValueType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    mutating func increase() {
        
        switch self {

        case .none:
            // NOOP
            break
        case .impossible:
            self = .bad
        case .bad:
            self = .average
        case .average:
            self = .favorable
        case .favorable:
            self = .soft
        case .soft:
            // NOOP
            break
        }
    }
    
    mutating func decrease() {
        
        switch self {

        case .none:
            // NOOP
            break
        case .impossible:
            // NOOP
            break
        case .bad:
            self = .impossible
        case .average:
            self = .bad
        case .favorable:
            self = .average
        case .soft:
            self = .favorable
        }
    }
}
