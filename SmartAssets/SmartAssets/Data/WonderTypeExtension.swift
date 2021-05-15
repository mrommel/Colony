//
//  WonderTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension WonderType {

    public func iconTexture() -> String {

        switch self {

        case .none: return "wonder-default"

            // ancient
            //case .greatBath: return "wonder-greatBath"
        case .pyramids: return "wonder-pyramids"
        case .hangingGardens: return "wonder-hangingGardens"
        case .oracle: return "wonder-oracle"
        case .stonehenge: return "wonder-stonehenge"
        case .templeOfArtemis: return "wonder-templeOfArtemis"

            // classical
        case .greatLighthouse: return "wonder-default"
        case .greatLibrary: return "wonder-default"
        case .apadana: return "wonder-default"
        case .colosseum: return "wonder-default"
        case .colossus: return "wonder-default"
        case .jebelBarkal: return "wonder-default"
        case .mausoleumAtHalicarnassus: return "wonder-default"
        case .mahabodhiTemple: return "wonder-default"
        case .petra: return "wonder-default"
        case .terracottaArmy: return "wonder-default"
        }
    }
}
