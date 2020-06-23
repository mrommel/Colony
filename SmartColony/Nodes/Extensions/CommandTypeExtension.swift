//
//  CommandTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 16.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension CommandType {
    
    func iconTexture() -> String {
        
        switch self {

        case .found: return "command_found"
        case .buildFarm: return "command_farm"
        case .buildMine: return "command_mine"
        case .buildCamp: return "command_camp"
        case .buildPasture: return "command_pasture"
        case .buildQuarry: return "command_quarry"

        case .hold: return "command_hold"
            
        case .fortify: return "command_fortify"
        case .garrison: return "command_garrison"
        case .pillage: return "command_pillage"
            
        case .attack: return "command_attack"
        case .rangedAttack: return "command_ranged"
        case .cancelAttack: return "command_cancel"
        }
    }
}
