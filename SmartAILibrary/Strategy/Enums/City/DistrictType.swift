//
//  DistrictType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
public enum DistrictType: Int, Codable {

    case cityCenter
    case campus
    case holySite
    case encampment
    case harbor
    case entertainment
    case commercialHub
    case industrial
    case spaceport

    public static var all: [DistrictType] {
        return [
            .cityCenter,
            .campus,
            .holySite,
            .encampment,
            .harbor,
            .entertainment,
            .commercialHub,
            .industrial,
            .spaceport
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    // in production units
    public func productionCost() -> Int {

        return self.data().productionCost
    }

    // in gold
    public func maintenanceCost() -> Int {

        return self.data().maintenanceCost
    }

    public func requiredTech() -> TechType? {

        return self.data().requiredTech
    }

    public func requiredCivic() -> CivicType? {

        return self.data().requiredCivic
    }

    public func domesticTradeYields() -> Yields {

        return self.data().domesticTradeYields
    }

    public func foreignTradeYields() -> Yields {

        return self.data().foreignTradeYields
    }

    // MARK: private methods / classes

    private struct DistrictTypeData {

        let name: String
        let effects: [String]
        let productionCost: Int
        let maintenanceCost: Int // in gold
        let requiredTech: TechType?
        let requiredCivic: CivicType?

        let domesticTradeYields: Yields
        let foreignTradeYields: Yields
    }

    // swiftlint:disable line_length
    private func data() -> DistrictTypeData {

        switch self {

        case .cityCenter:
            // https://civilization.fandom.com/wiki/City_Center_(Civ6)
            return DistrictTypeData(
                name: "CityCenter",
                effects: [
                    "Main District. Must be captured to capture the entire City. Has Defenses and a Ranged Strike (after building Walls)."
                ],
                productionCost: 0,
                maintenanceCost: 0,
                requiredTech: nil,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0)
            )

        case .campus:
            // https://civilization.fandom.com/wiki/Campus_(Civ6)
            return DistrictTypeData(
                name: "Campus",
                effects: [
                    "Major bonus (+2 Science) for each adjacent Geothermal Fissure and Reef tile.",
                    "Major bonus (+2 Science) for each adjacent Pamukkale tile.",
                    "Major bonus (+2 Science) for each adjacent Great Barrier Reef tile.",
                    "Standard bonus (+1 Science) for each adjacent Mountain tile.",
                    "Minor bonus (+½ Science) for each adjacent Rainforest and district tile.",
                    "+1 Great Scientist point per turn.",
                    "Specialists add +2 Science each"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: .writing,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0, science: 1.0)
            )

        case .holySite:
            // https://civilization.fandom.com/wiki/Holy_Site_(Civ6)
            return DistrictTypeData(
                name: "HolySite",
                effects: [
                    "Major bonus (+2 Faith) for each adjacent Natural Wonder",
                    "Standard bonus (+1 Faith) for each adjacent Mountain tile",
                    "Standard bonus (+1 Faith) for each adjacent Pamukkale tile",
                    "Minor bonus (+½ Faith) for each adjacent District tile and each adjacent unimproved Woods tile",
                    "+1 Great Prophet point per turn",
                    "A religion can be founded in the Holy Site",
                    "Religious units can be purchased in a city with a Holy Site, spawning in the Holy Site or if that's unavailable in the City Center",
                    "Religious units heal in a Holy Site district and in tiles adjacent to it",
                    "Specialists add +2 Faith each",
                    "+1 Appeal to adjacent tiles"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: .astrology,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 1.0)
            )

        case .encampment:
            // https://civilization.fandom.com/wiki/Encampment_(Civ6)
            return DistrictTypeData(
                name: "Encampment",
                effects: [
                    "+1 Great General point per turn",
                    "Acquires Outer Defenses and Ranged Strike along with the City Center once Walls have been built",
                    "Blocks movement of foreign units to this tile, unless the district is pillaged",
                    "Spawns all land military units the city produces or purchases",
                    "Provides XP bonus to units built in it once buildings have been added to the district",
                    "When a Military Academy is built, parent city may also build units as Corps and Armies",
                    "Specialists provide +1 Production Production and 2 Gold each",
                    "Gives its parent city the ability to build land units with only 1 count of the relative Strategic Resource",
                    "Increases Strategic Resource stockpiles by 10 for each building inside"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .bronzeWorking,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0)
            )

        case .harbor:
            // https://civilization.fandom.com/wiki/Harbor_(Civ6)
            return DistrictTypeData(
                name: "Harbor",
                effects: [
                    "Major bonus (+2 Gold) for being adjacent to the City Center",
                    "Standard bonus (+1 Gold) for each adjacent Sea resource",
                    "Minor bonus (+½ Gold) for each adjacent District",
                    "+1 Great Admiral point per turn",
                    "+1 Trade Route capacity if this city doesn't already have a Commercial Hub. (Requires a Lighthouse)",
                    "Allows its parent city to build ships, even if the City Center is inland",
                    "Newly produced or purchased ships will spawn at the Harbor tile (as long as the Harbor tile is unoccupied)",
                    "Removes movement penalties for units Embarking to and from its tile (even if the district is still under construction)",
                    "Allows its parent city to build Ships requiring Strategic Resources with only 1 count of the relevant resource",
                    "When the Seaport is built, the parent city may construct Fleets and Armadas",
                    "Buildings grant experience bonuses to ships built in this city",
                    "Specialists add +2 Gold and +1 Food each"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .celestialNavigation,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0)
            )

        case .entertainment:
            // https://civilization.fandom.com/wiki/Entertainment_Complex_(Civ6)
            return DistrictTypeData(
                name: "Entertainment",
                effects: [
                    "+1 Amenity from entertainment to parent city",
                    "Amenities from the Zoo and Stadium buildings extend to cities whose City Centers are up to 6 tiles away from the district. (Stacks with Water Park.)",
                    "+1 Appeal to adjacent tiles"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .gamesAndRecreation,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0, culture: 1.0)
            )

        case .commercialHub:
            // https://civilization.fandom.com/wiki/Commercial_Hub_(Civ6)
            return DistrictTypeData(
                name: "Commercial Hub",
                effects: [
                    "Major bonus (+2 Gold) for a nearby River or a Harbor District.",
                    "Major bonus (+2 Gold) for each adjacent Pamukkale tile.",
                    "Minor bonus (+½ Gold) for each nearby District.",
                    "+1 Trade Route capacity if this city doesn't already have a Harbor. (Requires a Market)",
                    "+1 Great Merchant point per turn",
                    "Specialists add +4 Gold each"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .currency,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0)
            )
        case .industrial:
            // https://civilization.fandom.com/wiki/Industrial_Zone_(Civ6)
            return DistrictTypeData(
                name: "Industrial Zone",
                effects: [
                    "Standard bonus (+1 Production) for each adjacent Mine or a Quarry",
                    "Minor bonus (+½ Production) for each adjacent district tile",
                    "+1 Great Engineer point per turn",
                    "Lowers the Appeal of nearby tiles",
                    "Production from Factory and Power Plant buildings extends to cities whose City Centers are within 6 tiles of this district",
                    "Specialists provide +2 Production each"
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .apprenticeship,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0)
            )

        case .spaceport:
            // https://civilization.fandom.com/wiki/Spaceport_(Civ6)
            return DistrictTypeData(
                name: "Spaceport",
                effects: [
                    "Allows development of the Space Race projects, which are the way to Science Victory."
                ],
                productionCost: 1800,
                maintenanceCost: 0,
                requiredTech: .rocketry,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0)
            )
        }
    }

    func canConstruct(on neighbor: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if self == .harbor {
            if let neighborTile = gameModel.tile(at: neighbor) {
                return neighborTile.terrain().isWater()
            }
        }

        if self == .spaceport {
            // check hill
            return true
        }

        return true // FIXME
    }
}
