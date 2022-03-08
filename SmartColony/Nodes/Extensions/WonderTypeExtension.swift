//
//  WonderTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 26.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension WonderType {

    func iconTexture() -> String {

        switch self {

        case .none: return "wonder_default"

            // ancient
            // case .greatBath: return "wonder_greatBath"
        case .pyramids: return "wonder_pyramids"
        case .hangingGardens: return "wonder_hangingGardens"
        case .oracle: return "wonder_oracle"
        case .stonehenge: return "wonder_stonehenge"
        case .templeOfArtemis: return "wonder_templeOfArtemis"

            // classical
        case .greatLighthouse: return "wonder_default"
        case .greatLibrary: return "wonder_default"
        case .apadana: return "wonder_default"
        case .colosseum: return "wonder_default"
        case .colossus: return "wonder_default"
        case .jebelBarkal: return "wonder_default"
        case .mausoleumAtHalicarnassus: return "wonder_default"
        case .mahabodhiTemple: return "wonder_default"
        case .petra: return "wonder_default"
        case .terracottaArmy: return "wonder_default"
        }
    }
}
