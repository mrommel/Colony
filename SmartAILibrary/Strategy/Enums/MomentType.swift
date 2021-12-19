//
//  MomentType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.12.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum MomentCategory {

    case minor
    case major
}

// https://www.civilopedia.net/gathering-storm/moments/moment_artifact_extracted
public enum MomentType {

    // major
    case founded(religion: ReligionType)
    case find(naturalWonder: FeatureType)
    case cityOnNewContinent
    case firstTier1Government // #
    case firstTier1GovernmentInWorld // #
    // ...
    case firstTechnologyOfNewEra // #
    case firstCivicOfNewEra // #

    // minor
    case aggressiveCityPlacement // #
    case artifactExtracted // #
    case barbarianCampDestroyed
    case battleFought // #
    // ...
    case metNew(civilization: CivilizationType)
    // ...
    case completed(wonder: WonderType)

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func summary() -> String {

        return self.data().summary
    }

    public func category() -> MomentCategory {

        return self.data().category
    }

    public func eraScore() -> Int {

        return self.data().eraScore
    }

    // MARK: private methods

    private struct MomentTypeData {

        let name: String
        let summary: String
        let category: MomentCategory
        let eraScore: Int
        let minEra: EraType
        let maxEra: EraType

        init(
            name: String,
            summary: String,
            category: MomentCategory,
            eraScore: Int,
            minEra: EraType = .ancient,
            maxEra: EraType = .future) {

            self.name = name
            self.summary = summary
            self.category = category
            self.eraScore = eraScore
            self.minEra = minEra
            self.maxEra = maxEra
        }
    }

    private func data() -> MomentTypeData {

        switch self {

        case .founded(religion: _):
            return MomentTypeData(
                name: "Religion Founded",
                summary: "A Great Prophet founds a Religion, bringing light to your people.",
                category: .major,
                eraScore: 2
            )

        case .find(naturalWonder: _):
            return MomentTypeData(
                name: "Discovery of a Natural Wonder",
                summary: "Your civilization discovers this natural wonder for the first time.",
                category: .major,
                eraScore: 1
            )

        case .cityOnNewContinent:
            return MomentTypeData(
                name: "City on New Continent",
                summary: "A city is placed on a continent you have not yet settled.",
                category: .major,
                eraScore: 2
            )

        case .firstTier1Government:
            return MomentTypeData(
                name: "First Tier 1 Government",
                summary: "Your civilization adopts its first Tier 1 Government.",
                category: .major,
                eraScore: 2
            )

        case .firstTier1GovernmentInWorld:
            return MomentTypeData(
                name: "First Tier 1 Government in World",
                summary: "Your civilization is the first to adopt a Tier 1 Government in the world.",
                category: .major,
                eraScore: 3
            )

            // ...

        case .firstTechnologyOfNewEra:
            return MomentTypeData(
                name: "First Technology of New Era",
                summary: "You have completed your civilization's first technology from a new era of discovery.",
                category: .major,
                eraScore: 1
            )

        case .firstCivicOfNewEra:
            return MomentTypeData(
                name: "First Civic of New Era",
                summary: "You have completed your civilization's first civic from a new era of discovery.",
                category: .major,
                eraScore: 1
            )

            // -- minor --------------------------------------

        case .aggressiveCityPlacement:
            return MomentTypeData(
                name: "Aggressive City Placement",
                summary: "A city is placed within 5 tiles of another civilization's city.",
                category: .minor,
                eraScore: 1
            )

        case .artifactExtracted:
            return MomentTypeData(
                name: "Artifact Extracted",
                summary: "An artifact has been uncovered, giving us insight into the past.",
                category: .minor,
                eraScore: 1
            )

        case .barbarianCampDestroyed:
            return MomentTypeData(
                name: "Barbarian Camp Destroyed",
                summary: "A hostile barbarian camp was leveled to the ground by a unit, spreading peace through the area.",
                category: .minor,
                eraScore: 2,
                minEra: .ancient,
                maxEra: .medieval
            )

        case .battleFought:
            return MomentTypeData(
                name: "Battle Fought",
                summary: "A battle was fought between adversaries. Used by the Archaeology system to potentially generate Antiquity Site resources.",
                category: .minor,
                eraScore: 0
            )

            // ...

        case .metNew(civilization: _):
            return MomentTypeData(
                name: "Met New Civilization",
                summary: "You have made contact with a new civilization.",
                category: .minor,
                eraScore: 1
            )

            // ...

        case .completed(wonder: _):
            return MomentTypeData(
                name: "World Wonder Completed",
                summary: "A world wonder is completed, showing our grandeur over other civilizations.",
                category: .minor,
                eraScore: 4
            )

        }
    }
}

extension MomentType: Codable {

    enum Key: CodingKey {

        case rawValue // Int

        case religion // ReligionType
        case feature // FeatureType
        case civilization // CivilizationType
        case wonder // WonderType
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: Key.self)

        let rawValue = try container.decode(Int.self, forKey: .rawValue)

        switch rawValue {

        case 0:
            let religion = try container.decode(ReligionType.self, forKey: .religion)
            self = .founded(religion: religion)

        default:
            fatalError("not handled: \(rawValue)")
        }
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: Key.self)

        switch self {

        case .founded(religion: let religion):
            try container.encode(religion, forKey: .religion)
            try container.encode(0, forKey: .rawValue)

        default:
            fatalError("not handled: \(self.name())")
        }
    }
}
