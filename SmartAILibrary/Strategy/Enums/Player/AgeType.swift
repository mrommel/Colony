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

    public func numDedicationsSelectable() -> Int {

        switch self {

        case .dark: return 1
        case .normal, .golden: return 1
        case .heroic: return 2
        }
    }

    public func name() -> String {

        switch self {

        case .dark: return "TXT_KEY_AGE_DARK_NAME"
        case .normal: return "TXT_KEY_AGE_NORMAL_NAME"
        case .golden: return "TXT_KEY_AGE_GOLDEN_NAME"
        case .heroic: return "TXT_KEY_AGE_HEROIC_NAME"
        }
    }

    public func loyaltyEffect() -> String {

        switch self {

        case .dark: return "TXT_KEY_AGE_DARK_LOYALTY"
        case .normal: return "TXT_KEY_AGE_NORMAL_LOYALTY"
        case .golden: return "TXT_KEY_AGE_GOLDEN_LOYALTY"
        case .heroic: return "TXT_KEY_AGE_HEROIC_LOYALTY"
        }
    }

    public func summary() -> String {

        switch self {

        case .dark: return "TXT_KEY_AGE_DARK_SUMMARY"
        case .normal: return "TXT_KEY_AGE_NORMAL_SUMMARY"
        case .golden: return "TXT_KEY_AGE_GOLDEN_SUMMARY"
        case .heroic: return "TXT_KEY_AGE_HEROIC_SUMMARY"
        }
    }
}
