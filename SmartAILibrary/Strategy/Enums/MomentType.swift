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
// swiftlint:disable type_body_length inclusive_language identifier_name
public enum MomentType: Hashable {

    // major
    case admiralDefeatsEnemy // 1 #
    case allGovernorsAppointed // 2
    case canalCompleted // 3 #
    case cityNearFloodableRiver(cityName: String) // 4 #
    case cityNearVolcano(cityName: String) // 5
    case cityOfAwe(cityName: String) // 6
    case cityOnNewContinent(cityName: String, continentName: String) // 7
    // case cityStatesFirstSuzerain 8
    // case cityStateArmyLeviedNearEnemy 9
    // case climateChangePhase 10
    case darkAgeBegins // 11
    case discoveryOfANaturalWonder(naturalWonder: FeatureType) // 12
    // case emergencyCompletedSuccessfully 13
    // case emergencySuccessfullyDefended 14
    case enemyCityAdoptsOurReligion // 15 #
    // case enemyCityStatePacified 16
    case enemyFormationDefeated // 17 #
    case enemyVeteranDefeated // 18 #
    case exoplanetExpeditionLaunched // 19 #
    case finalForeignCityTaken // 20 #
    case firstAerodromeFullyDeveloped // 21 #
    case firstBustlingCity(cityName: String) // 22
    case firstCivicOfNewEra(eraType: EraType) // 23
    // case firstCorporationCreated 24
    // case firstCorporationInTheWorld 25
    case firstDiscoveryOfANaturalWonder // 26 #
    case firstDiscoveryOfANewContinent // 27
    case firstEncampmentFullyDeveloped // 28 #
    case firstEnormousCity(cityName: String) // 29
    case firstEntertainmentComplexFullyDeveloped // 30 #
    case firstGiganticCity(cityName: String) // 31
    // case firstGreenImprovement 32
    // case firstGreenImprovementInWorld 33
    // case firstHeroClaimed 34
    // case firstHeroDeparted 35
    // case firstHeroRecalled 36
    // case firstImprovementAfterNaturalDisaster 37
    // case firstIndustryCreated 38
    // case firstIndustryInTheWorld 39
    case firstLargeCity(cityName: String) // 40
    // case firstLuxuryResourceMonopoly 41
    // case firstLuxuryResourceMonopolyInTheWorld 42
    // case firstMasterSpyEarned 43
    // case firstMountainTunnel 44
    // case firstMountainTunnelInTheWorld 45
    case firstNeighborhoodCompleted // 46
    // case firstRailroadConnection 47
    // case firstRailroadConnectionInWorld 48
    // case firstResourceConsumedForPower 49
    // case firstResourceConsumedForPowerInWorld 50
    // case firstRockBandConcert 51
    // case firstRockBandConcertInWorld 52
    // case firstSeasideResort 53
    case firstShipwreckExcavated // 54 #
    case firstTechnologyOfNewEra(eraType: EraType) // 55
    case firstTier1Government(governmentType: GovernmentType) // 56 #
    case firstTier1GovernmentInWorld(governmentType: GovernmentType) // 57 #
    case firstTier2Government(governmentType: GovernmentType) // 58 #
    case firstTier2GovernmentInWorld(governmentType: GovernmentType) // 59 #
    case firstTier3Government(governmentType: GovernmentType) // 60 #
    case firstTier3GovernmentInWorld(governmentType: GovernmentType) // 61 #
    case firstTier4Government(governmentType: GovernmentType) // 62 #
    case firstTier4GovernmentInWorld(governmentType: GovernmentType) // 63 #
    case firstTradingPostsInAllCivilizations // 64 #
    case firstUnitPromotedWithDistinction // 65 #
    // case firstWaterParkFullyDeveloped 66
    // case freeCityJoins 67
    case generalDefeatsEnemy // 68 #
    case goldenAgeBegins // 69 #
    case governorFullyPromoted // 70
    // case greatPersonLuredByFaith 71
    // case greatPersonLuredByGold 72
    case heroicAgeBegins // 73 #
    // case inquisitionBegins 74
    // case leviedArmyStandsDown 75
    case metAllCivilizations // 76 #
    case nationalParkFounded // 77 #
    case normalAgeBegins // 78 #
    case onTheWaves // 79 #
    case religionAdoptsAllBeliefs // 80 #
    case religionFounded(religion: ReligionType) // 81
    case rivalHolyCityConverted // 82 #
    case splendidCampusCompleted // 83 #
    case splendidCommercialHubCompleted // 84 #
    case splendidHarborCompleted // 85 #
    case splendidHolySiteCompleted // 86 #
    case splendidIndustrialZoneCompleted // 87 #
    case splendidTheaterSquareCompleted // 88 #
    case takingFlight // 89 #
    case threateningCampDestroyed // 90 #
    case tradingPostsInAllCivilizations // 91 #
    // case uniqueBuildingConstructed 92
    // case uniqueDistrictCompleted 93
    // case uniqueTileImprovementBuilt 94
    // case uniqueUnitMarches 95
    // case worldsFirstArmada 96
    // case worldsFirstArmy 97
    case worldsFirstBustlingCity(cityName: String) // 98
    case worldsFirstCircumnavigation // 99
    case worldsFirstCivicOfNewEra(eraType: EraType) // 100
    // case worldsFirstCorps 101
    case worldsFirstEnormousCity(cityName: String) // 102
    case worldsFirstExoplanetExpeditionLaunched // 103 #
    case worldsFirstFleet // 104 #
    case worldsFirstFlight // 105 #
    case worldsFirstGiganticCity(cityName: String) // 106
    // case worldsFirstInquisition 107
    case worldsFirstLandingOnTheMoon // 108 #
    case worldsFirstLargeCity(cityName: String) // 109
    case worldsFirstMartianColonyEstablished // 110 #
    case worldsFirstNationalPark // 111 #
    case worldsFirstNeighborhood // 112
    case worldsFirstPantheon // 113
    case worldsFirstReligion // 114
    case worldsFirstReligionToAdoptAllBeliefs // 115 #
    case worldsFirstSatelliteInOrbit // 116 #
    case worldsFirstSeafaring // 117 #
    case worldsFirstSeasideResort // 118 #
    case worldsFirstShipwreckExcavated // 119 #
    case worldsFirstStrategicResourcePotentialUnleashed // 120 #
    case worldsFirstTechnologyOfNewEra(eraType: EraType) // 121
    case worldsFirstToMeetAllCivilizations // 122 #
    case worldsLargestCivilization // 123
    case worldCircumnavigated // 124

