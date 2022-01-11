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
    // case enemyCityStatePacified
    case enemyFormationDefeated // #
    case enemyVeteranDefeated // #
    case exoplanetExpeditionLaunched // #
    case finalForeignCityTaken // #
    case firstAerodromeFullyDeveloped // #
    case firstBustlingCity // #
    case firstCivicOfNewEra
    // case firstCorporationCreated
    // case firstCorporationInTheWorld
    case firstDiscoveryOfANaturalWonder // #
    case firstDiscoveryOfANewContinent // #
    case firstEncampmentFullyDeveloped // #
    case firstEnormousCity // #
    case firstEntertainmentComplexFullyDeveloped // #
    case firstGiganticCity // #
    // case firstGreenImprovement
    // case First Green Improvement in World
    // case First Hero Claimed
    // case First Hero Departed
    // case First Hero Recalled
    // case First Improvement after Natural Disaster
    // case First Industry Created
    // case First Industry in the World
    case firstLargeCity // #
    // case firstLuxuryResourceMonopoly
    // case firstLuxuryResourceMonopolyInTheWorld
    // case firstMasterSpyEarned
    // case firstMountainTunnel
    // case firstMountainTunnelInTheWorld
    case firstNeighborhoodCompleted // #
    // case First Railroad Connection
    // case First Railroad Connection in World
    // case First Resource consumed for Power
    // case First Resource consumed for Power in World
    // case First Rock Band Concert
    // case First Rock Band Concert in World
    // case First Seaside Resort
    case firstShipwreckExcavated // #
    case firstTechnologyOfNewEra
    case firstTier1Government // #
    case firstTier1GovernmentInWorld // #
    case firstTier2Government // #
    case firstTier2GovernmentInWorld // #
    case firstTier3Government // #
    case firstTier3GovernmentInWorld // #
    case firstTier4Government // #
    case firstTier4GovernmentInWorld // #
    case firstTradingPostsInAllCivilizations // #
    case firstUnitPromotedWithDistinction // #
    // case firstWaterParkFullyDeveloped
    // case freeCityJoins
    case generalDefeatsEnemy // #
    case goldenAgeBegins // #
    case governorFullyPromoted // #
    // case greatPersonLuredByFaith
    // case greatPersonLuredByGold
    case heroicAgeBegins // #
    // case inquisitionBegins
    // case Levied Army Stands Down
    case metAllCivilizations // #
    case nationalParkFounded // #
    case normalAgeBegins // #
    case onTheWaves // #
    case religionAdoptsAllBeliefs // #
    case religionFounded(religion: ReligionType)
    case rivalHolyCityConverted // #
    case splendidCampusCompleted // #
    case splendidCommercialHubCompleted // #
    case splendidHarborCompleted // #
    case splendidHolySiteCompleted // #
    case splendidIndustrialZoneCompleted // #
    case splendidTheaterSquareCompleted // #
    case takingFlight // #
    case threateningCampDestroyed // #
    case tradingPostsInAllCivilizations // #
    // Unique Building Constructed
    // Unique District Completed
    // Unique Tile Improvement Built
    // Unique Unit Marches
    // World's First Armada
    // World's First Army
    case worldsFirstBustlingCity // #
    case worldsFirstCircumnavigation // #
    case worldsFirstCivicOfNewEra // #
    // World's First Corps
    case worldsFirstEnormousCity // #
    case worldsFirstExoplanetExpeditionLaunched // #
    case worldsFirstFleet // #
    case worldsFirstFlight // #
    case worldsFirstGiganticCity // #
    // World's First Inquisition
    case worldsFirstLandingOnTheMoon // #
    case worldsFirstLargeCity // #
    case worldsFirstMartianColonyEstablished // #
    case worldsFirstNationalPark // #
    case worldsFirstNeighborhood // #
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

    public static var all: [MomentType] = [

        .admiralDefeatsEnemy,
        .allGovernorsAppointed,
        .canalCompleted,
        .cityNearFloodableRiver,
        .cityNearVolcano,
        .cityOfAwe,
        .cityOnNewContinent,
        // City-State's First Suzerain
        // City-State Army Levied Near Enemy
        // Climate Change Phase
        .darkAgeBegins,
        .discoveryOfANaturalWonder(naturalWonder: FeatureType.none),
        // Emergency Completed Successfully
        // Emergency Successfully Defended
        .enemyCityAdoptsOurReligion,
        // case enemyCityStatePacified
        .enemyFormationDefeated,
        .enemyVeteranDefeated,
        .exoplanetExpeditionLaunched,
        .finalForeignCityTaken,
        .firstAerodromeFullyDeveloped,
        .firstBustlingCity,
        .firstCivicOfNewEra,
        // case firstCorporationCreated
        // case firstCorporationInTheWorld
        .firstDiscoveryOfANaturalWonder,
        .firstDiscoveryOfANewContinent,
        .firstEncampmentFullyDeveloped,
        .firstEnormousCity,
        .firstEntertainmentComplexFullyDeveloped,
        .firstGiganticCity,
        // case firstGreenImprovement
        // case First Green Improvement in World
        // case First Hero Claimed
        // case First Hero Departed
        // case First Hero Recalled
        // case First Improvement after Natural Disaster
        // case First Industry Created
        // case First Industry in the World
        .firstLargeCity,
        // case firstLuxuryResourceMonopoly
        // case firstLuxuryResourceMonopolyInTheWorld
        // case firstMasterSpyEarned
        // case firstMountainTunnel
        // case firstMountainTunnelInTheWorld
        .firstNeighborhoodCompleted,
        // case First Railroad Connection
        // case First Railroad Connection in World
        // case First Resource consumed for Power
        // case First Resource consumed for Power in World
        // case First Rock Band Concert
        // case First Rock Band Concert in World
        // case First Seaside Resort
        .firstShipwreckExcavated,
        .firstTechnologyOfNewEra,
        .firstTier1Government,
        .firstTier1GovernmentInWorld,
        .firstTier2Government,
        .firstTier2GovernmentInWorld,
        .firstTier3Government,
        .firstTier3GovernmentInWorld,
        .firstTier4Government,
        .firstTier4GovernmentInWorld,
        .firstTradingPostsInAllCivilizations,
        .firstUnitPromotedWithDistinction,
        // case firstWaterParkFullyDeveloped
        // case freeCityJoins
        .generalDefeatsEnemy,
        .goldenAgeBegins,
        .governorFullyPromoted,
        // case greatPersonLuredByFaith
        // case greatPersonLuredByGold
        .heroicAgeBegins,
        // case inquisitionBegins
        // case Levied Army Stands Down
        .metAllCivilizations,
        .nationalParkFounded,
        .normalAgeBegins,
        .onTheWaves,
        .religionAdoptsAllBeliefs,
        .religionFounded(religion: ReligionType.none),
        .rivalHolyCityConverted,
        .splendidCampusCompleted,
        .splendidCommercialHubCompleted,
        .splendidHarborCompleted,
        .splendidHolySiteCompleted,
        .splendidIndustrialZoneCompleted,
        .splendidTheaterSquareCompleted,
        .takingFlight,
        .threateningCampDestroyed,
        .tradingPostsInAllCivilizations,
        // Unique Building Constructed
        // Unique District Completed
        // Unique Tile Improvement Built
        // Unique Unit Marches
        // World's First Armada
        // World's First Army
        .worldsFirstBustlingCity,
        .worldsFirstCircumnavigation,
        .worldsFirstCivicOfNewEra,
        // World's First Corps
        .worldsFirstEnormousCity,
        .worldsFirstExoplanetExpeditionLaunched,
        .worldsFirstFleet,
        .worldsFirstFlight,
        .worldsFirstGiganticCity,
        // World's First Inquisition
        .worldsFirstLandingOnTheMoon,
        .worldsFirstLargeCity,
        .worldsFirstMartianColonyEstablished,
        .worldsFirstNationalPark,
        .worldsFirstNeighborhood,
        .worldsFirstPantheon,
        .worldsFirstReligion,
        // ...
        .worldCircumnavigated,

        // minor
        .aggressiveCityPlacement,
        .artifactExtracted,
        .barbarianCampDestroyed,
        .battleFought,
        .causeForWar,
        .cityReturnsToOriginalOwner,
        // case cityStateArmyLevied // #
        // case coastalFloodMitigated // #
        .desertCity,
        .diplomaticVictoryResolutionWon,
        // case firstArmada
        .firstArmy,
        // case firstCorps // #
        .firstFleet,
        .foreignCapitalTaken,
        .greatPersonRecruited,
        // case heroClaimed // #
        // case heroDeparted // #
        // case heroRecalled // #
        .landedOnTheMoon,
        .manhattanProjectCompleted,
        .martianColonyEstablished,
        .masterSpyEarned,
        .metNew(civilization: CivilizationType.unmet),
        .oldGreatPersonRecruited,
        .oldWorldWonderCompleted,
        // case Operation Ivy Completed
        .pantheonFounded,
        .riverFloodMitigated,
        .satelliteLaunchedIntoOrbit,
        .snowCity,
        .strategicResourcePotentialUnleashed,
        .tradingPostEstablishedInNewCivilization,
        .tribalVillageContacted,
        .tundraCity,
        .unitPromotedWithDistinction,
        .wonderCompleted(wonder: WonderType.none),

        // hidden
        .constructSpecialtyDistrict,
        .shipSunk
    ]

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

    // swiftlint:disable function_body_length cyclomatic_complexity
    private func data() -> MomentTypeData {

        switch self {

            // -- major ---------------------------------

        case .admiralDefeatsEnemy:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_ADMIRAL_DEFEATS_ENEMY_TITLE",
                summary: "TXT_KEY_MOMENT_ADMIRAL_DEFEATS_ENEMY_SUMMARY",
                category: .major,
                eraScore: 2
            )

        case .allGovernorsAppointed:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_ALL_GOVERNORS_APPOINTED_TITLE",
                summary: "TXT_KEY_MOMENT_ALL_GOVERNORS_APPOINTED_SUMMARY",
                category: .major,
                eraScore: 1
            )

        case .canalCompleted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_CANAL_COMPLETED_TITLE",
                summary: "TXT_KEY_MOMENT_CANAL_COMPLETED_SUMMARY",
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

        case .enemyCityAdoptsOurReligion:
            return MomentTypeData(
                name: "Enemy City Adopts Our Religion",
                summary: "An enemy city, despite being at war, has seen the light and adopted our Religion.",
                category: .major,
                eraScore: 3
            )

        // case enemyCityStatePacified

        case .enemyFormationDefeated:
            return MomentTypeData(
                name: "Enemy Formation Defeated",
                summary: "One of your units defeated an enemy unit with a superior military formation.",
                category: .major,
                eraScore: 1
            )

        case .enemyVeteranDefeated:
            return MomentTypeData(
                name: "Enemy Veteran Defeated",
                summary: "One of your units defeated an enemy unit with at least 2 more promotions than it.",
                category: .major,
                eraScore: 3
            )

        case .exoplanetExpeditionLaunched:
            return MomentTypeData(
                name: "Exoplanet Expedition Launched",
                summary: "You have launched your civilization's expedition to a distant planet.",
                category: .major,
                eraScore: 2
            )

        case .finalForeignCityTaken:
            return MomentTypeData(
                name: "Final Foreign City Taken",
                summary: "You have taken control of a civilization's last remaining city.",
                category: .major,
                eraScore: 5
            )

        case .firstAerodromeFullyDeveloped:
            return MomentTypeData(
                name: "First Aerodrome Fully Developed",
                summary: "You have completed every building in an Aerodrome district for the first time.",
                category: .major,
                eraScore: 3
            )

        case .firstBustlingCity:
            return MomentTypeData(
                name: "First Bustling City",
                summary: "A city has reached 10 [Population] Population for the first time in your civilization.",
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

        // case firstCorporationCreated
        // case firstCorporationInTheWorld

        case .firstDiscoveryOfANaturalWonder:
            return MomentTypeData(
                name: "First Discovery of a Natural Wonder",
                summary: "Our civilization's explorers are the first in the world to behold this natural wonder.",
                category: .major,
                eraScore: 3
            )

        case .firstDiscoveryOfANewContinent:
            return MomentTypeData(
                name: "First Discovery of a New Continent",
                summary: "Our civilization's explorers are the first in the world to find this continent.",
                category: .major,
                eraScore: 4
            )

        case .firstEncampmentFullyDeveloped:
            return MomentTypeData(
                name: "First Encampment Fully Developed",
                summary: "You have completed every building in an Encampment district for the first time.",
                category: .major,
                eraScore: 3
            )

        case .firstEnormousCity:
            return MomentTypeData(
                name: "First Enormous City",
                summary: "A city has reached 20 [Population] Population for the first time in your civilization.",
                category: .major,
                eraScore: 1
            )

        case .firstEntertainmentComplexFullyDeveloped:
            return MomentTypeData(
                name: "First Entertainment Complex Fully Developed",
                summary: "You have completed every building in an Entertainment Complex district for the first time.",
                category: .major,
                eraScore: 3
            )

        case .firstGiganticCity:
            return MomentTypeData(
                name: "First Gigantic City",
                summary: "A city has reached 25 [Population] Population for the first time in your civilization.",
                category: .major,
                eraScore: 1
            )

        // case firstGreenImprovement
        // case First Green Improvement in World
        // case First Hero Claimed
        // case First Hero Departed
        // case First Hero Recalled
        // case First Improvement after Natural Disaster
        // case First Industry Created
        // case First Industry in the World

        case .firstLargeCity:
            return MomentTypeData(
                name: "First Large City",
                summary: "A city has reached 15 [Population] Population for the first time in your civilization.",
                category: .major,
                eraScore: 1
            )

        // case firstLuxuryResourceMonopoly
        // case firstLuxuryResourceMonopolyInTheWorld
        // case firstMasterSpyEarned
        // case firstMountainTunnel
        // case firstMountainTunnelInTheWorld

        case .firstNeighborhoodCompleted:
            return MomentTypeData(
                name: "First Neighborhood Completed",
                summary: "You have completed your civilization's first Neighborhood district.",
                category: .major,
                eraScore: 2
            )

        // case First Railroad Connection
        // case First Railroad Connection in World
        // case First Resource consumed for Power
        // case First Resource consumed for Power in World
        // case First Rock Band Concert
        // case First Rock Band Concert in World
        // case First Seaside Resort

        case .firstShipwreckExcavated:
            return MomentTypeData(
                name: "You have completed your civilization's first Neighborhood district.",
                summary: "Your archaeologists have excavated their first shipwreck.",
                category: .major,
                eraScore: 2
            )

        case .firstTechnologyOfNewEra:
            return MomentTypeData(
                name: "First Technology of New Era",
                summary: "You have completed your civilization's first technology from a new era of discovery.",
                category: .major,
                eraScore: 1
            )

        case .firstTier1Government:
            return MomentTypeData(
                name: "First Tier 1 Government",
                summary: "Your civilization adopts its first Tier 1 Government.",
                category: .major,
                eraScore: 2,
                maxEra: .classical
            )

        case .firstTier1GovernmentInWorld:
            return MomentTypeData(
                name: "First Tier 1 Government in World",
                summary: "Your civilization is the first to adopt a Tier 1 Government in the world.",
                category: .major,
                eraScore: 3,
                maxEra: .classical
            )

        case .firstTier2Government:
            return MomentTypeData(
                name: "First Tier 2 Government",
                summary: "Your civilization adopts its first Tier 2 Government.",
                category: .major,
                eraScore: 2,
                maxEra: .medieval
            )

        case .firstTier2GovernmentInWorld:
            return MomentTypeData(
                name: "First Tier 2 Government in World",
                summary: "Your civilization is the first to adopt a Tier 2 Government in the world.",
                category: .major,
                eraScore: 3,
                maxEra: .medieval
            )

        case .firstTier3Government:
            return MomentTypeData(
                name: "First Tier 3 Government",
                summary: "Your civilization adopts its first Tier 3 Government.",
                category: .major,
                eraScore: 2,
                maxEra: .modern
            )

        case .firstTier3GovernmentInWorld:
            return MomentTypeData(
                name: "First Tier 3 Government in World",
                summary: "Your civilization is the first to adopt a Tier 3 Government in the world.",
                category: .major,
                eraScore: 3,
                maxEra: .modern
            )

        case .firstTier4Government:
            return MomentTypeData(
                name: "First Tier 4 Government",
                summary: "Your civilization adopts its first Tier 4 Government.",
                category: .major,
                eraScore: 2,
                maxEra: .information
            )

        case .firstTier4GovernmentInWorld:
            return MomentTypeData(
                name: "First Tier 4 Government in World",
                summary: "Your civilization is the first to adopt a Tier 4 Government in the world.",
                category: .major,
                eraScore: 3,
                maxEra: .information
            )

        case .firstTradingPostsInAllCivilizations:
            return MomentTypeData(
                name: "First Trading Posts in All Civilizations",
                summary: "You are the first in the world to establish a [TradingPost] Trading Post in all civilizations.",
                category: .major,
                eraScore: 5
            )

        case .firstUnitPromotedWithDistinction:
            return MomentTypeData(
                name: "First Unit Promoted with Distinction",
                summary: "For the first time, one of your units reaches its fourth level of promotion.",
                category: .major,
                eraScore: 1
            )

        // case firstWaterParkFullyDeveloped
        // case freeCityJoins

        case .generalDefeatsEnemy:
            return MomentTypeData(
                name: "General Defeats Enemy",
                summary: "One of your [GreatGeneral] Great Generals has overseen their first victorious offensive against an enemy unit.",
                category: .major,
                eraScore: 2
            )

        case .goldenAgeBegins:
            return MomentTypeData(
                name: "Golden Age Begins",
                summary: "Golden Age Begins",
                category: .major,
                eraScore: 0
            )

        case .governorFullyPromoted:
            return MomentTypeData(
                name: "Governor Fully Promoted",
                summary: "You have fully promoted a [Governor] Governor for the first time, unlocking powerful abilities to help a city.",
                category: .major,
                eraScore: 1
            )

        // case greatPersonLuredByFaith
        // case greatPersonLuredByGold
        case .heroicAgeBegins:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_HEROIC_AGE_BEGINS_TITLE",
                summary: "TXT_KEY_MOMENT_HEROIC_AGE_BEGINS_SUMMARY",
                category: .major,
                eraScore: 0
            )
        // case inquisitionBegins
        // case Levied Army Stands Down

        case .metAllCivilizations:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_MET_ALL_CIVILIZATION_TITLE",
                summary: "TXT_KEY_MOMENT_MET_ALL_CIVILIZATION_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .nationalParkFounded:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_NATIONAL_PARK_FOUNDED_TITLE",
                summary: "TXT_KEY_MOMENT_NATIONAL_PARK_FOUNDED_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .normalAgeBegins:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_NORMAL_AGE_BEGINS_TITLE",
                summary: "TXT_KEY_MOMENT_NORMAL_AGE_BEGINS_SUMMARY",
                category: .major,
                eraScore: 0
            )

        case .onTheWaves:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_ON_THE_WAVES_TITLE",
                summary: "TXT_KEY_MOMENT_ON_THE_WAVES_SUMMARY",
                category: .major,
                eraScore: 2
            )

        case .religionAdoptsAllBeliefs:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_RELIGION_ADOPTS_ALL_BELIEFS_TITLE",
                summary: "TXT_KEY_MOMENT_RELIGION_ADOPTS_ALL_BELIEFS_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .religionFounded(religion: _):
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_RELIGION_FOUNDED_TITLE",
                summary: "TXT_KEY_MOMENT_RELIGION_FOUNDED_SUMMARY",
                category: .major,
                eraScore: 2
            )

        case .rivalHolyCityConverted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_RIVAL_HOLY_CITY_CONVERTED_TITLE",
                summary: "TXT_KEY_MOMENT_RIVAL_HOLY_CITY_CONVERTED_SUMMARY",
                category: .major,
                eraScore: 4
            )

        case .splendidCampusCompleted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_SPLENDID_CAMPUS_COMPLETED_TITLE",
                summary: "TXT_KEY_MOMENT_SPLENDID_CAMPUS_COMPLETED_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .splendidCommercialHubCompleted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_SPLENDID_COMMERCIAL_HUB_COMPLETED_TITLE",
                summary: "TXT_KEY_MOMENT_SPLENDID_COMMERCIAL_HUB_COMPLETED_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .splendidHarborCompleted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_SPLENDID_HARBOR_COMPLETED_TITLE",
                summary: "TXT_KEY_MOMENT_SPLENDID_HARBOR_COMPLETED_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .splendidHolySiteCompleted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_SPLENDID_HOLY_SITE_COMPLETED_TITLE",
                summary: "TXT_KEY_MOMENT_SPLENDID_HOLY_SITE_COMPLETED_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .splendidIndustrialZoneCompleted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_SPLENDID_INDUSTRIAL_ZONE_COMPLETED_TITLE",
                summary: "TXT_KEY_MOMENT_SPLENDID_INDUSTRIAL_ZONE_COMPLETED_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .splendidTheaterSquareCompleted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_SPLENDID_THEATER_SQUARE_COMPLETED_TITLE",
                summary: "TXT_KEY_MOMENT_SPLENDID_THEATER_SQUARE_COMPLETED_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .takingFlight:
            return MomentTypeData(
                name: "Taking Flight",
                summary: "You own your first flying unit. People rejoice at the new possibilities this entails.",
                category: .major,
                eraScore: 3
            )

        case .threateningCampDestroyed:
            return MomentTypeData(
                name: "Threatening Camp Destroyed",
                summary: "A hostile barbarian camp within 6 tiles of one of your cities was destroyed by a unit.",
                category: .major,
                eraScore: 3,
                minEra: .ancient,
                maxEra: .medieval
            )

        case .tradingPostsInAllCivilizations:
            return MomentTypeData(
                name: "Trading Posts in All Civilizations",
                summary: "You have established a [TradingPost] Trading Post in all civilizations.",
                category: .major,
                eraScore: 3
            )

        // Unique Building Constructed
        // Unique District Completed
        // Unique Tile Improvement Built
        // Unique Unit Marches
        // World's First Armada
        // World's First Army

        case .worldsFirstBustlingCity:
            return MomentTypeData(
                name: "World's First Bustling City",
                summary: "A city has reached 10 [Population] Population for the first time in the world.",
                category: .major,
                eraScore: 2
            )

        case .worldsFirstCircumnavigation:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_WORLDS_FIRST_CIRCUMNAVIGATION_TITLE",
                summary: "TXT_KEY_MOMENT_WORLDS_FIRST_CIRCUMNAVIGATION_SUMMARY",
                category: .major,
                eraScore: 5
            )

        case .worldsFirstCivicOfNewEra:
            return MomentTypeData(
                name: "World's First Civic of New Era",
                summary: "You have completed the world's first civic from a new era of discovery.",
                category: .major,
                eraScore: 2
            )

        // World's First Corps

        case .worldsFirstEnormousCity:
            return MomentTypeData(
                name: "World's First Enormous City",
                summary: "A city has reached 20 [Population] Population for the first time in the world.",
                category: .major,
                eraScore: 2
            )

        case .worldsFirstExoplanetExpeditionLaunched:
            return MomentTypeData(
                name: "World's First Exoplanet Expedition Launched",
                summary: "You are the first in the world to launch an expedition to a distant planet.",
                category: .major,
                eraScore: 4
            )

        case .worldsFirstFleet:
            return MomentTypeData(
                name: "World's First Fleet",
                summary: "The world's very first Fleet is formed, under your command.",
                category: .major,
                eraScore: 2
            )

        case .worldsFirstFlight:
            return MomentTypeData(
                name: "World's First Flight",
                summary: "You own the world's first flying unit! People rejoice at the new possibilities this entails.",
                category: .major,
                eraScore: 5
            )

        case .worldsFirstGiganticCity:
            return MomentTypeData(
                name: "World's First Gigantic City",
                summary: "A city has reached 25 [Population] Population for the first time in the world.",
                category: .major,
                eraScore: 2
            )

        // World's First Inquisition

        case .worldsFirstLandingOnTheMoon:
            return MomentTypeData(
                name: "World's First Landing on the Moon",
                summary: "You are the first in the world to land on the moon.",
                category: .major,
                eraScore: 4
            )

        case .worldsFirstLargeCity:
            return MomentTypeData(
                name: "World's First Large City",
                summary: "A city has reached 15 [Population] Population for the first time in the world.",
                category: .major,
                eraScore: 2
            )

        case .worldsFirstMartianColonyEstablished:
            return MomentTypeData(
                name: "World's First Martian Colony Established",
                summary: "You are the first in the world to establish a colony on Mars.",
                category: .major,
                eraScore: 4
            )

        case .worldsFirstNationalPark:
            return MomentTypeData(
                name: "World's First National Park",
                summary: "You have founded the world's first National Park.",
                category: .major,
                eraScore: 4
            )

        case .worldsFirstNeighborhood:
            return MomentTypeData(
                name: "World's First Neighborhood",
                summary: "You have completed the world's first Neighborhood district.",
                category: .major,
                eraScore: 3
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
            self = .religionFounded(religion: religion)

        default:
            fatalError("not handled: \(rawValue)")
        }
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {

        case .religionFounded(religion: let religion):
            try container.encode(0, forKey: .rawValue)
            try container.encode(religion, forKey: .religion)

        default:
            fatalError("not handled: \(self.name())")
        }
    }
}

extension MomentType: Equatable {

}
