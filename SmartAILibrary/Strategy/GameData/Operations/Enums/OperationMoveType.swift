//
//  OperationMoveType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum OperationMoveType: Int, Codable {

    case none

    case singleHex
    case enemyTerritory
    case navalEscort
    case freeformNaval
    case rebase
    //case static
}