    // minor
    case aggressiveCityPlacement // 200 #
    case artifactExtracted // 201 #
    case barbarianCampDestroyed // 202
    case causeForWar(warType: CasusBelliType, civilizationType: CivilizationType) // 203 #
    case cityReturnsToOriginalOwner(cityName: String, originalCivilization: CivilizationType) // 204 #
    // case cityStateArmyLevied // 205 #
    // case coastalFloodMitigated // 206 #
    case desertCity(cityName: String) // 207
    case diplomaticVictoryResolutionWon // 208 #
    // case firstArmada 209
    case firstArmy // 210 #
    // case firstCorps // 211 #
    case firstFleet // 212 #
    case foreignCapitalTaken // 213 #
    case greatPersonRecruited // 214
    // case heroClaimed // 215 #
    // case heroDeparted // 216 #
    // case heroRecalled // 217 #
    case landedOnTheMoon // 218 #
    case manhattanProjectCompleted // 219 #
    case martianColonyEstablished // 220 #
    case masterSpyEarned // 221 #
    case metNewCivilization(civilization: CivilizationType) // 222
    case oldGreatPersonRecruited // 223
    case oldWorldWonderCompleted // 224
    // case operationIvyCompleted 225
    case pantheonFounded(pantheon: PantheonType) // 226
    case riverFloodMitigated // 227 #
    case satelliteLaunchedIntoOrbit // 228 #
    case snowCity(cityName: String) // 229
    case strategicResourcePotentialUnleashed // 230 #
    case tradingPostEstablishedInNewCivilization(civilization: CivilizationType) // 231
    case tribalVillageContacted // 232
    case tundraCity(cityName: String) // 233
    case unitPromotedWithDistinction // 234
    case wonderCompleted(wonder: WonderType) // 235

    // hidden
    case shipSunk // 300 for artifacts
    case battleFought // 301
    case dedicationTriggered(dedicationType: DedicationType) // 302 for dedications

