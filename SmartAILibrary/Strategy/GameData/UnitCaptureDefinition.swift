//
//  UnitCaptureDefinition.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

struct UnitCaptureDefinition {
    
    let oldPlayer: AbstractPlayer?
    let originalOwner: AbstractPlayer?
    let oldType: UnitType
    let capturingPlayer: AbstractPlayer?
    let embarked: Bool
    var captureUnitType: UnitType?
    let location: HexPoint
}
