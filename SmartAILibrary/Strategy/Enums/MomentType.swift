//
//  MomentType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.12.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum MomentCategory {

    case major
    case minor
    case hidden // just for scores
}

// https://www.civilopedia.net/gathering-storm/moments/moment_artifact_extracted
// swiftlint:disable type_body_length inclusive_language
public enum MomentType {

    // major
    case admiralDefeatsEnemy // #
    case allGovernorsAppointed
    case canalCompleted // #
    case cityNearFloodableRiver // #
    case cityNearVolcano // #
    case cityOfAwe // #
    case cityOnNewContinent
    // City-State's First Suzerain
    // City-State Army Levied Near Enemy
    // Climate Change Phase
    case darkAgeBegins
    case discoveryOfANaturalWonder(naturalWonder: FeatureType)
    // Emergency Completed Successfully
    // Emergency Successfully Defended
    case enemyCityAdoptsOurReligion // #
    // ...
    case founded(religion: ReligionType)
    case firstTier1Government // #
    case firstTier1GovernmentInWorld // #
    // ...
    case firstTechnologyOfNewEra
    case firstCivicOfNewEra
    // ...
    case worldsFirstPantheon
    case worldsFirstReligion
    // ...
    case worldCircumnavigated

    // minor
    case aggressiveCityPlacement // #
    case artifactExtracted // #
    case barbarianCampDestroyed
    case battleFought
    case causeForWar // #
    case cityReturnsToOriginalOwner // #
    // case cityStateArmyLevied // #
    // case coastalFloodMitigated // #
    case desertCity
    case diplomaticVictoryResolutionWon // #
    // case firstArmada
    case firstArmy // #
    // case firstCorps // #
    case firstFleet // #
    case foreignCapitalTaken // #
    case greatPersonRecruited
    // case heroClaimed // #
    // case heroDeparted // #
    // case heroRecalled // #
    case landedOnTheMoon // #
    case manhattanProjectCompleted // #
    case martianColonyEstablished // #
    case masterSpyEarned // #
    case metNew(civilization: CivilizationType)
    case oldGreatPersonRecruited
    case oldWorldWonderCompleted
    // case Operation Ivy Completed
    case pantheonFounded
    case riverFloodMitigated // #
    case satelliteLaunchedIntoOrbit // #
    case snowCity
    case strategicResourcePotentialUnleashed // #
    case tradingPostEstablishedInNewCivilization
    case tribalVillageContacted
    case tundraCity
    case unitPromotedWithDistinction
    case wonderCompleted(wonder: WonderType)

    // hidden
    case constructSpecialtyDistrict // for dedication monumentality
    case shipSunk // for artifacts

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

    public func minEra() -> EraType {

        return self.data().minEra
    }