    public static var all: [MomentType] = [

        .admiralDefeatsEnemy,
        .allGovernorsAppointed,
        .canalCompleted,
        .cityNearFloodableRiver(cityName: ""),
        .cityNearVolcano(cityName: ""),
        .cityOfAwe(cityName: ""),
        .cityOnNewContinent(cityName: "", continentName: ""),
        // .cityStatesFirstSuzerain
        // .cityStateArmyLeviedNearEnemy
        // .climateChangePhase
        .darkAgeBegins,
        .discoveryOfANaturalWonder(naturalWonder: FeatureType.none),
        // .emergencyCompletedSuccessfully
        // .emergencySuccessfullyDefended
        .enemyCityAdoptsOurReligion,
        // .enemyCityStatePacified
        .enemyFormationDefeated,
        .enemyVeteranDefeated,
        .exoplanetExpeditionLaunched,
        .finalForeignCityTaken,
        .firstAerodromeFullyDeveloped,
        .firstBustlingCity(cityName: ""),
        .firstCivicOfNewEra(eraType: EraType.none),
        // .firstCorporationCreated
        // .firstCorporationInTheWorld
        .firstDiscoveryOfANaturalWonder,
        .firstDiscoveryOfANewContinent,
        .firstEncampmentFullyDeveloped,
        .firstEnormousCity(cityName: ""),
        .firstEntertainmentComplexFullyDeveloped,
        .firstGiganticCity(cityName: ""),
        // .firstGreenImprovement
        // .firstGreenImprovementInWorld
        // .firstHeroClaimed
        // .firstHeroDeparted
        // .firstHeroRecalled
        // .firstImprovementAfterNaturalDisaster
        // .firstIndustryCreated
        // .firstIndustryInTheWorld
        .firstLargeCity(cityName: ""),
        // .firstLuxuryResourceMonopoly
        // .firstLuxuryResourceMonopolyInTheWorld
        // .firstMasterSpyEarned
        // .firstMountainTunnel
        // .firstMountainTunnelInTheWorld
        .firstNeighborhoodCompleted,
        // .firstRailroadConnection
        // .firstRailroadConnectionInWorld
        // .firstResourceConsumedForPower
        // .firstResourceConsumedForPowerInWorld
        // .firstRockBandConcert
        // .firstRockBandConcertInWorld
        // .firstSeasideResort
        .firstShipwreckExcavated,
        .firstTechnologyOfNewEra(eraType: EraType.none),
        .firstTier1Government(governmentType: GovernmentType.chiefdom),
        .firstTier1GovernmentInWorld(governmentType: GovernmentType.chiefdom),
        .firstTier2Government(governmentType: GovernmentType.chiefdom),
        .firstTier2GovernmentInWorld(governmentType: GovernmentType.chiefdom),
        .firstTier3Government(governmentType: GovernmentType.chiefdom),
        .firstTier3GovernmentInWorld(governmentType: GovernmentType.chiefdom),
        .firstTier4Government(governmentType: GovernmentType.chiefdom),
        .firstTier4GovernmentInWorld(governmentType: GovernmentType.chiefdom),
        .firstTradingPostsInAllCivilizations,
        .firstUnitPromotedWithDistinction,
        // .firstWaterParkFullyDeveloped,
        // .freeCityJoins,
        .generalDefeatsEnemy,
        .goldenAgeBegins,
        .governorFullyPromoted,
        // .greatPersonLuredByFaith,
        // .greatPersonLuredByGold,
        .heroicAgeBegins,
        // .inquisitionBegins,
        // .leviedArmyStandsDown,
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
        // .uniqueBuildingConstructed
        // .uniqueDistrictCompleted
        // .uniqueTileImprovement Built
        // .uniqueUnitMarches
        // .worldsFirstArmada
        // .worldsFirstArmy
        .worldsFirstBustlingCity(cityName: ""),
        .worldsFirstCircumnavigation,
        .worldsFirstCivicOfNewEra(eraType: EraType.none),
        // .worldsFirstCorps,
        .worldsFirstEnormousCity(cityName: ""),
        .worldsFirstExoplanetExpeditionLaunched,
        .worldsFirstFleet,
        .worldsFirstFlight,
        .worldsFirstGiganticCity(cityName: ""),
        // .worldsFirstInquisition,
        .worldsFirstLandingOnTheMoon,
        .worldsFirstLargeCity(cityName: ""),
        .worldsFirstMartianColonyEstablished,
        .worldsFirstNationalPark,
        .worldsFirstNeighborhood,
        .worldsFirstPantheon,
        .worldsFirstReligion,
        .worldsFirstReligionToAdoptAllBeliefs,
        .worldsFirstSatelliteInOrbit,
        .worldsFirstSeafaring,
        .worldsFirstSeasideResort,
        .worldsFirstShipwreckExcavated,
        .worldsFirstStrategicResourcePotentialUnleashed,
        .worldsFirstTechnologyOfNewEra(eraType: EraType.none),
        .worldsFirstToMeetAllCivilizations,
        .worldsLargestCivilization,
        .worldCircumnavigated,

        // minor
        .aggressiveCityPlacement,
        .artifactExtracted,
        .barbarianCampDestroyed,
        .causeForWar(warType: CasusBelliType.ancientWar, civilizationType: CivilizationType.unmet),
        .cityReturnsToOriginalOwner(cityName: "", originalCivilization: CivilizationType.unmet),
        // case cityStateArmyLevied
        // case coastalFloodMitigated
        .desertCity(cityName: ""),
        .diplomaticVictoryResolutionWon,
        // case firstArmada
        .firstArmy,
        // case firstCorps
        .firstFleet,
        .foreignCapitalTaken,
        .greatPersonRecruited,
        // case heroClaimed
        // case heroDeparted
        // case heroRecalled
        .landedOnTheMoon,
        .manhattanProjectCompleted,
        .martianColonyEstablished,
        .masterSpyEarned,
        .metNewCivilization(civilization: CivilizationType.unmet),
        .oldGreatPersonRecruited,
        .oldWorldWonderCompleted,
        // case operationIvyCompleted
        .pantheonFounded(pantheon: PantheonType.none),
        .riverFloodMitigated,
        .satelliteLaunchedIntoOrbit,
        .snowCity(cityName: ""),
        .strategicResourcePotentialUnleashed,
        .tradingPostEstablishedInNewCivilization(civilization: CivilizationType.unmet),
        .tribalVillageContacted,
        .tundraCity(cityName: ""),
        .unitPromotedWithDistinction,
        .wonderCompleted(wonder: WonderType.none),

        // hidden
        .shipSunk,
        .battleFought,
        .dedicationTriggered(dedicationType: DedicationType.none)
    ]

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func summary() -> String {

        return self.data().summary
    }

