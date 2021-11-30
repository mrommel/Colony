//
//  StrengthType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum StrengthType: Int, Codable, Comparable {

    case immense
    case powerful
    case strong
    case average
    case poor
    case weak
    case pathetic

    public static func < (lhs: StrengthType, rhs: StrengthType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public func name() -> String {

        switch self {

        case .immense: return "Immense"
        case .powerful: return "Powerful"
        case .strong: return "Strong"
        case .average: return "Average"
        case .poor: return "Poor"
        case .weak: return "Weak"
        case .pathetic: return "Pathetic"
        }
    }
}
