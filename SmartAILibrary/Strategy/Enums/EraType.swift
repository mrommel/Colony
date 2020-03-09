//
//  EraType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum EraType {
    
    case ancient
    case classical
    case medieval
    case renaissance
    case industrial
    case modern
    case atomic
    
    internal func value() -> Int {
        
        switch self {
            
        case .ancient: return 0
        case .classical: return 1
        case .medieval: return 2
        case .renaissance: return 3
        case .industrial: return 4
        case .modern: return 5
        case .atomic: return 6
        }
    }
}

extension EraType: Comparable {
    
    static func == (lhs: EraType, rhs: EraType) -> Bool {
        return lhs.value() == rhs.value()
    }
    
    static func < (lhs: EraType, rhs: EraType) -> Bool {
        return lhs.value() < rhs.value()
    }
}
