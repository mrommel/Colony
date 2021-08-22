//
//  UnitTaskType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// UnitAITypes
public enum UnitTaskType: Int, Codable {

    case none
    case unknown

    case settle
    case work
    case trade
    case attack
    case cityAttack
    case cityBombard
    case fastAttack
    case defense
    case ranged
    case explore
    case counter

    case workerSea
    case attackSea
    case exploreSea
    case escortSea
    case reserveSea
    case shadow

    case attackAir
    case defenseAir

    case general

    case citySpecial
}