    public func instanceText() -> String {

        if let text = self.data().instanceText {
            return text
        }

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
        let instanceText: String?
        let category: MomentCategory
        let eraScore: Int
        let minEra: EraType
        let maxEra: EraType

        init(
            name: String,
            summary: String,
            instanceText: String? = nil,
            category: MomentCategory,
            eraScore: Int,
            minEra: EraType = .ancient,
            maxEra: EraType = .future) {

            self.name = name
            self.summary = summary
            self.instanceText = instanceText
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
                name: "TXT_KEY_MOMENT_CITY_NEAR_FLOODABLE_RIVER_TITLE",
                summary: "TXT_KEY_MOMENT_CITY_NEAR_FLOODABLE_RIVER_SUMMARY",
                category: .major,
                eraScore: 1
            )

        case .cityNearVolcano:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_CITY_NEAR_VOLCANO_TITLE",
                summary: "TXT_KEY_MOMENT_CITY_NEAR_VOLCANO_SUMMARY",
                category: .major,
                eraScore: 1
            )

        case .cityOfAwe:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_CITY_OF_AWE_TITLE",
                summary: "TXT_KEY_MOMENT_CITY_OF_AWE_SUMMARY",
                category: .major,
                eraScore: 3
            )

        case .cityOnNewContinent:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_CITY_ON_NEW_CONTINENT_TITLE",
                summary: "TXT_KEY_MOMENT_CITY_OF_NEW_CONTINENT_SUMMARY",
                category: .major,
                eraScore: 2
            )

        // City-State's First Suzerain
        // City-State Army Levied Near Enemy
        // Climate Change Phase

        case .darkAgeBegins:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_DARK_AGE_BEGINS_TITLE",
                summary: "TXT_KEY_MOMENT_DARK_AGE_BEGINS_SUMMARY",
                category: .major,
                eraScore: 0
            )

        case .discoveryOfANaturalWonder(naturalWonder: _):
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_DISCOVERY_OF_A_NATURAL_WONDER_TITLE",
                summary: "TXT_KEY_MOMENT_DISCOVERY_OF_A_NATURAL_WONDER_SUMMARY",
                category: .major,
                eraScore: 1
            )

        // Emergency Completed Successfully
        // Emergency Successfully Defended

        case .enemyCityAdoptsOurReligion:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_ENEMY_CITY_ADOPTS_OUR_RELIGION_TITLE",
                summary: "TXT_KEY_MOMENT_ENEMY_CITY_ADOPTS_OUR_RELIGION_SUMMARY",
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
                name: "TXT_KEY_MOMENT_FIRST_BUSTLING_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_FIRST_BUSTLING_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_FIRST_BUSTLING_CITY_INSTANCE",
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
                name: "TXT_KEY_MOMENT_FIRST_ENORMOUS_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_FIRST_ENORMOUS_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_FIRST_ENORMOUS_CITY_INSTANCE",
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
                name: "TXT_KEY_MOMENT_FIRST_GIGANTIC_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_FIRST_GIGANTIC_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_FIRST_GIGANTIC_CITY_INSTANCE",
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
                name: "TXT_KEY_MOMENT_FIRST_LARGE_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_FIRST_LARGE_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_FIRST_LARGE_CITY_INSTANCE",
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
                name: "First Shipwreck Excavated",
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
                name: "TXT_KEY_MOMENT_WORLDS_FIRST_BUSTLING_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_WORLDS_FIRST_BUSTLING_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_WORLDS_FIRST_BUSTLING_CITY_INSTANCE",
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
                name: "TXT_KEY_MOMENT_WORLDS_FIRST_ENORMOUS_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_WORLDS_FIRST_ENORMOUS_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_WORLDS_FIRST_ENORMOUS_CITY_INSTANCE",
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
                name: "TXT_KEY_MOMENT_WORLDS_FIRST_GIGANTIC_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_WORLDS_FIRST_GIGANTIC_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_WORLDS_FIRST_GIGANTIC_CITY_INSTANCE",
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
                name: "TXT_KEY_MOMENT_WORLDS_FIRST_LARGE_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_WORLDS_FIRST_LARGE_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_WORLDS_FIRST_LARGE_CITY_INSTANCE",
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

        case .worldsFirstReligionToAdoptAllBeliefs:
            return MomentTypeData(
                name: "World's First Religion to Adopt All Beliefs",
                summary: "Your Religion is the first in the world to add its final Belief and become complete.",
                category: .major,
                eraScore: 4
            )

        case .worldsFirstSatelliteInOrbit:
            return MomentTypeData(
                name: "World's First Satellite in Orbit",
                summary: "You launched the world's first satellite into orbit.",
                category: .major,
                eraScore: 4
            )

        case .worldsFirstSeafaring:
            return MomentTypeData(
                name: "World's First Seafaring",
                summary: "You own the world's first seafaring unit! A world of possibility awaits on the horizon.",
                category: .major,
                eraScore: 3
            )

        case .worldsFirstSeasideResort:
            return MomentTypeData(
                name: "World's First Seaside Resort",
                summary: "You have completed the world's first Seaside Resort tile improvement.",
                category: .major,
                eraScore: 3
            )

        case .worldsFirstShipwreckExcavated:
            return MomentTypeData(
                name: "World's First Shipwreck Excavated",
                summary: "Your archaeologists have completed the world's first excavation of a shipwreck.",
                category: .major,
                eraScore: 3
            )

        case .worldsFirstStrategicResourcePotentialUnleashed:
            return MomentTypeData(
                name: "World's First Strategic Resource Potential Unleashed",
                summary: "You are the world's first civilization to own a unit using this strategic resource.",
                category: .major,
                eraScore: 2
            )

        case .worldsFirstTechnologyOfNewEra(eraType: _):
            return MomentTypeData(
                name: "World's First Technology of New Era",
                summary: "You have completed the world's first technology from a new era of discovery.",
                category: .major,
                eraScore: 2
            )

        case .worldsFirstToMeetAllCivilizations:
            return MomentTypeData(
                name: "World's First to Meet All Civilizations",
                summary: "You are the first to meet all living civilizations in the world.",
                category: .major,
                eraScore: 5
            )

        case .worldsLargestCivilization:
            return MomentTypeData(
                name: "World's Largest Civilization",
                summary: "Your civilization has become the largest in the world, with at least 3 more cities than its next biggest rival.",
                category: .major,
                eraScore: 3
            )

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
                name: "TXT_KEY_MOMENT_BARBARIAN_CAMP_DESTROYED_TITLE",
                summary: "TXT_KEY_MOMENT_BARBARIAN_CAMP_DESTROYED_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_BARBARIAN_CAMP_DESTROYED_INSTANCE",
                category: .minor,
                eraScore: 2,
                minEra: .ancient,
                maxEra: .medieval
            )

        case .causeForWar:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_CAUSE_FOR_WAR_TITLE",
                summary: "TXT_KEY_MOMENT_CAUSE_FOR_WAR_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_CAUSE_FOR_WAR_INSTANCE",
                category: .minor,
                eraScore: 2
            )

        case .cityReturnsToOriginalOwner(cityName: _, originalCivilization: _):
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_CITY_RETURNS_TO_ORIGINAL_OWNER_TITLE",
                summary: "TXT_KEY_MOMENT_CITY_RETURNS_TO_ORIGINAL_OWNER_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_CITY_RETURNS_TO_ORIGINAL_OWNER_INSTANCE",
                category: .minor,
                eraScore: 2
            )
        // case .cityStateArmyLevied:
        // case .coastalFloodMitigated:
        case .desertCity(cityName: _):
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_DESERT_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_DESERT_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_DESERT_CITY_INSTANCE",
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

        case .metNewCivilization(civilization: _):
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
        case .pantheonFounded(pantheon: let pantheon):
            return MomentTypeData(
                name: "Pantheon Founded",
                summary: "Your people adopt the Belief \(pantheon.name()) in a Pantheon.",
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
                name: "TXT_KEY_MOMENT_SNOW_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_SNOW_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_SNOW_CITY_INSTANCE",
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
                name: "TXT_KEY_MOMENT_TRADING_POST_ESTABLISHED_IN_NEW_CIVILIZATION_TITLE",
                summary: "TXT_KEY_MOMENT_TRADING_POST_ESTABLISHED_IN_NEW_CIVILIZATION_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_TRADING_POST_ESTABLISHED_IN_NEW_CIVILIZATION_INSTANCE",
                category: .minor,
                eraScore: 1
            )

        case .tribalVillageContacted:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_TRIBAL_VILLAGE_CONTACTED_TITLE",
                summary: "TXT_KEY_MOMENT_TRIBAL_VILLAGE_CONTACTED_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_TRIBAL_VILLAGE_CONTACTED_INSTANCE",
                category: .minor,
                eraScore: 1,
                minEra: .ancient,
                maxEra: .ancient
            )

        case .tundraCity(cityName: _):
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_TUNDRA_CITY_TITLE",
                summary: "TXT_KEY_MOMENT_TUNDRA_CITY_SUMMARY",
                instanceText: "TXT_KEY_MOMENT_TUNDRA_CITY_INSTANCE",
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

        case .shipSunk:
            return MomentTypeData(
                name: "Ship Sunk",
                summary: "A naval unit was sunk in combat. Used by the Archaeology system to potentially generate Shipwreck resources.",
                category: .hidden,
                eraScore: 0
            )

        case .battleFought:
            return MomentTypeData(
                name: "TXT_KEY_MOMENT_BATTLE_FOUGHT_TITLE",
                summary: "TXT_KEY_MOMENT_BATTLE_FOUGHT_SUMMARY",
                category: .hidden,
                eraScore: 0
            )

        case .dedicationTriggered(dedicationType: _):
            return MomentTypeData(
                name: "Dedication triggered",
                summary: "",
                category: .hidden,
                eraScore: 1
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
        case cityName // String
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rawValue = try container.decode(Int.self, forKey: .rawValue)

        switch rawValue {

        case 0:
            let religion = try container.decode(ReligionType.self, forKey: .religion)
            self = .religionFounded(religion: religion)

            // ...

        case 12:
            let naturalWonder = try container.decode(FeatureType.self, forKey: .feature)
            self = .discoveryOfANaturalWonder(naturalWonder: naturalWonder)

            // ...

        case 232:
            self = .tribalVillageContacted

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

            // ...

        case .discoveryOfANaturalWonder(naturalWonder: let naturalWonder):
            try container.encode(12, forKey: .rawValue)
            try container.encode(naturalWonder, forKey: .feature)

            // ...

        case .tribalVillageContacted:
            try container.encode(232, forKey: .rawValue)

        default:
            fatalError("not handled: \(self.name())")
        }
    }
}

