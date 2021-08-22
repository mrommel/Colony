//
//  AggressivePostureType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 19.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum AggressivePostureType: Int, Comparable, Codable {

    case none

    case low
    case medium
    case high
    case incredible

    func increased() -> AggressivePostureType {

        switch self {

        case .none:
            fatalError("cant increase none")
        case .low: return .medium
        case .medium: return .high
        case .high: return .incredible
        case .incredible:
            fatalError("cant increase incredible")
        }
    }

    static func < (lhs: AggressivePostureType, rhs: AggressivePostureType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
