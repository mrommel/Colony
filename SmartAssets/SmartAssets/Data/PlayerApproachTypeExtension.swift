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
        case .denounced: return "denounced"
        case .unfriendly: return "unfriendly"
        case .neutral: return "neutral"
        case .friendly: return "friendly"
        case .declaredFriend: return "declaredFriend"
        case .allied: return "allied"
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .none: return ""

        case .war: return "playerApproachType-war"
        case .denounced: return "playerApproachType-denounced"
        case .unfriendly: return "playerApproachType-unfriendly"
        case .neutral: return "playerApproachType-neutral"
        case .friendly: return "playerApproachType-friendly"
        case .declaredFriend: return "playerApproachType-declaredFriend"
        case .allied: return "playerApproachType-allied"
        }
    }
}
