//
//  UnitClassType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 06.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Units_(Civ6)
public enum UnitClassType {

    case civilian

    case melee
    case recon
    case ranged
    case antiCavalry
    case lightCavalry
    case heavyCavalry
    case siege

    case navalMelee
    case navalRanged
    case navalRaider
    case navalCarrier

    case airFighter
    case airBomber

    case support

    case city

    public static var all: [UnitClassType] = [

        .civilian,
        .melee, .recon, .ranged, .antiCavalry, .lightCavalry, .heavyCavalry, .siege,
        .navalMelee, .navalRanged, .navalRaider, .navalCarrier,
        .airFighter, .airBomber,
        .support,
        .city
    ]

    public static var combat: [UnitClassType] = [

        .melee, .recon, .ranged, .antiCavalry, .lightCavalry, .heavyCavalry, .siege,
        .navalMelee, .navalRanged, .navalRaider, .navalCarrier,
        .airFighter, .airBomber
    ]

    public func name() -> String {

        switch self {

        case .civilian: return "TXT_KEY_UNIT_CLASS_CIVILIAN_NAME"
        case .melee: return "TXT_KEY_UNIT_CLASS_MELEE_NAME"
        case .recon: return "TXT_KEY_UNIT_CLASS_RECON_NAME"
        case .ranged: return "TXT_KEY_UNIT_CLASS_RANGED_NAME"
        case .antiCavalry: return "TXT_KEY_UNIT_CLASS_ANTI_CAVALRY_NAME"
        case .lightCavalry: return "TXT_KEY_UNIT_CLASS_LIGHT_CAVALRY_NAME"
        case .heavyCavalry: return "TXT_KEY_UNIT_CLASS_HEAVY_CAVALRY_NAME"
        case .siege: return "TXT_KEY_UNIT_CLASS_SIEGE_NAME"
        case .navalMelee: return "TXT_KEY_UNIT_CLASS_NAVAL_MELEE_NAME"
        case .navalRanged: return "TXT_KEY_UNIT_CLASS_NAVAL_RANGED_NAME"
        case .navalRaider: return "TXT_KEY_UNIT_CLASS_NAVAL_RAIDER_NAME"
        case .navalCarrier: return "TXT_KEY_UNIT_CLASS_NAVAL_CARRIER_NAME"
        case .airFighter: return "TXT_KEY_UNIT_CLASS_AIR_FIGHTER_NAME"
        case .airBomber: return "TXT_KEY_UNIT_CLASS_AIR_BOMBER_NAME"
        case .support: return "TXT_KEY_UNIT_CLASS_SUPPORT_NAME"

        case .city: return "TXT_KEY_UNIT_CLASS_CITY_NAME"
        }
    }
}
