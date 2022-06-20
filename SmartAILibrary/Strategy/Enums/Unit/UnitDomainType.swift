//
//  UnitDomainType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum UnitDomainType: Int, Codable {

    case none

    case land
    case sea
    case air
    case immobile

    func unitClasses() -> [UnitClassType] {

        switch self {

        case .none:
            return []
        case .land:
            return [.recon, .melee, .ranged, .antiCavalry, .lightCavalry, .heavyCavalry, .siege, .support]
        case .sea:
            return [.navalMelee, .navalRanged, .navalRaider, .navalCarrier]
        case .air:
            return [.airFighter, .airBomber]
        case .immobile:
            return []
        }
    }
}
