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

    func commandTexture() -> String {

        switch self {
            
            case .found: return "command_button_found"
            case .buildFarm: return "command_button_farm"
            case .buildMine: return "command_button_mine"
            case .buildCamp: return "command_button_camp"
            case .buildPasture: return "command_button_pasture"
            case .buildQuarry: return "command_button_quarry"

            case .hold: return "command_button_hold"
            
            case .fortify: return "command_button_fortify"
            case .garrison: return "command_button_garrison"
            case .pillage: return "command_button_pillage"
            
            case .attack: return "command_button_attack"
            case .rangedAttack: return "command_button_default"
            case .cancelAttack: return "command_button_default"
        }
    }
}
