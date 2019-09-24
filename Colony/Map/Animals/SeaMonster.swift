//
//  SeaMonster.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class SeaMonster: Animal {

    init(position: HexPoint) {
        super.init(position: position, animalType: .monster)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
