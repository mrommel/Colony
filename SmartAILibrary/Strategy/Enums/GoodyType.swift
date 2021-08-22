//
//  GoodyType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 08.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum GoodyCategory {

    case gold
    case culture
    case faith
    case science
    case diplomacy
    case mitlitary
    case survivors
}

// https://civilization.fandom.com/wiki/Tribal_Village_(Civ6)
public enum GoodyType: Int, Codable {

    case none

    case goldMinorGift
    case goldMediumGift
    case goldMajorGift

    case civicMinorBoost
    case civicMajorBoost
    case relic

    case faithMinorGift
    case faithMediumGift
    case faithMajorGift

    case scienceMinorGift
    case scienceMajorGift
    case freeTech

    case diplomacyMinorBoost
    case freeEnvoy
    case diplomacyMajorBoost

    case freeScout
    case healing
    case freeResource
    case experienceBoost
    case unitUpgrade

    case additionalPopulation
    case freeBuilder
    case freeTrader
    case freeSettler

    private struct GoodyTypeData {

        let name: String
        let effect: String
        let category: GoodyCategory
        let minimalTurn: Int
        let probability: Int // in percent 0..100
    }

    static var all: [GoodyType] {
        return [
            .goldMinorGift, .goldMediumGift, .goldMajorGift, .civicMinorBoost, .civicMajorBoost, .relic,
            .faithMinorGift, .faithMediumGift, .faithMajorGift, .scienceMinorGift, .scienceMajorGift, .freeTech,
            .diplomacyMinorBoost, .freeEnvoy, .diplomacyMajorBoost, .freeScout, .healing, .freeResource,
            .experienceBoost, .unitUpgrade, .additionalPopulation, .freeBuilder, .freeTrader, .freeSettler
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func effect() -> String {

        return self.data().effect
    }

    func category() -> GoodyCategory {

        return self.data().category
    }

    func minimalTurn() -> Int {

        return self.data().minimalTurn
    }

    func probability() -> Int {

        return self.data().probability
    }

    private func data() -> GoodyTypeData {

        switch self {

            // gold
        case .goldMinorGift:
            return GoodyTypeData(
                name: "Gold gift (minor)",
                effect: "Receive a gift of 40 Gold from the villagers.",
                category: .gold,
                minimalTurn: 0,
                probability: 55
            )
        case .goldMediumGift:
            return GoodyTypeData(
                name: "Gold gift (medium)",
                effect: "Receive a gift of 75 Gold from the villagers.",
                category: .gold,
                minimalTurn: 20,
                probability: 30
            )
        case .goldMajorGift:
            return GoodyTypeData(
                name: "Gold gift (major)",
                effect: "Receive a gift of 120 Gold from the villagers.",
                category: .gold,
                minimalTurn: 40,
                probability: 15
            )

            // culture
        case .civicMinorBoost:
            return GoodyTypeData(
                name: "Civic boost (minor)",
                effect: "Villagers share the secrets of their well-ordered society: Receive 1 Inspiration.",
                category: .culture,
                minimalTurn: 0,
                probability: 55
            )
        case .civicMajorBoost:
            return GoodyTypeData(
                name: "Civic boost (major)",
                effect: "Villagers share the secrets of their well-ordered society: Receive 2 Inspiration.",
                category: .culture,
                minimalTurn: 30,
                probability: 30
            )
        case .relic:
            return GoodyTypeData(
                name: "Relic",
                effect: "Villagers give you their sacred Relic.",
                category: .culture,
                minimalTurn: 0,
                probability: 15
            )
        case .faithMinorGift:
            return GoodyTypeData(
                name: "Faith boost (minor)",
                effect: "Villagers pray for you: Receive 20 Faith.",
                category: .faith,
                minimalTurn: 20,
                probability: 55
            )
        case .faithMediumGift:
            return GoodyTypeData(
                name: "Faith boost (medium)",
                effect: "Villagers pray for you: Receive 60 Faith.",
                category: .faith,
                minimalTurn: 40,
                probability: 30
            )
        case .faithMajorGift:
            return GoodyTypeData(
                name: "Faith boost (major)",
                effect: "Villagers pray for you: Receive 100 Faith.",
                category: .faith,
                minimalTurn: 60,
                probability: 15
            )
        case .scienceMinorGift:
            return GoodyTypeData(
                name: "Tech boost (minor)",
                effect: "Villagers share their technological secrets: Receive 1 Eureka.",
                category: .science,
                minimalTurn: 0,
                probability: 55
            )
        case .scienceMajorGift:
            return GoodyTypeData(
                name: "Tech boost (major)",
                effect: "Villagers share their technological secrets: Receive 2 Eurekas.",
                category: .science,
                minimalTurn: 30,
                probability: 30
            )
        case .freeTech:
            return GoodyTypeData(
                name: "Free Technology",
                effect: "Villagers share their technological secrets: Receive 1 free technology (not a Eureka).",
                category: .science,
                minimalTurn: 50,
                probability: 15
            )
        case .diplomacyMinorBoost:
            return GoodyTypeData(
                name: "Diplomacy boost (minor)",
                effect: "Villagers spread the fame of your civilization: Receive 20 Diplomatic Favor.",
                category: .diplomacy,
                minimalTurn: 30,
                probability: 45
            )
        case .freeEnvoy:
            return GoodyTypeData(
                name: "Free Envoy",
                effect: "Villagers help you contact nearby city-state: Receive 1 Envoy.",
                category: .diplomacy,
                minimalTurn: 0,
                probability: 40
            )
        case .diplomacyMajorBoost:
            return GoodyTypeData(
                name: "Diplomacy boost (major)",
                effect: "Villagers share their government secrets: Receive 1 Governor Title.",
                category: .diplomacy,
                minimalTurn: 30,
                probability: 15
            )
        case .freeScout:
            return GoodyTypeData(
                name: "Free Scout",
                effect: "A Scout unit from the village joins you.",
                category: .mitlitary,
                minimalTurn: 0,
                probability: 30
            )
        case .healing:
            return GoodyTypeData(
                name: "Healing",
                effect: "The villagers Heal the wounds of the unit which activated the village (if it was wounded).",
                category: .mitlitary,
                minimalTurn: 0,
                probability: 25
            )
        case .freeResource:
            return GoodyTypeData(
                name: "Free resource",
                effect: "Receive from the villagers 20 units of the most advanced Strategic resource you've uncovered.",
                category: .mitlitary,
                minimalTurn: 0,
                probability: 20
            )
        case .experienceBoost:
            return GoodyTypeData(
                name: "Experience boost",
                effect: "Villagers train your men: Get an XP boost for the military unit which activated the village.",
                category: .mitlitary,
                minimalTurn: 0,
                probability: 20
            )
        case .unitUpgrade:
            return GoodyTypeData(
                name: "Unit upgrade",
                effect: "Your unit has been upgraded.",
                category: .mitlitary,
                minimalTurn: 0,
                probability: 5
            )
        case .additionalPopulation:
            return GoodyTypeData(
                name: "Additional population",
                effect: "Survivors decide to join you: Receive a free Citizen in your nearest city.",
                category: .survivors,
                minimalTurn: 0,
                probability: 40
            )
        case .freeBuilder:
            return GoodyTypeData(
                name: "Free Builder",
                effect: "A Builder unit from the village comes to work for you.",
                category: .survivors,
                minimalTurn: 0,
                probability: 30
            )
        case .freeTrader:
            return GoodyTypeData(
                name: "Free Trader",
                effect: "A Trader unit from the village comes to work for you.",
                category: .survivors,
                minimalTurn: 15,
                probability: 25
            )
        case .freeSettler:
            return GoodyTypeData(
                name: "Free Settler",
                effect: "A Settler unit from the village joins you.",
                category: .survivors,
                minimalTurn: 0,
                probability: 5
            )

        case .none:
            return GoodyTypeData(
                name: "None",
                effect: "",
                category: .gold,
                minimalTurn: 0,
                probability: 0
            )
        }
    }
}
