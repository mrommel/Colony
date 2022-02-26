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

    case none

    case cityCenter
    case campus
    case theatherSquare
    case holySite
    case encampment
    case harbor
    case commercialHub
    case industrialZone
    // preserve
    case entertainmentComplex
    // waterPark
    case aqueduct
    case neighborhood
    // canal
    // dam
    // areodrome
    case spaceport
    case governmentPlaza
    // case diplomaticQuarter

    public static let defaultFlavorValue = 5

    public static var all: [DistrictType] {
        return [
            .cityCenter,
            .campus,
            .theatherSquare,
            .holySite,
            .encampment,
            .harbor,
            .commercialHub,
            .industrialZone,
            // preserve
            .entertainmentComplex,
            // waterPark
            .aqueduct,
            .neighborhood,
            // canal
            // dam
            // areodrome
            .spaceport,
            .governmentPlaza
            // .diplomaticQuarter,
        ]
    }

    public func name() -> String {

        return self.data().name
    }

    public func isSpecialty() -> Bool {

        return self.data().specialty
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

    public func oncePerCivilization() -> Bool {

        return self.data().oncePerCivilization
    }

    // MARK: private methods / classes

    private class DistrictTypeData {

        let name: String
        let specialty: Bool
        let effects: [String]
        let productionCost: Int
        let maintenanceCost: Int // in gold
        let requiredTech: TechType?
        let requiredCivic: CivicType?

        let domesticTradeYields: Yields
        let foreignTradeYields: Yields

        let flavours: [Flavor]
        let oncePerCivilization: Bool

        init(
            name: String,
            specialty: Bool,
            effects: [String],
            productionCost: Int,
            maintenanceCost: Int,
            requiredTech: TechType?,
            requiredCivic: CivicType?,
            domesticTradeYields: Yields,
            foreignTradeYields: Yields,
            flavours: [Flavor],
            oncePerCivilization: Bool = false) {

                self.name = name
                self.specialty = specialty
                self.effects = effects
                self.productionCost = productionCost
                self.maintenanceCost = maintenanceCost
                self.requiredTech = requiredTech
                self.requiredCivic = requiredCivic

                self.domesticTradeYields = domesticTradeYields
                self.foreignTradeYields = foreignTradeYields

                self.flavours = flavours
                self.oncePerCivilization = oncePerCivilization
        }
    }

    // swiftlint:disable line_length
    private func data() -> DistrictTypeData {

        switch self {

        case .none:
            return DistrictTypeData(
                name: "",
                specialty: false,
                effects: [],
                productionCost: -1,
                maintenanceCost: -1,
                requiredTech: nil,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: []
            )

        case .cityCenter:
            // https://civilization.fandom.com/wiki/City_Center_(Civ6)
            return DistrictTypeData(
                name: "CityCenter",
                specialty: false,
                effects: [
                    "Main District. Must be captured to capture the entire City. Has Defenses and a Ranged Strike (after building Walls)."
                ],
                productionCost: 0,
                maintenanceCost: 0,
                requiredTech: nil,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                flavours: [
                    Flavor(type: .cityDefense, value: 7)
                ]
            )

        case .campus:
            // https://civilization.fandom.com/wiki/Campus_(Civ6)
            return DistrictTypeData(
                name: "Campus",
                specialty: true,
                effects: [
                    "Major bonus (+2 [Science] Science) for each adjacent Geothermal Fissure and Reef tile.",
                    // "Major bonus (+2 Science) for each adjacent Pamukkale tile.", // #
                    "Major bonus (+2 [Science] Science) for each adjacent Great Barrier Reef tile.",
                    "Standard bonus (+1 [Science] Science) for each adjacent Mountain tile.",
                    "Minor bonus (+½ [Science] Science) for each adjacent Rainforest and district tile.",
                    "+1 [GreatScientist] Great Scientist point per turn.",
                    "Specialists add +2 [Science] Science each" // #
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: .writing,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0, science: 1.0),
                flavours: [
                    Flavor(type: .science, value: 8)
                ]
            )

        case .theatherSquare:
            // https://civilization.fandom.com/wiki/Theater_Square_(Civ6)
            return DistrictTypeData(
                name: "Theater Square",
                specialty: true,
                effects: [
                    "Major bonus (+2 [Culture] Culture) for each adjacent Wonder",
                    "Major bonus (+2 [Culture] Culture) for each adjacent Water Park or Entertainment Complex district tile",
                    // "Major bonus (+2 Culture) for each adjacent Pamukkale tile",
                    "Minor bonus (+½ [Culture] Culture) for each adjacent district tile",
                    "+1 [GreatWriter] Great Writer point per turn",
                    "+1 [GreatArtist] Great Artist point per turn",
                    "+1 [GreatMusician] Great Musician point per turn",
                    "Buildings have slots for Great Works and Artifacts",
                    "Specialists add +2 [Culture] Culture each", // #
                    "+1 Appeal to adjacent tiles" // #
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .dramaAndPoetry,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .culture, value: 6),
                    Flavor(type: .greatPeople, value: 4)
                ]
            )

        case .holySite:
            // https://civilization.fandom.com/wiki/Holy_Site_(Civ6)
            return DistrictTypeData(
                name: "HolySite",
                specialty: true,
                effects: [
                    "Major bonus (+2 [Faith] Faith) for each adjacent Natural Wonder",
                    "Standard bonus (+1 [Faith] Faith) for each adjacent Mountain tile",
                    "Standard bonus (+1 [Faith] Faith) for each adjacent Pamukkale tile",
                    "Minor bonus (+½ [Faith] Faith) for each adjacent District tile and each adjacent unimproved Woods tile",
                    "+1 [GreatProphet] Great Prophet point per turn",
                    "A religion can be founded in the Holy Site",
                    "Religious units can be purchased in a city with a Holy Site, spawning in the Holy Site or if that's unavailable in the City Center",
                    "Religious units heal in a Holy Site district and in tiles adjacent to it",
                    "Specialists add +2 [Faith] Faith each",
                    "+1 Appeal to adjacent tiles"
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: .astrology,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0, faith: 1.0),
                flavours: [
                    Flavor(type: .religion, value: 7)
                ]
            )

        case .encampment:
            // https://civilization.fandom.com/wiki/Encampment_(Civ6)
            return DistrictTypeData(
                name: "Encampment",
                specialty: true,
                effects: [
                    "+1 [GreatGeneral] Great General point per turn",
                    "Acquires Outer Defenses and Ranged Strike along with the City Center once Walls have been built", // #
                    "Blocks movement of foreign units to this tile, unless the district is pillaged", // #
                    "Spawns all land military units the city produces or purchases", // #
                    "Provides XP bonus to units built in it once buildings have been added to the district", // #
                    "When a Military Academy is built, parent city may also build units as Corps and Armies", // #
                    "Specialists provide +1 [Production] Production and 2 Gold each", // #
                    "Gives its parent city the ability to build land units with only 1 count of the relative Strategic Resource", // #
                    "Increases Strategic Resource stockpiles by 10 for each building inside" // #
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .bronzeWorking,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                flavours: [
                    Flavor(type: .militaryTraining, value: 7),
                    Flavor(type: .cityDefense, value: 3)
                ]
            )

        case .harbor:
            // https://civilization.fandom.com/wiki/Harbor_(Civ6)
            return DistrictTypeData(
                name: "Harbor",
                specialty: true,
                effects: [
                    "Major bonus (+2 [Gold] Gold) for being adjacent to the City Center",
                    "Standard bonus (+1 [Gold] Gold) for each adjacent Sea resource",
                    "Minor bonus (+½ [Gold] Gold) for each adjacent District",
                    "+1 [GreatAdmiral] Great Admiral point per turn",
                    "+1 Trade Route capacity if this city doesn't already have a Commercial Hub. (Requires a Lighthouse)", // #
                    "Allows its parent city to build ships, even if the City Center is inland", // #
                    "Newly produced or purchased ships will spawn at the Harbor tile (as long as the Harbor tile is unoccupied)", // #
                    "Removes movement penalties for units Embarking to and from its tile (even if the district is still under construction)", // #
                    "Allows its parent city to build Ships requiring Strategic Resources with only 1 count of the relevant resource", // #
                    "When the Seaport is built, the parent city may construct Fleets and Armadas", // #
                    "Buildings grant experience bonuses to ships built in this city", // #
                    "Specialists add +2 [Gold] Gold and +1 [Food] Food each" // #
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .celestialNavigation,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                flavours: [
                    Flavor(type: .naval, value: 3),
                    Flavor(type: .navalGrowth, value: 7)
                ]
            )

        case .entertainmentComplex:
            // https://civilization.fandom.com/wiki/Entertainment_Complex_(Civ6)
            return DistrictTypeData(
                name: "Entertainment Complex",
                specialty: true,
                effects: [
                    "+1 [Amenity] Amenity from entertainment to parent city", // #
                    "Amenities from the Zoo and Stadium buildings extend to cities whose City Centers are up to 6 tiles away from the district. (Stacks with Water Park.)", // #
                    "Domestic Destination: +1 [Food] Food.", // #
                    "International Destination: +1 [Food] Food.", // #
                    "+1 Appeal to adjacent tiles" // #
                ],
                productionCost: 54,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .gamesAndRecreation,
                domesticTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 1.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .amenities, value: 7)
                ]
            )

        case .commercialHub:
            // https://civilization.fandom.com/wiki/Commercial_Hub_(Civ6)
            return DistrictTypeData(
                name: "Commercial Hub",
                specialty: true,
                effects: [
                    "Major bonus (+2 [Gold] Gold) for a nearby River or a Harbor District.",
                    // "Major bonus (+2 Gold) for each adjacent Pamukkale tile.", // #
                    "Minor bonus (+½ [Gold] Gold) for each nearby District.",
                    "+1 [TradeRoute] Trade Route capacity if this city doesn't already have a Harbor. (Requires a Market)", // #
                    "+1 [GreatMerchant] Great Merchant point per turn",
                    "Specialists add +4 [Gold] Gold each" // #
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .currency,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 3.0),
                flavours: [
                    Flavor(type: .gold, value: 7)
                ]
            )
        case .industrialZone:
            // https://civilization.fandom.com/wiki/Industrial_Zone_(Civ6)
            return DistrictTypeData(
                name: "Industrial Zone",
                specialty: true,
                effects: [
                    "Standard bonus (+1 [Production] Production) for each adjacent Mine or a Quarry",
                    "Minor bonus (+½ [Production] Production) for each adjacent district tile",
                    "+1 [GreatEngineer] Great Engineer point per turn",
                    "Lowers the Appeal of nearby tiles", // #
                    "Production from Factory and Power Plant buildings extends to cities whose City Centers are within 6 tiles of this district", // #
                    "Specialists provide +2 [Production] Production each" // #
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: .apprenticeship,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 1.0, gold: 0.0),
                flavours: [
                    Flavor(type: .production, value: 9)
                ]
            )

            // waterPark

        case .aqueduct:
            // https://civilization.fandom.com/wiki/Aqueduct_(Civ6)
            return DistrictTypeData(
                name: "Aqueduct",
                specialty: false,
                effects: [
                    "Cities that do not yet have existing fresh water receive up to 6 [Housing] Housing.",
                    "Cities that already have existing fresh water will instead get 2 [Housing] Housing.",
                    "Prevents [Food] Food loss during droughts.", // #
                    "+1 Amenity if adjacent to a Geothermal Fissure.", // #
                    "Military Engineers can spend a charge to complete 20% (rounding down) of an Aqueduct's production.", // #
                    "Does not depend on Citizen Population." // #
                ],
                productionCost: 36,
                maintenanceCost: 0,
                requiredTech: .engineering,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .tileImprovement, value: 7),
                    Flavor(type: .growth, value: 2)
                ]
            )

        case .neighborhood:
            // https://civilization.fandom.com/wiki/Neighborhood_(Civ6)
            return DistrictTypeData(
                name: "Neighborhood",
                specialty: false,
                effects: [
                    "A district in your city that provides [Housing] Housing based on the Appeal of the tile."
                ],
                productionCost: 54,
                maintenanceCost: 0,
                requiredTech: nil,
                requiredCivic: .urbanization,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .growth, value: 2),
                    Flavor(type: .expansion, value: 3)
                ]
            )

            // canal
            // dam
            // areodrome

        case .spaceport:
            // https://civilization.fandom.com/wiki/Spaceport_(Civ6)
            return DistrictTypeData(
                name: "Spaceport",
                specialty: false,
                effects: [
                    "Allows development of the Space Race projects, which are the way to [Science] Science Victory."
                ],
                productionCost: 1800,
                maintenanceCost: 0,
                requiredTech: .rocketry,
                requiredCivic: nil,
                domesticTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                foreignTradeYields: Yields(food: 0.0, production: 0.0, gold: 0.0),
                flavours: [
                    Flavor(type: .science, value: 7)
                ]
            )

        case .governmentPlaza:
            // https://civilization.fandom.com/wiki/Government_Plaza_(Civ6)
            return DistrictTypeData(
                name: "Government Plaza",
                specialty: true,
                effects: [
                    "+8 Loyalty to this city.",
                    "+1 adjacency bonus to all adjacent districts.",
                    "Awards +1 [Governor] Governor Title."
                ],
                productionCost: 30,
                maintenanceCost: 1,
                requiredTech: nil,
                requiredCivic: .stateWorkforce,
                domesticTradeYields: Yields(food: 1, production: 1, gold: 0),
                foreignTradeYields: Yields(food: 0, production: 0, gold: 2),
                flavours: [
                    Flavor(type: .diplomacy, value: 8)
                ],
                oncePerCivilization: true
            )
        }
    }

    func canBuild(on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        switch self {

        case .none: return false

        case .cityCenter: return true

        case .campus: return tile.isLand()
        case .theatherSquare: return tile.isLand()
        case .holySite: return tile.isLand()
        case .encampment: return tile.isLand()
        case .commercialHub: return tile.isLand()
        case .harbor: return gameModel.isCoastal(at: point) // must be built on the coast
        case .entertainmentComplex: return tile.isLand()
        case .industrialZone: return tile.isLand()
            // waterPark
        case .aqueduct: return self.canBuildAqueduct(on: tile.point, in: gameModel)
        case .neighborhood: return tile.isLand()
            // canal
            // dam
            // areodrome
        case .spaceport: return tile.isLand() && !tile.hasHills()
        case .governmentPlaza: return tile.isLand()
        }
    }

    private func canBuildAqueduct(on point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }

        // Must be built adjacent to both the City Center and one of the following: River, Lake, Oasis, or Mountain.
        var nextToCityCenter: Bool = false
        var nextToWaterSource: Bool = false

        for neighbor in point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            if neighborTile.isRiver() || neighborTile.has(feature: .lake) ||
                neighborTile.has(feature: .oasis) || neighborTile.has(feature: .mountains) {

                nextToWaterSource = true
            }

            if tile.workingCity()?.location == neighbor {
                nextToCityCenter = true
            }
        }

        return nextToCityCenter && nextToWaterSource
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let flavor = self.flavours().first(where: { $0.type == flavorType }) {
            return flavor.value
        }

        return DistrictType.defaultFlavorValue
    }

    private func flavours() -> [Flavor] {

        return self.data().flavours
    }
}
