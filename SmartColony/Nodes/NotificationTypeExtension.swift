//
//  NotificationTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 16.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension NotificationType {
    
    func iconTexture() -> String {
        
        switch self {
            
        case .generic: return "button_generic"
        case .tech: return "button_tech_needed"
        case .civic: return "button_civic_needed"
        case .production: return "button_production_needed"
            
        case .cityGrowth: return "abc"
        case .starving: return "abc"
        case .diplomaticDeclaration: return "abc"
        case .war: return "abc"
        case .enemyInTerritory: return "abc"
        case .unitPromotion: return "abc"
        case .unitNeedsOrders: return "abc"
        }
    }
}
