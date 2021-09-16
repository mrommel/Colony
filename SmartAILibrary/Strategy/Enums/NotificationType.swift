//
//  NotificationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// todo: add parameter to enum
public enum NotificationType: Int, Codable {

    case turn

    case generic

    case techNeeded
    case civicNeeded
    case productionNeeded
    case canChangeGovernment
    case policiesNeeded
    case canFoundPantheon
    case governorTitleAvailable // parameter: player

    case cityGrowth // parameter: city
    case starving // parameter: city

    case diplomaticDeclaration // parameter: player
    case war // parameter: player
    case enemyInTerritory // parameter: location, player

    case unitPromotion // parameter: unit
    case unitNeedsOrders // parameter: unit
    case unitDied // parameter: location

    case greatPersonJoined // parameter: location

    public static var all: [NotificationType] = [
        .turn, .generic, .techNeeded, .civicNeeded, .productionNeeded, .canChangeGovernment, .policiesNeeded,
        .canFoundPantheon, .governorTitleAvailable, .cityGrowth, .starving, .diplomaticDeclaration, .war, .enemyInTerritory, .unitPromotion,
        .unitNeedsOrders, .unitDied, .greatPersonJoined
    ]
}
