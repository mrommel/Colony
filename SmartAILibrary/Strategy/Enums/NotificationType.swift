//
//  NotificationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum NotificationType: Int, Codable {
    
    case turn
    
    case generic
    
    case techNeeded
    case civicNeeded
    case productionNeeded
    
    case cityGrowth
    case starving
    
    case diplomaticDeclaration
    case war
    case enemyInTerritory
    
    case unitPromotion
    case unitNeedsOrders
    case unitDied
}
