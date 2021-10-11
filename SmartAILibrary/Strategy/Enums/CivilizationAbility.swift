//
//  CivilizationAbility.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.03.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum CivilizationAbility {

    case none

    case platosRepublic // greek
    case allRoadsLeadToRome // roman
    case workshopOfTheWorld // english
    case legendOfTheFiveSuns // aztecs
    case satrapies // persian
    case grandTour // french
    case iteru // egyptian
    case freeImperialCities // german
    case motherRussia // russian

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    private struct CivilizationAbilityData {

        let name: String
        let effects: [String]
    }

    private func data() -> CivilizationAbilityData {

        switch self {

        case .none:
            return CivilizationAbilityData(
                name: "None",
                effects: ["None"]
            )

        case .platosRepublic:
            return CivilizationAbilityData(
                name: "Plato's Republic",
                effects: [
                    "Gain an additional Wildcard policy slot in all Governments."
                ]
            )

        case .allRoadsLeadToRome:
            return CivilizationAbilityData(
                name: "All Roads Lead to Rome",
                effects: [
                    "Founded or conquered cities start with a Trading Post", // FIXME: conquered
                    "If within Trade Route range of the Capital, a road to it.",
                    "Trade Routes generate +1 additional Gold from Roman Trading Posts they pass through."
                ]
            )

        case .workshopOfTheWorld:
            return CivilizationAbilityData(
                name: "Workshop of the World",
                effects: [
                    "Iron and Coal Mines accumulate +2 resources per turn.", // FIXME
                    "+100% Production towards Military Engineers.", // FIXME
                    "Military Engineers receive +2 charges.", // FIXME
                    "Buildings that provide additional yields when powered receive +4 of their respective yields.", // FIXME
                    "+20% Production towards Industrial Zone buildings.", // FIXME
                    "Harbor buildings grant +10 Strategic Resource stockpiles." // FIXME
                ]
            )

        case .legendOfTheFiveSuns:
            return CivilizationAbilityData(
                name: "Legend of the Five Suns",
                effects: [
                    "Can spend Builder charges to complete 20% of a district's Production cost." // FIXME
                ]
            )

        case .satrapies:
            return CivilizationAbilityData(
                name: "Satrapies",
                effects: [
                    "Gains +1 Trade Route capacity with Political Philosophy.",
                    "Domestic Trade Routes provide +2 Gold and +1 Culture.",
                    "Roads built inside Persian territory are one level more advanced than usual." // FIXME
                ]
            )
        case .grandTour:
            return CivilizationAbilityData(
                name: "Grand Tour",
                effects: [
                    "+20% Production towards Medieval, Renaissance, and Industrial Wonders.",
                    "Double Tourism from all Wonders." // FIXME
                ]
            )

        case .iteru:
            return CivilizationAbilityData(
                name: "Iteru",
                effects: [
                    "+15% Production towards Districts and wonders built next to a river.",
                    "Districts, improvements and units are immune to damage from floods." // FIXME
                ]
            )

        case .freeImperialCities:
            return CivilizationAbilityData(
                name: "Free Imperial Cities",
                effects: [
                    "Each city can build one more district than the population limit would normally allow." // FIXME
                ]
            )

        case .motherRussia:
            return CivilizationAbilityData(
                name: "Mother Russia",
                effects: [
                    "Founded cities start with eight additional tiles.",
                    "Tundra tiles provide +1 Faith and +1 Production, in addition to their usual yields.",
                    "Districts, improvements and units are immune to damage from Blizzards.", // FIXME
                    "+100% damage from Blizzards inside Russian territory to civilizations at war with Russia." // FIXME
                ]
            )
        }
    }
}
