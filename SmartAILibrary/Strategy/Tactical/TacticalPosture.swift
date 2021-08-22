//
//  TacticalPosture.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TacticalPosture {

    let type: TacticalPostureType
    let player: AbstractPlayer?
    let city: AbstractCity?
    let isWater: Bool

    init(of type: TacticalPostureType, for player: AbstractPlayer?, in city: AbstractCity?, isWater: Bool) {
        self.type = type
        self.player = player
        self.city = city
        self.isWater = isWater
    }
}
