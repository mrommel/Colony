//
//  BeliefTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 04.10.21.
//

import SmartAILibrary

extension BeliefMainType {

    public func iconTexture() -> String {

        switch self {

        case .founderBelief:
            return "belief-founder"
        case .followerBelief:
            return "belief-follower"
        case .worshipBelief:
            return "belief-worship"
        case .enhancerBelief:
            return "belief-enhancer"
        }
    }
}

extension BeliefType {

    public func iconTexture() -> String {

        return self.type().iconTexture()
    }
}
