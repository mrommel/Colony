//
//  HandicapTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 23.03.21.
//

import SmartAILibrary

extension HandicapType {

    public func iconTexture() -> String {

        switch self {

        case .settler:
            return "handicap-settler"
        case .chieftain:
            return "handicap-chieftain"
        case .warlord:
            return "handicap-warlord"
        case .prince:
            return "handicap-prince"
        case .king:
            return "handicap-king"
        case .emperor:
            return "handicap-emperor"
        case .immortal:
            return "handicap-immortal"
        case .deity:
            return "handicap-deity"
        }
    }
}
