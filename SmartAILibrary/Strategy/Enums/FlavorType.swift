//
//  FlavorType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum FlavorType: Int, Codable {

    case cityDefense
    case culture
    case defense
    case diplomacy
    case expansion
    case gold
    case greatPeople
    case growth
    case amenities // happiness
    case infrastructure
    case militaryTraining
    case mobile
    case naval
    case navalGrowth
    case navalRecon
    case navalTileImprovement
    case offense
    case production
    case ranged
    case recon
    case religion
    case science
    case tileImprovement
    case tourism
    case wonder
    case energy

    static var all: [FlavorType] {
        return [
            .offense, .defense, .cityDefense, .growth, .greatPeople, .militaryTraining, .amenities, .recon, .culture,
            .mobile, .production, .naval, .navalTileImprovement, .tileImprovement, .ranged, .navalRecon, .gold,
            .navalGrowth, .infrastructure, .science, .diplomacy, .tourism, .religion, .energy
        ]
    }
}
