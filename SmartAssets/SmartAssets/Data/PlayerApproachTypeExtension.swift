//
//  PlayerApproachTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 12.03.22.
//

import SmartAILibrary

extension PlayerApproachType {

    public func name() -> String {

        switch self {

        case .none: return ""

        case .war: return "war"
        case .hostile: return "hostile"
        case .guarded: return "guarded"
        case .deceptive: return "deceptive"
        case .afraid: return "afraid"
        case .friendly: return "friendly"
        case .neutrally: return "neutrally"
        }
    }
}
