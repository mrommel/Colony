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
    public let level: EnvoyEffectLevel

    public init(cityState: CityStateType, level: EnvoyEffectLevel) {

        self.cityState = cityState
        self.level = level
    }

    public func isEqual(category: CityStateCategory, at level: EnvoyEffectLevel) -> Bool {

        return self.cityState.category() == category && self.level == level
    }
}
