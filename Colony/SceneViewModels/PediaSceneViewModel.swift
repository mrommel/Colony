//
//  PediaSceneViewModel.swift
//  Colony
//
//  Created by Michael Rommel on 12.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class PediaSceneViewModel {
    
    let terrains: [Terrain] = Terrain.all
    let features: [Feature] = Feature.all
    let unitTypes: [UnitType] = UnitType.unitTypes
}
