//
//  CityCommandType.swift
//  SmartAssets
//
//  Created by Michael Rommel on 09.09.21.
//

import SmartAILibrary

public enum CityCommandType {

    case showRangedAttackTargets(city: AbstractCity?)
    case showBuilds(city: AbstractCity?)
    case aquireTiles(city: AbstractCity?)
    case purchaseGold(city: AbstractCity?)
    case purchaseFaith(city: AbstractCity?)

    public static var all: [CityCommandType] = [

        .showRangedAttackTargets(city: nil),
        .showBuilds(city: nil),
        .aquireTiles(city: nil),
        .purchaseGold(city: nil),
        .purchaseFaith(city: nil)
    ]

    public func buttonTexture() -> String {

        switch self {

        case .showRangedAttackTargets(city: _): return "city-command-button-rangedTargets"
        case .showBuilds(city: _): return "city-command-button-builds"
        case .aquireTiles(city: _): return "city-command-button-purchaseTiles"
        case .purchaseGold(city: _): return "city-command-button-purchaseGold"
        case .purchaseFaith(city: _): return "city-command-button-purchaseFaith"
        }
    }
}
