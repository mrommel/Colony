//
//  CityCommandType.swift
//  SmartAssets
//
//  Created by Michael Rommel on 09.09.21.
//

import SmartAILibrary

public enum CityCommandType {

    case showRangedAttackTargets(city: AbstractCity?)

    public static var all: [CityCommandType] = [
        .showRangedAttackTargets(city: nil)
    ]

    public func buttonTexture() -> String {

        switch self {

        case .showRangedAttackTargets(city: _):
            return "city-command-button-ranged-targets"
        }
    }
}
