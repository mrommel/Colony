//
//  AgeTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 05.01.22.
//

import SmartAILibrary

extension AgeType {

    public func iconTexture() -> String {

        switch self {

        case .dark: return "dark-age"
        case .normal: return "normal-age"
        case .golden: return "golden-age"
        case .heroic: return "golden-age"
        }
    }

    public func summaryText() -> String {

        switch self {

        case .dark: return "TXT_KEY_AGE_DARK_SUMMARY"
        case .normal: return "TXT_KEY_AGE_NORMAL_SUMMARY"
        case .golden: return "TXT_KEY_AGE_GOLDEN_SUMMARY"
        case .heroic: return "TXT_KEY_AGE_HEROIC_SUMMARY"
        }
    }

    public func earnedText() -> String {

        switch self {

        case .dark: return "TXT_KEY_EARNED_DARK_AGE"
        case .normal: return "TXT_KEY_EARNED_NORMAL_AGE"
        case .golden: return "TXT_KEY_EARNED_GOLDEN_AGE"
        case .heroic: return "TXT_KEY_EARNED_HEROIC_AGE"
        }
    }
}
