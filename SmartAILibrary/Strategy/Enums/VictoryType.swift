//
//  VictoryType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum VictoryType: Int, Codable, Comparable {

    case domination
    case cultural
    case science
    case diplomatic
    case religious
    case score
    case conquest

    static var all: [VictoryType] {
        return [.domination, .cultural, .science, .diplomatic, .religious, .conquest]
    }

    public static func < (lhs: VictoryType, rhs: VictoryType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
