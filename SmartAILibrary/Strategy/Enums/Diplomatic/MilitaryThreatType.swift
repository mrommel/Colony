//
//  MilitaryThreatType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum MilitaryThreatType: Int, Codable {

    case none

    case minor
    case major
    case severe
    case critical

    static func < (lhs: MilitaryThreatType, rhs: MilitaryThreatType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    func weight() -> Int {

        switch self {

        case .none: return 0
        case .minor: return 1
        case .major: return 3
        case .severe: return 6
        case .critical: return 10
        }
    }
}
