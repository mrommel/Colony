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

    public func name() -> String {

        switch self {

        case .civilian: return "Civilian"
        case .melee: return "Melee"
        case .recon: return "Recon"
        case .ranged: return "Ranged"
        case .antiCavalry: return "Anti-Cavalry"
        case .lightCavalry: return "Light Cavalry"
        case .heavyCavalry: return "Heavy Cavalry"
        case .siege: return "Siege"
        case .navalMelee: return "Naval Melee"
        case .navalRanged: return "Naval Ranged"
        case .navalRaider: return "Naval Raider"
        case .navalCarrier: return "Naval Carrier"
        case .airFighter: return "Air Fighter"
        case .airBomber: return "Air Bomber"
        case .support: return "Support"

        case .city: return "City"
        }
    }
}
