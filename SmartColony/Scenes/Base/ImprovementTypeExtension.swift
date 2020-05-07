//
//  TileImprovementType.swift
//  SmartColony
//
//  Created by Michael Rommel on 05.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension ImprovementType {
    
    func textureNamesHex() -> [String] {
    
        switch self {
            
        case .none: return ["improvement_none"]
            
        case .barbarianCamp: return ["improvement_barbarianCamp"] // #
        case .goodyHut: return ["improvement_goodyHut"] // #
        case .ruins: return ["improvement_ruins"] // #
            
        case .farm: return ["improvement_farm"]
        case .mine: return ["improvement_mine"]
        case .quarry: return ["improvement_quarry"]
        case .camp: return ["improvement_camp"]
        case .pasture: return ["improvement_pasture"] // #
        case .plantation: return ["improvement_plantation"]
        case .fishingBoats: return ["improvement_fishingBoats"]
        case .oilWell: return ["improvement_oilWell"] // #
            
        case .fort: return ["improvement_fort"] // #
        case .citadelle: return ["improvement_citadelle"] // #
        }
    }
}
