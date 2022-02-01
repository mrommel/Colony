//
//  MomentTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 11.01.22.
//

import SmartAILibrary

extension MomentType {

    // swiftlint:disable:next cyclomatic_complexity
    public func iconTexture() -> String {

        switch self {

        case .admiralDefeatsEnemy: return "moment-default"
        case .allGovernorsAppointed: return "moment-default"
        case .canalCompleted: return "moment-default"
        case .cityNearFloodableRiver(cityName: _): return "moment-cityNearFloodableRiver"
        case .cityNearVolcano(cityName: _): return "moment-cityNearVolcano"
        case .cityOfAwe(cityName: _): return "moment-default"
        case .cityOnNewContinent: return "moment-cityOnNewContinent"
            // City-State's First Suzerain
            // City-State Army Levied Near Enemy
            // Climate Change Phase
        case .darkAgeBegins: return "moment-default"
        case .discoveryOfANaturalWonder(naturalWonder: let featureType):
            return MomentType.iconTexture(for: featureType)

            // Emergency Completed Successfully
            // Emergency Successfully Defended
        case .enemyCityAdoptsOurReligion: return "moment-default"
            // case enemyCityStatePacified
        case .enemyFormationDefeated: return "moment-default"
        case .enemyVeteranDefeated: return "moment-default"
        case .exoplanetExpeditionLaunched: return "moment-default"
        case .finalForeignCityTaken: return "moment-default"
        case .firstAerodromeFullyDeveloped: return "moment-default"
        case .firstBustlingCity(cityName: _): return "moment-firstBustlingCity"
        case .firstCivicOfNewEra(eraType: let eraType):
            return MomentType.iconTextureOfCivic(for: eraType)
            // case firstCorporationCreated
            // case firstCorporationInTheWorld
        case .firstDiscoveryOfANaturalWonder: return "moment-default"
        case .firstDiscoveryOfANewContinent: return "moment-firstDiscoveryOfANewContinent"
        case .firstEncampmentFullyDeveloped: return "moment-default"
        case .firstEnormousCity(cityName: _): return "moment-firstEnormousCity"
        case .firstEntertainmentComplexFullyDeveloped: return "moment-default"
        case .firstGiganticCity(cityName: _): return "moment-firstGiganticCity"
            // case firstGreenImprovement
            // case First Green Improvement in World
            // case First Hero Claimed
            // case First Hero Departed
            // case First Hero Recalled
            // case First Improvement after Natural Disaster
            // case First Industry Created
            // case First Industry in the World
        case .firstLargeCity(cityName: _): return "moment-firstLargeCity"
            // case firstLuxuryResourceMonopoly
            // case firstLuxuryResourceMonopolyInTheWorld
            // case firstMasterSpyEarned
            // case firstMountainTunnel
            // case firstMountainTunnelInTheWorld
        case .firstNeighborhoodCompleted: return "moment-default"
            // case First Railroad Connection
            // case First Railroad Connection in World
            // case First Resource consumed for Power
            // case First Resource consumed for Power in World
            // case First Rock Band Concert
            // case First Rock Band Concert in World
            // case First Seaside Resort
        case .firstShipwreckExcavated: return "moment-firstShipwreckExcavated"
        case .firstTechnologyOfNewEra(eraType: let eraType):
            return MomentType.iconTextureOfTech(for: eraType)
        case .firstTier1Government(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTier1GovernmentInWorld(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTier2Government(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTier2GovernmentInWorld(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTier3Government(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTier3GovernmentInWorld(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTier4Government(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTier4GovernmentInWorld(governmentType: let governmentType):
            return MomentType.iconTexture(for: governmentType)
        case .firstTradingPostsInAllCivilizations: return "moment-default"
        case .firstUnitPromotedWithDistinction: return "moment-default"
            // case firstWaterParkFullyDeveloped
            // case freeCityJoins
        case .generalDefeatsEnemy: return "moment-default"
        case .goldenAgeBegins: return "moment-default"
        case .governorFullyPromoted: return "moment-default"
            // case greatPersonLuredByFaith
            // case greatPersonLuredByGold
        case .heroicAgeBegins: return "moment-default"
            // case inquisitionBegins
            // case Levied Army Stands Down
        case .metAllCivilizations: return "moment-metAllCivilizations"
        case .nationalParkFounded: return "moment-nationalParkFounded"
        case .normalAgeBegins: return "moment-default"
        case .onTheWaves: return "moment-default"
        case .religionAdoptsAllBeliefs: return "moment-religionFounded"
        case .religionFounded(religion: _): return "moment-religionFounded"
        case .rivalHolyCityConverted: return "moment-default"
        case .splendidCampusCompleted: return "moment-default"
        case .splendidCommercialHubCompleted: return "moment-default"
        case .splendidHarborCompleted: return "moment-default"
        case .splendidHolySiteCompleted: return "moment-default"
        case .splendidIndustrialZoneCompleted: return "moment-default"
        case .splendidTheaterSquareCompleted: return "moment-default"
        case .takingFlight: return "moment-default"
        case .threateningCampDestroyed: return "moment-default"
        case .tradingPostsInAllCivilizations: return "moment-default"
            // Unique Building Constructed
            // Unique District Completed
            // Unique Tile Improvement Built
            // Unique Unit Marches
            // World's First Armada
            // World's First Army
        case .worldsFirstBustlingCity(cityName: _): return "moment-firstBustlingCity"
        case .worldsFirstCircumnavigation: return "moment-worldCircumnavigated"
        case .worldsFirstCivicOfNewEra(eraType: let eraType):
            return MomentType.iconTextureOfCivic(for: eraType)
            // World's First Corps
        case .worldsFirstEnormousCity(cityName: _): return "moment-firstEnormousCity"
        case .worldsFirstExoplanetExpeditionLaunched: return "moment-default"
        case .worldsFirstFleet: return "moment-default"
        case .worldsFirstFlight: return "moment-default"
        case .worldsFirstGiganticCity(cityName: _): return "moment-firstGiganticCity"
            // World's First Inquisition
        case .worldsFirstLandingOnTheMoon: return "moment-default"
        case .worldsFirstLargeCity(cityName: _): return "moment-firstLargeCity"
        case .worldsFirstMartianColonyEstablished: return "moment-default"
        case .worldsFirstNationalPark: return "moment-default"
        case .worldsFirstNeighborhood: return "moment-default"
        case .worldsFirstPantheon: return "moment-pantheonFounded"
        case .worldsFirstReligion: return "moment-religionFounded"
        case .worldsFirstReligionToAdoptAllBeliefs: return "moment-default"
        case .worldsFirstSatelliteInOrbit: return "moment-default"
        case .worldsFirstSeafaring: return "moment-default"
        case .worldsFirstSeasideResort: return "moment-default"
        case .worldsFirstShipwreckExcavated: return "moment-default"
        case .worldsFirstStrategicResourcePotentialUnleashed: return "moment-default"
        case .worldsFirstTechnologyOfNewEra(eraType: let eraType):
            return MomentType.iconTextureOfTech(for: eraType)
        case .worldsFirstToMeetAllCivilizations: return "moment-default"
        case .worldsLargestCivilization: return "moment-default"
        case .worldCircumnavigated: return "moment-worldCircumnavigated"

            // minor
        case .aggressiveCityPlacement: return "moment-default"
        case .artifactExtracted: return "moment-default"
        case .barbarianCampDestroyed: return "moment-barbarianCampDestroyed"
        case .causeForWar: return "moment-causeForWar"
        case .cityReturnsToOriginalOwner: return "moment-default"
            // case cityStateArmyLevied // #
            // case coastalFloodMitigated // #
        case .desertCity: return "moment-default"
        case .diplomaticVictoryResolutionWon: return "moment-default"
            // case firstArmada
        case .firstArmy: return "moment-default"
            // case firstCorps // #
        case .firstFleet: return "moment-default"
        case .foreignCapitalTaken: return "moment-default"
        case .greatPersonRecruited: return "moment-default"
            // case heroClaimed // #
            // case heroDeparted // #
            // case heroRecalled // #
        case .landedOnTheMoon: return "moment-default"
        case .manhattanProjectCompleted: return "moment-default"
        case .martianColonyEstablished: return "moment-default"
        case .masterSpyEarned: return "moment-default"
        case .metNewCivilization(civilization: _): return "moment-metNewCivilization"
        case .oldGreatPersonRecruited: return "moment-default"
        case .oldWorldWonderCompleted: return "moment-default"
            // case Operation Ivy Completed
        case .pantheonFounded: return "moment-pantheonFounded"
        case .riverFloodMitigated: return "moment-default"
        case .satelliteLaunchedIntoOrbit: return "moment-default"
        case .snowCity: return "moment-default"
        case .strategicResourcePotentialUnleashed: return "moment-default"
        case .tradingPostEstablishedInNewCivilization: return "moment-default"
        case .tribalVillageContacted: return "moment-tribalVillageContacted"
        case .tundraCity: return "moment-default"
        case .unitPromotedWithDistinction: return "moment-default"
        case .wonderCompleted(wonder: _): return "moment-default"

            // hidden
        case .shipSunk: return "moment-default"
        case .battleFought: return "moment-default"
        case .dedicationTriggered(dedicationType: _): return "moment-default"

        }
    }

    private static func iconTexture(for featureType: FeatureType) -> String {

        switch featureType {

        case .cliffsOfDover: return "moment-discoveryOfANaturalWonder-cliffsOfDover"
        case .delicateArch: return "moment-discoveryOfANaturalWonder-delicateArch"
        case .galapagos: return "moment-discoveryOfANaturalWonder-galapagos"
        case .greatBarrierReef: return "moment-discoveryOfANaturalWonder-greatBarrierReef"
        case .mountEverest: return "moment-discoveryOfANaturalWonder-mountEverest"
        case .mountKilimanjaro: return "moment-discoveryOfANaturalWonder-mountKilimanjaro"
        case .pantanal: return "moment-discoveryOfANaturalWonder-pantanal"
        case .yosemite: return "moment-discoveryOfANaturalWonder-yosemite"
        case .uluru: return "moment-discoveryOfANaturalWonder-uluru"

        case .fuji: return "moment-discoveryOfANaturalWonder"
        case .barringCrater: return "moment-discoveryOfANaturalWonder"
        case .mesa: return "moment-discoveryOfANaturalWonder"
        case .gibraltar: return "moment-discoveryOfANaturalWonder"
        case .geyser: return "moment-discoveryOfANaturalWonder"
        case .potosi: return "moment-discoveryOfANaturalWonder"
        case .fountainOfYouth: return "moment-discoveryOfANaturalWonder"
        case .lakeVictoria: return "moment-discoveryOfANaturalWonder"

        default: return "moment-discoveryOfANaturalWonder"
        }
    }

    private static func iconTexture(for governmentType: GovernmentType) -> String {

        switch governmentType {

        case .chiefdom: return "moment-default"
        case .autocracy: return "moment-government-autocracy"
        case .classicalRepublic: return "moment-government-classicalRepublic"
        case .oligarchy: return "moment-government-oligarchy"
        case .merchantRepublic: return "moment-government-merchantRepublic"
        case .monarchy: return "moment-government-monarchy"
        case .theocracy: return "moment-government-theocracy"
        case .fascism: return "moment-government-fascism"
        case .communism: return "moment-government-communism"
        case .democracy: return "moment-government-democracy"
        }
    }

    private static func iconTextureOfTech(for eraType: EraType) -> String {

        switch eraType {

        case .none: return "moment-default"
        case .ancient: return "moment-default"
        case .classical: return "moment-tech-era-classical"
        case .medieval: return "moment-tech-era-medieval"
        case .renaissance: return "moment-tech-era-renaissance"
        case .industrial: return "moment-tech-era-industrial"
        case .modern: return "moment-tech-era-modern"
        case .atomic: return "moment-tech-era-atomic"
        case .information: return "moment-tech-era-information"
        case .future:return "moment-default"
        }
    }

    private static func iconTextureOfCivic(for eraType: EraType) -> String {

        switch eraType {

        case .none: return "moment-default"
        case .ancient: return "moment-default"
        case .classical: return "moment-civic-era-classical"
        case .medieval: return "moment-civic-era-medieval"
        case .renaissance: return "moment-civic-era-renaissance"
        case .industrial: return "moment-civic-era-industrial"
        case .modern: return "moment-civic-era-modern"
        case .atomic: return "moment-civic-era-atomic"
        case .information: return "moment-civic-era-information"
        case .future:return "moment-default"
        }
    }
}
