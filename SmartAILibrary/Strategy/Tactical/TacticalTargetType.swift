//
//  TacticalTargetType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum TacticalTargetType: Int, Codable {

    case none // AI_TACTICAL_TARGET_NONE
    case city // AI_TACTICAL_TARGET_CITY
    case barbarianCamp // AI_TACTICAL_TARGET_BARBARIAN_CAMP
    case improvement // AI_TACTICAL_TARGET_IMPROVEMENT
    case blockadeResourcePoint // AI_TACTICAL_TARGET_BLOCKADE_RESOURCE_POINT
    case lowPriorityUnit // AI_TACTICAL_TARGET_LOW_PRIORITY_UNIT,    // Can't attack one of our cities
    case mediumPriorityUnit // AI_TACTICAL_TARGET_MEDIUM_PRIORITY_UNIT, // Can damage one of our cities
    case highPriorityUnit // AI_TACTICAL_TARGET_HIGH_PRIORITY_UNIT,   // Can contribute to capturing one of our cities
    case cityToDefend // AI_TACTICAL_TARGET_CITY_TO_DEFEND
    case improvementToDefend // AI_TACTICAL_TARGET_IMPROVEMENT_TO_DEFEND
    case defensiveBastion // AI_TACTICAL_TARGET_DEFENSIVE_BASTION
    case ancientRuins // AI_TACTICAL_TARGET_ANCIENT_RUINS
    case bombardmentZone // AI_TACTICAL_TARGET_BOMBARDMENT_ZONE,     // Used for naval bombardment operation
    case embarkedMilitaryUnit // AI_TACTICAL_TARGET_EMBARKED_MILITARY_UNIT
    case embarkedCivilian // AI_TACTICAL_TARGET_EMBARKED_CIVILIAN
    case lowPriorityCivilian // AI_TACTICAL_TARGET_LOW_PRIORITY_CIVILIAN
    case mediumPriorityCivilian // AI_TACTICAL_TARGET_MEDIUM_PRIORITY_CIVILIAN
    case highPriorityCivilian // AI_TACTICAL_TARGET_HIGH_PRIORITY_CIVILIAN
    case veryHighPriorityCivilian // AI_TACTICAL_TARGET_VERY_HIGH_PRIORITY_CIVILIAN

    case tradeUnitSea // AI_TACTICAL_TARGET_TRADE_UNIT_SEA,
    case tradeUnitLand // AI_TACTICAL_TARGET_TRADE_UNIT_LAND,
    case tradeUnitSeaPlot // AI_TACTICAL_TARGET_TRADE_UNIT_SEA_PLOT, // Used for idle unit moves to plunder trade routes that go through our territory
    case tradeUnitLandPlot // AI_TACTICAL_TARGET_TRADE_UNIT_LAND_PLOT,
    case citadel // AI_TACTICAL_TARGET_CITADEL
    case improvementResource // AI_TACTICAL_TARGET_IMPROVEMENT_RESOURCE
}
