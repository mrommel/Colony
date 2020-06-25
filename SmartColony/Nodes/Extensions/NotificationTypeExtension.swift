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
            
        case .turn: return "button_turn"
            
        case .generic: return "button_generic" // #
            
        case .techNeeded: return "button_tech_needed"
        case .civicNeeded: return "button_civic_needed"
        case .productionNeeded: return "button_production_needed"
            
        case .cityGrowth: return "button_city_growth"
        case .starving: return "button_starving"
        case .diplomaticDeclaration: return "button_diplomatic_declaration" // #
        case .war: return "button_war" // #
        case .enemyInTerritory: return "button_enemy_in_territory" // #
        case .unitPromotion: return "button_promotion" // #
        case .unitNeedsOrders: return "button_unit_needs_orders"
        case .unitDied: return "button_unit_died"
            
        case .canChangeGovernment: return "button_change_government"
        }
    }
}
