//
//  LeaderTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 22.03.21.
//

import SmartAILibrary

extension LeaderType {
    
    public func textureName() -> String {
        
        switch self {
        
        case .none:
            return "leader-random"
            
        case .barbar:
            return "leader-barbar"
            
        case .alexander:
            return "leader-alexander"
        case .trajan:
            return "leader-trajan"
        case .victoria:
            return "leader-victoria"
        case .cyrus:
            return "leader-cyrus"
        case .montezuma:
            return "leader-montezuma"
        case .napoleon:
            return "leader-napoleon"
        case .cleopatra:
            return "leader-cleopatra"
        case .barbarossa:
            return "leader-barbarossa"
        case .peterTheGreat:
            return "leader-peterTheGreat"
        }
    }
}
