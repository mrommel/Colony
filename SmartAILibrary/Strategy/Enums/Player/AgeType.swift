//
//  AgeType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

// https://civilization.fandom.com/wiki/Age_(Civ6)
public enum AgeType: Int, Codable {

    case dark
    case normal
    case golden
    case heroic

    public static var all: [AgeType] = [

        .dark,
        .normal,
        .golden,
        .heroic
    ]

    public func name() -> String {

        return self.data().name
    }

    public func loyalityFactor() -> Double {

        return self.data().loyalityFactor
    }

    public func numDedicationsSelectable() -> Int {

        return self.data().numDedicationsSelectable
    }

    public func loyalityEffect() -> String {

        return self.data().loyalityEffect
    }

    // private methods

    private struct AgeTypeData {

        let name: String
        let loyalityFactor: Double
        let loyalityEffect: String
        let numDedicationsSelectable: Int
    }

    private func data() -> AgeTypeData {

        switch self {

        case .dark:
            return AgeTypeData(
                name: "TXT_KEY_AGE_DARK_NAME",
                loyalityFactor: 0.5,
                loyalityEffect: "TXT_KEY_AGE_DARK_LOYALTY",
                numDedicationsSelectable: 1
            )

        case .normal:
            return AgeTypeData(
                name: "TXT_KEY_AGE_NORMAL_NAME",
                loyalityFactor: 1.0,
                loyalityEffect: "TXT_KEY_AGE_NORMAL_LOYALTY",
                numDedicationsSelectable: 1
            )

        case .golden:
            return AgeTypeData(
                name: "TXT_KEY_AGE_GOLDEN_NAME",
                loyalityFactor: 1.5,
                loyalityEffect: "TXT_KEY_AGE_GOLDEN_LOYALTY",
                numDedicationsSelectable: 1
            )

        case .heroic:
            return AgeTypeData(
                name: "TXT_KEY_AGE_HEROIC_NAME",
                loyalityFactor: 1.5,
                loyalityEffect: "TXT_KEY_AGE_HEROIC_LOYALTY",
                numDedicationsSelectable: 3
            )
        }
    }
}