    public func maxEra() -> EraType {

        return self.data().maxEra
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

    // swiftlint:disable function_body_length
    private func data() -> MomentTypeData {

        switch self {

            // -- major ---------------------------------

        case .admiralDefeatsEnemy:
            return MomentTypeData(
                name: "Admiral Defeats Enemy",
                summary: "One of your [Great Admiral] Great Admirals has overseen their first victorious offensive against an enemy unit.",
                category: .major,
                eraScore: 2
            )

        case .allGovernorsAppointed:
            return MomentTypeData(
                name: "All Governors Appointed",
                summary: "You have appointed all available  Governors, securing the prosperity of many cities.",
                category: .major,
                eraScore: 1
            )

        case .canalCompleted:
            return MomentTypeData(
                name: "Canal Completed",
                summary: "You have completed your civilization's first Canal district.",
                category: .major,
                eraScore: 2
            )

        case .cityNearFloodableRiver:
            return MomentTypeData(
                name: "City near Floodable River",
                summary: "A city is placed within 2 tiles of a river that could flood.",
                category: .major,
                eraScore: 1
            )

        case .cityNearVolcano:
            return MomentTypeData(
                name: "City near Volcano",
                summary: "A city is placed within 2 tiles of a volcano that could erupt.",
                category: .major,
                eraScore: 1
            )

        case .cityOfAwe:
            return MomentTypeData(
                name: "City of Awe",
                summary: "A city is placed within 2 tiles of a natural wonder.",
                category: .major,
                eraScore: 3
            )

        case .cityOnNewContinent:
            return MomentTypeData(
                name: "City on New Continent",
                summary: "A city is placed on a continent you have not yet settled.",
                category: .major,
                eraScore: 2
            )

        // City-State's First Suzerain
        // City-State Army Levied Near Enemy
        // Climate Change Phase

        case .darkAgeBegins:
            return MomentTypeData(
                name: "Dark Age Begins",
                summary: "The game enters a new era, and your civilization has the challenges of a Dark Age to overcome.",
                category: .major,
                eraScore: 0
            )

        case .discoveryOfANaturalWonder(naturalWonder: _):
            return MomentTypeData(
                name: "Discovery of a Natural Wonder",
                summary: "Your civilization discovers this natural wonder for the first time.",
                category: .major,
                eraScore: 1
            )

        // Emergency Completed Successfully
        // Emergency Successfully Defended

        // ...

        case .founded(religion: _):
            return MomentTypeData(
                name: "Religion Founded",
                summary: "A Great Prophet founds a Religion, bringing light to your people.",
                category: .major,
                eraScore: 2
            )

        case .enemyCityAdoptsOurReligion:
            return MomentTypeData(
                name: "Enemy City Adopts Our Religion",
                summary: "An enemy city, despite being at war, has seen the light and adopted our Religion.",
                category: .major,
                eraScore: 3
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

            // ...

        case .worldsFirstPantheon:
            return MomentTypeData(
                name: "World's First Pantheon",
                summary: "Your people are the first in the world to adopt Belief in a Pantheon.",
                category: .major,
                eraScore: 2
            )

        case .worldsFirstReligion:
            return MomentTypeData(
                name: "World's First Religion",
                summary: "Your people are the first to form a Religion, bringing light to the world at large!",
                category: .major,
                eraScore: 3
            )

            // ...

        case .worldCircumnavigated:
            return MomentTypeData(
                name: "World Circumnavigated",
                summary: "Your civilization has revealed a tile in every vertical line of the map." +
                    "This forms a path around the world, even if the path does not end where it began.",
                category: .major,
                eraScore: 3
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

        case .causeForWar:
            return MomentTypeData(
                name: "Cause for War",
                summary: "You have utilized a Casus Belli to make war on another civilization.",
                category: .minor,
                eraScore: 2
            )

        case .cityReturnsToOriginalOwner:
            return MomentTypeData(
                name: "City Returns to Original Owner",
                summary: "A city has returned to its original owner.",
                category: .minor,
                eraScore: 2
            )
        // case .cityStateArmyLevied:
        // case .coastalFloodMitigated:
        case .desertCity:
            return MomentTypeData(
                name: "Desert City",
                summary: "A city is established on difficult Desert terrain, expanding your reach into the wilds.",
                category: .minor,
                eraScore: 1
            )

        case .diplomaticVictoryResolutionWon:
            return MomentTypeData(
                name: "Diplomatic Victory Resolution Won",
                summary: "You have won the Diplomatic Victory resolution and earned Victory Points.",
                category: .minor,
                eraScore: 2
            )
        // case .firstArmada:
        case .firstArmy:
            return MomentTypeData(
                name: "First Army",
                summary: "Your civilization's first Army is formed.",
                category: .minor,
                eraScore: 1,
                maxEra: .modern
            )
        // case firstCorps // #
        case .firstFleet:
            return MomentTypeData(
                name: "First Fleet",
                summary: "Your civilization's first Fleet is formed.",
                category: .minor,
                eraScore: 1
            )
        case .foreignCapitalTaken:
            return MomentTypeData(
                name: "Foreign Capital Taken",
                summary: "You have taken control of a foreign power's original capital city.",
                category: .minor,
                eraScore: 4
            )
        case .greatPersonRecruited:
            return MomentTypeData(
                name: "Great Person Recruited",
                summary: "A  Great Person has traveled to our lands to share unique talents.",
                category: .minor,
                eraScore: 1
            )
        // case .heroClaimed:
        // case .heroDeparted:
        // case .heroRecalled:
        case .landedOnTheMoon:
            return MomentTypeData(
                name: "Landed on the Moon",
                summary: "You send a successful mission to land on the moon.",
                category: .minor,
                eraScore: 2
            )

        case .manhattanProjectCompleted:
            return MomentTypeData(
                name: "Manhattan Project Completed",
                summary: "Your scientists completed the Manhattan Project.",
                category: .minor,
                eraScore: 2
            )

        case .martianColonyEstablished:
            return MomentTypeData(
                name: "Martian Colony Established",
                summary: "You have established a colony on Mars.",
                category: .minor,
                eraScore: 2
            )

        case .masterSpyEarned:
            return MomentTypeData(
                name: "Master Spy Earned",
                summary: "One of your Spies has reached its maximum promotion level.",
                category: .minor,
                eraScore: 1
            )

        case .metNew(civilization: _):
            return MomentTypeData(
                name: "Met New Civilization",
                summary: "You have made contact with a new civilization.",
                category: .minor,
                eraScore: 1
            )

        case .oldGreatPersonRecruited:
            return MomentTypeData(
                name: "Old Great Person Recruited",
                summary: "A  Great Person has traveled to our lands." +
                    "Though better suited to a past era, they will still contribute great things to our civilization.",
                category: .minor,
                eraScore: 1
            )

        case .oldWorldWonderCompleted:
            return MomentTypeData(
                name: "Old World Wonder Completed",
                summary: "A World Wonder is completed." +
                    "Even though it belongs to a bygone era, it will still show our grandeur over other civilizations.",
                category: .minor,
                eraScore: 3
            )
        // case .operationIvyCompleted:
        case .pantheonFounded:
            return MomentTypeData(
                name: "Pantheon Founded",
                summary: "Your people adopt Belief in a Pantheon.",
                category: .minor,
                eraScore: 1,
                maxEra: .classical
            )

        case .riverFloodMitigated:
            return MomentTypeData(
                name: "River Flood Mitigated",
                summary: "Your constructed infrastructure has prevented damage from a river flood.",
                category: .minor,
                eraScore: 1
            )

        case .satelliteLaunchedIntoOrbit:
            return MomentTypeData(
                name: "Satellite Launched Into Orbit",
                summary: "You launched your civilization's first satellite into orbit.",
                category: .minor,
                eraScore: 2
            )

        case .snowCity:
            return MomentTypeData(
                name: "Snow City",
                summary: "A city is established on difficult Snow terrain, expanding your reach into the wilds.",
                category: .minor,
                eraScore: 1
            )

        case .strategicResourcePotentialUnleashed:
            return MomentTypeData(
                name: "Strategic Resource Potential Unleashed",
                summary: "You own your first unit that uses this strategic resource.",
                category: .minor,
                eraScore: 1
            )

        case .tradingPostEstablishedInNewCivilization:
            return MomentTypeData(
                name: "Trading Post Established in New Civilization",
                summary: "You have established your first  Trading Post in this civilization, opening up access to new markets.",
                category: .minor,
                eraScore: 1
            )

        case .tribalVillageContacted:
            return MomentTypeData(
                name: "Tribal Village Contacted",
                summary: "A Tribal Village was contacted, giving strength to our budding cities.",
                category: .minor,
                eraScore: 1,
                minEra: .ancient,
                maxEra: .ancient
            )

        case .tundraCity:
            return MomentTypeData(
                name: "Tundra City",
                summary: "A city is established on difficult Tundra terrain, expanding your reach into the wilds.",
                category: .minor,
                eraScore: 1
            )

        case .unitPromotedWithDistinction:
            return MomentTypeData(
                name: "Unit Promoted with Distinction",
                summary: "One of your units reaches its fourth level of promotion.",
                category: .minor,
                eraScore: 1
            )

        case .wonderCompleted(wonder: _):
            return MomentTypeData(
                name: "World Wonder Completed",
                summary: "A world wonder is completed, showing our grandeur over other civilizations.",
                category: .minor,
                eraScore: 4
            )

            // -- hidden -----------------------

        case .constructSpecialtyDistrict:
            return MomentTypeData(
                name: "Specialty District constructed",
                summary: "",
                category: .hidden,
                eraScore: 1
            )

        case .shipSunk:
            return MomentTypeData(
                name: "Ship Sunk",
                summary: "A naval unit was sunk in combat. Used by the Archaeology system to potentially generate Shipwreck resources.",
                category: .hidden,
                eraScore: 0
            )

        }
    }
}

extension MomentType: Codable {

    enum CodingKeys: CodingKey {

        case rawValue // Int

        case religion // ReligionType
        case feature // FeatureType
        case civilization // CivilizationType
        case wonder // WonderType
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

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

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {

        case .founded(religion: let religion):
            try container.encode(0, forKey: .rawValue)
            try container.encode(religion, forKey: .religion)

        default:
            fatalError("not handled: \(self.name())")
        }
    }
}

extension MomentType: Equatable {

}
