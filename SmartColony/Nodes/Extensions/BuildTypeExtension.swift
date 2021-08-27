//
//  BuildTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 26.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension BuildType {

    func iconTexture() -> String {

        switch self {

        case .none: return "build_default"

        case .repair: return "build_default"

        case .ancientRoad: return "build_default"
        case .classicalRoad: return "build_default"
        case .removeRoad: return "build_default"

        case .farm: return "build_farm"
        case .mine: return "build_mine"
        case .quarry: return "build_default"
        case .plantation: return "build_default"
        case .camp: return "build_camp"
        case .pasture: return "build_pasture"
        case .fishingBoats: return "build_default"

        case .removeForest: return "build_default"
        case .removeRainforest: return "build_default"
        case .removeMarsh: return "build_default"
        }
    }
}
