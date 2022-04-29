//
//  CasusBelliType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.12.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum CasusBelliType: Int, Codable {

    case ancientWar // war in ancient era

    case surpriseWar
    case formalWar
    case holyWar
    case liberationWar
    case reconquestWar
    case protectorateWar
    case colonialWar
    case territorialExpansionWar

    public func name() -> String {

        return "todo proper names"
    }
}
