//
//  StrengthType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum StrengthType: Int, Comparable {

    case immense
    case powerful
    case strong
    case average
    case poor
    case weak
    case pathetic
    
    static func < (lhs: StrengthType, rhs: StrengthType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
