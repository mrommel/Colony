//
//  EnvoyEffect.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class EnvoyEffect {

    public let cityState: CityStateType
    public let category: CityStateCategory
    public let level: EnvoyEffectLevel

    public init(cityState: CityStateType, category: CityStateCategory, level: EnvoyEffectLevel) {

        self.cityState = cityState
        self.category = category
        self.level = level
    }
}
