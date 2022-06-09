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
    case military
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
                name: "TXT_KEY_GOODY_REWARD_MINOR_GOLD_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MINOR_GOLD_EFFECT",
                category: .gold,
                minimalTurn: 0,
                probability: 55
            )
        case .goldMediumGift:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MEDIUM_GOLD_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MEDIUM_GOLD_EFFECT",
                category: .gold,
                minimalTurn: 20,
                probability: 30
            )
        case .goldMajorGift:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MAJOR_GOLD_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MAJOR_GOLD_EFFECT",
                category: .gold,
                minimalTurn: 40,
                probability: 15
            )

            // culture
        case .civicMinorBoost:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MINOR_CIVIC_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MINOR_CIVIC_BOOST_EFFECT",
                category: .culture,
                minimalTurn: 0,
                probability: 55
            )
        case .civicMajorBoost:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MAJOR_CIVIC_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MAJOR_CIVIC_BOOST_EFFECT",
                category: .culture,
                minimalTurn: 30,
                probability: 30
            )
        case .relic:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_RELIC_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_RELIC_EFFECT",
                category: .culture,
                minimalTurn: 0,
                probability: 15
            )
        case .faithMinorGift:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MINOR_FAITH_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MINOR_FAITH_BOOST_EFFECT",
                category: .faith,
                minimalTurn: 20,
                probability: 55
            )
        case .faithMediumGift:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MEDIUM_FAITH_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MEDIUM_FAITH_BOOST_EFFECT",
                category: .faith,
                minimalTurn: 40,
                probability: 30
            )
        case .faithMajorGift:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MAJOR_FAITH_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MAJOR_FAITH_BOOST_EFFECT",
                category: .faith,
                minimalTurn: 60,
                probability: 15
            )
        case .scienceMinorGift:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MINOR_TECH_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MINOR_TECH_BOOST_EFFECT",
                category: .science,
                minimalTurn: 0,
                probability: 55
            )
        case .scienceMajorGift:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MAJOR_TECH_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MAJOR_TECH_BOOST_EFFECT",
                category: .science,
                minimalTurn: 30,
                probability: 30
            )
        case .freeTech:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_FREE_TECH_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_FREE_TECH_EFFECT",
                category: .science,
                minimalTurn: 50,
                probability: 15
            )
        case .diplomacyMinorBoost:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MINOR_DIPLOMACY_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MINOR_DIPLOMACY_BOOST_EFFECT",
                category: .diplomacy,
                minimalTurn: 30,
                probability: 45
            )
        case .freeEnvoy:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_FREE_ENVOY_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_FREE_ENVOY_EFFECT",
                category: .diplomacy,
                minimalTurn: 0,
                probability: 40
            )
        case .diplomacyMajorBoost:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_MAJOR_DIPLOMACY_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_MAJOR_DIPLOMACY_BOOST_EFFECT",
                category: .diplomacy,
                minimalTurn: 30,
                probability: 15
            )
        case .freeScout:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_FREE_SCOUT_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_FREE_SCOUT_EFFECT",
                category: .military,
                minimalTurn: 0,
                probability: 30
            )
        case .healing:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_UNIT_HEALING_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_UNIT_HEALING_EFFECT",
                category: .military,
                minimalTurn: 0,
                probability: 25
            )
        case .freeResource:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_FREE_RESOURCE_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_FREE_RESOURCE_EFFECT",
                category: .military,
                minimalTurn: 0,
                probability: 20
            )
        case .experienceBoost:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_EXPERIENCE_BOOST_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_EXPERIENCE_BOOST_EFFECT",
                category: .military,
                minimalTurn: 0,
                probability: 20
            )
        case .unitUpgrade:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_UNIT_UPGRADE_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_UNIT_UPGRADE_EFFECT",
                category: .military,
                minimalTurn: 0,
                probability: 5
            )
        case .additionalPopulation:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_ADDITIONAL_POPULATION_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_ADDITIONAL_POPULATION_EFFECT",
                category: .survivors,
                minimalTurn: 0,
                probability: 40
            )
        case .freeBuilder:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_FREE_BUILDER_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_FREE_BUILDER_EFFECT",
                category: .survivors,
                minimalTurn: 0,
                probability: 30
            )
        case .freeTrader:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_FREE_TRADER_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_FREE_TRADER_EFFECT",
                category: .survivors,
                minimalTurn: 15,
                probability: 25
            )
        case .freeSettler:
            return GoodyTypeData(
                name: "TXT_KEY_GOODY_REWARD_FREE_SETTLER_TITLE",
                effect: "TXT_KEY_GOODY_REWARD_FREE_SETTLER_EFFECT",
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
