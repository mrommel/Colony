//
//  UnitOperationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum UnitOperationType: Int, Codable {

    case foundCity // AI_OPERATION_FOUND_CITY
    case cityCloseDefense // AI_OPERATION_CITY_CLOSE_DEFENSE
    case basicCityAttack // AI_OPERATION_BASIC_CITY_ATTACK
    case pillageEnemy // AI_OPERATION_PILLAGE_ENEMY
    case rapidResponse // AI_OPERATION_RAPID_RESPONSE
    case destroyBarbarianCamp // AI_OPERATION_DESTROY_BARBARIAN_CAMP
    case navalAttack // AI_OPERATION_NAVAL_ATTACK
    case navalSuperiority // AI_OPERATION_NAVAL_SUPERIORITY
    case navalBombard // AI_OPERATION_NAVAL_BOMBARDMENT
    case colonize // AI_OPERATION_COLONIZE
    case notSoQuickColonize // AI_OPERATION_NOT_SO_QUICK_COLONIZE
    case quickColonize // AI_OPERATION_QUICK_COLONIZE

    case pureNavalCityAttack
    case sneakCityAttack // AI_OPERATION_SNEAK_CITY_ATTACK
    case navalSneakAttack // AI_OPERATION_NAVAL_SNEAK_ATTACK

    case smallCityAttack // AI_OPERATION_SMALL_CITY_ATTACK,
    // AI_OPERATION_MERCHANT_DELEGATION,
    // AI_OPERATION_CITY_STATE_ATTACK,
    // AI_OPERATION_CITY_STATE_NAVAL_ATTACK,
    // AI_OPERATION_NUKE_ATTACK,
}
