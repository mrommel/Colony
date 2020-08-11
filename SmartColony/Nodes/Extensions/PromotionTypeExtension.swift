//
//  PromotionTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 11.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension UnitPromotionType {
    
    func iconTexture() -> String {
        
        switch self {
            
        case .embarkation: return "promotion_default"
        case .healthBoostRecon: return "promotion_default"
        case .healthBoostMelee: return "promotion_default"
            
            // recon
        case .ranger: return "promotion_default"
        case .alpine: return "promotion_default"
        case .sentry: return "promotion_default"
        case .guerrilla: return "promotion_default"
        case .spyglass: return "promotion_default"
        case .ambush: return "promotion_default"
        case .camouflage: return "promotion_default"
            
            // melee
        case .battleCry: return "promotion_default"
        case .tortoise: return "promotion_default"
        case .commando: return "promotion_default"
        case .amphibious: return "promotion_default"
        case .zweihander: return "promotion_default"
        case .urbanWarfare: return "promotion_default"
        case .eliteGuard: return "promotion_default"
        }
    }
}
