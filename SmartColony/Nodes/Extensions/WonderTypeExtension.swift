//
//  WonderTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 26.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import SmartAILibrary

extension WonderType {

    func iconTexture() -> String {
        
        switch self {
            
        case .none: return "wonder_default"
            
            // ancient
        case .greatBath: return "wonder_greatBath"
        case .pyramids: return "wonder_pyramids"
        case .hangingGardens: return "wonder_hangingGardens"
        case .oracle: return "wonder_oracle"
        case .stonehenge: return "wonder_stonehenge"
        case .templeOfArtemis: return "wonder_templeOfArtemis"
        }
    }
}
