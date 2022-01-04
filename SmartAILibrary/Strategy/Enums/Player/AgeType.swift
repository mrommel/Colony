//
//  AgeType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

// https://civilization.fandom.com/wiki/Age_(Civ6)
public enum AgeType: Int, Codable {

    case dark
    case normal
    case golden
    case heroic

    public func loyalityFactor() -> Double {

        switch self {

        case .dark: return 0.5
        case .normal: return 1.0
        case .golden, .heroic: return 1.5
        }
    }

    public func loyaltyEffect() -> String {

        switch self {

        case .dark: return "TXT_KEY_AGE_DARK_LOYALTY"
        case .normal: return "TXT_KEY_AGE_NORMAL_LOYALTY"
        case .golden, .heroic: return "TXT_KEY_AGE_GOLDEN_LOYALTY"
        }
    }

    public func summary() -> String {

        switch self {

        case .dark: return "TXT_KEY_AGE_DARK_SUMMARY"
        case .normal: return "TXT_KEY_AGE_NORMAL_SUMMARY"
        case .golden, .heroic: return "TXT_KEY_AGE_GOLDEN_SUMMARY"
        }
    }
}