extension MomentType: Equatable {

    public static func == (lhs: MomentType, rhs: MomentType) -> Bool {

        switch (lhs, rhs) {

        case (.admiralDefeatsEnemy, .admiralDefeatsEnemy):
            return true
        case (.allGovernorsAppointed, .allGovernorsAppointed):
            return true
        case (.canalCompleted, .canalCompleted):
            return true
        case (.cityNearFloodableRiver(cityName: _), .cityNearFloodableRiver(cityName: _)):
            return true
        case (.cityNearVolcano(cityName: _), .cityNearVolcano(cityName: _)):
            return true
        case (.cityOfAwe(cityName: _), .cityOfAwe(cityName: _)):
            return true
        case (.cityOnNewContinent(cityName: _, continentName: _), .cityOnNewContinent(cityName: _, continentName: _)):
            return true
        // case cityStatesFirstSuzerain
        // case cityStateArmyLeviedNearEnemy
        // case climateChangePhase
        case (.darkAgeBegins, .darkAgeBegins):
            return true
        case (.discoveryOfANaturalWonder(naturalWonder: _), .discoveryOfANaturalWonder(naturalWonder: _)):
            return true
        // case emergencyCompletedSuccessfully
        // case emergencySuccessfullyDefended
        case (.enemyCityAdoptsOurReligion, enemyCityAdoptsOurReligion):
            return true
        // case enemyCityStatePacified
        case (.enemyFormationDefeated, .enemyFormationDefeated):
            return true
        case (.enemyVeteranDefeated, .enemyVeteranDefeated):
            return true
        case (.exoplanetExpeditionLaunched, .exoplanetExpeditionLaunched):
            return true
        case (.finalForeignCityTaken, .finalForeignCityTaken):
            return true
        case (.firstAerodromeFullyDeveloped, .firstAerodromeFullyDeveloped):
            return true
        case (.firstBustlingCity(cityName: _), .firstBustlingCity(cityName: _)):
            return true
        case (.firstCivicOfNewEra(eraType: _), .firstCivicOfNewEra(eraType: _)):
            return true
        // case firstCorporationCreated
        // case firstCorporationInTheWorld
        case (.firstDiscoveryOfANaturalWonder, .firstDiscoveryOfANaturalWonder):
            return true
        case (.firstDiscoveryOfANewContinent, .firstDiscoveryOfANewContinent):
            return true
        case (.firstEncampmentFullyDeveloped, .firstEncampmentFullyDeveloped):
            return true
        case (.firstEnormousCity(cityName: _), .firstEnormousCity(cityName: _)):
            return true
        case (.firstEntertainmentComplexFullyDeveloped, .firstEntertainmentComplexFullyDeveloped):
            return true
        case (.firstGiganticCity(cityName: _), .firstGiganticCity(cityName: _)):
            return true
        // case firstGreenImprovement
        // case firstGreenImprovementInWorld
        // case firstHeroClaimed
        // case firstHeroDeparted
        // case firstHeroRecalled
        // case firstImprovementAfterNaturalDisaster
        // case firstIndustryCreated
        // case firstIndustryInTheWorld
        case (.firstLargeCity(cityName: _), .firstLargeCity(cityName: _)):
            return true
        // case firstLuxuryResourceMonopoly
        // case firstLuxuryResourceMonopolyInTheWorld
        // case firstMasterSpyEarned
        // case firstMountainTunnel
        // case firstMountainTunnelInTheWorld
        case (.firstNeighborhoodCompleted, .firstNeighborhoodCompleted):
            return true
        // case firstRailroadConnection
        // case firstRailroadConnectionInWorld
        // case firstResourceConsumedForPower
        // case firstResourceConsumedForPowerInWorld
        // case firstRockBandConcert
        // case firstRockBandConcertInWorld
        // case firstSeasideResort
        case (.firstShipwreckExcavated, .firstShipwreckExcavated):
            return true
        case (.firstTechnologyOfNewEra(eraType: _), .firstTechnologyOfNewEra(eraType: _)):
            return true
        case (.firstTier1Government(governmentType: _), .firstTier1Government(governmentType: _)):
            return true
        case (.firstTier1GovernmentInWorld(governmentType: _), .firstTier1GovernmentInWorld(governmentType: _)):
            return true
        case (.firstTier2Government(governmentType: _), .firstTier2Government(governmentType: _)):
            return true
        case (.firstTier2GovernmentInWorld(governmentType: _), .firstTier2GovernmentInWorld(governmentType: _)):
            return true
        case (.firstTier3Government(governmentType: _), .firstTier3Government(governmentType: _)):
            return true
        case (.firstTier3GovernmentInWorld(governmentType: _), .firstTier3GovernmentInWorld(governmentType: _)):
            return true
        case (.firstTier4Government(governmentType: _), .firstTier4Government(governmentType: _)):
            return true
        case (.firstTier4GovernmentInWorld(governmentType: _), .firstTier4GovernmentInWorld(governmentType: _)):
            return true
        case (.firstTradingPostsInAllCivilizations, .firstTradingPostsInAllCivilizations):
            return true
        case (.firstUnitPromotedWithDistinction, .firstUnitPromotedWithDistinction):
            return true
        // case firstWaterParkFullyDeveloped
        // case freeCityJoins
        case (.generalDefeatsEnemy, .generalDefeatsEnemy):
            return true
        case (.goldenAgeBegins, .goldenAgeBegins):
            return true
        case (.governorFullyPromoted, .governorFullyPromoted):
            return true
        // case greatPersonLuredByFaith
        // case greatPersonLuredByGold
        case (.heroicAgeBegins, .heroicAgeBegins):
            return true
        // case inquisitionBegins
        // case leviedArmyStandsDown
        case (.metAllCivilizations, .metAllCivilizations):
            return true
        case (.nationalParkFounded, .nationalParkFounded):
            return true
        case (.normalAgeBegins, .normalAgeBegins):
            return true
        case (.onTheWaves, .onTheWaves):
            return true
        case (.religionAdoptsAllBeliefs, .religionAdoptsAllBeliefs):
            return true
        case (.religionFounded(religion: _), .religionFounded(religion: _)):
            return true
        case (.rivalHolyCityConverted, .rivalHolyCityConverted):
            return true
        case (.splendidCampusCompleted, .splendidCampusCompleted):
            return true
        case (.splendidCommercialHubCompleted, .splendidCommercialHubCompleted):
            return true
        case (.splendidHarborCompleted, .splendidHarborCompleted):
            return true
        case (.splendidHolySiteCompleted, .splendidHolySiteCompleted):
            return true
        case (.splendidIndustrialZoneCompleted, .splendidIndustrialZoneCompleted):
            return true
        case (.splendidTheaterSquareCompleted, .splendidTheaterSquareCompleted):
            return true
        case (.takingFlight, .takingFlight):
            return true
        case (.threateningCampDestroyed, .threateningCampDestroyed):
            return true
        case (.tradingPostsInAllCivilizations, .tradingPostsInAllCivilizations):
            return true
        // case uniqueBuildingConstructed
        // case uniqueDistrictCompleted
        // case uniqueTileImprovementBuilt
        // case uniqueUnitMarches
        // case worldsFirstArmada
        // case worldsFirstArmy
        case (.worldsFirstBustlingCity(cityName: _), .worldsFirstBustlingCity(cityName: _)):
            return true
        case (.worldsFirstCircumnavigation, .worldsFirstCircumnavigation):
            return true
        case (.worldsFirstCivicOfNewEra(eraType: _), .worldsFirstCivicOfNewEra(eraType: _)):
            return true
        // case worldsFirstCorps
        case (.worldsFirstEnormousCity(cityName: _), .worldsFirstEnormousCity(cityName: _)):
            return true
        case (.worldsFirstExoplanetExpeditionLaunched, .worldsFirstExoplanetExpeditionLaunched):
            return true
        case (.worldsFirstFleet, .worldsFirstFleet):
            return true
        case (.worldsFirstFlight, .worldsFirstFlight):
            return true
        case (.worldsFirstGiganticCity(cityName: _), .worldsFirstGiganticCity(cityName: _)):
            return true

        // worldsFirstInquisition
        case (.worldsFirstLandingOnTheMoon, .worldsFirstLandingOnTheMoon):
            return true
        case (.worldsFirstLargeCity(cityName: _), .worldsFirstLargeCity(cityName: _)):
            return true
        case (.worldsFirstMartianColonyEstablished, .worldsFirstMartianColonyEstablished):
            return true
        case (.worldsFirstNationalPark, .worldsFirstNationalPark):
            return true
        case (.worldsFirstNeighborhood, .worldsFirstNeighborhood):
            return true
        case (.worldsFirstPantheon, .worldsFirstPantheon):
            return true
        case (.worldsFirstReligion, .worldsFirstReligion):
            return true
        case (.worldsFirstReligionToAdoptAllBeliefs, .worldsFirstReligionToAdoptAllBeliefs):
            return true
        case (.worldsFirstSatelliteInOrbit, .worldsFirstSatelliteInOrbit):
            return true
        case (.worldsFirstSeafaring, .worldsFirstSeafaring):
            return true
        case (.worldsFirstSeasideResort, .worldsFirstSeasideResort):
            return true
        case (.worldsFirstShipwreckExcavated, .worldsFirstShipwreckExcavated):
            return true
        case (.worldsFirstStrategicResourcePotentialUnleashed, .worldsFirstStrategicResourcePotentialUnleashed):
            return true
        case (.worldsFirstTechnologyOfNewEra(eraType: _), .worldsFirstTechnologyOfNewEra(eraType: _)):
            return true
        case (.worldsFirstToMeetAllCivilizations, .worldsFirstToMeetAllCivilizations):
            return true
        case (.worldsLargestCivilization, .worldsLargestCivilization):
            return true
        case (.worldCircumnavigated, .worldCircumnavigated):
            return true

        // minor
        case (.aggressiveCityPlacement, .aggressiveCityPlacement):
            return true
        case (.artifactExtracted, .artifactExtracted):
            return true
        case (.barbarianCampDestroyed, .barbarianCampDestroyed):
            return true
        case (.causeForWar(warType: _, civilizationType: _), .causeForWar(warType: _, civilizationType: _)):
            return true
        case (.cityReturnsToOriginalOwner(cityName: _, originalCivilization: _), .cityReturnsToOriginalOwner(cityName: _, originalCivilization: _)):
            return true
        // case cityStateArmyLevied // #
        // case coastalFloodMitigated // #
        case (.desertCity(cityName: _), .desertCity(cityName: _)):
            return true
        case (.diplomaticVictoryResolutionWon, .diplomaticVictoryResolutionWon):
            return true
        // case firstArmada
        case (.firstArmy, .firstArmy):
            return true
        // case firstCorps // #
        case (.firstFleet, .firstFleet):
            return true
        case (.foreignCapitalTaken, .foreignCapitalTaken):
            return true
        case (.greatPersonRecruited, .greatPersonRecruited):
            return true
        // case heroClaimed // #
        // case heroDeparted // #
        // case heroRecalled // #
        case (.landedOnTheMoon, .landedOnTheMoon):
            return true
        case (.manhattanProjectCompleted, .manhattanProjectCompleted):
            return true
        case (.martianColonyEstablished, .martianColonyEstablished):
            return true
        case (.masterSpyEarned, .masterSpyEarned):
            return true
        case (.metNewCivilization(civilization: _), .metNewCivilization(civilization: _)):
            return true
        case (.oldGreatPersonRecruited, .oldGreatPersonRecruited):
            return true
        case (.oldWorldWonderCompleted, .oldWorldWonderCompleted):
            return true
        // case operationIvyCompleted
        case (.pantheonFounded, .pantheonFounded):
            return true
        case (.riverFloodMitigated, .riverFloodMitigated):
            return true
        case (.satelliteLaunchedIntoOrbit, .satelliteLaunchedIntoOrbit):
            return true
        case (.snowCity(cityName: _), .snowCity(cityName: _)):
            return true
        case (.strategicResourcePotentialUnleashed, .strategicResourcePotentialUnleashed):
            return true
        case (.tradingPostEstablishedInNewCivilization(civilization: _), .tradingPostEstablishedInNewCivilization(civilization: _)):
            return true
        case (.tribalVillageContacted, .tribalVillageContacted):
            return true
        case (.tundraCity(cityName: _), .tundraCity(cityName: _)):
            return true
        case (.unitPromotedWithDistinction, .unitPromotedWithDistinction):
            return true
        case (.wonderCompleted(wonder: _), .wonderCompleted(wonder: _)):
            return true

        // hidden
        case (.dedicationTriggered(dedicationType: _), .dedicationTriggered(dedicationType: _)):
            return true
        case (.shipSunk, .shipSunk):
            return true
        case (.battleFought, .battleFought):
            return true

        default:
            // print("try to compare \(lhs) with \(rhs)")
            return false
        }
    }
}
