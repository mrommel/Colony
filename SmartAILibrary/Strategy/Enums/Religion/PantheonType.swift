//
//  PantheonType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/List_of_pantheons_in_Civ6
public enum PantheonType: Int, Codable {

    case none

    case cityPatronGoddess
    case danceOfTheAurora
    case desertFolklore
    case divineSpark
    case earthGoddess
    case fertilityRites
    case fireGoddess // #
    case godOfCraftsmen
    case godOfHealing // #
    case godOfTheForge
    case godOfTheOpenSky
    case godOfTheSea
    case godOfWar // #
    case goddessOfFestivals
    case goddessOfTheHarvest // #
    case goddessOfTheHunt
    case initiationRites
    case ladyOfTheReedsAndMarshes
    case monumentToTheGods
    case oralTradition // #
    case religiousIdols
    case riverGoddess
    case religiousSettlements
    case sacredPath
    case stoneCircles

    public static var all: [PantheonType] = [
        .cityPatronGoddess, .danceOfTheAurora, .desertFolklore, .divineSpark, .earthGoddess, .fertilityRites,
        .fireGoddess, .godOfCraftsmen, .godOfHealing, .godOfTheForge, .godOfTheOpenSky, .godOfTheSea, .godOfWar,
        .goddessOfFestivals, .goddessOfTheHarvest, .goddessOfTheHunt, .initiationRites, .ladyOfTheReedsAndMarshes,
        .monumentToTheGods, .oralTradition, .religiousIdols, .riverGoddess, .religiousSettlements, .sacredPath,
        .stoneCircles
    ]

    public func name() -> String {

        return self.data().name
    }

    public func bonus() -> String {

        return self.data().bonus
    }

    // MARK: internal classes

    private struct PantheonData {

        let name: String
        let bonus: String
    }

    // MARK: private methods

    private func data() -> PantheonData {

        switch self {

        case .none:
            return PantheonData(
                name: "None",
                bonus: ""
            )

        case .cityPatronGoddess:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_CITY_PATRON_GODDESS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_CITY_PATRON_GODDESS_BONUS"
            )

        case .danceOfTheAurora:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_DANCE_OF_THE_AURORA_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_DANCE_OF_THE_AURORA_BONUS"
            )

        case .desertFolklore:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_DESERT_FOLKLORE_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_DESERT_FOLKLORE_BONUS"
            )

        case .divineSpark:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_DIVINE_SPARK_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_DIVINE_SPARK_BONUS"
            )

        case .earthGoddess:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_EARTH_GODDESS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_EARTH_GODDESS_BONUS"
            )

        case .fertilityRites:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_FERTILITY_RITES_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_FERTILITY_RITES_BONUS"
            )

        case .fireGoddess:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_FIRE_GODDESS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_FIRE_GODDESS_BONUS"
            )

        case .godOfCraftsmen:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_CRAFTSMEN_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_CRAFTSMEN_BONUS"
            )

        case .godOfHealing:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_HEALING_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_HEALING_BONUS"
            )

        case .godOfTheForge:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_THE_FORGE_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_THE_FORGE_BONUS"
            )

        case .godOfTheOpenSky:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_THE_OPEN_SKY_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_THE_OPEN_SKY_BONUS"
            )

        case .godOfTheSea:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_THE_SEA_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_THE_SEA_BONUS"
            )

        case .godOfWar:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_WAR_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GOD_OF_WAR_BONUS"
            )

        case .goddessOfFestivals:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GODDESS_OF_FESTIVALS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GODDESS_OF_FESTIVALS_BONUS"
            )

        case .goddessOfTheHarvest:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GODDESS_OF_THE_HARVEST_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GODDESS_OF_THE_HARVEST_BONUS"
            )

        case .goddessOfTheHunt:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_GODDESS_OF_THE_HUNT_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_GODDESS_OF_THE_HUNT_BONUS"
            )

        case .initiationRites:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_INITIATION_RITES_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_INITIATION_RITES_BONUS"
            )

        case .ladyOfTheReedsAndMarshes:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_LADY_OF_THE_REEDS_AND_MARSHES_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_LADY_OF_THE_REEDS_AND_MARSHES_BONUS"
            )

        case .monumentToTheGods:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_MONUMENT_TO_THE_GODS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_MONUMENT_TO_THE_GODS_BONUS"
            )

        case .oralTradition:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_ORAL_TRADITION_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_ORAL_TRADITION_BONUS"
            )

        case .religiousIdols:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_RELIGIOUS_IDOLS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_RELIGIOUS_IDOLS_BONUS"
            )

        case .riverGoddess:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_RIVER_GODDESS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_RIVER_GODDESS_BONUS"
            )

        case .religiousSettlements:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_RELIGIOUS_SETTLEMENTS_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_RELIGIOUS_SETTLEMENTS_BONUS"
            )

        case .sacredPath:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_SACRED_PATH_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_SACRED_PATH_BONUS"
            )

        case .stoneCircles:
            return PantheonData(
                name: "TXT_KEY_RELIGION_PANTHEON_STONE_CIRCLES_TITLE",
                bonus: "TXT_KEY_RELIGION_PANTHEON_STONE_CIRCLES_BONUS"
            )
        }
    }
}

extension PantheonType {

    func requiresResource() -> Bool {

        return false
    }

    func requiresNoImprovement() -> Bool {

        return false
    }

    func requiresImprovement() -> Bool {

        return false
    }

    func requiresNoFeature() -> Bool {

        return false
    }

    func minPopulation() -> Int {

        return 0
    }

    func minFollowers() -> Int {

        return 0
    }

    func cityGrowthModifier() -> Int {

        if self == .fertilityRites {
            return 4
        }

        if self == .riverGoddess || self == .goddessOfTheHunt {
            return 2
        }

        if self == .religiousSettlements {
            return 2
        }

        return 1
    }

    func obsoleteEra() -> EraType {

        return .future
    }

    func unitProductionModifier() -> Int {

        if self == .godOfTheForge {
            return 5
        }

        return 0
    }

    func wonderProductionModifier() -> Int {

        if self == .monumentToTheGods {
            return 5
        }

        return 0
    }

    func requiresPeace() -> Bool {

        return false
    }

    func riverHappiness() -> Int {

        if self == .riverGoddess {
            return 4
        }

        return 0
    }

    func happinessPerCity() -> Int {

        return 0
    }

    func yieldPerPopulation(of yieldType: YieldType) -> Int {

        return 0
    }

    func yieldPerLuxuryResource(of yieldType: YieldType) -> Int {

        if self == .religiousIdols && yieldType == .faith {
            return 2
        }

        return 0
    }

    func yieldFor(building buildingType: BuildingType, yield yieldType: YieldType) -> Int {

        return 0
    }

    func friendlyHealChange() -> Int {

        return 0
    }

    func plotCultureCostModifier() -> Int {

        return 0
    }

    func cityRangeStrikeModifier() -> Int {

        return 0
    }

    func greatPersonPoints(for greatPersonType: GreatPersonType) -> Int {

        return 0
    }
}
