//
//  AgeType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Age_(Civ6)
public enum AgeType: Int, Codable {

    case dark
    case normal
    case golden
    case heroic

    public func loyalityFactor() -> Double {

        switch self {

        case .dark:
            return 0.5
        case .normal:
            return 1.0
        case .golden, .heroic:
            return 1.5
        }
    }
}
