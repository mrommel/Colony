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
        case .buildRoute: return "command_route"
        case .pillage: return "command_pillage"
        case .fortify: return "command_fortify"
        case .hold: return "command_hold"
        case .garrison: return "command_garrison"
        }
    }
}
