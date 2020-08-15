//
//  LeaderTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension LeaderType {
    
    func iconTexture() -> String {
        
        switch self {
            
        case .none: return "--"
        case .barbar: return "--"
            
        case .alexander: return "leader_alexander"
        case .trajan: return "leader_augustus"
        case .victoria: return "leader_elizabeth"
        case .cyrus: return "leader_darius" // #
        case .montezuma: return "leader_montezuma"
        case .napoleon: return "leader_napoleon"
        case .cleopatra: return "leader_cleopatra" // #
        case .barbarossa: return "leader_barbarossa" // #
        case .peterTheGreat: return "leader_peterTheGreat" // #
        }
    }
}
