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
        case .greatLighthouse: return "wonder-greatLighthouse"
        case .greatLibrary: return "wonder-greatLibrary"
        case .apadana: return "wonder-apadana"
        case .colosseum: return "wonder-colosseum"
        case .colossus: return "wonder-colossus"
        case .jebelBarkal: return "wonder-jebelBarkal"
        case .mausoleumAtHalicarnassus: return "wonder-mausoleumAtHalicarnassus"
        case .mahabodhiTemple: return "wonder-mahabodhiTemple"
        case .petra: return "wonder-petra"
        case .terracottaArmy: return "wonder-terracottaArmy"
        }
    }
}
