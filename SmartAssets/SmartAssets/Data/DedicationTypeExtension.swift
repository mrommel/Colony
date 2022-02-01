//
//  DedicationTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 05.01.22.
//

import SmartAILibrary

extension DedicationType {

    public func iconTexture() -> String {

        switch self {

        case .none: return "dedication-monumentality"

        case .monumentality: return "dedication-monumentality"
        case .penBrushAndVoice: return "dedication-penBrushAndVoice"
        case .freeInquiry: return "dedication-freeInquiry"
        case .exodusOfTheEvangelists: return "dedication-exodusOfTheEvangelists"
        case .hicSuntDracones: return "dedication-hicSuntDracones"
        case .reformTheCoinage: return "dedication-reformTheCoinage"
        case .heartbeatOfSteam: return "dedication-heartbeatOfSteam"
        case .toArms: return "dedication-toArms"
        case .wishYouWereHere: return "dedication-wishYouWereHere"
        case .bodyguardOfLies: return "dedication-bodyguardOfLies"
        case .skyAndStars: return "dedication-skyAndStars"
        case .automatonWarfare: return "dedication-automatonWarfare"
        }
    }
}
