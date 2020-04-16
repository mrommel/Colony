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

        case .found: return "Command_Found"
        case .buildFarm: return "Command_Farm"
        case .buildMine: return "Command_Mine"
        case .buildRoute: return "Command_Route"
        case .pillage: return "Command_Pillage"
        case .fortify: return "Command_Fortify"
        case .hold: return "Command_Hold"
        case .garrison: return "Command_Garrison"
        }
    }
}
