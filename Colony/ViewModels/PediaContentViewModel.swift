//
//  PediaContentViewModel.swift
//  Colony
//
//  Created by Michael Rommel on 02.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class PediaContentViewModel {
    
    var terrain: Terrain? = nil
    var feature: Feature? = nil
    var unitType: UnitType? = nil
    
    init(with terrain: Terrain) {
        self.terrain = terrain
    }
    
    init(with feature: Feature) {
        self.feature = feature
    }
    
    init(with unitType: UnitType) {
        self.unitType = unitType
    }
}
